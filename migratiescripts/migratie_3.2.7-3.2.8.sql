SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag
AS SELECT i.id,
    i.geom,
    i.datum_aangemaakt,
    i.datum_gewijzigd,
    i.ingang_type_id,
    i.rotatie,
    i.label,
    i.bouwlaag_id,
    i.fotografie_id,
    t.naam AS soort,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(i.geom)) AS x,
    round(st_y(i.geom)) AS y,
    t.symbol_name,
    t.size
   FROM objecten.ingang i
     JOIN objecten.ingang_type t ON i.ingang_type_id = t.id
     JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_multi(st_union(t_1.geom))::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t_1 ON o.id = t_1.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(i.geom, part.geovlak);

CREATE OR REPLACE VIEW objecten.view_ingang_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.ingang_type_id,
    b.rotatie,
    b.label,
    b.belemmering,
    b.voorzieningen,
    b.bouwlaag_id,
    b.object_id,
    b.fotografie_id,
    vt.naam AS soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.ingang b
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id
     JOIN objecten.ingang_type vt ON b.ingang_type_id = vt.id;

CREATE OR REPLACE VIEW objecten.view_afw_binnendekking
AS SELECT a.id,
    a.geom,
    a.datum_aangemaakt,
    a.datum_gewijzigd,
    a.soort,
    a.rotatie,
    a.label,
    a.handelingsaanwijzing,
    a.bouwlaag_id,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(a.geom)) AS x,
    round(st_y(a.geom)) AS y,
    t.symbol_name,
    t.size
   FROM objecten.afw_binnendekking a
     JOIN objecten.bouwlagen b ON a.bouwlaag_id = b.id
     JOIN objecten.afw_binnendekking_type t ON a.soort = t.naam
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_multi(st_union(t.geom))::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t ON o.id = t.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(a.geom, part.geovlak);

CREATE OR REPLACE VIEW objecten.view_dreiging_bouwlaag
AS SELECT d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.dreiging_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    t.naam AS soort,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    t.symbol_name,
    t.size
   FROM objecten.dreiging d
     JOIN objecten.dreiging_type t ON d.dreiging_type_id = t.id
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_multi(st_union(t_1.geom))::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t_1 ON o.id = t_1.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(d.geom, part.geovlak);

CREATE OR REPLACE VIEW objecten.view_dreiging_ruimtelijk
AS SELECT b.id,
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
   FROM objecten.dreiging b
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id
     JOIN objecten.dreiging_type vt ON b.dreiging_type_id = vt.id;

DROP VIEW IF EXISTS objecten.view_opstelplaats;
CREATE OR REPLACE VIEW objecten.view_opstelplaats
AS SELECT b.id,
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
   FROM objecten.opstelplaats b
     JOIN objecten.opstelplaats_type vt ON b.soort = vt.naam
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id;

CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag
AS SELECT s.id,
    s.geom,
    s.datum_aangemaakt,
    s.datum_gewijzigd,
    s.sleutelkluis_type_id,
    st.naam AS type,
    s.rotatie,
    s.label,
    s.aanduiding_locatie,
    s.sleuteldoel_type_id,
    sd.naam AS doel,
    s.ingang_id,
    s.fotografie_id,
    sub.formelenaam,
    sub.object_id,
    part.bouwlaag,
    part.bouwdeel,
    round(st_x(s.geom)) AS x,
    round(st_y(s.geom)) AS y,
    part.bouwlaag_id,
    st.symbol_name,
    st.size
   FROM objecten.sleutelkluis s
     JOIN ( SELECT i.id,
            i.geom,
            i.datum_aangemaakt,
            i.datum_gewijzigd,
            i.ingang_type_id,
            i.rotatie,
            i.label,
            i.belemmering,
            i.voorzieningen,
            i.bouwlaag_id,
            i.object_id,
            i.fotografie_id,
            b.bouwlaag,
            b.bouwdeel
           FROM objecten.ingang i
             JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id) part ON s.ingang_id = part.id
     JOIN objecten.sleutelkluis_type st ON s.sleutelkluis_type_id = st.id
     LEFT JOIN objecten.sleuteldoel_type sd ON s.sleuteldoel_type_id = sd.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_multi(st_union(t.geom))::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t ON o.id = t.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) sub ON st_intersects(s.geom, sub.geovlak);

