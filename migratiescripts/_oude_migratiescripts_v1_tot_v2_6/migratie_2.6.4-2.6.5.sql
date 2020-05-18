SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE object ADD COLUMN oms_nummer CHARACTER VARYING(25);

CREATE OR REPLACE VIEW objecten.print_objectgegevens AS 
 SELECT obj.id,
    obj.geom,
    obj.datum_aangemaakt,
    obj.datum_gewijzigd,
    obj.pand_id,
    obj.object_bouwconstructie_id,
    obj.laagstebouw,
    obj.hoogstebouw,
    obj.formelenaam,
    obj.bhvaanwezig,
    obj.bijzonderheden,
    obj.pers_max,
    obj.pers_nietz_max,
    ob.naam AS gebouwconstructie,
    obj.oms_nummer
   FROM objecten.object obj
     LEFT JOIN objecten.object_bouwconstructie ob ON obj.object_bouwconstructie_id = ob.id;

CREATE OR REPLACE VIEW objecten.view_objectgegevens AS 
 SELECT object.id,
    object.formelenaam,
    object.geom,
    object.pand_id,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.laagstebouw,
    object.hoogstebouw,
        CASE
            WHEN object.bhvaanwezig = true THEN 'ja'::text
            ELSE 'nee'::text
        END AS bhvaanwezig,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    ob.naam AS bouwconstructie,
    b.gebruiksdoel,
    round(st_x(object.geom)) AS x,
    round(st_y(object.geom)) AS y,
    object.oms_nummer
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
           FROM objecten.historie historie_1
          WHERE historie_1.object_id = object.id
          ORDER BY historie_1.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN objecten.object_bouwconstructie ob ON object.object_bouwconstructie_id = ob.id
     LEFT JOIN algemeen.bag_extent b ON object.pand_id::text = b.identificatie
  WHERE historie.historie_status_id = 2;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 5;
UPDATE algemeen.applicatie SET db_versie = 265; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();