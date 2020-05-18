SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

--move "hekwerk" from scheiding to bereikbaarheid
INSERT INTO bereikbaarheid (geom, soort, object_id)
    SELECT s.geom, 'hekwerk', b.object_id FROM scheiding s 
    LEFT JOIN bouwlagen b ON s.bouwlaag_id = b.id
    WHERE scheiding_type_id = 6;
    
--INSERT type bouwkundige veiligheidsvoorzieningen
INSERT INTO veiligh_bouwk (geom, soort, bouwlaag_id)
    SELECT s.geom, st.naam::veiligh_bouwk_type, s.bouwlaag_id FROM scheiding s
    LEFT JOIN scheiding_type st ON s.scheiding_type_id = st.id WHERE st.naam <> 'hekwerk';

--Backup en opschonen scheidingen tabel
ALTER TABLE scheiding ADD COLUMN scheiding_type CHARACTER VARYING(254);
UPDATE scheiding s SET scheiding_type = st.naam
    FROM scheiding_type st WHERE s.scheiding_type_id = st.id;
CREATE TABLE objecten_backup.scheiding AS SELECT * FROM scheiding;
DROP TABLE scheiding CASCADE;
DROP TABLE scheiding_type CASCADE;

--INSERT type ruimten    
INSERT INTO ruimten_type (id, naam)
    SELECT id, naam FROM vlakken_type;

INSERT INTO ruimten (geom, ruimten_type_id, bouwlaag_id)
    SELECT geom, vlakken_type_id, bouwlaag_id FROM vlakken;

--Backup en opschonen vlakken tabel
ALTER TABLE vlakken ADD COLUMN vlakken_type CHARACTER VARYING(254);
UPDATE vlakken s SET vlakken_type = st.naam
    FROM vlakken_type st WHERE s.vlakken_type_id = st.id;
CREATE TABLE objecten_backup.vlakken AS SELECT * FROM vlakken;
DROP TABLE vlakken CASCADE;
DROP TABLE vlakken_type CASCADE;
  
--INSERT ingang en sleutelkluis
INSERT INTO ingang_type (id, naam) VALUES (32,'Brandweeringang');
INSERT INTO ingang_type (id, naam) VALUES (47,'Neveningang');
INSERT INTO ingang_type (id, naam) VALUES (35,'Brandweerlift');
INSERT INTO ingang_type (id, naam) VALUES (165,'Lift');
INSERT INTO ingang_type (id, naam) VALUES (153,'Trap bordes');
INSERT INTO ingang_type (id, naam) VALUES (174,'Trap recht');
INSERT INTO ingang_type (id, naam) VALUES (173,'Trap rond');

INSERT INTO ingang (geom, ingang_type_id, label, rotatie, bouwlaag_id)
    SELECT geom, voorziening_pictogram_id, label, rotatie, bouwlaag_id FROM pictogram
    WHERE voorziening_pictogram_id = 32 OR voorziening_pictogram_id = 47 OR voorziening_pictogram_id = 35 OR voorziening_pictogram_id = 153
            OR voorziening_pictogram_id = 165 OR voorziening_pictogram_id = 173 OR voorziening_pictogram_id = 174;
    
INSERT INTO sleutelkluis_type (id, naam) VALUES (148, 'sleutelkluis');
INSERT INTO sleutelkluis_type (id, naam) VALUES (1, 'sleutelbuis');
INSERT INTO sleuteldoel_type (id, naam) VALUES (1, 'generale hoofdsleutel');

--insert sleutekluizen en koppel aan dichtsbijzijnde brandweeringang
INSERT INTO sleutelkluis (geom, sleutelkluis_type_id, rotatie, label, sleuteldoel_type_id, ingang_id)
SELECT geom, 148, rotatie, label, 1, brw_ingang_id FROM
    (SELECT DISTINCT ON (sl.id) sl.id AS sleutelkluis_id, sl.geom, sl.rotatie, sl.label, i.id AS brw_ingang_id, ST_Distance(i.geom, sl.geom) as dist
        FROM (SELECT * FROM pictogram WHERE voorziening_pictogram_id = 148 ) As sl, 
             (SELECT * FROM ingang WHERE ingang_type_id = 32 ) As i   
        ORDER BY sl.id, ST_Distance(i.geom, sl.geom)) part;

