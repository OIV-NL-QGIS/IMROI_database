SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE OR REPLACE VIEW veiligh_bouwk_types AS
SELECT
row_number() OVER (ORDER BY e.enumlabel)::integer AS id, e.enumlabel::text AS naam
FROM pg_type t 
   JOIN pg_enum e on t.oid = e.enumtypid  
   JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
WHERE t.typname = 'veiligh_bouwk_type';

-- create view bouwlagen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_bouwlagen;
CREATE OR REPLACE VIEW view_bouwlagen AS
SELECT bl.id, bl.geom, bl.datum_aangemaakt, bl.datum_gewijzigd, bl.bouwlaag, bl.bouwdeel, o.object_id, o.formelenaam FROM bouwlagen bl
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(bl.geom, o.geovlak);

-- create view bouwkundige veiligheidsvoorzieningen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_veiligh_bouwk AS
SELECT s.*, o.formelenaam, o.object_id, b.bouwlaag, b.bouwdeel FROM veiligh_bouwk s
INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(s.geom, o.geovlak);

-- create view ruimten, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_ruimten AS
SELECT r.*, t.naam AS soort, o.formelenaam, o.object_id, b.bouwlaag, b.bouwdeel FROM ruimten r
INNER JOIN ruimten_type t ON r.ruimten_type_id = t.id
INNER JOIN bouwlagen b ON r.bouwlaag_id = b.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(r.geom, o.geovlak);

-- create view labels op een bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_label_bouwlaag AS 
SELECT l.id, l.geom, l.datum_aangemaakt, l.datum_gewijzigd, l.omschrijving, l.bouwlaag_id, o.formelenaam, o.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(l.geom)) AS X, ROUND(ST_Y(l.geom)) AS Y FROM label l
INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id
INNER JOIN
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(l.geom, o.geovlak);

-- create view installatietechnische veiligheidsvoorzieningen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_veiligh_install;
CREATE OR REPLACE VIEW view_veiligh_install AS
SELECT v.*, t.naam AS soort, o.formelenaam, o.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(v.geom)) AS X, ROUND(ST_Y(v.geom)) AS Y FROM veiligh_install v
INNER JOIN veiligh_install_type t ON v.veiligh_install_type_id = t.id
INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(v.geom, o.geovlak);

-- view van gevaarlijkestoffen locatie met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_gevaarlijkestof_bouwlaag AS 
SELECT gvs.id, gvs.opslag_id, gvs.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, gvs.eenheid, gvs.toestand,
    o.object_id, o.formelenaam, ops.bouwlaag, ops.bouwdeel, ops.geom, ops.locatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y FROM gevaarlijkestof gvs
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN 
  (SELECT op.id, op.geom, op.bouwlaag_id, op.locatie, b.bouwlaag, b.bouwdeel FROM gevaarlijkestof_opslag op
  INNER JOIN bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(ops.geom, o.geovlak);

-- view van gevaarlijkestoffen schade crikel met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_schade_cirkel_bouwlaag AS 
SELECT gvs.id, gvs.opslag_id, gvs.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, gvs.eenheid, gvs.toestand,
    o.object_id, o.formelenaam, ops.bouwlaag, ops.bouwdeel, ST_BUFFER(ops.geom, gsc.straal)::geometry(Polygon,28992) AS geom, ops.locatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y FROM gevaarlijkestof gvs
INNER JOIN gevaarlijkestof_schade_cirkel gsc ON gvs.id = gevaarlijkestof_id
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN 
  (SELECT op.id, op.geom, op.bouwlaag_id, op.locatie, b.bouwlaag, b.bouwdeel FROM gevaarlijkestof_opslag op
  INNER JOIN bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(ops.geom, o.geovlak);

CREATE OR REPLACE VIEW view_schade_cirkel_ruimtelijk AS
SELECT g.id, g.opslag_id, g.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, g.hoeveelheid, g.eenheid, g.toestand,
    part.object_id, part.formelenaam, ST_BUFFER(part.geom, gsc.straal)::geometry(Polygon,28992) AS geom, part.locatie, ROUND(ST_X(part.geom)) AS X, ROUND(ST_Y(part.geom)) AS Y FROM gevaarlijkestof g
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

-- create view dreiging bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_dreiging_bouwlaag AS
SELECT d.id, d.geom, d.datum_aangemaakt, d.datum_gewijzigd, d.dreiging_type_id, d.rotatie, d.label, d.bouwlaag_id, d.fotografie_id, t.naam AS soort, o.formelenaam, o.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(d.geom)) AS X, ROUND(ST_Y(d.geom)) AS Y FROM dreiging d
INNER JOIN dreiging_type t ON d.dreiging_type_id = t.id
INNER JOIN bouwlagen b ON d.bouwlaag_id = b.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(d.geom, o.geovlak);

-- create view ingang bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_ingang_bouwlaag AS
SELECT i.id, i.geom, i.datum_aangemaakt, i.datum_gewijzigd, i.ingang_type_id, i.rotatie, i.label, i.bouwlaag_id, i.fotografie_id, t.naam AS soort, 
    o.formelenaam, o.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(i.geom)) AS X, ROUND(ST_Y(i.geom)) AS Y FROM ingang i 
