SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_gebiedsgerichte_aanpak', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_points_of_interest', 'id', 1, 'assigned');  

CREATE INDEX IF NOT EXISTS bouwlagen_pand_id_idx
  ON objecten.bouwlagen
  USING btree
  (pand_id);

CREATE INDEX IF NOT EXISTS bouwlagen_bouwlaag_idx
  ON objecten.bouwlagen
  USING btree
  (bouwlaag);

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
    b.bouwdeel,
    vt.size
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
INNER JOIN objecten.label_type vt ON d.soort = vt.naam
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_ruimten;
CREATE OR REPLACE VIEW objecten.view_ruimten AS 
 SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.ruimten_type_id,
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
    b.bouwdeel,
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
INNER JOIN objecten.afw_binnendekking d ON ST_INTERSECTS(t.geom, d.geom)
INNER JOIN objecten.afw_binnendekking_type dt ON d.soort = dt.naam
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
    o.id as object_id,
    sub.hoogste_bouwlaag,
    sub.laagste_bouwlaag 
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
INNER JOIN 
  (SELECT pand_id, max(bouwlaag) as hoogste_bouwlaag, min(bouwlaag) as laagste_bouwlaag 
    FROM objecten.bouwlagen
    GROUP BY pand_id) sub ON d.pand_id = sub.pand_id
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
    op.bouwlaag_id,
    gsc.soort
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


DROP VIEW objecten.view_bedrijfshulpverlening;
CREATE OR REPLACE VIEW objecten.view_bedrijfshulpverlening AS
 SELECT 
	  b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.ademluchtdragend,
    b.object_id,
    o.formelenaam
   FROM objecten.object o
   INNER JOIN objecten.bedrijfshulpverlening b ON o.id = b.object_id
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_bereikbaarheid;
CREATE OR REPLACE VIEW objecten.view_bereikbaarheid AS
 SELECT 
	  b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.obstakels,
    b.wegafzetting,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    o.formelenaam
   FROM objecten.object o
   INNER JOIN objecten.bereikbaarheid b ON o.id = b.object_id
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_contactpersoon;
CREATE OR REPLACE VIEW objecten.view_contactpersoon AS
 SELECT 
	  b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.object_id,
    b.soort,
    o.formelenaam
   FROM objecten.object o
   INNER JOIN objecten.contactpersoon b ON o.id = b.object_id
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_dreiging_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_dreiging_ruimtelijk AS
 SELECT 
	  b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dreiging_type_id,
    b.rotatie,
    b.label,
    b.bouwlaag_id,
    b.object_id,
    b.fotografie_id,
    vt.naam AS soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.object o
   INNER JOIN objecten.dreiging b ON o.id = b.object_id
   INNER JOIN objecten.dreiging_type vt ON b.dreiging_type_id = vt.id
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_gebiedsgerichte_aanpak;
CREATE OR REPLACE VIEW objecten.view_gebiedsgerichte_aanpak AS
 SELECT 
	  b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.bijzonderheden,
    b.object_id,
    b.fotografie_id,
    o.formelenaam
   FROM objecten.object o
   INNER JOIN objecten.gebiedsgerichte_aanpak b ON o.id = b.object_id
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_gevaarlijkestof_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_ruimtelijk AS 
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
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y
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
INNER JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
INNER JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
INNER JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW IF EXISTS objecten.view_schade_cirkel_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_schade_cirkel_ruimtelijk AS 
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
    ST_BUFFER(op.geom, gsc.straal)::geometry(Polygon,28992) as geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    gsc.soort
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
INNER JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
INNER JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
INNER JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_ingang_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_ingang_ruimtelijk AS
 SELECT 
	  b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.ingang_type_id,
    b.rotatie,
    b.label,
    b.belemmering,
    b.voorzieningen,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.naam AS soort,
    vt.symbol_name,
    vt.size
   FROM objecten.object o
   INNER JOIN objecten.ingang b ON o.id = b.object_id
   INNER JOIN objecten.ingang_type vt ON b.ingang_type_id = vt.id
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_isolijnen;
CREATE OR REPLACE VIEW objecten.view_isolijnen AS
 SELECT 
	  b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.hoogte,
    b.omschrijving,
    b.object_id,
    o.formelenaam
   FROM objecten.object o
   INNER JOIN objecten.isolijnen b ON o.id = b.object_id
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_label_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_label_ruimtelijk AS
 SELECT 
	  b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.rotatie,
    b.bouwlaag_id,
    b.object_id,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.size
   FROM objecten.object o
   INNER JOIN objecten.label b ON o.id = b.object_id
   INNER JOIN objecten.label_type vt ON b.soort = vt.naam
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_objectgegevens;
CREATE OR REPLACE VIEW objecten.view_objectgegevens AS
 SELECT 
	  o.id,
    o.formelenaam,
    o.geom,
    o.basisreg_identifier,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.bijzonderheden,
    o.pers_max,
    o.pers_nietz_max,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.bron,
    o.bron_tabel,
    o.fotografie_id,
    bg.naam AS bodemgesteldheid,
    gf.gebruiksfuncties,
    round(st_x(o.geom)) AS x,
    round(st_y(o.geom)) AS y,
    part.typeobject
   FROM objecten.object o
   LEFT JOIN objecten.bodemgesteldheid_type bg ON o.bodemgesteldheid_type_id = bg.id
   LEFT JOIN ( SELECT DISTINCT g.object_id,
            string_agg(gt.naam, ', '::text) AS gebruiksfuncties
           FROM objecten.gebruiksfunctie g
             JOIN objecten.gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
          GROUP BY g.object_id) gf ON o.id = gf.object_id
   INNER JOIN 
    (SELECT h.object_id, h.typeobject
      FROM objecten.historie h
      INNER JOIN
          (SELECT object_id, MAX(datum_aangemaakt) AS maxdatetime
          FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text
          GROUP BY object_id
          ) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime
    ) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_opstelplaats;
CREATE OR REPLACE VIEW objecten.view_opstelplaats AS
 SELECT 
	  b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.rotatie,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.object o
   INNER JOIN objecten.opstelplaats b ON o.id = b.object_id
   INNER JOIN objecten.opstelplaats_type vt ON b.soort = vt.naam
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_points_of_interest;
CREATE OR REPLACE VIEW objecten.view_points_of_interest AS
 SELECT 
	  b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.points_of_interest_type_id,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    b.bijzonderheid,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.object o
   INNER JOIN objecten.points_of_interest b ON o.id = b.object_id
   INNER JOIN objecten.points_of_interest_type vt ON b.points_of_interest_type_id = vt.id
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_sectoren;
CREATE OR REPLACE VIEW objecten.view_sectoren AS
 SELECT 
	  b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.label,
    b.object_id,
    b.fotografie_id,
    b.soort,
    o.formelenaam
   FROM objecten.object o
   INNER JOIN objecten.sectoren b ON o.id = b.object_id
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);


DROP VIEW objecten.view_veiligh_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_veiligh_ruimtelijk AS
 SELECT 
	  b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.veiligh_ruimtelijk_type_id,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    vt.naam AS soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.object o
   INNER JOIN objecten.veiligh_ruimtelijk b ON o.id = b.object_id
   INNER JOIN objecten.veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id
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
INNER JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id 
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 333; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();