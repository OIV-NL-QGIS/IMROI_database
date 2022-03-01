SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

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
        SET geom = new.geom, bouwlaag = new.bouwlaag, bouwdeel = new.bouwdeel, pand_id = new.pand_id
  WHERE (bouwlagen.id = new.id);
  
CREATE RULE bouwlagen_ins AS
    ON INSERT TO objecten.bouwlaag_bouwlagen DO INSTEAD  INSERT INTO objecten.bouwlagen (geom, bouwlaag, bouwdeel, pand_id)
  VALUES (new.geom, new.bouwlaag, new.bouwdeel, new.pand_id)
  RETURNING bouwlagen.id,
    bouwlagen.geom,
    bouwlagen.datum_aangemaakt,
    bouwlagen.datum_gewijzigd,
    bouwlagen.bouwlaag,
    bouwlagen.bouwdeel,
    bouwlagen.pand_id,
    bouwlagen.datum_deleted;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 340; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();