INNER JOIN ingang_type t ON i.ingang_type_id = t.id
INNER JOIN bouwlagen b ON i.bouwlaag_id = b.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(i.geom, o.geovlak);

-- create view sleutelkluis bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_sleutelkluis_bouwlaag AS
SELECT s.id, s.geom, s.datum_aangemaakt, s.datum_gewijzigd, s.sleutelkluis_type_id, st.naam AS type, s.rotatie, s.label, s.aanduiding_locatie, s.sleuteldoel_type_id, sd.naam AS doel, s.ingang_id, s.fotografie_id, 
    o.formelenaam, o.object_id, part.bouwlaag, part.bouwdeel, ROUND(ST_X(s.geom)) AS X, ROUND(ST_Y(s.geom)) AS Y FROM sleutelkluis s 
INNER JOIN (SELECT i.*, b.bouwlaag, b.bouwdeel FROM ingang i INNER JOIN bouwlagen b ON i.bouwlaag_id = b.id) part ON s.ingang_id = part.id
INNER JOIN objecten.sleutelkluis_type st ON s.sleutelkluis_type_id = st.id
INNER JOIN objecten.sleuteldoel_type sd ON s.sleuteldoel_type_id = sd.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(s.geom, o.geovlak);

-- create view dreiging bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_afw_binnendekking AS
SELECT a.id, a.geom, a.datum_aangemaakt, a.datum_gewijzigd, a.soort, a.rotatie, a.label, a.handelingsaanwijzing, a.bouwlaag_id, 
    o.formelenaam, o.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(a.geom)) AS X, ROUND(ST_Y(a.geom)) AS Y FROM afw_binnendekking a
INNER JOIN bouwlagen b ON a.bouwlaag_id = b.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(a.geom, o.geovlak);

 
CREATE OR REPLACE VIEW object_terrein AS
SELECT id, basisreg_identifier, formelenaam, geovlak, bron, bron_tabel FROM object;

CREATE OR REPLACE RULE object_terrein_del AS
    ON DELETE TO object_terrein DO INSTEAD NOTHING;

CREATE OR REPLACE RULE object_terrein_ins AS
    ON INSERT TO object_terrein DO INSTEAD UPDATE object SET geovlak = new.geovlak
      WHERE id = new.id RETURNING id, basisreg_identifier, formelenaam, geovlak, bron, bron_tabel;

CREATE OR REPLACE RULE object_terrein_upd AS
    ON UPDATE TO object_terrein DO INSTEAD UPDATE object SET geovlak = new.geovlak
  WHERE id = new.id;

CREATE OR REPLACE VIEW view_bereikbaarheid AS
  SELECT b.*, o.formelenaam FROM bereikbaarheid b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL) 
         ) o 
  ON b.object_id = o.id;

CREATE OR REPLACE VIEW view_opstelplaats AS
  SELECT b.*, o.formelenaam, ROUND(ST_X(b.geom)) AS X, ROUND(ST_Y(b.geom)) AS Y FROM opstelplaats b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id;

CREATE OR REPLACE VIEW view_sectoren AS
  SELECT b.*, o.formelenaam FROM sectoren b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id;

