SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- database gereed maken voor gebruik plugin
-- drop de overbodige views
-- Drop OIV Objecten Plus Views
DROP VIEW IF EXISTS bouwlaag;
DROP VIEW IF EXISTS bouwlaag_1;
DROP VIEW IF EXISTS bouwlaag_2;
DROP VIEW IF EXISTS bouwlaag_3;
DROP VIEW IF EXISTS bouwlaag_4;
DROP VIEW IF EXISTS bouwlaag_5;
DROP VIEW IF EXISTS bouwlaag_6;
DROP VIEW IF EXISTS bouwlaag_7;
DROP VIEW IF EXISTS bouwlaag_8;
DROP VIEW IF EXISTS bouwlaag_9;
DROP VIEW IF EXISTS bouwlaag_10;
DROP VIEW IF EXISTS bouwlaag_min1;
DROP VIEW IF EXISTS bouwlaag_min2;
DROP VIEW IF EXISTS bouwlaag_min3;

DROP VIEW IF EXISTS bouwlaag_1_label;
DROP VIEW IF EXISTS bouwlaag_2_label;
DROP VIEW IF EXISTS bouwlaag_3_label;
DROP VIEW IF EXISTS bouwlaag_4_label;
DROP VIEW IF EXISTS bouwlaag_5_label;
DROP VIEW IF EXISTS bouwlaag_6_label;
DROP VIEW IF EXISTS bouwlaag_7_label;
DROP VIEW IF EXISTS bouwlaag_8_label;
DROP VIEW IF EXISTS bouwlaag_9_label;
DROP VIEW IF EXISTS bouwlaag_10_label;
DROP VIEW IF EXISTS bouwlaag_min1_label;
DROP VIEW IF EXISTS bouwlaag_min2_label;
DROP VIEW IF EXISTS bouwlaag_min3_label;
DROP VIEW IF EXISTS bouwlaag_label;

DROP VIEW IF EXISTS bouwlaag_opslag;
DROP VIEW IF EXISTS bouwlaag_1_opslag;
DROP VIEW IF EXISTS bouwlaag_2_opslag;
DROP VIEW IF EXISTS bouwlaag_3_opslag;
DROP VIEW IF EXISTS bouwlaag_4_opslag;
DROP VIEW IF EXISTS bouwlaag_5_opslag;
DROP VIEW IF EXISTS bouwlaag_6_opslag;
DROP VIEW IF EXISTS bouwlaag_7_opslag;
DROP VIEW IF EXISTS bouwlaag_8_opslag;
DROP VIEW IF EXISTS bouwlaag_9_opslag;
DROP VIEW IF EXISTS bouwlaag_10_opslag;
DROP VIEW IF EXISTS bouwlaag_min1_opslag;
DROP VIEW IF EXISTS bouwlaag_min2_opslag;
DROP VIEW IF EXISTS bouwlaag_min3_opslag;

DROP VIEW IF EXISTS bouwlaag_scheiding;
DROP VIEW IF EXISTS bouwlaag_1_scheiding;
DROP VIEW IF EXISTS bouwlaag_2_scheiding;
DROP VIEW IF EXISTS bouwlaag_3_scheiding;
DROP VIEW IF EXISTS bouwlaag_4_scheiding;
DROP VIEW IF EXISTS bouwlaag_5_scheiding;
DROP VIEW IF EXISTS bouwlaag_6_scheiding;
DROP VIEW IF EXISTS bouwlaag_7_scheiding;
DROP VIEW IF EXISTS bouwlaag_8_scheiding;
DROP VIEW IF EXISTS bouwlaag_9_scheiding;
DROP VIEW IF EXISTS bouwlaag_10_scheiding;
DROP VIEW IF EXISTS bouwlaag_min1_scheiding;
DROP VIEW IF EXISTS bouwlaag_min2_scheiding;
DROP VIEW IF EXISTS bouwlaag_min3_scheiding;