--overzetten van dmo/tmo dekkingsprobleem
INSERT INTO afw_binnendekking (geom, soort, rotatie, label, bouwlaag_id)
    SELECT geom, 
        CASE
            WHEN pt.id = 18 THEN 'Dekkingsprobleem DMO'::objecten.afw_binnendekking_type
            WHEN pt.id = 20 THEN 'Dekkingsprobleem TMO'::objecten.afw_binnendekking_type
        END
        ,rotatie, label, bouwlaag_id 
    FROM pictogram 
    LEFT JOIN pictogram_type pt ON voorziening_pictogram_id = pt.id
    WHERE voorziening_pictogram_id = 18 OR voorziening_pictogram_id = 20;

--Voor elke registratie van bhv 1 regel aanmaken in de tabel bedrijfshulpverlening, verwijder bhvaanwezig uit de tabel object
INSERT INTO bedrijfshulpverlening (dagen, tijdvakbegin, tijdvakeind, ademluchtdragend, object_id)
    SELECT 'ma - zo', '2000-01-01 00:00:00', '2000-01-01 23:59:00', False, id FROM object
    WHERE bhvaanwezig = True;
ALTER TABLE object DROP COLUMN bhvaanwezig CASCADE;
    
-- INSERT type ruimtelijke veiligheidsvoorzieningen
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (7,'Afsluiter CV','Afsluiter');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (8,'Afsluiter elektra','Afsluiter');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (9,'Afsluiter gas','Afsluiter');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (164,'Afsluiter luchtbehandeling','Afsluiter');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (11,'Afsluiter neon','Afsluiter');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (12,'Afsluiter noodstop','Afsluiter');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (13,'Afsluiter omloop','Afsluiter');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (14,'Afsluiter rwa','Afsluiter');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (15,'Afsluiter sprinkler','Afsluiter');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (16,'Afsluiter water','Afsluiter');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (151,'Stijgleiding HD afnamepunt','Voorziening');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (152,'Stijgleiding HD vulpunt','Voorziening');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (149,'Stijgleiding LD afnamepunt','Voorziening');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (150,'Stijgleiding LD vulpunt','Voorziening');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (172,'Blussysteem afff','Blussysteem');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (171,'Blussysteem hifog','Blussysteem');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (23,'Blussysteem koolstofdioxide','Blussysteem');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (25,'Blussysteem schuim','Blussysteem');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (26,'Blussysteem water','Blussysteem');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (160,'Verzamelplaats','Toetreding');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie) VALUES (154,'Waterkanon','Voorziening');