CREATE OR REPLACE VIEW view_veiligh_ruimtelijk AS
  SELECT b.*, vt.naam, o.formelenaam, ROUND(ST_X(b.geom)) AS X, ROUND(ST_Y(b.geom)) AS Y FROM veiligh_ruimtelijk b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  INNER JOIN veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id;

CREATE OR REPLACE VIEW view_ingang_ruimtelijk AS
  SELECT b.*, vt.naam, o.formelenaam, ROUND(ST_X(b.geom)) AS X, ROUND(ST_Y(b.geom)) AS Y FROM ingang b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  INNER JOIN ingang_type vt ON b.ingang_type_id = vt.id;

CREATE OR REPLACE VIEW view_label_ruimtelijk AS
  SELECT b.*, o.formelenaam, ROUND(ST_X(b.geom)) AS X, ROUND(ST_Y(b.geom)) AS Y FROM label b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id;

CREATE OR REPLACE VIEW view_dreiging_ruimtelijk AS
  SELECT b.*, vt.naam, o.formelenaam, ROUND(ST_X(b.geom)) AS X, ROUND(ST_Y(b.geom)) AS Y FROM dreiging b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  INNER JOIN dreiging_type vt ON b.dreiging_type_id = vt.id;
		
CREATE OR REPLACE VIEW view_sleutelkluis_ruimtelijk AS
SELECT s.*, st.naam AS type, sd.naam AS doel, part.formelenaam, ROUND(ST_X(s.geom)) AS X, ROUND(ST_Y(s.geom)) AS Y FROM sleutelkluis s
INNER JOIN
  (
  SELECT b.id AS ingang_id, o.formelenaam FROM ingang b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  ) part ON s.ingang_id = part.ingang_id
  LEFT JOIN sleutelkluis_type st ON s.sleutelkluis_type_id = st.id
  LEFT JOIN sleuteldoel_type sd  ON s.sleuteldoel_type_id = sd.id;

-- view van gevaarlijkestoffen locatie met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_gevaarlijkestof_ruimtelijk AS
SELECT s.*, vn.vn_nr, vn.gevi_nr, vn.eric_kaart, part.geom, part.formelenaam, ROUND(ST_X(part.geom)) AS X, ROUND(ST_Y(part.geom)) AS Y FROM gevaarlijkestof s
INNER JOIN
  (
  SELECT b.id AS opslag_id, b.geom, o.formelenaam FROM gevaarlijkestof_opslag b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  ) part ON s.opslag_id = part.opslag_id
  LEFT JOIN gevaarlijkestof_vnnr vn ON s.gevaarlijkestof_vnnr_id = vn.id;

-- Create new views t.b.v. de plugin
CREATE OR REPLACE VIEW bouwlaag_veiligh_install AS
  SELECT v.*, b.bouwlaag FROM veiligh_install v JOIN bouwlagen b ON v.bouwlaag_id = b.id;
  
CREATE OR REPLACE RULE veiligh_install_del AS
    ON DELETE TO bouwlaag_veiligh_install DO INSTEAD  DELETE FROM veiligh_install
  WHERE veiligh_install.id = old.id;

CREATE OR REPLACE RULE veiligh_install_ins AS
    ON INSERT TO bouwlaag_veiligh_install DO INSTEAD  INSERT INTO veiligh_install (geom, veiligh_install_type_id, label, rotatie, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.veiligh_install_type_id, new.label, new.rotatie, new.bouwlaag_id, new.fotografie_id)
  RETURNING veiligh_install.id,
    veiligh_install.geom,
    veiligh_install.datum_aangemaakt,
    veiligh_install.datum_gewijzigd,
    veiligh_install.veiligh_install_type_id,
    veiligh_install.label,
    veiligh_install.bouwlaag_id,
    veiligh_install.rotatie,
    veiligh_install.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE veiligh_install.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE veiligh_install_upd AS
    ON UPDATE TO bouwlaag_veiligh_install DO INSTEAD  UPDATE veiligh_install SET geom = new.geom, veiligh_install_type_id = new.veiligh_install_type_id, bouwlaag_id = new.bouwlaag_id, label = new.label, rotatie = new.rotatie, fotografie_id = new.fotografie_id
        WHERE veiligh_install.id = new.id;

