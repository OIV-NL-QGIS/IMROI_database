SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

DROP VIEW IF EXISTS objecten.view_sleutelkluis_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag AS 
 SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.sleutelkluis_type_id,
    d.aanduiding_locatie,
    d.sleuteldoel_type_id,
    d.rotatie,
    d.label,
    d.ingang_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id as object_id,
    b.bouwlaag,
    b.bouwdeel,
    i.bouwlaag_id,
    dd.naam AS doel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size
FROM objecten.object o
INNER JOIN 
    (SELECT h.object_id
      FROM objecten.historie h
      INNER JOIN
          (SELECT object_id, MAX(datum_aangemaakt) AS maxdatetime
          FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text
          GROUP BY object_id
          ) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime
    ) part ON o.id = part.object_id
INNER JOIN objecten.terrein t ON o.id = t.object_id
INNER JOIN objecten.sleutelkluis d ON ST_INTERSECTS(t.geom, d.geom)
INNER JOIN objecten.ingang i ON d.ingang_id = i.id
INNER JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
INNER JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
LEFT OUTER JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id 
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

DROP VIEW IF EXISTS objecten.view_sleutelkluis_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_ruimtelijk AS 
 SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.sleutelkluis_type_id,
    d.aanduiding_locatie,
    d.sleuteldoel_type_id,
    d.rotatie,
    d.label,
    d.ingang_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    i.object_id,
    dd.naam AS doel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size
FROM objecten.object o
INNER JOIN 
    (SELECT h.object_id
      FROM objecten.historie h
      INNER JOIN
          (SELECT object_id, MAX(datum_aangemaakt) AS maxdatetime
          FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text
          GROUP BY object_id
          ) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime
    ) part ON o.id = part.object_id
INNER JOIN objecten.ingang i ON o.id = i.object_id
INNER JOIN objecten.sleutelkluis d ON i.id = d.ingang_id
INNER JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
LEFT OUTER JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id 
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

CREATE OR REPLACE VIEW objecten.view_grid
AS SELECT b.id,
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
    b.uuid,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.grid b ON o.id = b.object_id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 5;
UPDATE algemeen.applicatie SET db_versie = 335; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
