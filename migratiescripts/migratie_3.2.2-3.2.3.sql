SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- create view bouwlagen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_bouwlagen AS
SELECT bl.id, bl.geom, bl.datum_aangemaakt, bl.datum_gewijzigd, bl.bouwlaag, bl.bouwdeel, part.object_id, part.formelenaam FROM bouwlagen bl
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part 
ON ST_INTERSECTS(bl.geom, part.geovlak);

-- create view bouwkundige veiligheidsvoorzieningen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_veiligh_bouwk AS
SELECT s.*, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel FROM veiligh_bouwk s
INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(s.geom, part.geovlak);

-- create view ruimten, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_ruimten AS 
 SELECT r.id,
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
   FROM ruimten r
     JOIN bouwlagen b ON r.bouwlaag_id = b.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            ST_MULTI(ST_UNION(t_1.geom))::geometry(MultiPolygon, 28992) as geovlak
           FROM object o
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN terrein t_1 ON o.id = t_1.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(r.geom, part.geovlak);

-- create view labels op een bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_label_bouwlaag AS 
SELECT l.id, l.geom, l.datum_aangemaakt, l.datum_gewijzigd, l.omschrijving, l.soort, l.rotatie, l.bouwlaag_id, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(l.geom)) AS X, ROUND(ST_Y(l.geom)) AS Y FROM label l
INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(l.geom, part.geovlak);

-- create view installatietechnische veiligheidsvoorzieningen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_veiligh_install AS
SELECT v.*, t.naam AS soort, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(v.geom)) AS X, ROUND(ST_Y(v.geom)) AS Y FROM veiligh_install v
INNER JOIN veiligh_install_type t ON v.veiligh_install_type_id = t.id
INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(v.geom, part.geovlak);

-- view van gevaarlijkestoffen schade crikel met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_schade_cirkel_bouwlaag AS 
SELECT gvs.id, gvs.opslag_id, gvs.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, gvs.eenheid, gvs.toestand,
    part.object_id, part.formelenaam, ops.bouwlaag, ops.bouwdeel, ST_BUFFER(ops.geom, gsc.straal)::geometry(Polygon,28992) AS geom, 
    ops.locatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y, gsc.soort FROM gevaarlijkestof gvs
INNER JOIN gevaarlijkestof_schade_cirkel gsc ON gvs.id = gevaarlijkestof_id
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN 
  (SELECT op.id, op.geom, op.bouwlaag_id, op.locatie, b.bouwlaag, b.bouwdeel FROM gevaarlijkestof_opslag op
  INNER JOIN bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(ops.geom, part.geovlak);

-- view van gevaarlijkestoffen schade crikel met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_schade_cirkel_bouwlaag AS 
SELECT gvs.id, gvs.opslag_id, gvs.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, gvs.eenheid, gvs.toestand,
    part.object_id, part.formelenaam, ops.bouwlaag, ops.bouwdeel, ST_BUFFER(ops.geom, gsc.straal)::geometry(Polygon,28992) AS geom, 
    ops.locatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y, gsc.soort FROM gevaarlijkestof gvs
INNER JOIN gevaarlijkestof_schade_cirkel gsc ON gvs.id = gevaarlijkestof_id
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN 
  (SELECT op.id, op.geom, op.bouwlaag_id, op.locatie, b.bouwlaag, b.bouwdeel FROM gevaarlijkestof_opslag op
  INNER JOIN bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(ops.geom, part.geovlak);

-- create view dreiging bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_dreiging_bouwlaag AS
SELECT d.id, d.geom, d.datum_aangemaakt, d.datum_gewijzigd, d.dreiging_type_id, d.rotatie, d.label, d.bouwlaag_id, d.fotografie_id, t.naam AS soort, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(d.geom)) AS X, ROUND(ST_Y(d.geom)) AS Y, t.symbol_name FROM dreiging d
INNER JOIN dreiging_type t ON d.dreiging_type_id = t.id
INNER JOIN bouwlagen b ON d.bouwlaag_id = b.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(d.geom, part.geovlak);

-- create view ingang bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_ingang_bouwlaag AS
SELECT i.id, i.geom, i.datum_aangemaakt, i.datum_gewijzigd, i.ingang_type_id, i.rotatie, i.label, i.bouwlaag_id, i.fotografie_id, t.naam AS soort, 
    part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(i.geom)) AS X, ROUND(ST_Y(i.geom)) AS Y, t.symbol_name FROM ingang i 
INNER JOIN ingang_type t ON i.ingang_type_id = t.id
INNER JOIN bouwlagen b ON i.bouwlaag_id = b.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(i.geom, part.geovlak);

-- create view sleutelkluis bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_sleutelkluis_bouwlaag AS
SELECT s.id, s.geom, s.datum_aangemaakt, s.datum_gewijzigd, s.sleutelkluis_type_id, st.naam AS type, s.rotatie, s.label, s.aanduiding_locatie, s.sleuteldoel_type_id, sd.naam AS doel, s.ingang_id, s.fotografie_id, 
    sub.formelenaam, sub.object_id, part.bouwlaag, part.bouwdeel, ROUND(ST_X(s.geom)) AS X, ROUND(ST_Y(s.geom)) AS Y, part.bouwlaag_id FROM sleutelkluis s 
INNER JOIN (SELECT i.*, b.bouwlaag, b.bouwdeel FROM ingang i INNER JOIN bouwlagen b ON i.bouwlaag_id = b.id) part ON s.ingang_id = part.id
INNER JOIN sleutelkluis_type st ON s.sleutelkluis_type_id = st.id
LEFT JOIN sleuteldoel_type sd ON s.sleuteldoel_type_id = sd.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) sub
ON ST_INTERSECTS(s.geom, sub.geovlak);

-- create view dreiging bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_afw_binnendekking AS
SELECT a.id, a.geom, a.datum_aangemaakt, a.datum_gewijzigd, a.soort, a.rotatie, a.label, a.handelingsaanwijzing, a.bouwlaag_id, 
    part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(a.geom)) AS X, ROUND(ST_Y(a.geom)) AS Y FROM afw_binnendekking a
INNER JOIN bouwlagen b ON a.bouwlaag_id = b.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(a.geom, part.geovlak);

CREATE OR REPLACE VIEW view_schade_cirkel_ruimtelijk AS
SELECT g.id, g.opslag_id, g.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, g.hoeveelheid, g.eenheid, g.toestand,
    part.object_id, part.formelenaam, ST_BUFFER(part.geom, gsc.straal)::geometry(Polygon,28992) AS geom, part.locatie,
    ROUND(ST_X(part.geom)) AS X, ROUND(ST_Y(part.geom)) AS Y, gsc.soort FROM gevaarlijkestof g
INNER JOIN
  (
  SELECT ops.id AS opslag_id, ops.geom, ops.locatie, o.formelenaam, o.id AS object_id FROM gevaarlijkestof_opslag ops
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
  ON ops.object_id = o.id
  ) part ON g.opslag_id = part.opslag_id
INNER JOIN gevaarlijkestof_schade_cirkel gsc ON g.id = gevaarlijkestof_id
LEFT JOIN gevaarlijkestof_vnnr vnnr ON g.gevaarlijkestof_vnnr_id = vnnr.id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 323; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();