-- Opslag stoffen
CREATE OR REPLACE VIEW bouwlaag_opslag AS 
 SELECT o.*,
    b.bouwlaag
   FROM gevaarlijkestof_opslag o
     JOIN bouwlagen b ON o.bouwlaag_id = b.id;

CREATE OR REPLACE RULE opslag_del AS
    ON DELETE TO bouwlaag_opslag DO INSTEAD  DELETE FROM gevaarlijkestof_opslag
  WHERE gevaarlijkestof_opslag.id = old.id;

CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_opslag DO INSTEAD  INSERT INTO gevaarlijkestof_opslag (geom, locatie, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id, new.fotografie_id)
  RETURNING gevaarlijkestof_opslag.id,
    gevaarlijkestof_opslag.geom,
    gevaarlijkestof_opslag.datum_aangemaakt,
    gevaarlijkestof_opslag.datum_gewijzigd,
    gevaarlijkestof_opslag.locatie,
    gevaarlijkestof_opslag.bouwlaag_id,
    gevaarlijkestof_opslag.object_id,
    gevaarlijkestof_opslag.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE gevaarlijkestof_opslag.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE opslag_upd AS
    ON UPDATE TO bouwlaag_opslag DO INSTEAD  UPDATE gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE gevaarlijkestof_opslag.id = new.id;

-- labels
CREATE OR REPLACE VIEW bouwlaag_label AS 
 SELECT l.id, l.geom, l.datum_aangemaakt, l.datum_gewijzigd, l.omschrijving, l.soort, l.rotatie, l.bouwlaag_id, b.bouwlaag
   FROM label l JOIN bouwlagen b ON l.bouwlaag_id = b.id;

CREATE OR REPLACE RULE label_del AS
    ON DELETE TO bouwlaag_label DO INSTEAD  DELETE FROM label WHERE label.id = old.id;

