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

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 340; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