-- INSERT type installatietechnische voorzieningen
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (7,'Afsluiter CV','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (8,'Afsluiter elektra','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (9,'Afsluiter gas','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (164,'Afsluiter luchtbehandeling','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (11,'Afsluiter neon','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (12,'Afsluiter noodstop','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (13,'Afsluiter omloop','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (14,'Afsluiter rwa','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (15,'Afsluiter sprinkler','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (16,'Afsluiter water','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (156,'Meterkast elektra en gas','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (159,'Meterkast elektra, gas en water','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (157,'Meterkast elektra en water','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (158,'Meterkast gas en water','Afsluiter');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (162,'Brandmeldcentrale','BMC');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (30,'Brandmeldpaneel','BMC');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (161,'Nevenpaneel','BMC');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (163,'Ontruimingspaneel','BMC');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (147,'Rook warmte afvoer','Voorziening');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (151,'Stijgleiding HD afnamepunt','Voorziening');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (152,'Stijgleiding HD vulpunt','Voorziening');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (149,'Stijgleiding LD afnamepunt','Voorziening');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (150,'Stijgleiding LD vulpunt','Voorziening');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (172,'Blussysteem afff','Blussysteem');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (171,'Blussysteem hifog','Blussysteem');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (23,'Blussysteem koolstofdioxide','Blussysteem');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (25,'Blussysteem schuim','Blussysteem');
INSERT INTO veiligh_install_type (id, naam, categorie) VALUES (26,'Blussysteem water','Blussysteem');

INSERT INTO veiligh_install (geom, veiligh_install_type_id, label, rotatie, bouwlaag_id)
    SELECT p.geom, p.voorziening_pictogram_id, label, rotatie, bouwlaag_id FROM pictogram p 
        INNER JOIN veiligh_install_type v ON p.voorziening_pictogram_id = v.id;

INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (1, 'Aanrijding', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (2, 'Agressie', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (3, 'Beknelling', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (4, 'Beschadiging', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (5, 'Besmetting', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (6, 'Bijtgevaar', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (7, 'Brand', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (8, 'Desoriëntatie', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (9, 'Drukgolf', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (10, 'Elektrisering', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (11, 'Elektrocutie', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (12, 'Explosie', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (13, 'Implosie', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (14, 'Insluiting', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (15, 'Instorting', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (16, 'Kortsluiting', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (17, 'Onderkoeling', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (18, 'Straling', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (19, 'Uitglijden', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (20, 'Uitval', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (21, 'Verdrinking', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (22, 'Vergiftiging', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (23, 'Verlies', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (24, 'Verstikking', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (25, 'Vervuiling', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (26, 'Verwonding', '');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (101, 'Biologische agentia','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (108, 'Elektrische spanning','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (114, 'Laserstralen','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (112, 'Lage temperatuur of bevriezing','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (109, 'Magnetisch veld','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (110, 'Niet-ioniserende straling','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (104, 'Niet blussen met water','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (111, 'Radioactief materiaal','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (113, 'Asbest','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (105, 'Ontvlambare stoffen','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (102, 'Bijtende stoffen','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (106, 'Giftige stoffen','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (103, 'Oxiderende stoffen','');
INSERT INTO dreiging_type (id, naam, omschrijving) VALUES (107, 'Explosieve stoffen','');

--backup pictogrammen
ALTER TABLE pictogram ADD COLUMN pictogrammen_type CHARACTER VARYING(254);
UPDATE pictogram s SET pictogrammen_type = st.naam
    FROM pictogram_type st WHERE s.voorziening_pictogram_id = st.id;
CREATE TABLE objecten_backup.pictogrammen AS SELECT * FROM pictogram;
DROP TABLE pictogram CASCADE;
DROP TABLE pictogram_type CASCADE; 

--backup labels
CREATE TABLE objecten_backup.label AS 
    SELECT l.* FROM label l;

--koppel labels die buiten het pand staan en op bouwlaag 1 staan aan het object en de overige aan de bouwlaag
UPDATE label l SET bouwlaag_id = p.bouwlaag_id FROM
(SELECT bl.id, bl.bouwlaag_id FROM label bl) p
WHERE l.id = p.id AND p.bouwlaag_id IN (SELECT id FROM bouwlagen);

UPDATE label l SET object_id = p.object_id FROM
(
 SELECT l.id, b.object_id FROM label l 
 LEFT JOIN bouwlagen b ON l.bouwlaag_id = b.id
 WHERE b.bouwlaag = 1 AND ST_INTERSECTS(ST_BUFFER(b.geom,10), l.geom) = false
) p
WHERE l.id = p.id AND p.object_id IN (SELECT object_id FROM bouwlagen b);

UPDATE label l SET object_id = NULL
WHERE object_id IN (SELECT object_id FROM bouwlagen b) AND l.bouwlaag_id IS NOT NULL;

UPDATE label l SET bouwlaag_id = NULL
WHERE object_id IS NOT NULL and object_id IN (SELECT object_id FROM bouwlagen b);
    
-- labels
CREATE OR REPLACE VIEW bouwlaag_label AS 
 SELECT l.id, l.geom, l.datum_aangemaakt, l.datum_gewijzigd, l.omschrijving, l.soort, l.rotatie, l.bouwlaag_id, b.bouwlaag
   FROM label l JOIN bouwlagen b ON l.bouwlaag_id = b.id;

CREATE OR REPLACE RULE label_del AS
    ON DELETE TO bouwlaag_label DO INSTEAD  DELETE FROM label WHERE label.id = old.id;

CREATE OR REPLACE RULE label_ins AS
    ON INSERT TO bouwlaag_label DO INSTEAD  INSERT INTO label (geom, soort, omschrijving, rotatie, bouwlaag_id)
  VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING label.id, label.geom, label.datum_aangemaakt, label.datum_gewijzigd, label.omschrijving, label.soort,
    label.rotatie, label.bouwlaag_id, (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE label.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE label_upd AS
    ON UPDATE TO bouwlaag_label DO INSTEAD  UPDATE label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id
  WHERE label.id = new.id;
 
-- koppel schade cirkel aan 1e gevaarlijke stof binnen een opslag. Indien er geen gevaarlijke stof ligt wordt de cirkel weggegooit.
CREATE TABLE objecten_backup.gevaarlijke_stof AS 
    SELECT gvs.*, v.vn_nr, v.gevi_nr, v.eric_kaart FROM gevaarlijkestof gvs
        INNER JOIN gevaarlijkestof_vnnr v ON gvs.gevaarlijkestof_vnnr_id = v.id;
        
DROP TABLE gevaarlijkestof_eenheid;
DROP TABLE gevaarlijkestof_toestand;

ALTER TABLE gevaarlijkestof_schade_cirkel DROP COLUMN opslag_id CASCADE;

CREATE OR REPLACE VIEW schade_cirkel_calc AS
    SELECT sc.*, ST_BUFFER(part.geom, straal) AS geom_cirkel FROM gevaarlijkestof_schade_cirkel sc
    LEFT JOIN (SELECT gb.id, ops.geom FROM gevaarlijkestof gb
                LEFT JOIN gevaarlijkestof_opslag ops 
                ON gb.opslag_id = ops.id) part
    ON sc.gevaarlijkestof_id = part.id;

REVOKE ALL ON schade_cirkel_calc FROM oiv_write;

--opschonen van de historie tabel door enumeratie toe te passen
CREATE TYPE historie_status_type AS ENUM ('concept', 'in gebruik', 'archief');

ALTER TABLE historie ADD COLUMN status historie_status_type;
UPDATE historie h SET status = hs.naam::historie_status_type 
    FROM historie_status hs WHERE h.historie_status_id = hs.id;

ALTER TABLE historie ALTER COLUMN status SET NOT NULL;
ALTER TABLE historie DROP COLUMN historie_status_id CASCADE;

DROP TABLE historie_status;

CREATE TYPE historie_aanpassing_type AS ENUM ('aanpassing', 'nieuw', 'update');

ALTER TABLE historie ADD COLUMN aanpassing historie_aanpassing_type;
UPDATE historie h SET aanpassing = hs.naam::historie_aanpassing_type 
    FROM historie_aanpassing hs WHERE h.historie_aanpassing_id = hs.id;

ALTER TABLE historie ALTER COLUMN aanpassing SET NOT NULL;
ALTER TABLE historie DROP COLUMN historie_aanpassing_id;

DROP TABLE historie_aanpassing;
    
ALTER TABLE bouwlagen DROP COLUMN object_id CASCADE;

UPDATE algemeen.applicatie SET sub = 9;
UPDATE algemeen.applicatie SET revisie = 95;
UPDATE algemeen.applicatie SET db_versie = 995; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();