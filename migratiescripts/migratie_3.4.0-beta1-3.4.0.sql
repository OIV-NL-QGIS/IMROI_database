SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE objecten.bouwlagen ADD COLUMN IF NOT EXISTS fotografie_id integer;

ALTER TABLE objecten.bouwlagen DROP CONSTRAINT IF EXISTS bouwlagen_fotografie_id_fk;
ALTER TABLE objecten.bouwlagen ADD CONSTRAINT bouwlagen_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

DROP VIEW IF EXISTS objecten.bouwlaag_bouwlagen;
CREATE OR REPLACE VIEW objecten.bouwlaag_bouwlagen
AS SELECT *
   FROM objecten.bouwlagen b
  WHERE b.datum_deleted IS NULL;
  
CREATE RULE bouwlagen_del AS
    ON DELETE TO objecten.bouwlaag_bouwlagen DO INSTEAD  DELETE FROM objecten.bouwlagen
  WHERE (bouwlagen.id = old.id);
  
CREATE RULE bouwlagen_upd AS
    ON UPDATE TO objecten.bouwlaag_bouwlagen DO INSTEAD  
      UPDATE objecten.bouwlagen 
        SET geom = new.geom, bouwlaag = new.bouwlaag, bouwdeel = new.bouwdeel, pand_id = new.pand_id, fotografie_id = new.fotografie_id
  WHERE (bouwlagen.id = new.id);

CREATE RULE bouwlagen_ins AS
    ON INSERT TO objecten.bouwlaag_bouwlagen DO INSTEAD  INSERT INTO objecten.bouwlagen (geom, bouwlaag, bouwdeel, pand_id, fotografie_id)
  VALUES (new.geom, new.bouwlaag, new.bouwdeel, new.pand_id, new.fotografie_id)
  RETURNING *;

DROP RULE IF EXISTS object_bgt_ins ON objecten.object_bgt;
CREATE RULE object_bgt_ins AS
    ON INSERT TO objecten.object_bgt DO INSTEAD  INSERT INTO objecten.object (geom, basisreg_identifier, formelenaam, bron, bron_tabel)  SELECT new.geom,
            b.identificatie,
            new.formelenaam,
            b.bron,
            b.bron_tbl
           FROM algemeen.bgt_extent b
          WHERE st_intersects(new.geom, st_curvetoline(b.geovlak))
         LIMIT 1
  RETURNING object.id,
    object.geom,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.basisreg_identifier,
    object.formelenaam,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    object.datum_geldig_tot,
    object.datum_geldig_vanaf,
    object.bron,
    object.bron_tabel,
    object.fotografie_id,
    object.bodemgesteldheid_type_id,
    ( SELECT o.typeobject
           FROM objecten.historie o
          WHERE (o.object_id = object.id)
         LIMIT 1) AS typeobject;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 340; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
