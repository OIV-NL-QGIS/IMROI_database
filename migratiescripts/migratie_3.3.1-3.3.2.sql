SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- Toevoegen van unieke identifier aan de view_ views gekoppeld aan bouwlagen
DROP VIEW objecten.view_bouwlagen;
CREATE OR REPLACE VIEW objecten.view_bouwlagen AS 
 SELECT 
  	ROW_NUMBER () OVER (ORDER BY bl.id) AS gid,
 	bl.id,
    bl.geom,
    bl.datum_aangemaakt,
    bl.datum_gewijzigd,
    bl.bouwlaag,
    bl.bouwdeel,
    part.object_id,
    part.formelenaam
   FROM objecten.bouwlagen bl
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
          GROUP BY o.formelenaam, o.id) part ON st_intersects(bl.geom, part.geovlak);

DROP VIEW objecten.view_afw_binnendekking;
CREATE OR REPLACE VIEW objecten.view_afw_binnendekking AS 
 SELECT 
 	ROW_NUMBER () OVER (ORDER BY a.id) AS gid,
 	a.id,
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
    round(st_y(a.geom)) AS y
   FROM objecten.afw_binnendekking a
     JOIN objecten.bouwlagen b ON a.bouwlaag_id = b.id
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


DROP VIEW objecten.view_gevaarlijkestof_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_bouwlaag AS 
 SELECT 
  	ROW_NUMBER () OVER (ORDER BY gvs.id) AS gid,
 	gvs.id,
    gvs.opslag_id,
    gvs.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    gvs.hoeveelheid,
    gvs.eenheid,
    gvs.toestand,
    part.object_id,
    part.formelenaam,
    ops.bouwlaag,
    ops.bouwdeel,
    ops.geom,
    ops.locatie,
    ops.rotatie,
    round(st_x(ops.geom)) AS x,
    round(st_y(ops.geom)) AS y,
    ops.bouwlaag_id
   FROM objecten.gevaarlijkestof gvs
     LEFT JOIN objecten.gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN ( SELECT op.id,
            op.geom,
            op.bouwlaag_id,
            op.locatie,
            op.rotatie,
            b.bouwlaag,
            b.bouwdeel
           FROM objecten.gevaarlijkestof_opslag op
             JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_union(t.geom)::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t ON o.id = t.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(ops.geom, part.geovlak);

DROP VIEW objecten.view_ingang_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag AS 
 SELECT  
  	ROW_NUMBER () OVER (ORDER BY i.id) AS gid,
 	i.id,
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
    t.symbol_name
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

DROP VIEW objecten.view_label_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_label_bouwlaag AS 
 SELECT  
  	ROW_NUMBER () OVER (ORDER BY l.id) AS gid,
 	l.id,
    l.geom,
    l.datum_aangemaakt,
    l.datum_gewijzigd,
    l.omschrijving,
    l.soort,
    l.rotatie,
    l.bouwlaag_id,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(l.geom)) AS x,
    round(st_y(l.geom)) AS y
   FROM objecten.label l
     JOIN objecten.bouwlagen b ON l.bouwlaag_id = b.id
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
          GROUP BY o.formelenaam, o.id) part ON st_intersects(l.geom, part.geovlak);

DROP VIEW objecten.view_ruimten;
CREATE OR REPLACE VIEW objecten.view_ruimten AS 
 SELECT  
  	ROW_NUMBER () OVER (ORDER BY r.id) AS gid,
 	r.id,
    r.geom,
    r.datum_aangemaakt,
    r.datum_gewijzigd,
    r.ruimten_type_id,
    r.omschrijving,
    r.bouwlaag_id,
    r.fotografie_id,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel
   FROM objecten.ruimten r
     JOIN objecten.bouwlagen b ON r.bouwlaag_id = b.id
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
          GROUP BY o.formelenaam, o.id) part ON st_intersects(r.geom, part.geovlak);

DROP VIEW objecten.view_schade_cirkel_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_schade_cirkel_bouwlaag AS 
 SELECT  
  	ROW_NUMBER () OVER (ORDER BY gvs.id) AS gid,
 	gvs.id,
    gvs.opslag_id,
    gvs.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    gvs.hoeveelheid,
    gvs.eenheid,
    gvs.toestand,
    part.object_id,
    part.formelenaam,
    ops.bouwlaag,
    ops.bouwdeel,
    st_buffer(ops.geom, gsc.straal::double precision)::geometry(Polygon,28992) AS geom,
    ops.locatie,
    round(st_x(ops.geom)) AS x,
    round(st_y(ops.geom)) AS y,
    gsc.soort
   FROM objecten.gevaarlijkestof gvs
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON gvs.id = gsc.gevaarlijkestof_id
     LEFT JOIN objecten.gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN ( SELECT op.id,
            op.geom,
            op.bouwlaag_id,
            op.locatie,
            b.bouwlaag,
            b.bouwdeel
           FROM objecten.gevaarlijkestof_opslag op
             JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
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
          GROUP BY o.formelenaam, o.id) part ON st_intersects(ops.geom, part.geovlak);

DROP VIEW objecten.view_sleutelkluis_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag AS 
 SELECT  
  	ROW_NUMBER () OVER (ORDER BY s.id) AS gid,
 	s.id,
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
    part.bouwlaag_id
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

DROP VIEW objecten.view_veiligh_bouwk;
CREATE OR REPLACE VIEW objecten.view_veiligh_bouwk AS 
 SELECT  
  	ROW_NUMBER () OVER (ORDER BY s.id) AS gid,
 	s.id,
    s.geom,
    s.datum_aangemaakt,
    s.datum_gewijzigd,
    s.bouwlaag_id,
    s.fotografie_id,
    s.soort,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel
   FROM objecten.veiligh_bouwk s
     JOIN objecten.bouwlagen b ON s.bouwlaag_id = b.id
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
          GROUP BY o.formelenaam, o.id) part ON st_intersects(s.geom, part.geovlak);

DROP VIEW objecten.view_veiligh_install;
CREATE OR REPLACE VIEW objecten.view_veiligh_install AS 
 SELECT  
  	ROW_NUMBER () OVER (ORDER BY v.id) AS gid,
 	v.id,
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
    round(st_y(v.geom)) AS y
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

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 332; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();