CREATE OR REPLACE VIEW objecten.view_sleutelkluis_ruimtelijk
AS SELECT s.id,
    s.geom,
    s.datum_aangemaakt,
    s.datum_gewijzigd,
    s.sleutelkluis_type_id,
    s.rotatie,
    s.label,
    s.aanduiding_locatie,
    s.sleuteldoel_type_id,
    s.ingang_id,
    s.fotografie_id,
    st.naam AS type,
    sd.naam AS doel,
    part.formelenaam,
    part.object_id,
    round(st_x(s.geom)) AS x,
    round(st_y(s.geom)) AS y,
    st.symbol_name,
    st.size
   FROM objecten.sleutelkluis s
     JOIN ( SELECT b.id AS ingang_id,
            b.object_id,
            o.formelenaam
           FROM objecten.ingang b
             JOIN ( SELECT object.formelenaam,
                    object.id
                   FROM objecten.object
                     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                           FROM objecten.historie historie_1
                          WHERE historie_1.object_id = object.id
                          ORDER BY historie_1.datum_aangemaakt DESC
                         LIMIT 1))
                  WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id) part ON s.ingang_id = part.ingang_id
     LEFT JOIN objecten.sleutelkluis_type st ON s.sleutelkluis_type_id = st.id
     LEFT JOIN objecten.sleuteldoel_type sd ON s.sleuteldoel_type_id = sd.id;

CREATE OR REPLACE VIEW objecten.view_veiligh_install
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.veiligh_install_type_id,
    v.label,
    v.bouwlaag_id,
    v.rotatie,
    v.fotografie_id,
    v.bijzonderheid,
    t.naam AS soort,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(v.geom)) AS x,
    round(st_y(v.geom)) AS y,
    t.symbol_name,
    t.size
   FROM objecten.veiligh_install v
     JOIN objecten.veiligh_install_type t ON v.veiligh_install_type_id = t.id
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_multi(st_union(t_1.geom))::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t_1 ON o.id = t_1.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(v.geom, part.geovlak);

CREATE OR REPLACE VIEW objecten.view_veiligh_ruimtelijk
AS SELECT b.id,
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
   FROM objecten.veiligh_ruimtelijk b
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id
     JOIN objecten.veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id;

DROP RULE IF EXISTS veiligh_ruimtelijk_ins ON objecten.object_points_of_interest;

UPDATE algemeen.styles SET lijndikte = 8 WHERE soortnaam LIKE 'Afrastering%';
UPDATE algemeen.styles SET lijndikte = 8 WHERE laagnaam = 'Gebiedsgerichte aanpak';
UPDATE algemeen.styles SET lijndikte = 8 WHERE soortnaam LIKE '%terrein%' AND laagnaam = 'Sectoren';
UPDATE algemeen.styles SET lijndikte = 18 WHERE soortnaam LIKE 'Weg%_bottom' AND laagnaam = 'Bereikbaarheid';
UPDATE algemeen.styles SET lijndikte = 14 WHERE (soortnaam LIKE 'Weg%_middle' OR soortnaam LIKE 'Weg%_top') AND laagnaam = 'Bereikbaarheid';

UPDATE objecten.ingang_type SET size = 12 WHERE naam = 'Inrijpunt';
UPDATE objecten.points_of_interest_type SET size = 12 WHERE naam = 'Bivakplaats defensie';

INSERT INTO objecten.opstelplaats_type VALUES (8, 'CoPI', 'copi', 15);
UPDATE objecten.opstelplaats_type SET symbol_name = 'ugs', size = 12 WHERE naam = 'UGS';

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 8;
UPDATE algemeen.applicatie SET db_versie = 328; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();