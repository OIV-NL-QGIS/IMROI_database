SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

--Opzoeklijst voorzieningen zonder koppeling object
CREATE TABLE voorziening_lijst_zonder_object 
(
  id SMALLINT PRIMARY KEY NOT NULL,
  naam TEXT,
  categorie TEXT
);

-- Insert pictogrammen in opzoeklijst, id komt overeen met de volledige voorzieningen lijst
INSERT INTO voorziening_lijst_zonder_object SELECT * FROM voorziening_pictogram
WHERE id = 17 OR id = 18 OR id = 20 OR id = 146 OR id = 148 OR id = 149 OR id = 150 OR id = 151 OR id = 152 OR id = 154; 

-- Create pictogrammenlaag zonder object
CREATE TABLE voorziening_zonder_object
(
  id                   SERIAL PRIMARY KEY 						NOT NULL,
  geom                 GEOMETRY(POINT, 28992),
  datum_aangemaakt     TIMESTAMP WITH TIME ZONE DEFAULT now() 	NOT NULL,
  datum_gewijzigd      TIMESTAMP WITH TIME ZONE,
  voorziening_pictogram_id SMALLINT 							NOT NULL,
  rotatie              INTEGER,
  label                TEXT,
  pand_id              BIGINT                					NOT NULL,
  CONSTRAINT voorziening_zonder_id_fk FOREIGN KEY (voorziening_pictogram_id) REFERENCES voorziening_lijst_zonder_object (id)
);
CREATE INDEX voorziening_zonder_geom_gist
  ON voorziening (geom);
COMMENT ON TABLE voorziening IS 'Brandvoorzieningen zonder object';

-- formelenaam NOT NULL
UPDATE object 			SET formelenaam = '.' WHERE formelenaam IS NULL;
ALTER TABLE object 		ALTER COLUMN formelenaam SET NOT NULL;
ALTER TABLE object 		DROP COLUMN straatnaam;
ALTER TABLE object 		DROP COLUMN huisnummer;
ALTER TABLE object 		DROP COLUMN plaats;
ALTER TABLE object 		ALTER COLUMN hoogstebouw SET DEFAULT 0;
UPDATE object	 		SET laagstebouw = 0 WHERE laagstebouw IS NULL;
UPDATE object 			SET hoogstebouw = 0 WHERE hoogstebouw IS NULL;

