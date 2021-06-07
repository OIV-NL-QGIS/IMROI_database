SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

UPDATE objecten.gevaarlijkestof_vnnr SET vn_nr = ' geen vn nummer' WHERE vn_nr = 'geen vn nummer';

DROP VIEW IF EXISTS objecten.view_label_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_label_bouwlaag AS 
 SELECT l.id,
    l.geom,
    l.datum_aangemaakt,
    l.datum_gewijzigd,
    l.omschrijving,
    l.soort,
    l.rotatie,
    l.bouwlaag_id,
    o.formelenaam,
    o.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(l.geom)) AS x,
    round(st_y(l.geom)) AS y
   FROM objecten.label l
     JOIN objecten.bouwlagen b ON l.bouwlaag_id = b.id
     JOIN ( SELECT object.formelenaam,
            object.id AS object_id,
            object.geovlak
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON st_intersects(l.geom, o.geovlak);


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 0;
UPDATE algemeen.applicatie SET revisie = 9;
UPDATE algemeen.applicatie SET db_versie = 309; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();