SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TABLE terrein
(
	id 				SERIAL PRIMARY KEY NOT NULL,
	geom	 		GEOMETRY(MULTIPOLYGON, 28992),
	datum_aangemaakt  TIMESTAMP WITH TIME ZONE DEFAULT now(),
  	datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
	omschrijving 	TEXT,
	object_id 		INTEGER,
	CONSTRAINT terrein_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX terrein_geom_gist
  ON terrein USING GIST(geom);
COMMENT ON TABLE bouwlagen IS 'Terreinen behorende bij een repressief object';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON terrein
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON terrein
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

INSERT INTO terrein (geom, object_id)
SELECT geovlak, id FROM object;

DROP VIEW object_terrein;

-- create view bouwlagen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW view_bouwlagen CASCADE;
CREATE OR REPLACE VIEW view_bouwlagen AS
SELECT bl.id, bl.geom, bl.datum_aangemaakt, bl.datum_gewijzigd, bl.bouwlaag, bl.bouwdeel, part.object_id, part.formelenaam FROM bouwlagen bl
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part 
ON ST_INTERSECTS(bl.geom, part.geovlak);

-- create view bouwkundige veiligheidsvoorzieningen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW view_veiligh_bouwk CASCADE;
CREATE OR REPLACE VIEW view_veiligh_bouwk AS
SELECT s.*, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel FROM veiligh_bouwk s
INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(s.geom, part.geovlak);

-- create view ruimten, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW view_ruimten CASCADE;
CREATE OR REPLACE VIEW view_ruimten AS
SELECT r.*, t.naam AS soort, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel FROM ruimten r
INNER JOIN ruimten_type t ON r.ruimten_type_id = t.id
INNER JOIN bouwlagen b ON r.bouwlaag_id = b.id
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(r.geom, part.geovlak);

-- create view labels op een bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW view_label_bouwlaag CASCADE;
CREATE OR REPLACE VIEW view_label_bouwlaag AS 
SELECT l.id, l.geom, l.datum_aangemaakt, l.datum_gewijzigd, l.omschrijving, l.soort, l.rotatie, l.bouwlaag_id, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(l.geom)) AS X, ROUND(ST_Y(l.geom)) AS Y FROM label l
INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(l.geom, part.geovlak);

-- create view installatietechnische veiligheidsvoorzieningen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW view_veiligh_install CASCADE;
CREATE OR REPLACE VIEW view_veiligh_install AS
SELECT v.*, t.naam AS soort, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(v.geom)) AS X, ROUND(ST_Y(v.geom)) AS Y FROM veiligh_install v
INNER JOIN veiligh_install_type t ON v.veiligh_install_type_id = t.id
INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(v.geom, part.geovlak);

-- view van gevaarlijkestoffen locatie met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
DROP VIEW view_gevaarlijkestof_bouwlaag CASCADE;
CREATE OR REPLACE VIEW view_gevaarlijkestof_bouwlaag AS 
SELECT gvs.id, gvs.opslag_id, gvs.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, gvs.eenheid, gvs.toestand,
    part.object_id, part.formelenaam, ops.bouwlaag, ops.bouwdeel, ops.geom, ops.locatie, ops.rotatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y, ops.bouwlaag_id FROM gevaarlijkestof gvs
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN 
  (SELECT op.id, op.geom, op.bouwlaag_id, op.locatie, op.rotatie, b.bouwlaag, b.bouwdeel FROM gevaarlijkestof_opslag op
  INNER JOIN bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(ops.geom, part.geovlak);

-- view van gevaarlijkestoffen schade crikel met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_schade_cirkel_bouwlaag CASCADE;
CREATE OR REPLACE VIEW view_schade_cirkel_bouwlaag AS 
SELECT gvs.id, gvs.opslag_id, gvs.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, gvs.eenheid, gvs.toestand,
    part.object_id, part.formelenaam, ops.bouwlaag, ops.bouwdeel, ST_BUFFER(ops.geom, gsc.straal)::geometry(Polygon,28992) AS geom, ops.locatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y FROM gevaarlijkestof gvs
INNER JOIN gevaarlijkestof_schade_cirkel gsc ON gvs.id = gevaarlijkestof_id
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN 
  (SELECT op.id, op.geom, op.bouwlaag_id, op.locatie, b.bouwlaag, b.bouwdeel FROM gevaarlijkestof_opslag op
  INNER JOIN bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(ops.geom, part.geovlak);

-- create view dreiging bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW view_dreiging_bouwlaag CASCADE;
CREATE OR REPLACE VIEW view_dreiging_bouwlaag AS
SELECT d.id, d.geom, d.datum_aangemaakt, d.datum_gewijzigd, d.dreiging_type_id, d.rotatie, d.label, d.bouwlaag_id, d.fotografie_id, t.naam AS soort, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(d.geom)) AS X, ROUND(ST_Y(d.geom)) AS Y, t.symbol_name FROM dreiging d
INNER JOIN dreiging_type t ON d.dreiging_type_id = t.id
INNER JOIN bouwlagen b ON d.bouwlaag_id = b.id
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(d.geom, part.geovlak);

-- create view ingang bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW view_ingang_bouwlaag CASCADE;
CREATE OR REPLACE VIEW view_ingang_bouwlaag AS
SELECT i.id, i.geom, i.datum_aangemaakt, i.datum_gewijzigd, i.ingang_type_id, i.rotatie, i.label, i.bouwlaag_id, i.fotografie_id, t.naam AS soort, 
    part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(i.geom)) AS X, ROUND(ST_Y(i.geom)) AS Y, t.symbol_name FROM ingang i 