-- Aanmaken tabel bouwlagen
CREATE TABLE bouwlagen
(
	id 				SERIAL PRIMARY KEY 						 NOT NULL,
	geom	 		GEOMETRY(MULTIPOLYGON, 28992),
	datum_aangemaakt  TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
	bouwlaag 		INTEGER 								 NOT NULL,
	bouwdeel 		CHARACTER VARYING(25),
	object_id 		INTEGER 								 NOT NULL,
	CONSTRAINT 	bouwlaag_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Neem alle bouwlaag vlakvullingen over voor bouwlaag 1 vanuit de het BAG pand, BAG moet wel onderdeel zijn van de database
--Zorg hiervoor dat we de rechten op het schema en tabellen goed staan.
INSERT INTO bouwlagen(geom, bouwlaag, object_id)
SELECT ST_Multi(ST_force2d(p.geovlak))::geometry(MultiPolygon,28992) AS geom, '1'::integer AS bouwlaag, o.id AS object_id FROM object o
	LEFT JOIN bagactueel.pandactueelbestaand p ON o.pand_id = p.identificatie;
	
-- Bouwlagen relatie toevoegen aan de basistabellen en NOT NULL constraints
ALTER TABLE voorziening 	ADD COLUMN bouwlaag_id INTEGER;
UPDATE 		voorziening v 	SET bouwlaag_id = b.id FROM (SELECT id, object_id FROM bouwlagen) AS b WHERE v.object_id = b.object_id;
ALTER TABLE voorziening		ALTER COLUMN bouwlaag_id SET NOT NULL;
ALTER TABLE voorziening 	ADD CONSTRAINT voorziening_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE voorziening		DROP CONSTRAINT voorziening_object_id_fk;
DELETE FROM voorziening 	WHERE voorziening_pictogram_id IS NULL;
ALTER TABLE voorziening		ALTER COLUMN voorziening_pictogram_id SET NOT NULL;

ALTER TABLE scheiding	 	ADD COLUMN bouwlaag_id INTEGER;
UPDATE 		scheiding v 	SET bouwlaag_id = b.id FROM (SELECT id, object_id FROM bouwlagen) AS b WHERE v.object_id = b.object_id;
ALTER TABLE scheiding		ALTER COLUMN bouwlaag_id SET NOT NULL;
ALTER TABLE scheiding 		ADD CONSTRAINT scheiding_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE scheiding		DROP CONSTRAINT scheiding_object_id_fk;
DELETE FROM scheiding 		WHERE scheiding_type_id IS NULL;
ALTER TABLE scheiding		ALTER COLUMN scheiding_type_id SET NOT NULL;

ALTER TABLE vlakken 		ADD COLUMN bouwlaag_id INTEGER;
UPDATE 		vlakken v 		SET bouwlaag_id = b.id FROM (SELECT id, object_id FROM bouwlagen) AS b WHERE v.object_id = b.object_id;
ALTER TABLE vlakken			ALTER COLUMN bouwlaag_id SET NOT NULL;
ALTER TABLE vlakken 		ADD CONSTRAINT vlakken_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE vlakken			DROP CONSTRAINT vlakken_object_id_fk;

ALTER TABLE object_labels 	ADD COLUMN bouwlaag_id INTEGER;
UPDATE 		object_labels v	SET bouwlaag_id = b.id FROM (SELECT id, object_id FROM bouwlagen) AS b WHERE v.object_id = b.object_id;
ALTER TABLE object_labels	ALTER COLUMN bouwlaag_id SET NOT NULL;
ALTER TABLE object_labels 	ADD CONSTRAINT object_labels_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE object_labels	DROP CONSTRAINT labels_object_id_fk;
DELETE FROM object_labels	WHERE omschrijving IS NULL;
ALTER TABLE object_labels	ALTER COLUMN omschrijving SET NOT NULL;

ALTER TABLE opslag 			ADD COLUMN bouwlaag_id INTEGER;
UPDATE 		opslag v 		SET bouwlaag_id = b.id FROM (SELECT id, object_id FROM bouwlagen) AS b WHERE v.object_id = b.object_id;
ALTER TABLE opslag			ALTER COLUMN bouwlaag_id SET NOT NULL;
ALTER TABLE opslag		 	ADD CONSTRAINT opslag_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE opslag			DROP CONSTRAINT opslag_object_id_fk;
UPDATE 		opslag			SET locatie = ' ' WHERE locatie is NULL;
ALTER TABLE opslag			ALTER COLUMN locatie SET NOT NULL;

ALTER TABLE aanwezig 		ADD COLUMN bouwlaag_id INTEGER;
UPDATE 		aanwezig v 		SET bouwlaag_id = b.id FROM (SELECT id, object_id FROM bouwlagen) AS b WHERE v.object_id = b.object_id;
ALTER TABLE aanwezig		ALTER COLUMN bouwlaag_id SET NOT NULL;
ALTER TABLE aanwezig	 	ADD CONSTRAINT aanwezig_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE aanwezig		DROP CONSTRAINT aanwezig_object_id_fk;
DELETE FROM aanwezig 		WHERE aanwezig_groep_id IS NULL;
ALTER TABLE aanwezig		ALTER COLUMN aanwezig_groep_id SET NOT NULL;

UPDATE gevaarlijkestof_eenheid	SET naam = 'geen eenheid geselecteerd' 	WHERE id = 6;
UPDATE gevaarlijkestof_toestand	SET naam = 'geen toestand geselecteerd' WHERE id = 11;
UPDATE gevaarlijkestof		SET hoeveelheid = 0 						WHERE hoeveelheid IS NULL;
ALTER TABLE gevaarlijkestof	ALTER COLUMN hoeveelheid 					SET NOT NULL;
UPDATE gevaarlijkestof		SET gevaarlijkestof_eenheid_id = 6 			WHERE gevaarlijkestof_eenheid_id IS NULL;
ALTER TABLE gevaarlijkestof	ALTER COLUMN gevaarlijkestof_eenheid_id 	SET NOT NULL;
UPDATE gevaarlijkestof		SET gevaarlijkestof_toestand_id = 11 		WHERE gevaarlijkestof_toestand_id IS NULL;
ALTER TABLE gevaarlijkestof	ALTER COLUMN gevaarlijkestof_toestand_id 	SET NOT NULL;

-- create admin team_lid
INSERT INTO algemeen.team (id, statcode, naam, email) VALUES (999, 'VR10', 'admin', 'admin@admin.nl');
INSERT INTO algemeen.teamlid (id, team_id, login, wachtwoord, naam, email) VALUES (999, 999, 'admin', '', 'admin', 'admin@admin.nl');

-- Controleer of de conversie goed is gegaan.
-- Aanmaken vlakken opzoektabel
CREATE TABLE vlakken_type
(
	id 			SMALLINT PRIMARY KEY NOT NULL,
	naam		TEXT				 NOT NULL		
);

INSERT INTO vlakken_type (id, naam) VALUES (1, 'bijzondere ruimte');
INSERT INTO vlakken_type (id, naam) VALUES (2, 'tijdelijke BAG');
INSERT INTO vlakken_type (id, naam) VALUES (3, 'verkeersruimte');
INSERT INTO vlakken_type (id, naam) VALUES (4, 'overige ruimte');

ALTER TABLE vlakken ADD COLUMN vlakken_type_id INTEGER NOT NULL;
ALTER TABLE vlakken ADD CONSTRAINT vlakken_type_id_fk FOREIGN KEY (vlakken_type_id) REFERENCES vlakken_type (id);

REVOKE ALL ON TABLE vlakken_type FROM GROUP oiv_write;

-- DROP geoserver views om daarna opnieuw aan te maken inclusief bouwlagen
DROP VIEW IF EXISTS view_scheidingen;
DROP VIEW IF EXISTS view_vlakken;
DROP VIEW IF EXISTS view_voorzieningen;
DROP VIEW IF EXISTS view_labels;
DROP VIEW IF EXISTS view_object_aanw_pers;
DROP VIEW IF EXISTS view_gevaarlijkestof;

-- DROP object_id vanuit de tabellen
ALTER TABLE voorziening 	DROP COLUMN object_id;
ALTER TABLE scheiding 		DROP COLUMN object_id;
ALTER TABLE vlakken 		DROP COLUMN object_id;
ALTER TABLE object_labels 	DROP COLUMN object_id;
ALTER TABLE opslag 			DROP COLUMN object_id;
ALTER TABLE opslag			DROP COLUMN omschrijving;
ALTER TABLE aanwezig 		DROP COLUMN object_id;

-- create view scheidingen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_scheidingen AS
SELECT s.id, s.geom, s.datum_aangemaakt, s.datum_gewijzigd, s.scheiding_type_id, t.naam AS scheiding_type, b.formelenaam, b.bouwlaag, b.bouwdeel FROM scheiding s
INNER JOIN scheiding_type t ON s.scheiding_type_id = t.id
INNER JOIN (SELECT o.*, bouwlagen.id AS bouwlaag_id, bouwlagen.bouwlaag, bouwlagen.bouwdeel FROM (SELECT formelenaam, object.id FROM objecten.object
			LEFT JOIN objecten.historie ON objecten.historie.id = 
			((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
			ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
			WHERE historie_status_id = 2) o	INNER JOIN bouwlagen ON o.id = bouwlagen.object_id) b ON s.bouwlaag_id = b.bouwlaag_id;

-- view van objectgegevens gecombineerd met bouwconstructie en gebruikstype van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_objectgegevens;
CREATE OR REPLACE VIEW view_objectgegevens AS
SELECT object.id, formelenaam, geom, pand_id, object.datum_aangemaakt, object.datum_gewijzigd, laagstebouw, hoogstebouw, bhvaanwezig, tmo_dekking, dmo_dekking, bijzonderheden, pers_max, pers_nietz_max, og.naam AS gebruikstype, ob.naam AS bouwconstructie, algemeen.team.naam, ROUND(ST_X(geom)) AS X, ROUND(ST_Y(geom)) AS Y FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
LEFT JOIN object_gebruiktype og ON object.object_gebruiktype_id = og.id
LEFT JOIN object_bouwconstructie ob ON object.object_bouwconstructie_id = ob.id
LEFT JOIN algemeen.team ON object.team_id = algemeen.team.id
WHERE historie_status_id = 2;

-- create view vlakken, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_vlakken AS
SELECT v.id, v.geom, v.datum_aangemaakt, v.datum_gewijzigd, v.vlakken_type_id, t.naam AS vlakken_type, b.formelenaam, b.bouwlaag, b.bouwdeel FROM vlakken v
INNER JOIN vlakken_type t ON v.vlakken_type_id = t.id
INNER JOIN (SELECT o.*, bouwlagen.id AS bouwlaag_id, bouwlagen.bouwlaag, bouwlagen.bouwdeel FROM (SELECT formelenaam, object.id FROM objecten.object
			LEFT JOIN objecten.historie ON objecten.historie.id = 
			((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
			ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
			WHERE historie_status_id = 2) o	INNER JOIN bouwlagen ON o.id = bouwlagen.object_id) b ON v.bouwlaag_id = b.bouwlaag_id;
			
-- create view voorzieningen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_voorzieningen AS
SELECT v.id, v.geom, v.datum_aangemaakt, v.datum_gewijzigd, v.voorziening_pictogram_id, v.label, v.rotatie, p.naam AS pictogram, 
							b.formelenaam, b.bouwlaag, b.bouwdeel, ROUND(ST_X(geom)) AS X, ROUND(ST_Y(geom)) AS Y FROM voorziening v
INNER JOIN voorziening_pictogram p ON v.voorziening_pictogram_id = p.id
INNER JOIN (SELECT o.*, bouwlagen.id AS bouwlaag_id, bouwlagen.bouwlaag, bouwlagen.bouwdeel FROM (SELECT formelenaam, object.id FROM objecten.object
			LEFT JOIN objecten.historie ON objecten.historie.id = 
			((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
			ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
			WHERE historie_status_id = 2) o INNER JOIN bouwlagen ON o.id = bouwlagen.object_id) b ON v.bouwlaag_id = b.bouwlaag_id;
			
-- create view labels, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_labels AS
SELECT l.id, l.geom, l.datum_aangemaakt, l.datum_gewijzigd, l.omschrijving, l.rotatie, t.type_label, 
							b.formelenaam, b.bouwlaag, b.bouwdeel, ROUND(ST_X(geom)) AS X, ROUND(ST_Y(geom)) AS Y FROM object_labels l
INNER JOIN label_type t ON l.type_label = t.id
INNER JOIN (SELECT o.*, bouwlagen.id AS bouwlaag_id, bouwlagen.bouwlaag, bouwlagen.bouwdeel FROM (SELECT formelenaam, object.id FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o INNER JOIN bouwlagen ON o.id = bouwlagen.object_id) b ON l.bouwlaag_id = b.bouwlaag_id;
		
-- view van aanwezigepersonen gecombineerd met object (formelenaam en geometrie) van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_object_aanw_pers AS
SELECT b.formelenaam, b.bouwlaag, b.bouwdeel, a.id, a.datum_aangemaakt, a.datum_gewijzigd, a.dagen, a.tijdvakbegin, a.tijdvakeind, a.aantal, a.aantalniet, ag.naam, 
							b.geom, ROUND(ST_X(geom)) AS X, ROUND(ST_Y(geom)) AS Y FROM aanwezig a
INNER JOIN aanwezig_groep ag ON a.aanwezig_groep_id = ag.id
INNER JOIN (SELECT o.*, bouwlagen.id AS bouwlaag_id, bouwlagen.bouwlaag, bouwlagen.bouwdeel FROM (SELECT formelenaam, object.id, geom FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o INNER JOIN bouwlagen ON o.id = bouwlagen.object_id) b ON a.bouwlaag_id = b.bouwlaag_id;

-- view van gevaarlijkestoffen locatie met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_gevaarlijkestof AS 
SELECT b.formelenaam, b.bouwlaag, b.bouwdeel, gvs.id, gvs.locatie AS gvslocatie, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, eenh.naam AS eenheid, toest.naam AS toestand,
							ops.geom, ops.locatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y FROM gevaarlijkestof gvs
LEFT JOIN gevaarlijkestof_eenheid eenh ON gvs.gevaarlijkestof_eenheid_id = eenh.id
LEFT JOIN gevaarlijkestof_toestand toest ON gvs.gevaarlijkestof_toestand_id = toest.id
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN opslag ops ON gvs.opslag_id = ops.id
INNER JOIN (SELECT o.*, bouwlagen.id AS bouwlaag_id, bouwlagen.bouwlaag, bouwlagen.bouwdeel FROM (SELECT formelenaam, object.id, geom FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o INNER JOIN bouwlagen ON o.id = bouwlagen.object_id) b ON ops.bouwlaag_id = b.bouwlaag_id;

-- CREATE VIEW t.b.v. categorisering voorzieningen in dropdownlijst Qgis
CREATE OR REPLACE VIEW objecten.view_voorziening_pictogram AS 
 SELECT v.id,
    concat(v.categorie, ' - ', v.naam) AS categorie
   FROM objecten.voorziening_pictogram v
  ORDER BY (concat(v.categorie, ' - ', v.naam));
  
-- Aanmaken van alle tekenlagen per bouwlaag
-- Views t.b.v. bouwlaag 1
CREATE OR REPLACE VIEW bouwlaag_1 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = 1;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_1 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (1, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_1 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_1 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag 1
CREATE OR REPLACE VIEW bouwlaag_1_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 1;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_1_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_1_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_1_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag 1
CREATE OR REPLACE VIEW bouwlaag_1_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 1;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_1_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_1_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_1_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag 1
CREATE OR REPLACE VIEW bouwlaag_1_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = 1;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_1_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_1_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_1_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag 1
CREATE OR REPLACE VIEW bouwlaag_1_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = 1;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_1_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_1_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_1_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag 1
CREATE OR REPLACE VIEW bouwlaag_1_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 1;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_1_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_1_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_1_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag min3
CREATE OR REPLACE VIEW bouwlaag_min3 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = -3;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_min3 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (-3, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_min3 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_min3 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag min3
CREATE OR REPLACE VIEW bouwlaag_min3_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = -3;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_min3_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_min3_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_min3_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag min3
CREATE OR REPLACE VIEW bouwlaag_min3_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = -3;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_min3_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_min3_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_min3_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag min3
CREATE OR REPLACE VIEW bouwlaag_min3_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = -3;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_min3_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_min3_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_min3_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag min3
CREATE OR REPLACE VIEW bouwlaag_min3_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = -3;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_min3_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_min3_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_min3_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag min3
CREATE OR REPLACE VIEW bouwlaag_min3_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = -3;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_min3_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_min3_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_min3_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag min2
CREATE OR REPLACE VIEW bouwlaag_min2 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = -2;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_min2 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (-2, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_min2 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_min2 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag min2
CREATE OR REPLACE VIEW bouwlaag_min2_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = -2;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_min2_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_min2_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_min2_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag min2
CREATE OR REPLACE VIEW bouwlaag_min2_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = -2;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_min2_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_min2_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_min2_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag min2
CREATE OR REPLACE VIEW bouwlaag_min2_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = -2;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_min2_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_min2_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_min2_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag min2
CREATE OR REPLACE VIEW bouwlaag_min2_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = -2;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_min2_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_min2_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_min2_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag min2
CREATE OR REPLACE VIEW bouwlaag_min2_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = -2;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_min2_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_min2_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_min2_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag min1
CREATE OR REPLACE VIEW bouwlaag_min1 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = -1;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_min1 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (-1, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_min1 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_min1 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag min1
CREATE OR REPLACE VIEW bouwlaag_min1_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = -1;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_min1_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_min1_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_min1_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag min1
CREATE OR REPLACE VIEW bouwlaag_min1_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = -1;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_min1_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_min1_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_min1_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag min1
CREATE OR REPLACE VIEW bouwlaag_min1_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = -1;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_min1_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_min1_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_min1_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag min1
CREATE OR REPLACE VIEW bouwlaag_min1_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = -1;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_min1_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_min1_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_min1_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag min1
CREATE OR REPLACE VIEW bouwlaag_min1_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = -1;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_min1_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_min1_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_min1_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag 2
CREATE OR REPLACE VIEW bouwlaag_2 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = 2;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_2 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (2, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_2 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_2 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag 2
CREATE OR REPLACE VIEW bouwlaag_2_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 2;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_2_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_2_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_2_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag 2
CREATE OR REPLACE VIEW bouwlaag_2_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 2;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_2_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_2_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_2_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag 2
CREATE OR REPLACE VIEW bouwlaag_2_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = 2;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_2_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_2_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_2_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag 2
CREATE OR REPLACE VIEW bouwlaag_2_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = 2;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_2_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_2_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_2_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag 2
CREATE OR REPLACE VIEW bouwlaag_2_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 2;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_2_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_2_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_2_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag 3
CREATE OR REPLACE VIEW bouwlaag_3 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = 3;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_3 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (3, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_3 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_3 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag 3
CREATE OR REPLACE VIEW bouwlaag_3_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 3;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_3_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_3_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_3_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag 3
CREATE OR REPLACE VIEW bouwlaag_3_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 3;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_3_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_3_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_3_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag 3
CREATE OR REPLACE VIEW bouwlaag_3_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = 3;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_3_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_3_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_3_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag 3
CREATE OR REPLACE VIEW bouwlaag_3_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = 3;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_3_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_3_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_3_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag 3
CREATE OR REPLACE VIEW bouwlaag_3_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 3;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_3_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_3_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_3_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag 4
CREATE OR REPLACE VIEW bouwlaag_4 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = 4;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_4 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (4, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_4 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_4 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag 4
CREATE OR REPLACE VIEW bouwlaag_4_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 4;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_4_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_4_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_4_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag 4
CREATE OR REPLACE VIEW bouwlaag_4_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 4;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_4_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_4_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_4_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag 4
CREATE OR REPLACE VIEW bouwlaag_4_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = 4;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_4_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_4_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_4_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag 4
CREATE OR REPLACE VIEW bouwlaag_4_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = 4;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_4_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_4_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_4_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag 4
CREATE OR REPLACE VIEW bouwlaag_4_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 4;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_4_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_4_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_4_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag 5
CREATE OR REPLACE VIEW bouwlaag_5 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = 5;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_5 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (5, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_5 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_5 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag 5
CREATE OR REPLACE VIEW bouwlaag_5_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 5;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_5_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_5_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_5_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag 5
CREATE OR REPLACE VIEW bouwlaag_5_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 5;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_5_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_5_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_5_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag 5
CREATE OR REPLACE VIEW bouwlaag_5_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = 5;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_5_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_5_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_5_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag 5
CREATE OR REPLACE VIEW bouwlaag_5_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = 5;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_5_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_5_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_5_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag 5
CREATE OR REPLACE VIEW bouwlaag_5_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 5;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_5_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_5_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_5_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag 6
CREATE OR REPLACE VIEW bouwlaag_6 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = 6;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_6 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (6, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_6 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_6 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag 6
CREATE OR REPLACE VIEW bouwlaag_6_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 6;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_6_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_6_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_6_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag 6
CREATE OR REPLACE VIEW bouwlaag_6_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 6;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_6_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_6_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_6_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag 6
CREATE OR REPLACE VIEW bouwlaag_6_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = 6;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_6_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_6_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_6_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag 6
CREATE OR REPLACE VIEW bouwlaag_6_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = 6;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_6_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_6_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_6_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag 6
CREATE OR REPLACE VIEW bouwlaag_6_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 6;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_6_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_6_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_6_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag 7
CREATE OR REPLACE VIEW bouwlaag_7 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = 7;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_7 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (7, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_7 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_7 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag 7
CREATE OR REPLACE VIEW bouwlaag_7_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 7;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_7_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_7_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_7_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag 7
CREATE OR REPLACE VIEW bouwlaag_7_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 7;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_7_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_7_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_7_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag 7
CREATE OR REPLACE VIEW bouwlaag_7_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = 7;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_7_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_7_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_7_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag 7
CREATE OR REPLACE VIEW bouwlaag_7_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = 7;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_7_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_7_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_7_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag 7
CREATE OR REPLACE VIEW bouwlaag_7_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 7;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_7_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_7_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_7_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag 8
CREATE OR REPLACE VIEW bouwlaag_8 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = 8;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_8 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (8, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_8 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_8 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag 8
CREATE OR REPLACE VIEW bouwlaag_8_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 8;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_8_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_8_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_8_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag 8
CREATE OR REPLACE VIEW bouwlaag_8_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 8;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_8_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_8_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_8_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag 8
CREATE OR REPLACE VIEW bouwlaag_8_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = 8;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_8_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_8_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_8_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag 8
CREATE OR REPLACE VIEW bouwlaag_8_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = 8;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_8_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_8_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_8_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag 8
CREATE OR REPLACE VIEW bouwlaag_8_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 8;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_8_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_8_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_8_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag 9
CREATE OR REPLACE VIEW bouwlaag_9 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = 9;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_9 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (9, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_9 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_9 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag 9
CREATE OR REPLACE VIEW bouwlaag_9_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 9;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_9_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_9_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_9_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag 9
CREATE OR REPLACE VIEW bouwlaag_9_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 9;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_9_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_9_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_9_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag 9
CREATE OR REPLACE VIEW bouwlaag_9_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = 9;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_9_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_9_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_9_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag 9
CREATE OR REPLACE VIEW bouwlaag_9_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = 9;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_9_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_9_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_9_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag 9
CREATE OR REPLACE VIEW bouwlaag_9_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 9;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_9_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_9_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_9_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Views t.b.v. bouwlaag 10
CREATE OR REPLACE VIEW bouwlaag_10 AS SELECT b.*, o.formelenaam FROM bouwlagen b INNER JOIN object o ON b.object_id = o.id WHERE bouwlaag = 10;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_10 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (10, new.object_id, new.bouwdeel, new.geom);
CREATE OR REPLACE RULE bouwlaag_upd AS ON UPDATE TO bouwlaag_10 DO INSTEAD UPDATE bouwlagen SET object_id = new.object_id, bouwdeel = new.bouwdeel, geom = new.geom
				WHERE id = new.id;
CREATE OR REPLACE RULE bouwlaag_del AS ON DELETE TO bouwlaag_10 DO INSTEAD DELETE FROM bouwlagen WHERE id = old.id;

-- Create view voorzieningen bouwlaag 10
CREATE OR REPLACE VIEW bouwlaag_10_voorz AS SELECT v.* FROM voorziening v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 10;
CREATE OR REPLACE RULE voorziening_ins AS 
	ON INSERT TO bouwlaag_10_voorz DO INSTEAD INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
	VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id);
CREATE OR REPLACE RULE voorziening_upd AS 
	ON UPDATE TO bouwlaag_10_voorz DO INSTEAD UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, 
				rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;
CREATE OR REPLACE RULE voorziening_del AS ON DELETE TO bouwlaag_10_voorz DO INSTEAD DELETE FROM voorziening WHERE id = old.id;

-- Create view opslag bouwlaag 10
CREATE OR REPLACE VIEW bouwlaag_10_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 10;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_10_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_10_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_10_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view scheidingen bouwlaag 10
CREATE OR REPLACE VIEW bouwlaag_10_scheiding AS SELECT s.* FROM scheiding s INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id WHERE b.bouwlaag = 10;
CREATE OR REPLACE RULE scheiding_ins AS 
	ON INSERT TO bouwlaag_10_scheiding DO INSTEAD INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
	VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE scheiding_upd AS ON UPDATE TO bouwlaag_10_scheiding DO INSTEAD UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, 
				bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE scheiding_del AS ON DELETE TO bouwlaag_10_scheiding DO INSTEAD DELETE FROM scheiding WHERE id = old.id;

-- Create view labels bouwlaag 10
CREATE OR REPLACE VIEW bouwlaag_10_label AS SELECT l.* FROM object_labels l INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id WHERE b.bouwlaag = 10;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_10_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id);
CREATE OR REPLACE RULE label_upd AS ON UPDATE TO bouwlaag_10_label DO INSTEAD UPDATE object_labels SET geom = new.geom, type_label = new.type_label, 
				omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE label_del AS ON DELETE TO bouwlaag_10_label DO INSTEAD DELETE FROM object_labels WHERE id = old.id;

-- Create view vlakken bouwlaag 10
CREATE OR REPLACE VIEW bouwlaag_10_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 10;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_10_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, omschrijving, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.omschrijving, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_10_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_10_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- CREATE VIEWS t.b.v. de print composer
CREATE OR REPLACE VIEW print_bouwlaag_gev_stoffen AS
SELECT g.id, o.formelenaam, o.pand_id, b.bouwlaag, b.bouwdeel, op.locatie, g.omschrijving As stof_omschrijving, gv.vn_nr, gv.gevi_nr, gv.eric_kaart, g.hoeveelheid, ge.naam As eenheid, gt.naam As toestand 
	FROM gevaarlijkestof g
	LEFT JOIN gevaarlijkestof_vnnr gv ON g.gevaarlijkestof_vnnr_id = gv.id
	LEFT JOIN gevaarlijkestof_eenheid ge ON g.gevaarlijkestof_eenheid_id = ge.id
	LEFT JOIN gevaarlijkestof_toestand gt ON g.gevaarlijkestof_toestand_id = gt.id
	LEFT JOIN opslag op ON g.opslag_id = op.id
	LEFT JOIN bouwlagen b ON op.bouwlaag_id = b.id
	LEFT JOIN object o ON b.object_id = o.id;

CREATE OR REPLACE VIEW print_bouwlaag_aanwezig AS
SELECT a.id, o.formelenaam, o.pand_id, b.bouwlaag, b.bouwdeel, ag.naam As aanwezig_groep, a.dagen, a.tijdvakbegin, a.tijdvakeind, a.aantal, a.aantalniet 
	FROM aanwezig a 
	LEFT JOIN aanwezig_groep ag ON a.aanwezig_groep_id = ag.id
	LEFT JOIN bouwlagen b ON a.bouwlaag_id = b.id
	LEFT JOIN object o ON b.object_id = o.id;

CREATE OR REPLACE VIEW print_bouwlagen AS
SELECT b.id, o.formelenaam, o.pand_id, b.bouwlaag, b.bouwdeel FROM bouwlagen b
	LEFT JOIN object o ON b.object_id = o.id;

CREATE OR REPLACE VIEW print_objectgegevens AS
SELECT obj.*, og.naam AS gebruikstype, ob.naam AS gebouwconstructie, a.openbareruimtenaam, a.huisnummer, a.huisnummertoevoeging, a.woonplaatsnaam FROM bagactueel.adres a
	INNER JOIN (SELECT object_id, min(gid) AS gid FROM
			(SELECT object_id, a.* FROM bagactueel.adres a 
			INNER JOIN (	SELECT b.*, o.id AS object_id FROM objecten.object o 
					INNER JOIN bagactueel.verblijfsobjectpandactueelbestaand b ON o.pand_id = b.gerelateerdpand) p 
			ON a.adresseerbaarobject = p.identificatie) adr
			GROUP BY object_id) adr	ON a.gid = adr.gid
	INNER JOIN objecten.object obj ON object_id = obj.id
	LEFT JOIN objecten.object_gebruiktype og ON object_gebruiktype_id = og.id
	LEFT JOIN objecten.object_bouwconstructie ob ON object_bouwconstructie_id = ob.id;

-- Update versie
UPDATE algemeen.applicatie SET revisie = 8;
UPDATE algemeen.applicatie SET db_versie = 7;