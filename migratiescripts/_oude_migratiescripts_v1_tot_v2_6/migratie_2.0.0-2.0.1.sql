SET role oiv_admin;

SET search_path = objecten, pg_catalog, public;

-- create view scheidingen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_scheidingen;
CREATE OR REPLACE VIEW view_scheidingen AS
SELECT s.id, s.geom, s.datum_aangemaakt, s.datum_gewijzigd, t.naam, o.formelenaam FROM scheiding s
INNER JOIN scheiding_type t ON s.scheiding_type_id = t.id
INNER JOIN (SELECT formelenaam, object.id FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o ON s.object_id = o.id;

-- create view voorzieningen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_voorzieningen;
CREATE OR REPLACE VIEW view_voorzieningen AS
SELECT v.id, v.geom, v.datum_aangemaakt, v.datum_gewijzigd, v.label, v.rotatie, p.naam, o.formelenaam, ROUND(ST_X(geom)) AS X, ROUND(ST_Y(geom)) AS Y FROM voorziening v
INNER JOIN voorziening_pictogram p ON v.voorziening_pictogram_id = p.id
INNER JOIN (SELECT formelenaam, object.id FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o ON v.object_id = o.id;

-- create view labels, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_labels;
CREATE OR REPLACE VIEW view_labels AS
SELECT l.id, l.geom, l.datum_aangemaakt, l.datum_gewijzigd, l.omschrijving, l.rotatie, t.type_label, o.formelenaam, ROUND(ST_X(geom)) AS X, ROUND(ST_Y(geom)) AS Y FROM object_labels l
INNER JOIN label_type t ON l.type_label = t.id
INNER JOIN (SELECT formelenaam, object.id FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o ON l.object_id = o.id;

-- view van objectgegevens gecombineerd met bouwconstructie en gebruikstype van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_objectgegevens;
CREATE OR REPLACE VIEW view_objectgegevens AS
SELECT formelenaam, object.id, geom, pand_id, object.datum_aangemaakt, object.datum_gewijzigd, laagstebouw, hoogstebouw, bhvaanwezig, tmo_dekking, dmo_dekking, bijzonderheden, pers_max, pers_nietz_max, og.naam AS gebruikstype, ob.naam AS bouwconstructie, algemeen.team.naam, ROUND(ST_X(geom)) AS X, ROUND(ST_Y(geom)) AS Y FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
LEFT JOIN object_gebruiktype og ON object.object_gebruiktype_id = og.id
LEFT JOIN object_bouwconstructie ob ON object.object_bouwconstructie_id = ob.id
LEFT JOIN algemeen.team ON object.team_id = algemeen.team.id
WHERE historie_status_id = 2;

-- view van aanwezigepersonen gecombineerd met object (formelenaam en geometrie) van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_object_aanw_pers;
CREATE OR REPLACE VIEW view_object_aanw_pers AS
SELECT o.formelenaam, a.id, a.datum_aangemaakt, a.datum_gewijzigd, a.dagen, a.tijdvakbegin, a.tijdvakeind, a.aantal, a.aantalniet, ag.naam, o.geom, ROUND(ST_X(geom)) AS X, ROUND(ST_Y(geom)) AS Y FROM aanwezig a
INNER JOIN aanwezig_groep ag ON a.aanwezig_groep_id = ag.id
INNER JOIN (SELECT formelenaam, object.id, geom FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o ON a.object_id = o.id;

-- create view vlakken, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_vlakken;
CREATE OR REPLACE VIEW view_vlakken AS
SELECT v.id, v.geom, v.datum_aangemaakt, v.datum_gewijzigd, v.omschrijving, o.formelenaam FROM vlakken v
INNER JOIN (SELECT formelenaam, object.id FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o ON v.object_id = o.id;

-- view van gevaarlijkestoffen locatie met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
ALTER TABLE gevaarlijkestof DROP CONSTRAINT IF EXISTS gevaarlijkestof_gevi_id_fk;
ALTER TABLE gevaarlijkestof DROP COLUMN IF EXISTS erickaart;
ALTER TABLE gevaarlijkestof DROP COLUMN IF EXISTS gevaarlijkestof_gevi_id;
DROP TABLE IF EXISTS objecten.gevaarlijkestof_gevi;
DROP VIEW IF EXISTS view_gevaarlijkestof;

CREATE OR REPLACE VIEW view_gevaarlijkestof AS 
SELECT o.formelenaam, gvs.id, gvs.un_nummer, gvs.locatie AS gvslocatie, gvs.hoeveelheid, eenh.naam AS eenheid, toest.naam AS toestand,
						ops.geom, ops.omschrijving, ops.locatie, ops.object_id, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y FROM gevaarlijkestof gvs
INNER JOIN gevaarlijkestof_eenheid eenh ON gvs.gevaarlijkestof_eenheid_id = eenh.id
INNER JOIN gevaarlijkestof_toestand toest ON gvs.gevaarlijkestof_toestand_id = toest.id
INNER JOIN opslag ops ON gvs.opslag_id = ops.id
INNER JOIN (SELECT formelenaam, object.id, geom FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o ON ops.object_id = o.id;
		
-- Aanpassen van view veiligheidsregio, zodat alle NW4 regio's in de view zitten
DROP VIEW algemeen.veiligheidsregio_huidig;
CREATE OR REPLACE VIEW algemeen.veiligheidsregio_huidig AS 
 SELECT veiligheidsregio.id,
    veiligheidsregio.geom,
    veiligheidsregio.statcode,
    veiligheidsregio.statnaam,
    veiligheidsregio.rubriek
   FROM algemeen.veiligheidsregio
  WHERE veiligheidsregio.statcode = 'VR10'::text OR veiligheidsregio.statcode = 'VR11'::text OR veiligheidsregio.statcode = 'VR12'::text OR veiligheidsregio.statcode = 'VR13'::text;

ALTER TABLE algemeen.veiligheidsregio_huidig
  OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.veiligheidsregio_huidig TO oiv_admin;
GRANT SELECT ON TABLE algemeen.veiligheidsregio_huidig TO oiv_read;

-- Update historie tabellen aanpassing en status, indien deze nog vice versa staan
UPDATE historie_aanpassing SET naam = 'aanpassing' WHERE id = 1;
UPDATE historie_aanpassing SET naam = 'nieuw' WHERE id = 2;
UPDATE historie_aanpassing SET naam = 'update' WHERE id = 3;

UPDATE historie_status SET naam = 'concept' WHERE id = 1;
UPDATE historie_status SET naam = 'in gebruik' WHERE id = 2;
UPDATE historie_status SET naam = 'archief' WHERE id = 3;

-- Verwijderen van de evetueel aangemaakte scripts in het migratie_script 1.1.0 - 1.1.2. Views voor web weergave, bijvoorbeeld geoserver, bovenstaande scripts vervangen deze
DROP VIEW IF EXISTS webgis_scheiding;
DROP VIEW IF EXISTS webgis_object;
DROP VIEW IF EXISTS webgis_voorziening;
DROP VIEW IF EXISTS webgis_opslag;
DROP VIEW IF EXISTS webgis_gevaarlijkestof;
DROP VIEW IF EXISTS webgis_aanwezig;
DROP VIEW IF EXISTS webgis_historie;

-- Update tabel applicatie naar de juiste versie, sub en revisie
UPDATE algemeen.applicatie SET versie = 2;
UPDATE algemeen.applicatie SET sub = 0;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET datum = now();
ALTER TABLE algemeen.applicatie DROP COLUMN IF EXISTS db_versie;
ALTER TABLE algemeen.applicatie ADD COLUMN db_versie smallint;
UPDATE algemeen.applicatie SET db_versie = 1;