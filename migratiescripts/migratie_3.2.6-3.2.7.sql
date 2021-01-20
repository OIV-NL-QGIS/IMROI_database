SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

DROP TABLE IF EXISTS objecten.kaartbladen CASCADE;

ALTER TABLE grid ADD COLUMN scale integer;
ALTER TABLE grid ADD COLUMN papersize varchar(2);
ALTER TABLE grid ADD COLUMN orientation varchar(10);
ALTER TABLE grid ADD COLUMN type varchar(10) NOT NULL DEFAULT 'Grid';
ALTER TABLE grid ALTER COLUMN type DROP DEFAULT;

DROP VIEW object_grid;
CREATE OR REPLACE VIEW object_grid AS 
 SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.y_as_label,
    b.x_as_label,
    b.object_id,
    b.afstand,
    b.vaknummer,
    b.scale,
    b.papersize,
    b.orientation,
    b.type,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM objecten.grid b
     JOIN ( SELECT object.formelenaam,
            object.datum_geldig_vanaf,
            object.datum_geldig_tot,
            object.id,
            historie.typeobject
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE object_grid_ins AS
  ON INSERT TO objecten.object_grid DO INSTEAD  
  INSERT INTO objecten.grid (geom, x_as_label, y_as_label, object_id, afstand, vaknummer, scale, papersize, orientation, type)
  VALUES (new.geom, new.x_as_label, new.y_as_label, new.object_id, new.afstand, new.vaknummer, new.scale, new.papersize, new.orientation, new.type)
  RETURNING grid.id,
    grid.geom,
    grid.datum_aangemaakt,
    grid.datum_gewijzigd,
    grid.y_as_label,
    grid.x_as_label,
    grid.object_id,
    grid.afstand,
    grid.vaknummer,
    grid.scale,
    grid.papersize,
    grid.orientation,
    grid.type,
    ( SELECT o.formelenaam
           FROM objecten.object o
          WHERE o.id = grid.object_id) AS formelenaam,
    ( SELECT o.datum_geldig_vanaf
           FROM objecten.object o
          WHERE o.id = grid.object_id) AS datum_geldig_vanaf,
    ( SELECT o.datum_geldig_tot
           FROM objecten.object o
          WHERE o.id = grid.object_id) AS datum_geldig_tot,
    ( SELECT o.typeobject
           FROM objecten.historie o
          WHERE o.object_id = grid.object_id
         LIMIT 1) AS typeobject;

CREATE OR REPLACE RULE object_grid_upd AS
    ON UPDATE TO objecten.object_grid DO INSTEAD  
    UPDATE objecten.grid 
    SET geom = new.geom, x_as_label = new.x_as_label, y_as_label = new.y_as_label, object_id = new.object_id, afstand = new.afstand, vaknummer = new.vaknummer,
        scale = new.scale, papersize = new.papersize, orientation = new.orientation, type = new.type
  WHERE grid.id = new.id;

CREATE OR REPLACE RULE object_grid_upd AS
    ON UPDATE TO objecten.object_grid DO INSTEAD  
    UPDATE objecten.grid 
    SET geom = new.geom, x_as_label = new.x_as_label, y_as_label = new.y_as_label, object_id = new.object_id, afstand = new.afstand, vaknummer = new.vaknummer,
        scale = new.scale, papersize = new.papersize, orientation = new.orientation, type = new.type
  WHERE grid.id = new.id;

CREATE OR REPLACE RULE object_grid_del AS
    ON DELETE TO objecten.object_grid DO INSTEAD  DELETE FROM objecten.grid
  WHERE grid.id = old.id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 327; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();