DROP VIEW IF EXISTS bouwlaag_vlakken;
DROP VIEW IF EXISTS bouwlaag_1_vlakken;
DROP VIEW IF EXISTS bouwlaag_2_vlakken;
DROP VIEW IF EXISTS bouwlaag_3_vlakken;
DROP VIEW IF EXISTS bouwlaag_4_vlakken;
DROP VIEW IF EXISTS bouwlaag_5_vlakken;
DROP VIEW IF EXISTS bouwlaag_6_vlakken;
DROP VIEW IF EXISTS bouwlaag_7_vlakken;
DROP VIEW IF EXISTS bouwlaag_8_vlakken;
DROP VIEW IF EXISTS bouwlaag_9_vlakken;
DROP VIEW IF EXISTS bouwlaag_10_vlakken;
DROP VIEW IF EXISTS bouwlaag_min1_vlakken;
DROP VIEW IF EXISTS bouwlaag_min2_vlakken;
DROP VIEW IF EXISTS bouwlaag_min3_vlakken;

DROP VIEW IF EXISTS bouwlaag_picto;
DROP VIEW IF EXISTS bouwlaag_1_voorz;
DROP VIEW IF EXISTS bouwlaag_2_voorz;
DROP VIEW IF EXISTS bouwlaag_3_voorz;
DROP VIEW IF EXISTS bouwlaag_4_voorz;
DROP VIEW IF EXISTS bouwlaag_5_voorz;
DROP VIEW IF EXISTS bouwlaag_6_voorz;
DROP VIEW IF EXISTS bouwlaag_7_voorz;
DROP VIEW IF EXISTS bouwlaag_8_voorz;
DROP VIEW IF EXISTS bouwlaag_9_voorz;
DROP VIEW IF EXISTS bouwlaag_10_voorz;
DROP VIEW IF EXISTS bouwlaag_min1_voorz;
DROP VIEW IF EXISTS bouwlaag_min2_voorz;
DROP VIEW IF EXISTS bouwlaag_min3_voorz;

--alter column omschrijving (length of label) 16 to 254
DROP VIEW IF EXISTS objecten.bouwlaag_label;
DROP VIEW IF EXISTS objecten.view_labels;
ALTER TABLE objecten.object_labels ALTER COLUMN omschrijving TYPE character varying(254);

CREATE OR REPLACE VIEW objecten.view_labels AS 
 SELECT l.id,
    l.geom,
    l.datum_aangemaakt,
    l.datum_gewijzigd,
    l.omschrijving,
    l.rotatie,
    t.type_label,
    b.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(l.geom)) AS x,
    round(st_y(l.geom)) AS y
   FROM objecten.object_labels l
     JOIN objecten.label_type t ON l.type_label = t.id
     JOIN ( SELECT o.formelenaam,
            o.id,
            bouwlagen.id AS bouwlaag_id,
            bouwlagen.bouwlaag,
            bouwlagen.bouwdeel
           FROM ( SELECT object.formelenaam,
                    object.id
                   FROM objecten.object
                     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                           FROM objecten.historie historie_1
                          WHERE historie_1.object_id = object.id
                          ORDER BY historie_1.datum_aangemaakt DESC
                         LIMIT 1))
                  WHERE historie.historie_status_id = 2) o
             JOIN objecten.bouwlagen ON o.id = bouwlagen.object_id) b ON l.bouwlaag_id = b.bouwlaag_id;

-- Create new views t.b.v. de plugin
-- voorzieningen
CREATE OR REPLACE VIEW bouwlaag_picto AS 
 SELECT v.id, v.geom, v.datum_aangemaakt, v.datum_gewijzigd, v.voorziening_pictogram_id, v.rotatie, v.label, v.bouwlaag_id, b.bouwlaag
   FROM voorziening v JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE voorziening_del AS
    ON DELETE TO bouwlaag_picto DO INSTEAD  DELETE FROM voorziening WHERE voorziening.id = old.id;

CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_picto DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label,
    voorziening.bouwlaag_id, ( SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE voorziening.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE voorziening_upd AS
    ON UPDATE TO bouwlaag_picto DO INSTEAD  UPDATE voorziening SET geom = new.geom, voorziening_pictogram_id = new.voorziening_pictogram_id, rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id
  WHERE voorziening.id = new.id;

-- Opslag stoffen
CREATE OR REPLACE VIEW bouwlaag_opslag AS 
 SELECT o.id, o.geom, o.datum_aangemaakt, o.datum_gewijzigd, o.locatie, o.bouwlaag_id, b.bouwlaag
   FROM opslag o JOIN bouwlagen b ON o.bouwlaag_id = b.id;

CREATE OR REPLACE RULE opslag_del AS
    ON DELETE TO bouwlaag_opslag DO INSTEAD  DELETE FROM opslag WHERE opslag.id = old.id;

CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING opslag.id, opslag.geom, opslag.datum_aangemaakt, opslag.datum_gewijzigd, opslag.locatie, opslag.bouwlaag_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE opslag.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE opslag_upd AS
    ON UPDATE TO bouwlaag_opslag DO INSTEAD  UPDATE opslag SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id
  WHERE opslag.id = new.id;

-- labels
CREATE OR REPLACE VIEW bouwlaag_label AS 
 SELECT l.id, l.geom, l.datum_aangemaakt, l.datum_gewijzigd, l.omschrijving, l.type_label, l.rotatie, l.bouwlaag_id, b.bouwlaag
   FROM object_labels l JOIN bouwlagen b ON l.bouwlaag_id = b.id;

CREATE OR REPLACE RULE label_del AS
    ON DELETE TO bouwlaag_label DO INSTEAD  DELETE FROM object_labels WHERE object_labels.id = old.id;

CREATE OR REPLACE RULE label_ins AS
    ON INSERT TO bouwlaag_label DO INSTEAD  INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
  VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING object_labels.id, object_labels.geom, object_labels.datum_aangemaakt, object_labels.datum_gewijzigd, object_labels.omschrijving, object_labels.type_label,
    object_labels.rotatie, object_labels.bouwlaag_id, (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE object_labels.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE label_upd AS
    ON UPDATE TO bouwlaag_label DO INSTEAD  UPDATE object_labels SET geom = new.geom, type_label = new.type_label, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id
  WHERE object_labels.id = new.id;

-- scheidingen
CREATE OR REPLACE VIEW bouwlaag_scheiding AS 
 SELECT s.id, s.geom, s.datum_aangemaakt, s.datum_gewijzigd, s.scheiding_type_id, s.bouwlaag_id, b.bouwlaag
   FROM scheiding s JOIN bouwlagen b ON s.bouwlaag_id = b.id;

CREATE OR REPLACE RULE scheiding_del AS
    ON DELETE TO bouwlaag_scheiding DO INSTEAD  DELETE FROM scheiding WHERE scheiding.id = old.id;

CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING scheiding.id, scheiding.geom, scheiding.datum_aangemaakt, scheiding.datum_gewijzigd, scheiding.scheiding_type_id, scheiding.bouwlaag_id,
    ( SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE scheiding.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE scheiding_upd AS
    ON UPDATE TO bouwlaag_scheiding DO INSTEAD  UPDATE scheiding SET geom = new.geom, scheiding_type_id = new.scheiding_type_id, bouwlaag_id = new.bouwlaag_id
  WHERE scheiding.id = new.id;
  
-- vlakken
CREATE OR REPLACE VIEW bouwlaag_vlakken AS 
 SELECT v.id, v.geom, v.datum_aangemaakt, v.datum_gewijzigd, v.vlakken_type_id, v.bouwlaag_id, b.bouwlaag
   FROM vlakken v JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE vlakken_del AS
    ON DELETE TO bouwlaag_vlakken DO INSTEAD  DELETE FROM vlakken WHERE vlakken.id = old.id;

CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO bouwlaag_vlakken DO INSTEAD  INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING vlakken.id, vlakken.geom, vlakken.datum_aangemaakt, vlakken.datum_gewijzigd, vlakken.vlakken_type_id, vlakken.bouwlaag_id,
    ( SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE vlakken.bouwlaag_id = bouwlagen.id) AS bouwlaag;
    
CREATE OR REPLACE RULE vlakken_upd AS
    ON UPDATE TO bouwlaag_vlakken DO INSTEAD  UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, bouwlaag_id = new.bouwlaag_id
  WHERE vlakken.id = new.id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 8;
UPDATE algemeen.applicatie SET db_versie = 18;
UPDATE algemeen.applicatie SET datum = now();