CREATE OR REPLACE RULE label_ins AS
    ON INSERT TO bouwlaag_label DO INSTEAD  INSERT INTO label (geom, soort, omschrijving, rotatie, bouwlaag_id)
  VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING label.id, label.geom, label.datum_aangemaakt, label.datum_gewijzigd, label.omschrijving, label.soort,
    label.rotatie, label.bouwlaag_id, (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE label.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE label_upd AS
    ON UPDATE TO bouwlaag_label DO INSTEAD  UPDATE label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id
  WHERE label.id = new.id;

CREATE OR REPLACE VIEW bouwlaag_veiligh_bouwk AS
  SELECT v.*, b.bouwlaag FROM veiligh_bouwk v JOIN bouwlagen b ON v.bouwlaag_id = b.id;
  
CREATE OR REPLACE RULE veiligh_bouwk_del AS
    ON DELETE TO bouwlaag_veiligh_bouwk DO INSTEAD  DELETE FROM veiligh_bouwk
  WHERE veiligh_bouwk.id = old.id;

CREATE OR REPLACE RULE veiligh_bouwk_ins AS
    ON INSERT TO bouwlaag_veiligh_bouwk DO INSTEAD  INSERT INTO veiligh_bouwk (geom, soort, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.soort, new.bouwlaag_id, new.fotografie_id)
  RETURNING veiligh_bouwk.id,
    veiligh_bouwk.geom,
    veiligh_bouwk.datum_aangemaakt,
    veiligh_bouwk.datum_gewijzigd,
    veiligh_bouwk.soort,
    veiligh_bouwk.bouwlaag_id,
    veiligh_bouwk.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE veiligh_bouwk.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE veiligh_bouwk_upd AS
    ON UPDATE TO bouwlaag_veiligh_bouwk DO INSTEAD  UPDATE veiligh_bouwk SET geom = new.geom, soort = new.soort, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE veiligh_bouwk.id = new.id;
  
CREATE OR REPLACE VIEW bouwlaag_ruimten AS 
 SELECT v.*,
    b.bouwlaag
   FROM ruimten v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE ruimten_del AS
    ON DELETE TO bouwlaag_ruimten DO INSTEAD  DELETE FROM ruimten
  WHERE ruimten.id = old.id;

CREATE OR REPLACE RULE ruimten_ins AS
    ON INSERT TO bouwlaag_ruimten DO INSTEAD  INSERT INTO ruimten (geom, ruimten_type_id, omschrijving, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.ruimten_type_id, new.omschrijving, new.bouwlaag_id, new.fotografie_id)
  RETURNING ruimten.id,
    ruimten.geom,
    ruimten.datum_aangemaakt,
    ruimten.datum_gewijzigd,
    ruimten.ruimten_type_id,
    ruimten.omschrijving,
    ruimten.bouwlaag_id,
    ruimten.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE ruimten.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE ruimten_upd AS
    ON UPDATE TO bouwlaag_ruimten DO INSTEAD  UPDATE ruimten SET geom = new.geom, ruimten_type_id = new.ruimten_type_id, omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE ruimten.id = new.id;

CREATE OR REPLACE VIEW bouwlaag_ingang AS
  SELECT v.*, b.bouwlaag FROM ingang v JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE ingang_del AS
    ON DELETE TO bouwlaag_ingang DO INSTEAD  DELETE FROM ingang
  WHERE ingang.id = old.id;

CREATE OR REPLACE RULE ingang_ins AS
    ON INSERT TO bouwlaag_ingang DO INSTEAD  INSERT INTO ingang (geom, ingang_type_id, label, rotatie, belemmering, voorzieningen, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.ingang_type_id, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.bouwlaag_id, new.fotografie_id)
  RETURNING ingang.id,
    ingang.geom,
    ingang.datum_aangemaakt,
    ingang.datum_gewijzigd,
    ingang.ingang_type_id,
    ingang.rotatie,
    ingang.label,
    ingang.belemmering,
    ingang.voorzieningen,
    ingang.bouwlaag_id,
    ingang.object_id,
    ingang.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE ingang.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE ingang_upd AS
    ON UPDATE TO bouwlaag_ingang DO INSTEAD  UPDATE ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, 
        voorzieningen = new.voorzieningen, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
        WHERE ingang.id = new.id;

CREATE OR REPLACE VIEW bouwlaag_dreiging AS
  SELECT v.*, b.bouwlaag FROM dreiging v JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE dreiging_del AS
    ON DELETE TO bouwlaag_dreiging DO INSTEAD  DELETE FROM dreiging
  WHERE dreiging.id = old.id;

CREATE OR REPLACE RULE dreiging_ins AS
    ON INSERT TO bouwlaag_dreiging DO INSTEAD  INSERT INTO dreiging (geom, dreiging_type_id, label, rotatie, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.dreiging_type_id, new.label, new.rotatie, new.bouwlaag_id, new.fotografie_id)
  RETURNING dreiging.id,
    dreiging.geom,
    dreiging.datum_aangemaakt,
    dreiging.datum_gewijzigd,
    dreiging.dreiging_type_id,
    dreiging.rotatie,
    dreiging.label,
    dreiging.bouwlaag_id,
    dreiging.object_id,
    dreiging.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE dreiging.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE dreiging_upd AS
    ON UPDATE TO bouwlaag_dreiging DO INSTEAD  UPDATE dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
        WHERE dreiging.id = new.id;

CREATE OR REPLACE VIEW bouwlaag_sleutelkluis AS
  SELECT v.*, part.bouwlaag FROM sleutelkluis v INNER JOIN 
    (SELECT b.bouwlaag, ib.id FROM ingang ib JOIN bouwlagen b ON ib.bouwlaag_id = b.id) part
    ON v.ingang_id = part.id;

CREATE OR REPLACE RULE sleutelkluis_del AS
    ON DELETE TO bouwlaag_sleutelkluis DO INSTEAD  DELETE FROM sleutelkluis
  WHERE sleutelkluis.id = old.id;

CREATE OR REPLACE RULE sleutelkluis_ins AS
    ON INSERT TO bouwlaag_sleutelkluis DO INSTEAD  INSERT INTO sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, fotografie_id)
  VALUES (new.geom, new.sleutelkluis_type_id, new.label, new.rotatie, new.aanduiding_locatie, new.sleuteldoel_type_id, new.ingang_id, new.fotografie_id)
  RETURNING sleutelkluis.id,
    sleutelkluis.geom,
    sleutelkluis.datum_aangemaakt,
    sleutelkluis.datum_gewijzigd,
    sleutelkluis.sleutelkluis_type_id,
    sleutelkluis.rotatie,
    sleutelkluis.label,
    sleutelkluis.aanduiding_locatie,
    sleutelkluis.sleuteldoel_type_id,
    sleutelkluis.ingang_id,
    sleutelkluis.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE sleutelkluis.ingang_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE sleutelkluis_upd AS
    ON UPDATE TO bouwlaag_sleutelkluis DO INSTEAD  UPDATE sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, 
        sleuteldoel_type_id = new.sleuteldoel_type_id, ingang_id = new.ingang_id, fotografie_id = new.fotografie_id
        WHERE sleutelkluis.id = new.id;

