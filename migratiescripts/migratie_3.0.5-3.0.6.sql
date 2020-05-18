SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- create view sleutelkluis bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_sleutelkluis_bouwlaag AS
SELECT s.id, s.geom, s.datum_aangemaakt, s.datum_gewijzigd, s.sleutelkluis_type_id, st.naam AS type, s.rotatie, s.label, s.aanduiding_locatie, s.sleuteldoel_type_id, sd.naam AS doel, s.ingang_id, s.fotografie_id, 
    o.formelenaam, o.object_id, part.bouwlaag, part.bouwdeel, ROUND(ST_X(s.geom)) AS X, ROUND(ST_Y(s.geom)) AS Y, part.bouwlaag_id FROM sleutelkluis s 
INNER JOIN (SELECT i.*, b.bouwlaag, b.bouwdeel FROM ingang i INNER JOIN bouwlagen b ON i.bouwlaag_id = b.id) part ON s.ingang_id = part.id
INNER JOIN objecten.sleutelkluis_type st ON s.sleutelkluis_type_id = st.id
LEFT JOIN objecten.sleuteldoel_type sd ON s.sleuteldoel_type_id = sd.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(s.geom, o.geovlak);

-- view van gevaarlijkestoffen locatie met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_gevaarlijkestof_bouwlaag AS 
SELECT gvs.id, gvs.opslag_id, gvs.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, gvs.eenheid, gvs.toestand,
    o.object_id, o.formelenaam, ops.bouwlaag, ops.bouwdeel, ops.geom, ops.locatie, ops.rotatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y, ops.bouwlaag_id FROM gevaarlijkestof gvs
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN 
  (SELECT op.id, op.geom, op.bouwlaag_id, op.locatie, op.rotatie, b.bouwlaag, b.bouwdeel FROM gevaarlijkestof_opslag op
  INNER JOIN bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
INNER JOIN 
(SELECT formelenaam, object.id AS object_id, geovlak FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
ON ST_INTERSECTS(ops.geom, o.geovlak);

DROP VIEW view_veiligh_ruimtelijk;
CREATE OR REPLACE VIEW view_veiligh_ruimtelijk AS
  SELECT b.*, vt.naam AS soort, o.formelenaam, ROUND(ST_X(b.geom)) AS X, ROUND(ST_Y(b.geom)) AS Y FROM veiligh_ruimtelijk b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  INNER JOIN veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id;

DROP VIEW view_dreiging_ruimtelijk;
CREATE OR REPLACE VIEW view_dreiging_ruimtelijk AS
  SELECT b.*, vt.naam AS soort, o.formelenaam, ROUND(ST_X(b.geom)) AS X, ROUND(ST_Y(b.geom)) AS Y FROM dreiging b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  INNER JOIN dreiging_type vt ON b.dreiging_type_id = vt.id;

DROP VIEW view_gevaarlijkestof_ruimtelijk;
CREATE OR REPLACE VIEW view_gevaarlijkestof_ruimtelijk AS
SELECT s.*, vn.vn_nr, vn.gevi_nr, vn.eric_kaart, part.geom, part.formelenaam, part.rotatie, ROUND(ST_X(part.geom)) AS X, ROUND(ST_Y(part.geom)) AS Y, part.object_id FROM gevaarlijkestof s
INNER JOIN
  (
  SELECT b.id AS opslag_id, b.geom, b.rotatie, o.formelenaam, b.object_id FROM gevaarlijkestof_opslag b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  ) part ON s.opslag_id = part.opslag_id
  LEFT JOIN gevaarlijkestof_vnnr vn ON s.gevaarlijkestof_vnnr_id = vn.id;

DROP VIEW view_ingang_ruimtelijk;
CREATE OR REPLACE VIEW view_ingang_ruimtelijk AS
  SELECT b.*, vt.naam AS soort, o.formelenaam, ROUND(ST_X(b.geom)) AS X, ROUND(ST_Y(b.geom)) AS Y FROM ingang b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  INNER JOIN ingang_type vt ON b.ingang_type_id = vt.id;

DROP VIEW view_sleutelkluis_ruimtelijk;
CREATE OR REPLACE VIEW view_sleutelkluis_ruimtelijk AS
SELECT s.*, st.naam AS type, sd.naam AS doel, part.formelenaam, part.object_id, ROUND(ST_X(s.geom)) AS X, ROUND(ST_Y(s.geom)) AS Y FROM sleutelkluis s
INNER JOIN
  (
  SELECT b.id AS ingang_id, b.object_id, o.formelenaam FROM ingang b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  ) part ON s.ingang_id = part.ingang_id
  LEFT JOIN sleutelkluis_type st ON s.sleutelkluis_type_id = st.id
  LEFT JOIN sleuteldoel_type sd  ON s.sleuteldoel_type_id = sd.id;

CREATE OR REPLACE VIEW view_contactpersoon AS
  SELECT b.*, o.formelenaam FROM contactpersoon b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id;

CREATE OR REPLACE VIEW view_bedrijfshulpverlening AS
  SELECT b.*, o.formelenaam FROM bedrijfshulpverlening b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id;

DROP VIEW view_opstelplaats;
CREATE OR REPLACE VIEW view_opstelplaats AS
  SELECT b.*, o.formelenaam, ROUND(ST_X(b.geom)) AS X, ROUND(ST_Y(b.geom)) AS Y FROM opstelplaats b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 0;
UPDATE algemeen.applicatie SET revisie = 6;
UPDATE algemeen.applicatie SET db_versie = 306; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();