SET ROLE oiv_admin;

ALTER TABLE objecten.object DROP COLUMN IF EXISTS bhvaanwezig CASCADE;

CREATE OR REPLACE VIEW objecten.object_bgt AS
SELECT * FROM objecten.object WHERE bron = 'BGT';

CREATE OR REPLACE RULE object_bgt_ins AS
  ON INSERT TO objecten.object_bgt DO INSTEAD  
  INSERT INTO objecten.object (geom, basisreg_identifier, formelenaam, bron, bron_tabel)
  SELECT new.geom, b.identificatie, new.formelenaam, b.bron, b.bron_tbl FROM
  algemeen.bgt_extent b WHERE ST_INTERSECTS(new.geom, ST_CURVETOLINE(b.geovlak)) LIMIT 1
  RETURNING object.id,
    object.geom,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.basisreg_identifier,
    object.formelenaam,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    object.fotografie_id,
    object.oms_nummer,
    object.geovlak,
    object.datum_geldig_tot,
    object.datum_geldig_vanaf,
    object.bron,
    object.bron_tabel;

CREATE OR REPLACE VIEW objecten.view_objectgegevens AS 
 SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    object.datum_geldig_vanaf,
    object.datum_geldig_tot,
    object.bron,
    object.bron_tabel,
    round(st_x(object.geom)) AS x,
    round(st_y(object.geom)) AS y
   FROM objecten.object
     JOIN ( SELECT object_1.formelenaam,
            object_1.id AS object_id,
            object_1.geovlak
           FROM objecten.object object_1
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object_1.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object_1.datum_geldig_vanaf <= now() OR object_1.datum_geldig_vanaf IS NULL) AND (object_1.datum_geldig_tot > now() OR object_1.datum_geldig_tot IS NULL)) o ON object.id = o.object_id;

CREATE OR REPLACE VIEW objecten.ruimtelijk_sleutelkluis AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.sleutelkluis_type_id,
    v.rotatie,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.ingang_id,
    v.fotografie_id
   FROM objecten.sleutelkluis v
     INNER JOIN objecten.ingang ib ON v.ingang_id = ib.id
   WHERE ib.object_id IS NOT NULL;

CREATE OR REPLACE RULE sleutelkluis_ruimtelijk_del AS
    ON DELETE TO objecten.ruimtelijk_sleutelkluis DO INSTEAD  DELETE FROM objecten.sleutelkluis
  WHERE sleutelkluis.id = old.id;

CREATE OR REPLACE RULE ruimtelijk_sleutelkluis_ins AS
    ON INSERT TO objecten.ruimtelijk_sleutelkluis DO INSTEAD  INSERT INTO objecten.sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, fotografie_id)
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
    sleutelkluis.fotografie_id;

CREATE OR REPLACE RULE ruimtelijk_sleutelkluis_upd AS
    ON UPDATE TO objecten.ruimtelijk_sleutelkluis DO INSTEAD  UPDATE objecten.sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, sleuteldoel_type_id = new.sleuteldoel_type_id, ingang_id = new.ingang_id, fotografie_id = new.fotografie_id
  WHERE sleutelkluis.id = new.id;

UPDATE algemeen.applicatie SET versie = 3;
UPDATE algemeen.applicatie SET sub = 0;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 300; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();