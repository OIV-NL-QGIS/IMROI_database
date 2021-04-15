--Extra analyse lagen t.b.v. bluswater beheer, analyse bag pand niet bereikt binnen 100m straal
SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE gevaarlijkestof_opslag ADD COLUMN rotatie integer DEFAULT 0;
ALTER TABLE bereikbaarheid         ADD COLUMN label   CHARACTER VARYING(254);

DROP VIEW IF EXISTS bouwlaag_opslag;
CREATE OR REPLACE VIEW bouwlaag_opslag AS 
 SELECT o.*,
    b.bouwlaag
   FROM gevaarlijkestof_opslag o
     JOIN bouwlagen b ON o.bouwlaag_id = b.id;

CREATE OR REPLACE RULE opslag_del AS
    ON DELETE TO bouwlaag_opslag DO INSTEAD  DELETE FROM gevaarlijkestof_opslag
  WHERE gevaarlijkestof_opslag.id = old.id;

CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_opslag DO INSTEAD  INSERT INTO gevaarlijkestof_opslag (geom, locatie, bouwlaag_id, fotografie_id, rotatie)
  VALUES (new.geom, new.locatie, new.bouwlaag_id, new.fotografie_id, new.rotatie)
  RETURNING gevaarlijkestof_opslag.id,
    gevaarlijkestof_opslag.geom,
    gevaarlijkestof_opslag.datum_aangemaakt,
    gevaarlijkestof_opslag.datum_gewijzigd,
    gevaarlijkestof_opslag.locatie,
    gevaarlijkestof_opslag.bouwlaag_id,
    gevaarlijkestof_opslag.object_id,
    gevaarlijkestof_opslag.fotografie_id,
    gevaarlijkestof_opslag.rotatie,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE gevaarlijkestof_opslag.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE opslag_upd AS
    ON UPDATE TO bouwlaag_opslag DO INSTEAD  UPDATE gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE gevaarlijkestof_opslag.id = new.id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 10;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 2104; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();