SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

DROP VIEW IF EXISTS objecten.view_dreiging_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_dreiging_bouwlaag AS 
 SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.dreiging_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id as object_id,
    b.bouwlaag,
    b.bouwdeel,
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
INNER JOIN objecten.dreiging d ON ST_INTERSECTS(t.geom, d.geom)
INNER JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
INNER JOIN objecten.dreiging_type dt ON d.dreiging_type_id = dt.id 
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_ingang_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag AS 
 SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.ingang_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id as object_id,
    b.bouwlaag,
    b.bouwdeel,
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
INNER JOIN objecten.ingang d ON ST_INTERSECTS(t.geom, d.geom)
INNER JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
INNER JOIN objecten.ingang_type dt ON d.ingang_type_id = dt.id 
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_label_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_label_bouwlaag AS 
 SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.omschrijving,
    d.soort,
    d.rotatie,
    d.bouwlaag_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id as object_id,
    b.bouwlaag,
    b.bouwdeel
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
INNER JOIN objecten.label d ON ST_INTERSECTS(t.geom, d.geom)
INNER JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_ruimten;
CREATE OR REPLACE VIEW objecten.view_ruimten AS 
 SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.ruimten_type_id as soort,
    d.omschrijving,
    d.bouwlaag_id,
    d.fotografie_id,
    o.formelenaam,
    o.id as object_id,
    b.bouwlaag,
    b.bouwdeel
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
INNER JOIN objecten.ruimten d ON ST_INTERSECTS(t.geom, d.geom)
INNER JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_veiligh_bouwk;
CREATE OR REPLACE VIEW objecten.view_veiligh_bouwk AS 
 SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.bouwlaag_id,
    d.fotografie_id,
    o.formelenaam,
    o.id as object_id,
    b.bouwlaag,
    b.bouwdeel
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
INNER JOIN objecten.veiligh_bouwk d ON ST_INTERSECTS(t.geom, d.geom)
INNER JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_veiligh_install;
CREATE OR REPLACE VIEW objecten.view_veiligh_install AS 
 SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.veiligh_install_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    d.bijzonderheid,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id as object_id,
    b.bouwlaag,
    b.bouwdeel,
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
INNER JOIN objecten.veiligh_install d ON ST_INTERSECTS(t.geom, d.geom)
INNER JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
INNER JOIN objecten.veiligh_install_type dt ON d.veiligh_install_type_id = dt.id 
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


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
INNER JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id 
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_afw_binnendekking;
CREATE OR REPLACE VIEW objecten.view_afw_binnendekking AS 
 SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.handelingsaanwijzing,
    d.bouwlaag_id,
    o.formelenaam,
    o.id as object_id,
    b.bouwlaag,
    b.bouwdeel
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
INNER JOIN objecten.afw_binnendekking d ON ST_INTERSECTS(t.geom, d.geom)
INNER JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_bouwlagen;
CREATE OR REPLACE VIEW objecten.view_bouwlagen AS 
SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.bouwlaag,
    d.bouwdeel,
    d.pand_id,
    o.formelenaam,
    o.id as object_id
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
INNER JOIN objecten.bouwlagen d ON ST_INTERSECTS(t.geom, d.geom)
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_gevaarlijkestof_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_bouwlaag AS 
SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id as object_id,
    o.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id
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
INNER JOIN objecten.gevaarlijkestof_opslag op ON ST_INTERSECTS(t.geom, op.geom)
INNER JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
INNER JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
INNER JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_schade_cirkel_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_schade_cirkel_bouwlaag AS 
SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id as object_id,
    o.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    ST_BUFFER(op.geom, gsc.straal)::geometry(Polygon,28992) as geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id
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
INNER JOIN objecten.gevaarlijkestof_opslag op ON ST_INTERSECTS(t.geom, op.geom)
INNER JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
INNER JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
INNER JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 332; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();