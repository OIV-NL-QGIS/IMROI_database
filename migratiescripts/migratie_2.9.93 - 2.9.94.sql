SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE SCHEMA objecten_backup;
CREATE TABLE objecten_backup.object AS SELECT * FROM object;
CREATE TABLE objecten_backup.bouwlagen AS SELECT * FROM bouwlagen;

--set relation bouwlagen_bag
ALTER TABLE bouwlagen   ADD COLUMN pand_id CHARACTER VARYING(16);
UPDATE      bouwlagen b SET pand_id = o.pand_id FROM object o WHERE b.object_id = o.id;
ALTER TABLE bouwlagen   ALTER COLUMN pand_id SET NOT NULL;
ALTER TABLE bouwlagen   DROP CONSTRAINT bouwlaag_object_id_fk;

ALTER TABLE IF EXISTS bluswater."brandkraan_2017_1" RENAME TO brandkranen;
ALTER TABLE IF EXISTS bluswater."leiding_2017_1" RENAME TO leidingen;

ALTER TABLE object ADD COLUMN geovlak geometry(MultiPolygon, 28992);
CREATE INDEX object_geovlak_gist
  ON objecten.object
  USING gist
  (geovlak);

ALTER TABLE object ADD COLUMN datum_geldig_tot timestamp without time zone; 
ALTER TABLE object ADD COLUMN datum_geldig_vanaf timestamp without time zone;
--laagste/hoogste bouwlaag en constructie hebben nog geen plaats in het nieuwe model nog op te halen uit de oude dataset!!

ALTER TABLE object DROP COLUMN laagstebouw CASCADE;
ALTER TABLE object DROP COLUMN hoogstebouw CASCADE;

ALTER TABLE object DROP CONSTRAINT object_bouwconstructie_id_fk;
ALTER TABLE object DROP COLUMN object_bouwconstructie_id CASCADE;

CREATE TABLE objecten_backup.object_bouwconstructie AS SELECT * FROM object_bouwconstructie;
DROP   TABLE object_bouwconstructie CASCADE;
DROP   VIEW  status_objectgegevens  CASCADE;

ALTER TABLE object RENAME COLUMN pand_id TO basisreg_identifier;
ALTER TABLE object ADD COLUMN bron       CHARACTER VARYING(3) NOT NULL DEFAULT 'BAG';
ALTER TABLE object ADD COLUMN bron_tabel CHARACTER VARYING(25) NOT NULL DEFAULT 'BGT';
UPDATE      object SET bron_tabel = 'Pand', bron = 'BAG';

DROP VIEW print_bouwlagen;
DROP VIEW print_bouwlaag_aanwezig;
DROP VIEW print_bouwlaag_gev_stoffen;
DROP VIEW stavaza_objecten;
DROP VIEW stavaza_volgende_update CASCADE;

ALTER TABLE object ALTER COLUMN basisreg_identifier TYPE CHARACTER VARYING(254);
ALTER TABLE object DROP CONSTRAINT object_pand_id_key;

--create table bereikbaarheid
CREATE TYPE bereikbaarheid_type AS ENUM ('aanrijdroute', 'hekwerk');