INNER JOIN ingang_type t ON i.ingang_type_id = t.id
INNER JOIN bouwlagen b ON i.bouwlaag_id = b.id
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(i.geom, part.geovlak);

-- create view sleutelkluis bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_sleutelkluis_bouwlaag CASCADE;
CREATE OR REPLACE VIEW view_sleutelkluis_bouwlaag AS
SELECT s.id, s.geom, s.datum_aangemaakt, s.datum_gewijzigd, s.sleutelkluis_type_id, st.naam AS type, s.rotatie, s.label, s.aanduiding_locatie, s.sleuteldoel_type_id, sd.naam AS doel, s.ingang_id, s.fotografie_id, 
    sub.formelenaam, sub.object_id, part.bouwlaag, part.bouwdeel, ROUND(ST_X(s.geom)) AS X, ROUND(ST_Y(s.geom)) AS Y, part.bouwlaag_id FROM sleutelkluis s 
INNER JOIN (SELECT i.*, b.bouwlaag, b.bouwdeel FROM ingang i INNER JOIN bouwlagen b ON i.bouwlaag_id = b.id) part ON s.ingang_id = part.id
INNER JOIN objecten.sleutelkluis_type st ON s.sleutelkluis_type_id = st.id
LEFT JOIN objecten.sleuteldoel_type sd ON s.sleuteldoel_type_id = sd.id
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) sub
ON ST_INTERSECTS(s.geom, sub.geovlak);

-- create view dreiging bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW view_afw_binnendekking CASCADE;
CREATE OR REPLACE VIEW view_afw_binnendekking AS
SELECT a.id, a.geom, a.datum_aangemaakt, a.datum_gewijzigd, a.soort, a.rotatie, a.label, a.handelingsaanwijzing, a.bouwlaag_id, 
    part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(a.geom)) AS X, ROUND(ST_Y(a.geom)) AS Y FROM afw_binnendekking a
INNER JOIN bouwlagen b ON a.bouwlaag_id = b.id
INNER JOIN (
	SELECT DISTINCT formelenaam, o.id AS object_id, ST_UNION(t.geom)::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(a.geom, part.geovlak);

DROP VIEW view_objectgegevens CASCADE;
CREATE OR REPLACE VIEW view_objectgegevens AS 
 SELECT object.id,
    object.formelenaam,
    geom,
    basisreg_identifier,
    datum_aangemaakt,
    datum_gewijzigd,
    bijzonderheden,
    pers_max,
    pers_nietz_max,
    datum_geldig_vanaf,
    datum_geldig_tot,
    bron,
    bron_tabel,
    fotografie_id,
    bg.naam AS bodemgesteldheid,
    gf.gebruiksfuncties,
    round(st_x(geom)) AS x,
    round(st_y(geom)) AS y
   FROM object
     JOIN ( SELECT object_1.formelenaam,
            object_1.id AS object_id
           FROM object object_1
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object_1.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object_1.datum_geldig_vanaf <= now() OR object_1.datum_geldig_vanaf IS NULL) AND (object_1.datum_geldig_tot > now() OR object_1.datum_geldig_tot IS NULL)) o ON id = o.object_id
     LEFT JOIN bodemgesteldheid_type bg ON bodemgesteldheid_type_id = bg.id
     LEFT JOIN (SELECT DISTINCT g.object_id, STRING_AGG(gt.naam, ', ') AS gebruiksfuncties FROM gebruiksfunctie g
                                INNER JOIN gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
                                GROUP BY g.object_id) gf ON object.id = gf.object_id;

DROP VIEW object_bgt CASCADE;
CREATE OR REPLACE VIEW object_bgt AS 
 SELECT id,
    geom,
    datum_aangemaakt,
    datum_gewijzigd,
    basisreg_identifier,
    formelenaam,
    bijzonderheden,
    pers_max,
    pers_nietz_max,
    datum_geldig_tot,
    datum_geldig_vanaf,
    bron,
    bron_tabel,
    fotografie_id,
    bodemgesteldheid_type_id
   FROM object
  WHERE bron::text = 'BGT'::text;

CREATE OR REPLACE RULE object_bgt_ins AS
    ON INSERT TO object_bgt DO INSTEAD  INSERT INTO object (geom, basisreg_identifier, formelenaam, bron, bron_tabel)  SELECT new.geom,
            b.identificatie,
            new.formelenaam,
            b.bron,
            b.bron_tbl
           FROM algemeen.bgt_extent b
          WHERE st_intersects(new.geom, ST_CURVETOLINE(b.geovlak))
         LIMIT 1
  RETURNING id,
    geom,
    datum_aangemaakt,
    datum_gewijzigd,
    basisreg_identifier,
    formelenaam,
    bijzonderheden,
    pers_max,
    pers_nietz_max,
    datum_geldig_tot,
    datum_geldig_vanaf,
    bron,
    bron_tabel,
    fotografie_id,
    bodemgesteldheid_type_id;

ALTER TABLE object DROP COLUMN geovlak;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 1;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 312; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();