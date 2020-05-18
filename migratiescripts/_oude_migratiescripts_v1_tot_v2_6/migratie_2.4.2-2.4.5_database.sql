SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

TRUNCATE TABLE algemeen.bag_extent;
ALTER TABLE algemeen.bag_extent ADD COLUMN gebruiksdoel TEXT;

-- import de nieuwe bag_extent tabel
-- via psql plugin in pgAdmin
-- gebruik het volgende commando
-- \copy algemeen.bag_extent FROM 'c:/pad_naar_bestand/bestandsnaam.csv' DELIMITER ',' CSV
-- pas het pad en de bestandsnaam aan
-- denk erom er mogen geen spaties in de pad verwijzing staan

--Denk erom, als er andere views aan gekoppeld zijn dan verdwijnen die ook!!!
-- aanpassen view objectgegevens bhv ja/nee ipv t/f en koppeling gebruiksdoel vanuit bag_extent
DROP VIEW IF EXISTS objecten.view_objectgegevens CASCADE;

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
        WHEN bhvaanwezig = true THEN 'ja'::text
        ELSE 'nee'::text
    END AS bhvaanwezig,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    ob.naam AS bouwconstructie,
    b.gebruiksdoel,
    round(st_x(object.geom)) AS x,
    round(st_y(object.geom)) AS y
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
           FROM objecten.historie historie_1
          WHERE historie_1.object_id = object.id
          ORDER BY historie_1.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN objecten.object_bouwconstructie ob ON object.object_bouwconstructie_id = ob.id
     LEFT JOIN algemeen.bag_extent b ON object.pand_id = b.identificatie     
  WHERE historie.historie_status_id = 2;

  
-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 243; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();