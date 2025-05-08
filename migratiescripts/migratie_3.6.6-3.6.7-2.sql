SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE OR REPLACE VIEW objecten.bouwlaag_afw_binnendekking
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.toelichting AS handelingsaanwijzing,
    v.bouwlaag_id,
    b.bouwlaag,
    v.rotatie,
    CONCAT(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    ''::text AS applicatie,
    v.label_positie,
    v.formaat_bouwlaag
   FROM objecten.afw_binnendekking v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.afw_binnendekking_type st ON v.soort::text = st.naam::text
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_afw_binnendekking;
CREATE OR REPLACE VIEW objecten.view_afw_binnendekking
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.toelichting AS handelingsaanwijzing,
    d.bouwlaag_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    CONCAT(dt.symbol_name, '_', dt.symbol_type) as symbol_name,
	CASE
		WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
		WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
		WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
		ELSE NULL::numeric
	END AS size,
    o.share,
    d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.afw_binnendekking d ON st_intersects(t.geom, d.geom)
     JOIN objecten.afw_binnendekking_type dt ON d.soort::text = dt.naam::text
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.dreiging (geom, soort, label, rotatie, bouwlaag_id, object_id, fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.soort, new.label, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id, new.label_positie, new.formaat_bouwlaag, new.formaat_object);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.dreiging_type dt WHERE dt.naam = new.soort);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.dreiging_type dt WHERE dt.naam = new.soort);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'INSERT', 'dreiging', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.dreiging SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, label = new.label, 
						bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie,
						formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (dreiging.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
                size := (SELECT dt."size" FROM objecten.dreiging_type dt WHERE dt.naam = new.soort);
            ELSE
                size := (SELECT dt."size_object" FROM objecten.dreiging_type dt WHERE dt.naam = new.soort);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'UPDATE', 'dreiging', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'dreiging', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE VIEW objecten.bouwlaag_dreiging
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.fotografie_id,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    CONCAT(st.symbol_name, '_', st.symbol_type) as symbol_name,
	CASE
		WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
		WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
		WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
		ELSE NULL::numeric
	END AS size,
    ''::text AS applicatie,
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.dreiging v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.dreiging_type st ON v.soort = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_dreiging_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_del('bouwlaag');
CREATE TRIGGER bouwlaag_dreiging_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_ins('bouwlaag');
CREATE TRIGGER bouwlaag_dreiging_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_upd('bouwlaag');

CREATE OR REPLACE VIEW objecten.object_dreiging
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.fotografie_id,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    CONCAT(st.symbol_name, '_', st.symbol_type) as symbol_name,
	CASE
		WHEN v.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
		WHEN v.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
		WHEN v.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
		ELSE NULL::numeric
	END AS size,
    ''::text AS applicatie,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    v.label_positie,
    v.formaat_object,
    v.formaat_bouwlaag
   FROM objecten.dreiging v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.dreiging_type st ON v.soort = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_dreiging_del INSTEAD OF
DELETE
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_del('object');
CREATE TRIGGER object_dreiging_ins INSTEAD OF
INSERT
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_ins('object');
CREATE TRIGGER object_dreiging_upd INSTEAD OF
UPDATE
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_upd('object');

CREATE OR REPLACE VIEW objecten.view_dreiging_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    CONCAT(dt.symbol_name, '_', dt.symbol_type) as symbol_name,
	CASE
		WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
		WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
		WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
		ELSE NULL::numeric
	END AS size,
    o.share,
    d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.dreiging d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.dreiging_type dt ON d.soort = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW objecten.view_dreiging_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.rotatie,
    b.label,
    b.bouwlaag_id,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    CONCAT(vt.symbol_name, '_', vt.symbol_type) as symbol_name,
	CASE
		WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
		WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
		WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
		ELSE NULL::numeric
	END AS size,
    o.share,
    b.label_positie
   FROM objecten.object o
     JOIN objecten.dreiging b ON o.id = b.object_id
     JOIN objecten.dreiging_type vt ON b.soort = vt.naam
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW objecten.bouwlaag_ingang
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.belemmering,
    v.voorzieningen,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    CONCAT(st.symbol_name, '_', st.symbol_type) as symbol_name,
    CASE
        WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
        WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
        WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
        ELSE NULL::numeric
    END AS size,
    ''::text AS applicatie,
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.ingang v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.ingang_type st ON v.soort = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_ingang_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_del('bouwlaag');
CREATE TRIGGER bouwlaag_ingang_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_ins('bouwlaag');
CREATE TRIGGER bouwlaag_ingang_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_upd('bouwlaag');

CREATE OR REPLACE VIEW objecten.object_ingang
AS SELECT v.id,
    v.geom,
    v.soort AS ingang_type_id,
    v.label,
    v.belemmering,
    v.voorzieningen,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    CONCAT(st.symbol_name, '_', st.symbol_type) as symbol_name,
    CASE
        WHEN v.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
        WHEN v.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
        WHEN v.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
        ELSE NULL::numeric
    END AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    v.label_positie,
    v.formaat_object,
    v.formaat_bouwlaag
   FROM objecten.ingang v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.ingang_type st ON v.soort = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_ingang_del INSTEAD OF
DELETE
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_del('object');
CREATE TRIGGER object_ingang_ins INSTEAD OF
INSERT
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_ins('object');
CREATE TRIGGER object_ingang_upd INSTEAD OF
UPDATE
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_upd('object');

CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    CONCAT(dt.symbol_name, '_', dt.symbol_type) as symbol_name,
    CASE
        WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
        WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
        WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
        ELSE NULL::numeric
    END AS size,
    o.share,
    d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.ingang d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.ingang_type dt ON d.soort = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW objecten.view_ingang_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.rotatie,
    b.label,
    b.belemmering,
    b.voorzieningen,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    CONCAT(vt.symbol_name, '_', vt.symbol_type) as symbol_name,
    CASE
        WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
        WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
        WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
        ELSE NULL::numeric
    END AS size,
    o.share,
    b.label_positie
   FROM objecten.object o
     JOIN objecten.ingang b ON o.id = b.object_id
     JOIN objecten.ingang_type vt ON b.soort = vt.naam
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE FUNCTION objecten.func_ingang_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.ingang (geom, soort, label, rotatie, belemmering, voorzieningen, bouwlaag_id, object_id, fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.soort, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.bouwlaag_id, new.object_id, new.fotografie_id, new.label_positie, new.formaat_bouwlaag, new.formaat_object);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.belemmering, new.voorzieningen) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.ingang_type dt WHERE dt.naam = new.soort);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.ingang_type dt WHERE dt.naam = new.soort);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'INSERT', 'ingang', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_ingang_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.ingang SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, 
                    bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (ingang.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.belemmering, new.voorzieningen) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.ingang_type dt WHERE dt.naam = new.soort);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT dt."size_object" FROM objecten.ingang_type dt WHERE dt.naam = new.soort);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag)
            VALUES (new.geom, jsonstring, 'UPDATE', 'ingang', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'ingang', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE VIEW objecten.bouwlaag_opslag
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.locatie,
    v.bouwlaag_id,
    v.object_id,
    v.fotografie_id,
    v.rotatie,
    b.bouwlaag,
    CONCAT(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    CASE
        WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
        WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
        WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
        ELSE NULL::numeric
    END AS size,
    ''::text AS applicatie,
    v.self_deleted,
    v.label,
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.gevaarlijkestof_opslag v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON v.soort = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW objecten.object_opslag
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    b.formelenaam,
    o.rotatie,
    CASE
        WHEN o.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
        WHEN o.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
        WHEN o.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
        ELSE NULL::numeric
    END AS size,
    CONCAT(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    o.label,
    o.label_positie,
    o.formaat_object,
    o.formaat_bouwlaag
   FROM objecten.gevaarlijkestof_opslag o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON o.soort = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.parent_deleted = 'infinity'::timestamp with time zone AND o.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_gevaarlijkestof_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    CONCAT(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    CASE
        WHEN op.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
        WHEN op.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
        WHEN op.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
        ELSE NULL::numeric
    END AS size,
    o.share,
    op.label,
    op.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_opslag_type st ON op.soort = st.naam
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_gevaarlijkestof_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    CONCAT(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    CASE
        WHEN op.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
        WHEN op.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
        WHEN op.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
        ELSE NULL::numeric
    END AS size,
    o.share,
    op.label,
    op.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW objecten.object_opstelplaats
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.fotografie_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    CASE
        WHEN v.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
        WHEN v.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
        WHEN v.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
        ELSE NULL::numeric
    END AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    v.label_positie,
    v.formaat_object
   FROM objecten.opstelplaats v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.opstelplaats_type st ON v.soort::text = st.naam::text
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_opstelplaats;
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
    CASE
        WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
        WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
        WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
        ELSE NULL::numeric
    END AS size,
    o.share,
    b.label_positie
   FROM objecten.object o
     JOIN objecten.opstelplaats b ON o.id = b.object_id
     JOIN objecten.opstelplaats_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW objecten.object_points_of_interest
AS SELECT b.id,
    b.geom,
    b.soort,
    b.label,
    b.bijzonderheid,
    b.fotografie_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    CONCAT(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    CASE
	    WHEN b.formaat_object = 'klein' THEN st.size_object_klein
	    WHEN b.formaat_object = 'middel' THEN st.size_object_middel
	    WHEN b.formaat_object = 'groot' THEN st.size_object_groot
	END AS size,
    ''::text AS applicatie,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject,
	b.label_positie,
	b.formaat_object
   FROM objecten.points_of_interest b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.points_of_interest_type st ON b.soort = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER points_of_interest_del INSTEAD OF
DELETE
    ON
    objecten.object_points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.func_points_of_interest_del();
CREATE TRIGGER points_of_interest_ins INSTEAD OF
INSERT
    ON
    objecten.object_points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.func_points_of_interest_ins();
CREATE TRIGGER points_of_interest_upd INSTEAD OF
UPDATE
    ON
    objecten.object_points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.func_points_of_interest_upd();

CREATE OR REPLACE VIEW objecten.view_points_of_interest
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    b.bijzonderheid,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    CONCAT(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
    CASE
        WHEN b.formaat_object = 'klein' THEN vt.size_object_klein
        WHEN b.formaat_object = 'middel' THEN vt.size_object_middel
        WHEN b.formaat_object = 'groot' THEN vt.size_object_groot
    END as size,
    o.share,
	b.label_positie
   FROM objecten.object o
     JOIN objecten.points_of_interest b ON o.id = b.object_id
     JOIN objecten.points_of_interest_type vt ON b.soort = vt.naam
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.points_of_interest (geom, soort, label, bijzonderheid, rotatie, object_id, fotografie_id, label_positie, formaat_object)
            VALUES (new.geom, new.soort, new.label, new.bijzonderheid, new.rotatie, new.object_id, new.fotografie_id, new.label_positie, new.formaat_object);
        ELSE
            size := (SELECT vt."size" FROM objecten.points_of_interest_type vt WHERE vt.naam = new.soort);
            symbol_name := (SELECT vt.symbol_name FROM objecten.points_of_interest_type vt WHERE vt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.bijzonderheid) d));
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (new.geom, jsonstring, 'INSERT', 'points_of_interest', NULL, objectid, NEW.rotatie, size, symbol_name, new.fotografie_id, false, new.label, new.label_positie, new.formaat_object);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
                UPDATE objecten.points_of_interest SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, bijzonderheid = new.bijzonderheid, 
						label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_object=new.formaat_object
                WHERE (points_of_interest.id = new.id);
        ELSE
            size := (SELECT vt."size" FROM objecten.points_of_interest_type vt WHERE vt.naam = new.soort);
            symbol_name := (SELECT vt.symbol_name FROM objecten.points_of_interest_type vt WHERE vt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.bijzonderheid) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (new.geom, jsonstring, 'UPDATE', 'points_of_interest', old.id, new.object_id, NEW.rotatie, size, symbol_name, new.fotografie_id, false, new.label, new.label_positie, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'points_of_interest');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 367; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