CREATE OR REPLACE VIEW bouwlaag_afw_binnendekking AS
  SELECT v.*, b.bouwlaag FROM afw_binnendekking v JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE afw_binnendekking_del AS
    ON DELETE TO bouwlaag_afw_binnendekking DO INSTEAD  DELETE FROM afw_binnendekking
  WHERE afw_binnendekking.id = old.id;

CREATE OR REPLACE RULE afw_binnendekking_ins AS
    ON INSERT TO bouwlaag_afw_binnendekking DO INSTEAD  INSERT INTO afw_binnendekking (geom, soort, label, rotatie, handelingsaanwijzing, bouwlaag_id)
  VALUES (new.geom, new.soort, new.label, new.rotatie, new.handelingsaanwijzing, new.bouwlaag_id)
  RETURNING afw_binnendekking.id,
    afw_binnendekking.geom,
    afw_binnendekking.datum_aangemaakt,
    afw_binnendekking.datum_gewijzigd,
    afw_binnendekking.soort,
    afw_binnendekking.rotatie,
    afw_binnendekking.label,
    afw_binnendekking.handelingsaanwijzing,
    afw_binnendekking.bouwlaag_id,
    afw_binnendekking.object_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE afw_binnendekking.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE afw_binnendekking_bouwlaag_upd AS
    ON UPDATE TO bouwlaag_afw_binnendekking DO INSTEAD  UPDATE afw_binnendekking SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, handelingsaanwijzing = new.handelingsaanwijzing, bouwlaag_id = new.bouwlaag_id
        WHERE afw_binnendekking.id = new.id; 

-- Create View t.b.v. berekenen schade cirkels
CREATE OR REPLACE VIEW schade_cirkel_calc AS
  SELECT sc.*, ST_BUFFER(part.geom, straal) AS geom_cirkel FROM gevaarlijkestof_schade_cirkel sc
  LEFT JOIN (SELECT gb.id, ops.geom FROM gevaarlijkestof gb
        LEFT JOIN gevaarlijkestof_opslag ops 
        ON gb.opslag_id = ops.id) part
  ON sc.gevaarlijkestof_id = part.id;

CREATE OR REPLACE VIEW view_pictogram_zonder_object AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.voorziening_pictogram_id,
    v.label,
    v.rotatie,
    p.naam AS pictogram,
    round(st_x(v.geom)) AS x,
    round(st_y(v.geom)) AS y
   FROM objecten.pictogram_zonder_object v
     JOIN objecten.pictogram_zonder_object_type p ON v.voorziening_pictogram_id = p.id;

CREATE OR REPLACE VIEW objecten.view_objectgegevens AS 
 SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    object.datum_geldig_vanaf,
    object.datum_geldig_tot,
    object.bron,
    object.bron_tabel,
    round(st_x(object.geom)) AS x,
    round(st_y(object.geom)) AS y
   FROM objecten.object
INNER JOIN
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON object.id = o.object_id;

REVOKE ALL ON schade_cirkel_calc FROM oiv_write;
REVOKE ALL ON TABLE veiligh_bouwk_types     FROM GROUP oiv_write;

UPDATE algemeen.applicatie SET sub = 9;
UPDATE algemeen.applicatie SET revisie = 98;
UPDATE algemeen.applicatie SET db_versie = 998; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();