CREATE TABLE bereikbaarheid
(
  id                     SERIAL PRIMARY KEY NOT NULL,
  geom                   geometry(MultiLineString,28992),
  datum_aangemaakt       TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd        TIMESTAMP WITH TIME ZONE,
  obstakels              CHARACTER VARYING(50),
  wegafzetting           CHARACTER VARYING(50),
  soort                  bereikbaarheid_type,
  object_id              INTEGER NOT NULL,
  fotografie_id          INTEGER,
  CONSTRAINT bereikbaarheid_object_id_fk FOREIGN KEY (object_id)     REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT bereikbaarheid_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON bereikbaarheid
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE INDEX bereikbaarheid_geom_gist
  ON bereikbaarheid USING GIST(geom);
COMMENT ON TABLE bereikbaarheid IS 'Bereikbaarheids bijzonderheden per repressief object';

--create contactpersonen
CREATE TYPE contactpersoon_type AS ENUM ('Hoofd BHV');

CREATE TABLE contactpersoon
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  soort                     contactpersoon_type,
  dagen                     TEXT,
  tijdvakbegin              TIMESTAMP WITHOUT TIME ZONE,
  tijdvakeind               TIMESTAMP WITHOUT TIME ZONE,
  telefoonnummer             CHARACTER VARYING(11),
  object_id 		        INTEGER 				NOT NULL,
  CONSTRAINT contactpersoon_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE contactpersoon IS 'Contactpersonen';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON contactpersoon
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
--create bedrijfshulpverlening
CREATE TABLE bedrijfshulpverlening
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  dagen                     TEXT,
  tijdvakbegin              TIMESTAMP,
  tijdvakeind               TIMESTAMP,
  telefoonnummer            CHARACTER VARYING(11),
  ademluchtdragend          BOOLEAN,
  object_id 		            INTEGER 				NOT NULL,
  CONSTRAINT bedrijfshulpverlening_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE bedrijfshulpverlening IS 'Bedrijfshulpverlening';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON bedrijfshulpverlening
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

--create table scenario
CREATE TABLE scenario_type
(
  id            SMALLINT PRIMARY KEY NOT NULL,
  naam          TEXT,
  omschrijving  TEXT
);
COMMENT ON TABLE scenario_type IS 'Enumeratie van de verschillende scenarios';
REVOKE ALL ON TABLE scenario_type FROM GROUP oiv_write;

CREATE TABLE scenario
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                   	geometry(Point,28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  omschrijving              TEXT,
  scenario_type_id          INTEGER,
  object_id 		        INTEGER 				NOT NULL,
  CONSTRAINT scenario_type_id_fk FOREIGN KEY (scenario_type_id) REFERENCES scenario_type (id),
  CONSTRAINT scenario_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE bedrijfshulpverlening IS 'scenarios';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON scenario
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE INDEX scenario_geom_gist
  ON scenario USING GIST(geom);
  
--create table opstelplaats
CREATE TYPE opstelplaats_type AS ENUM ('Tankautospuit','Redvoertuig','Autoladder','WTS','Schuimblusvoertuig');

CREATE TABLE opstelplaats
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  soort                     opstelplaats_type,
  rotatie                   INTEGER DEFAULT 0,  
  object_id 		            INTEGER	NOT NULL,
  fotografie_id             INTEGER,
  CONSTRAINT opstelplaats_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT opstelplaats_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE opstelplaats IS 'Opstelplaatsen t.b.v. brandweervoertuigen';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON opstelplaats
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE INDEX opstelplaats_geom_gist
  ON opstelplaats USING GIST(geom);

--create table veiligheidsvoorziening organisatorisch
CREATE TYPE veilighv_org_type AS 
    ENUM ('bedrijfsbrandweer', 'onderhoud', 'rampenbestrijdingsplan', 'regulering transitie (verladingen, venstertijden etc)',
            'risicocommunicatie', 'sancties', 'supervisie', 'veiligheidsfunctionaris', 'veiligheidsovertredingenregister'); 

CREATE TABLE veilighv_org
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  soort                     veilighv_org_type,
  omschrijving              TEXT,
  object_id 		            INTEGER NOT NULL,
  CONSTRAINT veilighv_org_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE veilighv_org IS 'Organisatorische veiligheidsvoorzieningen';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON veilighv_org
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

--create table veiligheidsvoorzieningen ruimtelijk
CREATE TABLE veiligh_ruimtelijk_type
(
  id        SMALLINT PRIMARY KEY NOT NULL,
  naam      TEXT,
  categorie TEXT
);
COMMENT ON TABLE veiligh_ruimtelijk_type IS 'Enumeratie van de verschillende ruimtelijke veiligheidsvoorzieningen';
REVOKE ALL ON TABLE veiligh_ruimtelijk_type FROM GROUP oiv_write;

CREATE TABLE veiligh_ruimtelijk
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  veiligh_ruimtelijk_type_id   INTEGER,
  label                     TEXT,
  object_id 		            INTEGER 				NOT NULL,
  rotatie                   INTEGER DEFAULT 0,
  fotografie_id             INTEGER,
  CONSTRAINT veiligh_ruimtelijk_type_id_fk FOREIGN KEY (veiligh_ruimtelijk_type_id) REFERENCES veiligh_ruimtelijk_type (id),
  CONSTRAINT veiligh_ruimtelijk_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT veiligh_ruimtelijk_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE veiligh_ruimtelijk IS 'Ruimtelijke veiligheidsvoorzieningen';

CREATE INDEX veiligh_ruimtelijk_geom_gist
  ON veiligh_ruimtelijk USING GIST(geom);

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON veiligh_ruimtelijk
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
    
--create table veiligheidsvoorzieningen installaties
CREATE TABLE veiligh_install_type
(
  id        SMALLINT PRIMARY KEY NOT NULL,
  naam      TEXT,
  categorie TEXT
);
COMMENT ON TABLE veiligh_install_type IS 'Enumeratie van de verschillende installatietechnische veiligheidsvoorzieningen';
REVOKE ALL ON TABLE veiligh_install_type FROM GROUP oiv_write;

CREATE TABLE veiligh_install
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  veiligh_install_type_id   INTEGER,
  label                     TEXT,
  bouwlaag_id 		          INTEGER 				NOT NULL,
  rotatie                   INTEGER DEFAULT 0,
  fotografie_id             INTEGER,
  CONSTRAINT veiligh_install_type_id_fk FOREIGN KEY (veiligh_install_type_id) REFERENCES veiligh_install_type (id),
  CONSTRAINT veiligh_install_bouwlaag_id_fk  FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT veiligh_install_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE veiligh_install IS 'Installatietechnische veiligheidsvoorzieningen';

CREATE INDEX veiligh_install_geom_gist
  ON veiligh_install USING GIST(geom);

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON veiligh_install
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE OR REPLACE VIEW bouwlaag_veiligh_install AS
  SELECT v.*, b.bouwlaag FROM veiligh_install v JOIN bouwlagen b ON v.bouwlaag_id = b.id;
  
CREATE OR REPLACE RULE veiligh_install_del AS
    ON DELETE TO bouwlaag_veiligh_install DO INSTEAD  DELETE FROM veiligh_install
  WHERE veiligh_install.id = old.id;

CREATE OR REPLACE RULE veiligh_install_ins AS
    ON INSERT TO bouwlaag_veiligh_install DO INSTEAD  INSERT INTO veiligh_install (geom, veiligh_install_type_id, label, rotatie, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.veiligh_install_type_id, new.label, new.rotatie, new.bouwlaag_id, new.fotografie_id)
  RETURNING veiligh_install.id,
    veiligh_install.geom,
    veiligh_install.datum_aangemaakt,
    veiligh_install.datum_gewijzigd,
    veiligh_install.veiligh_install_type_id,
    veiligh_install.label,
    veiligh_install.bouwlaag_id,
    veiligh_install.rotatie,
    veiligh_install.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE veiligh_install.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE veiligh_install_upd AS
    ON UPDATE TO bouwlaag_veiligh_install DO INSTEAD  UPDATE veiligh_install SET geom = new.geom, veiligh_install_type_id = new.veiligh_install_type_id, bouwlaag_id = new.bouwlaag_id, label = new.label, rotatie = new.rotatie, fotografie_id = new.fotografie_id
        WHERE veiligh_install.id = new.id;

--create table veiligheidsvoorzieningen bouwkundig
CREATE TYPE veiligh_bouwk_type AS ENUM ('30 min brandwerende scheiding', '60 min brandwerende scheiding', 'bouwdeelscheiding', 'rookwerendescheiding', '120 min brandwerende scheiding');

CREATE TABLE veiligh_bouwk
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(MultiLineString, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  soort                     veiligh_bouwk_type,
  bouwlaag_id 		          INTEGER 				NOT NULL,
  fotografie_id             INTEGER,
  CONSTRAINT veiligh_bouwk_bouwlaag_id_fk  FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT veiligh_bouwk_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE veiligh_bouwk IS 'Bouwkundige veiligheidsvoorzieningen';

CREATE INDEX veiligh_bouwk_geom_gist
  ON veiligh_bouwk USING GIST(geom);

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON veiligh_bouwk
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE OR REPLACE VIEW bouwlaag_veiligh_bouwk AS
  SELECT v.*, b.bouwlaag FROM veiligh_bouwk v JOIN bouwlagen b ON v.bouwlaag_id = b.id;
  
CREATE OR REPLACE RULE veiligh_bouwk_del AS
    ON DELETE TO bouwlaag_veiligh_bouwk DO INSTEAD  DELETE FROM veiligh_bouwk
  WHERE veiligh_bouwk.id = old.id;

CREATE OR REPLACE RULE veiligh_bouwk_ins AS
    ON INSERT TO bouwlaag_veiligh_bouwk DO INSTEAD  INSERT INTO veiligh_bouwk (geom, soort, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.soort, new.bouwlaag_id, new.fotografie_id)
  RETURNING veiligh_bouwk.id,
    veiligh_bouwk.geom,
    veiligh_bouwk.datum_aangemaakt,
    veiligh_bouwk.datum_gewijzigd,
    veiligh_bouwk.soort,
    veiligh_bouwk.bouwlaag_id,
    veiligh_bouwk.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE veiligh_bouwk.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE veiligh_bouwk_upd AS
    ON UPDATE TO bouwlaag_veiligh_bouwk DO INSTEAD  UPDATE veiligh_bouwk SET geom = new.geom, soort = new.soort, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE veiligh_bouwk.id = new.id;
  
--create table ruimten
CREATE TABLE ruimten_type
(
  id        SMALLINT PRIMARY KEY NOT NULL,
  naam      TEXT
);
COMMENT ON TABLE ruimten_type IS 'Enumeratie van de verschillende soorten ruimtes in een pand.';
REVOKE ALL ON TABLE ruimten_type FROM GROUP oiv_write;

CREATE TABLE ruimten
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(MultiPolygon,28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  ruimten_type_id           INTEGER,
  omschrijving              TEXT,
  bouwlaag_id 		          INTEGER 				NOT NULL,
  fotografie_id             INTEGER,
  CONSTRAINT ruimten_type_id_fk FOREIGN KEY (ruimten_type_id) REFERENCES ruimten_type (id),
  CONSTRAINT ruimten_bouwlaag_id_fk  FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT ruimten_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE ruimten IS 'Ruimten binnen een bouwlaag.';

CREATE INDEX ruimten_geom_gist
  ON ruimten USING GIST(geom);

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON ruimten
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE OR REPLACE VIEW bouwlaag_ruimten AS 
 SELECT v.*,
    b.bouwlaag
   FROM ruimten v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE ruimten_del AS
    ON DELETE TO bouwlaag_ruimten DO INSTEAD  DELETE FROM ruimten
  WHERE ruimten.id = old.id;

CREATE OR REPLACE RULE ruimten_ins AS
    ON INSERT TO bouwlaag_ruimten DO INSTEAD  INSERT INTO ruimten (geom, ruimten_type_id, omschrijving, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.ruimten_type_id, new.omschrijving, new.bouwlaag_id, new.fotografie_id)
  RETURNING ruimten.id,
    ruimten.geom,
    ruimten.datum_aangemaakt,
    ruimten.datum_gewijzigd,
    ruimten.ruimten_type_id,
    ruimten.omschrijving,
    ruimten.bouwlaag_id,
    ruimten.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE ruimten.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE ruimten_upd AS
    ON UPDATE TO bouwlaag_ruimten DO INSTEAD  UPDATE ruimten SET geom = new.geom, ruimten_type_id = new.ruimten_type_id, omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE ruimten.id = new.id;
  
--create table ingang
CREATE TABLE ingang_type
(
  id            SMALLINT PRIMARY KEY NOT NULL,
  naam          TEXT
);
COMMENT ON TABLE ingang_type IS 'Enumeratie van de verschillende soorten ingangen';
REVOKE ALL ON TABLE ingang_type FROM GROUP oiv_write;

CREATE TABLE ingang
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  ingang_type_id 			      INTEGER,
  rotatie                   INTEGER DEFAULT 0,
  label                     TEXT,
  belemmering               VARCHAR(254),
  voorzieningen             VARCHAR(254),  
  bouwlaag_id 		          INTEGER,
  object_id				          INTEGER,
  fotografie_id             INTEGER,
  CONSTRAINT ingang_type_id_fk 		FOREIGN KEY (ingang_type_id) REFERENCES ingang_type (id),
  CONSTRAINT ingang_id_fk  			FOREIGN KEY (bouwlaag_id)	 REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT ingang_object_id_fk  	FOREIGN KEY (object_id) 	 REFERENCES object (id)    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT ingang_fk_check 		CHECK 		(bouwlaag_id IS NOT NULL OR object_id IS NOT NULL),
  CONSTRAINT ingang_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE ingang IS 'Ingang t.b.v. een pand en dus een bouwlaag';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON ingang
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE INDEX ingang_geom_gist
  ON ingang USING GIST(geom);
  
CREATE OR REPLACE VIEW bouwlaag_ingang AS
  SELECT v.*, b.bouwlaag FROM ingang v JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE ingang_del AS
    ON DELETE TO bouwlaag_ingang DO INSTEAD  DELETE FROM ingang
  WHERE ingang.id = old.id;

CREATE OR REPLACE RULE ingang_ins AS
    ON INSERT TO bouwlaag_ingang DO INSTEAD  INSERT INTO ingang (geom, ingang_type_id, label, rotatie, belemmering, voorzieningen, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.ingang_type_id, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.bouwlaag_id, new.fotografie_id)
  RETURNING ingang.id,
    ingang.geom,
    ingang.datum_aangemaakt,
    ingang.datum_gewijzigd,
    ingang.ingang_type_id,
    ingang.rotatie,
    ingang.label,
    ingang.belemmering,
    ingang.voorzieningen,
    ingang.bouwlaag_id,
    ingang.object_id,
    ingang.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE ingang.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE ingang_upd AS
    ON UPDATE TO bouwlaag_ingang DO INSTEAD  UPDATE ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, 
        voorzieningen = new.voorzieningen, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
        WHERE ingang.id = new.id;
        
ALTER TABLE aanwezig RENAME COLUMN aanwezig_groep_id TO aanwezig_type_id;
ALTER TABLE aanwezig ADD COLUMN aantal_personeel SMALLINT;
ALTER TABLE aanwezig RENAME COLUMN aantal TO aantal_totaal;
ALTER TABLE aanwezig RENAME COLUMN aantalniet TO aantal_nietzelf_bewoners;
ALTER TABLE aanwezig ADD COLUMN dieren BOOLEAN;

ALTER TABLE aanwezig_groep RENAME TO aanwezig_type;

--CREATE tabel dreiging
CREATE TABLE dreiging_type
(
  id            SMALLINT PRIMARY KEY NOT NULL,
  naam          TEXT,
  omschrijving  TEXT
);
COMMENT ON TABLE dreiging_type IS 'Enumeratie van de verschillende soorten dreigingen';
REVOKE ALL ON TABLE dreiging_type FROM GROUP oiv_write;

CREATE TABLE dreiging
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  dreiging_type_id          INTEGER,
  rotatie                   INTEGER DEFAULT 0,
  label                     VARCHAR(50),
  bouwlaag_id 		          INTEGER,
  object_id 				        INTEGER,
  fotografie_id             INTEGER,
  CONSTRAINT dreiging_type_id_fk 		FOREIGN KEY (dreiging_type_id)  REFERENCES dreiging_type (id),
  CONSTRAINT dreiging_bouwlaag_id_fk  	FOREIGN KEY (bouwlaag_id)		REFERENCES bouwlagen (id) 	ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT dreiging_object_id_fk 		FOREIGN KEY (object_id) 		REFERENCES object (id) 		ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT dreiging_fk_check 			CHECK 		(bouwlaag_id IS NOT NULL OR object_id IS NOT NULL),
  CONSTRAINT dreiging_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE dreiging IS 'Dreiging van een gevaar';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON dreiging
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE INDEX dreiging_geom_gist
  ON dreiging USING GIST(geom);
  
CREATE OR REPLACE VIEW bouwlaag_dreiging AS
  SELECT v.*, b.bouwlaag FROM dreiging v JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE dreiging_del AS
    ON DELETE TO bouwlaag_dreiging DO INSTEAD  DELETE FROM dreiging
  WHERE dreiging.id = old.id;

CREATE OR REPLACE RULE dreiging_ins AS
    ON INSERT TO bouwlaag_dreiging DO INSTEAD  INSERT INTO dreiging (geom, dreiging_type_id, label, rotatie, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.dreiging_type_id, new.label, new.rotatie, new.bouwlaag_id, new.fotografie_id)
  RETURNING dreiging.id,
    dreiging.geom,
    dreiging.datum_aangemaakt,
    dreiging.datum_gewijzigd,
    dreiging.dreiging_type_id,
    dreiging.rotatie,
    dreiging.label,
    dreiging.bouwlaag_id,
    dreiging.object_id,
    dreiging.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE dreiging.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE dreiging_upd AS
    ON UPDATE TO bouwlaag_dreiging DO INSTEAD  UPDATE dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
        WHERE dreiging.id = new.id;

--CREATE tabel sleutelkluis
CREATE TABLE sleutelkluis_type
(
  id            SMALLINT PRIMARY KEY NOT NULL,
  naam          TEXT
);
COMMENT ON TABLE sleutelkluis_type IS 'Enumeratie van de verschillende soorten sleutelkluis';
REVOKE ALL ON TABLE sleutelkluis_type FROM GROUP oiv_write;

CREATE TABLE sleuteldoel_type
(
  id            SMALLINT PRIMARY KEY NOT NULL,
  naam          TEXT
);
COMMENT ON TABLE sleuteldoel_type IS 'Enumeratie van de verschillende doelen van de sleutel in de sleutelkluis';
REVOKE ALL ON TABLE sleuteldoel_type FROM GROUP oiv_write;

CREATE TABLE sleutelkluis
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  sleutelkluis_type_id      INTEGER,
  rotatie                   INTEGER DEFAULT 0,
  label                     VARCHAR(50),
  aanduiding_locatie        VARCHAR(254),
  sleuteldoel_type_id       INTEGER,  
  ingang_id        			    INTEGER 				NOT NULL,
  fotografie_id             INTEGER,
  CONSTRAINT sleutelkluis_type_id_fk FOREIGN KEY (sleutelkluis_type_id) REFERENCES sleutelkluis_type (id),
  CONSTRAINT sleuteldoel_type_id_fk  FOREIGN KEY (sleuteldoel_type_id)  REFERENCES sleuteldoel_type (id),
  CONSTRAINT sleutelkluis_ingang_id_fk FOREIGN KEY (ingang_id) REFERENCES ingang (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT sleutelkluis_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE sleutelkluis IS 'Sleutelkluizen t.b.v. ingang een pand en dus een bouwlaag';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON sleutelkluis
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE INDEX sleutelkluis_geom_gist
  ON sleutelkluis USING GIST(geom);
  
CREATE OR REPLACE VIEW bouwlaag_sleutelkluis AS
  SELECT v.*, part.bouwlaag FROM sleutelkluis v INNER JOIN 
    (SELECT b.bouwlaag, ib.id FROM ingang ib JOIN bouwlagen b ON ib.bouwlaag_id = b.id) part
    ON v.ingang_id = part.id;

CREATE OR REPLACE RULE sleutelkluis_del AS
    ON DELETE TO bouwlaag_sleutelkluis DO INSTEAD  DELETE FROM sleutelkluis
  WHERE sleutelkluis.id = old.id;

CREATE OR REPLACE RULE sleutelkluis_ins AS
    ON INSERT TO bouwlaag_sleutelkluis DO INSTEAD  INSERT INTO sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, fotografie_id)
  VALUES (new.geom, new.sleutelkluis_type_id, new.label, new.rotatie, new.aanduiding_locatie, new.sleuteldoel_type_id, new.ingang_id, new.fotografie_id)
  RETURNING sleutelkluis.id,
    sleutelkluis.geom,
    sleutelkluis.datum_aangemaakt,
    sleutelkluis.datum_gewijzigd,
    sleutelkluis.sleutelkluis_type_id,
    sleutelkluis.rotatie,
    sleutelkluis.label,
    sleutelkluis.aanduiding_locatie,
    sleutelkluis.sleuteldoel_type_id,
    sleutelkluis.ingang_id,
    sleutelkluis.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE sleutelkluis.ingang_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE sleutelkluis_upd AS
    ON UPDATE TO bouwlaag_sleutelkluis DO INSTEAD  UPDATE sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, 
        sleuteldoel_type_id = new.sleuteldoel_type_id, ingang_id = new.ingang_id, fotografie_id = new.fotografie_id
        WHERE sleutelkluis.id = new.id;
        
--Update gevaarlijke stoffen, opslag en cirkel
ALTER TABLE gevaarlijkestof_opslag ADD COLUMN object_id INTEGER;
ALTER TABLE gevaarlijkestof_opslag ALTER bouwlaag_id DROP NOT NULL;
ALTER TABLE gevaarlijkestof_opslag ADD CONSTRAINT opslag_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE gevaarlijkestof_opslag ADD CONSTRAINT opslag_fk_check CHECK	(bouwlaag_id IS NOT NULL OR object_id IS NOT NULL);

DROP VIEW bouwlaag_opslag;
CREATE OR REPLACE VIEW bouwlaag_opslag AS 
 SELECT o.*,
    b.bouwlaag
   FROM gevaarlijkestof_opslag o
     JOIN bouwlagen b ON o.bouwlaag_id = b.id;

CREATE OR REPLACE RULE opslag_del AS
    ON DELETE TO bouwlaag_opslag DO INSTEAD  DELETE FROM gevaarlijkestof_opslag
  WHERE gevaarlijkestof_opslag.id = old.id;

CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_opslag DO INSTEAD  INSERT INTO gevaarlijkestof_opslag (geom, locatie, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id, new.fotografie_id)
  RETURNING gevaarlijkestof_opslag.id,
    gevaarlijkestof_opslag.geom,
    gevaarlijkestof_opslag.datum_aangemaakt,
    gevaarlijkestof_opslag.datum_gewijzigd,
    gevaarlijkestof_opslag.locatie,
    gevaarlijkestof_opslag.bouwlaag_id,
    gevaarlijkestof_opslag.object_id,
    gevaarlijkestof_opslag.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE gevaarlijkestof_opslag.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE opslag_upd AS
    ON UPDATE TO bouwlaag_opslag DO INSTEAD  UPDATE gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE gevaarlijkestof_opslag.id = new.id;

ALTER TABLE gevaarlijkestof ADD COLUMN handelingsaanwijzing TEXT;
ALTER TABLE gevaarlijkestof_schade_cirkel ADD COLUMN gevaarlijkestof_id INTEGER;
ALTER TABLE gevaarlijkestof_schade_cirkel ADD CONSTRAINT schade_cirkel_gevaarlijkestof_id_fk FOREIGN KEY (gevaarlijkestof_id) 
                                            REFERENCES gevaarlijkestof (id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE gevaarlijkestof_schade_cirkel DROP CONSTRAINT schade_cirkel_opslag_id_fk;

UPDATE gevaarlijkestof_schade_cirkel gsc SET gevaarlijkestof_id = p.id FROM
    (SELECT DISTINCT ON (opslag_id) * FROM gevaarlijkestof) p
    WHERE gsc.opslag_id = p.opslag_id;

ALTER TABLE gevaarlijkestof_schade_cirkel ALTER COLUMN gevaarlijkestof_id SET NOT NULL;

--CREATE tabel afw_binnendekking
CREATE TYPE afw_binnendekking_type AS ENUM('Dekkingsprobleem DMO', 'Dekkingsprobleem TMO');

CREATE TABLE afw_binnendekking
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  soort 					afw_binnendekking_type NOT NULL,
  rotatie                   INTEGER DEFAULT 0,
  label                     VARCHAR(50),
  handelingsaanwijzing      VARCHAR(254),
  bouwlaag_id               INTEGER,
  object_id 				INTEGER,
  CONSTRAINT afw_binnendekking_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT afw_binnendekking_object_id_fk   FOREIGN KEY (object_id)   REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT afw_binnendekking_fk_check 	  CHECK       (bouwlaag_id IS NOT NULL OR object_id IS NOT NULL)
);
COMMENT ON TABLE afw_binnendekking IS 'Afwijkende binnendekking';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON afw_binnendekking
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE INDEX afw_binnendekking_geom_gist
  ON afw_binnendekking USING GIST(geom);
  
CREATE OR REPLACE VIEW bouwlaag_afw_binnendekking AS
  SELECT v.*, b.bouwlaag FROM afw_binnendekking v JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE afw_binnendekking_del AS
    ON DELETE TO bouwlaag_afw_binnendekking DO INSTEAD  DELETE FROM afw_binnendekking
  WHERE afw_binnendekking.id = old.id;

CREATE OR REPLACE RULE afw_binnendekking_ins AS
    ON INSERT TO bouwlaag_afw_binnendekking DO INSTEAD  INSERT INTO afw_binnendekking (geom, soort, label, rotatie, handelingsaanwijzing, bouwlaag_id)
  VALUES (new.geom, new.soort, new.label, new.rotatie, new.handelingsaanwijzing, new.bouwlaag_id)
  RETURNING afw_binnendekking.id,
    afw_binnendekking.geom,
    afw_binnendekking.datum_aangemaakt,
    afw_binnendekking.datum_gewijzigd,
    afw_binnendekking.soort,
    afw_binnendekking.rotatie,
    afw_binnendekking.label,
    afw_binnendekking.handelingsaanwijzing,
    afw_binnendekking.bouwlaag_id,
    afw_binnendekking.object_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE afw_binnendekking.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE afw_binnendekking_bouwlaag_upd AS
    ON UPDATE TO bouwlaag_afw_binnendekking DO INSTEAD  UPDATE afw_binnendekking SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, handelingsaanwijzing = new.handelingsaanwijzing, bouwlaag_id = new.bouwlaag_id
        WHERE afw_binnendekking.id = new.id;    

CREATE TYPE labels_type AS ENUM(
    'Algemeen',
    'Gevaar',
    'Voorzichtig',
    'Waarschuwing');

ALTER TABLE label DROP CONSTRAINT labels_type_id_fk;
DROP VIEW bouwlaag_label;
DROP VIEW view_labels;
ALTER TABLE label ALTER COLUMN type_label TYPE VARCHAR(25);

UPDATE label g SET type_label = e.type_label
	FROM label_type e WHERE g.type_label = e.id::TEXT;

ALTER TABLE label RENAME type_label TO soort;
ALTER TABLE label ALTER COLUMN soort TYPE labels_type USING soort::labels_type;

ALTER TABLE label ADD COLUMN object_id INTEGER;
ALTER TABLE label ALTER COLUMN bouwlaag_id DROP NOT NULL;
ALTER TABLE label ADD CONSTRAINT labels_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE label ADD CONSTRAINT label_fk_check 	 CHECK       (bouwlaag_id IS NOT NULL OR object_id IS NOT NULL);
  
DROP TABLE label_type;

--gevaarlijke stoffen
CREATE TYPE eenheid_type AS ENUM
   ('cilinder',
    'geen eenheid geselecteerd',
    'kg',
    'liter',
    'm3',
    'stuks');
    
CREATE TYPE toestand_type AS ENUM
   ('gas',
    'gas / vloeibaar',
    'vast',
    'vloeibaar',
    'vloeibaar / vast', 
    'geen toestand geselecteerd');

DROP VIEW view_gevaarlijkestof;
ALTER TABLE gevaarlijkestof DROP CONSTRAINT gevaarlijkestof_eenheid_id_fk;
ALTER TABLE gevaarlijkestof ALTER COLUMN gevaarlijkestof_eenheid_id TYPE VARCHAR(50);

UPDATE gevaarlijkestof g SET gevaarlijkestof_eenheid_id = e.naam
	FROM gevaarlijkestof_eenheid e WHERE g.gevaarlijkestof_eenheid_id = e.id::TEXT;

ALTER TABLE gevaarlijkestof RENAME gevaarlijkestof_eenheid_id TO eenheid;
ALTER TABLE gevaarlijkestof ALTER COLUMN eenheid TYPE eenheid_type USING eenheid::eenheid_type;

ALTER TABLE gevaarlijkestof DROP CONSTRAINT gevaarlijkestof_toestand_id_fk;
ALTER TABLE gevaarlijkestof ALTER COLUMN gevaarlijkestof_toestand_id TYPE VARCHAR(50);

UPDATE gevaarlijkestof g SET gevaarlijkestof_toestand_id = e.naam
	FROM gevaarlijkestof_toestand e WHERE g.gevaarlijkestof_toestand_id = e.id::TEXT;

ALTER TABLE gevaarlijkestof RENAME gevaarlijkestof_toestand_id TO toestand;
ALTER TABLE gevaarlijkestof ALTER COLUMN toestand TYPE toestand_type USING toestand::toestand_type;

--CREATE TABLE Schade_cirkel
CREATE TYPE schade_cirkel_type AS ENUM (
    'onherstelbare schade en branden',
    'zware schade en secundaire branden',
    'secundaire branden treden op',
    'geen of lichte schade');

DROP VIEW schade_cirkel_calc;
DROP VIEW view_schade_cirkel;
ALTER TABLE gevaarlijkestof_schade_cirkel DROP CONSTRAINT schade_cirkel_id_fk;
ALTER TABLE gevaarlijkestof_schade_cirkel ALTER COLUMN soort_cirkel TYPE VARCHAR(50);

UPDATE gevaarlijkestof_schade_cirkel g SET soort_cirkel = e.naam
	FROM gevaarlijkestof_schade_cirkel_type e WHERE g.soort_cirkel = e.id::TEXT;

ALTER TABLE gevaarlijkestof_schade_cirkel RENAME soort_cirkel TO soort;
ALTER TABLE gevaarlijkestof_schade_cirkel ALTER COLUMN soort TYPE schade_cirkel_type USING soort::schade_cirkel_type;

DROP TABLE gevaarlijkestof_schade_cirkel_type;

CREATE OR REPLACE VIEW object_terrein AS
SELECT id, basisreg_identifier, formelenaam, geovlak, bron, bron_tabel FROM object;

CREATE OR REPLACE RULE object_terrein_del AS
    ON DELETE TO object_terrein DO INSTEAD NOTHING;

CREATE OR REPLACE RULE object_terrein_ins AS
    ON INSERT TO object_terrein DO INSTEAD UPDATE object SET geovlak = new.geovlak
      WHERE id = new.id RETURNING id, basisreg_identifier, formelenaam, geovlak, bron, bron_tabel;

CREATE OR REPLACE RULE object_terrein_upd AS
    ON UPDATE TO object_terrein DO INSTEAD UPDATE object SET geovlak = new.geovlak
  WHERE id = new.id;

UPDATE algemeen.applicatie SET sub = 9;
UPDATE algemeen.applicatie SET revisie = 94;
UPDATE algemeen.applicatie SET db_versie = 994; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();