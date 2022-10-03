SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE grid ADD COLUMN vaknummer varchar(10);

ALTER TABLE grid RENAME COLUMN label_top TO x_as_label;
ALTER TABLE grid RENAME COLUMN label_left TO y_as_label;

ALTER TABLE grid ALTER COLUMN geom TYPE geometry(MultiPolygon, 28992) USING ST_MULTI(geom);

DROP VIEW IF EXISTS view_isolijnen;

ALTER TABLE isolijnen ALTER COLUMN geom TYPE geometry(MultiLineString, 28992) USING ST_MULTI(geom);

CREATE OR REPLACE VIEW objecten.view_isolijnen AS 
 SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.hoogte,
    b.omschrijving,
    b.object_id,
    o.formelenaam
   FROM objecten.isolijnen b
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND 
                (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND 
                (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id;


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 1;
UPDATE algemeen.applicatie SET revisie = 6;
UPDATE algemeen.applicatie SET db_versie = 316; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();