SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE mobiel.werkvoorraad_punt ADD COLUMN opmerking text;

ALTER TABLE objecten.afw_binnendekking RENAME COLUMN handelingsaanwijzing TO opmerking;

DROP VIEW objecten.bouwlaag_afw_binnendekking;
CREATE OR REPLACE VIEW objecten.bouwlaag_afw_binnendekking
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
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

CREATE TRIGGER afw_binnendekking_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_del();
CREATE TRIGGER afw_binnendekking_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_ins();
CREATE TRIGGER afw_binnendekking_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_upd();

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer;
        symbol_name TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.afw_binnendekking (geom, soort, label, rotatie, opmerking, bouwlaag_id, label_positie, formaat_bouwlaag)
            VALUES (new.geom, new.soort, new.label, new.rotatie, new.opmerking, new.bouwlaag_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition), COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat));
        ELSE
            symbol_name := (SELECT at.symbol_name FROM objecten.afw_binnendekking_type at WHERE naam = new.soort);
            bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
    
            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, rotatie, symbol_name, bouwlaag, accepted, label, opmerking, label_positie, formaat_bouwlaag)
            VALUES (new.geom, 'INSERT', 'afw_binnendekking', NULL, bouwlaagid, NEW.rotatie, symbol_name, new.bouwlaag, false, new.label, new.opmerking,
                    COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition), COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat));
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        symbol_name TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.afw_binnendekking SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, opmerking = new.opmerking, 
					bouwlaag_id = new.bouwlaag_id, label_positie= new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag
            WHERE (afw_binnendekking.id = new.id);
        ELSE
            symbol_name := (SELECT at.symbol_name FROM objecten.afw_binnendekking_type at WHERE naam = new.soort);

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted, label, opmerking, label_positie, formaat_bouwlaag)
            VALUES (new.geom, 'UPDATE', 'afw_binnendekking', old.id, new.bouwlaag_id, NEW.rotatie, size, symbol_name, new.bouwlaag, false, label, new.opmerking, new.label_positie, new.formaat_bouwlaag);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'afw_binnendekking', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.afw_binnendekking WHERE (afw_binnendekking.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, symbol_name, bouwlaag, accepted, label, opmerking, label_positie, formaat_bouwlaag)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'afw_binnendekking', OLD.id, OLD.bouwlaag_id, OLD.rotatie, OLD.symbol_name, OLD.bouwlaag, false, old.label, old.opmerking, old.label_positie, old.formaat_bouwlaag);
        END IF;
        RETURN OLD;
    END;
    $function$
;

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
    d.opmerking,
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


ALTER TABLE objecten.dreiging RENAME COLUMN omschrijving TO opmerking;

DROP VIEW IF EXISTS objecten.bouwlaag_dreiging;
CREATE OR REPLACE VIEW objecten.bouwlaag_dreiging
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.fotografie_id,
    v.opmerking,
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

DROP VIEW IF EXISTS objecten.object_dreiging;
CREATE OR REPLACE VIEW objecten.object_dreiging
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.fotografie_id,
    v.opmerking,
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

CREATE OR REPLACE FUNCTION objecten.func_dreiging_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.dreiging (geom, soort, label, opmerking, rotatie, bouwlaag_id, object_id, fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
                    COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.naam = new.soort);

            IF bouwlaag_object = 'object'::text THEN
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'INSERT', 'dreiging', NULL, bouwlaagid, objectid, NEW.rotatie, symbol_name, bouwlaag, new.fotografie_id, false, new.label, new.opmerking, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
                    COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));

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
            UPDATE objecten.dreiging SET geom = new.geom, soort = new.soort, opmerking = new.opmerking, rotatie = new.rotatie, label = new.label, 
						bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie,
						formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (dreiging.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.naam = new.soort);

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'UPDATE', 'dreiging', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.opmerking, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'dreiging', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.dreiging WHERE (dreiging.id = old.id);
        ELSE
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'dreiging', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.symbol_name, bouwlaag, 
						old.fotografie_id, false, old.label, old.opmerking, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW IF EXISTS objecten.view_dreiging_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_dreiging_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.opmerking,
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

DROP VIEW IF EXISTS objecten.view_dreiging_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_dreiging_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.rotatie,
    b.label,
    b.opmerking,
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
    b.label_positie,
    h2.typeobject
   FROM objecten.object o
     JOIN objecten.dreiging b ON o.id = b.object_id
     JOIN objecten.dreiging_type vt ON b.soort = vt.naam
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
    JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.gevaarlijkestof_opslag RENAME COLUMN locatie TO opmerking;

DROP VIEW objecten.bouwlaag_opslag;
CREATE OR REPLACE VIEW objecten.bouwlaag_opslag
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.opmerking,
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
    v.formaat_object,
    v.soort
   FROM objecten.gevaarlijkestof_opslag v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON v.soort = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_opslag_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_ins('bouwlaag');
CREATE TRIGGER bouwlaag_opslag_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_del('bouwlaag');
CREATE TRIGGER bouwlaag_opslag_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_upd('bouwlaag');

DROP VIEW objecten.object_opslag;
CREATE OR REPLACE VIEW objecten.object_opslag
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.opmerking,
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
    o.formaat_bouwlaag,
    o.soort
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

CREATE TRIGGER object_opslag_ins INSTEAD OF
INSERT
    ON
    objecten.object_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_ins('object');
CREATE TRIGGER object_opslag_del INSTEAD OF
DELETE
    ON
    objecten.object_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_del('object');
CREATE TRIGGER object_opslag_upd INSTEAD OF
UPDATE
    ON
    objecten.object_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_upd('object');

CREATE OR REPLACE FUNCTION objecten.func_opslag_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.gevaarlijkestof_opslag (geom, opmerking, bouwlaag_id, object_id, fotografie_id, rotatie, label, soort, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.opmerking, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie, new.label, new.soort, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
					COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = new.soort);

            IF bouwlaag_object = 'object'::text THEN
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'INSERT', 'gevaarlijkestof_opslag', NULL, bouwlaagid, objectid, NEW.rotatie, symbol_name, bouwlaag, new.fotografie_id, false, new.label, new.opmerking,
                    COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition), COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_opslag_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.gevaarlijkestof_opslag SET geom = new.geom, opmerking = new.opmerking, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, soort = new.soort, 
					fotografie_id = new.fotografie_id, label = new.label, label_positie = new.label_positie, formaat_bouwlaag= new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (gevaarlijkestof_opslag.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = new.soort);

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'UPDATE', 'gevaarlijkestof_opslag', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.opmerking, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'gevaarlijkestof_opslag', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_opslag_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.gevaarlijkestof_opslag WHERE (gevaarlijkestof_opslag.id = old.id);
        ELSE
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, 'DELETE', 'gevaarlijkestof_opslag', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.symbol_name, bouwlaag, 
						old.fotografie_id, false, old.label, old.opmerking, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

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
    op.opmerking as locatie,
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
    op.opmerking As locatie,
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
    op.label_positie,
    h2.typeobject
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
     JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.ingang ADD COLUMN opmerking text;
UPDATE objecten.ingang SET opmerking = CONCAT(voorzieningen, CASE WHEN voorzieningen IS NOT NULL THEN CONCAT(CHR(13), CHR(10)) ELSE '' END, belemmering);

DROP VIEW IF EXISTS objecten.bouwlaag_ingang;
CREATE OR REPLACE VIEW objecten.bouwlaag_ingang
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
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

DROP VIEW IF EXISTS objecten.object_ingang;
CREATE OR REPLACE VIEW objecten.object_ingang
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
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

CREATE OR REPLACE FUNCTION objecten.func_ingang_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.ingang (geom, soort, label, opmerking, rotatie, bouwlaag_id, object_id, fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
                    COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.naam = new.soort);

            IF bouwlaag_object = 'object'::text THEN
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'INSERT', 'ingang', NULL, bouwlaagid, objectid, NEW.rotatie, symbol_name, bouwlaag, new.fotografie_id, false, new.label, new.opmerking, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
                    COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
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
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.ingang SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, opmerking = new.opmerking, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id,
                                         fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (ingang.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.naam = new.soort);

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag)
            VALUES (new.geom, 'UPDATE', 'ingang', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.opmerking, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'ingang', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_ingang_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.ingang WHERE (ingang.id = old.id);
        ELSE
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, 'DELETE', 'ingang', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, 
						old.fotografie_id, false, old.label, old.opmerking, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW IF EXISTS objecten.view_ingang_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.opmerking,
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

DROP VIEW IF EXISTS objecten.view_ingang_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_ingang_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.rotatie,
    b.label,
    b.opmerking,
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
    b.label_positie,
    h2.typeobject
   FROM objecten.object o
     JOIN objecten.ingang b ON o.id = b.object_id
     JOIN objecten.ingang_type vt ON b.soort = vt.naam
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
    JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.opstelplaats ADD COLUMN opmerking text;

DROP VIEW objecten.object_opstelplaats;
CREATE OR REPLACE VIEW objecten.object_opstelplaats
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
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

CREATE TRIGGER opstelplaats_del INSTEAD OF
DELETE
    ON
    objecten.object_opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.func_opstelplaats_del();
CREATE TRIGGER opstelplaats_ins INSTEAD OF
INSERT
    ON
    objecten.object_opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.func_opstelplaats_ins();
CREATE TRIGGER opstelplaats_upd INSTEAD OF
UPDATE
    ON
    objecten.object_opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.func_opstelplaats_upd();

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        symbol_name TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.opstelplaats (geom, soort, label, opmerking, rotatie, object_id, fotografie_id, label_positie, formaat_object)
            VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
					COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        ELSE
            symbol_name := (SELECT ot.symbol_name FROM objecten.opstelplaats_type ot WHERE ot.naam = new.soort);
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, object_id, rotatie, symbol_name, fotografie_id, accepted, label, opmerking, label_positie, formaat_object)
            VALUES (new.geom, 'INSERT', 'opstelplaats', NULL, objectid, NEW.rotatie, symbol_name, new.fotografie_id, false, new.label, new.opmerking, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
					COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        symbol_name TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.opstelplaats SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, opmerking = new.opmerking, object_id = new.object_id, 
												fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_object=new.formaat_object
            WHERE (opstelplaats.id = new.id);
        ELSE
            symbol_name := (SELECT ot.symbol_name FROM objecten.opstelplaats_type ot WHERE ot.naam = new.soort);

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, object_id, rotatie, symbol_name, fotografie_id, accepted, label, opmerking, label_positie, formaat_object)
            VALUES (new.geom, 'UPDATE', 'opstelplaats', old.id, new.object_id, NEW.rotatie, symbol_name, new.fotografie_id, false, new.label, new.opmerking, new.label_positie, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'opstelplaats');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.opstelplaats WHERE (opstelplaats.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, object_id, rotatie, symbol_name, fotografie_id, accepted, label, opmerking, label_positie, formaat_object)
            VALUES (OLD.geom, 'DELETE', 'opstelplaats', OLD.id, OLD.object_id, OLD.rotatie, OLD.symbol_name, old.fotografie_id, false, old.label, old.opmerking, old.label_positie, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

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
    b.opmerking,
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
    b.label_positie,
    h2.typeobject
   FROM objecten.object o
     JOIN objecten.opstelplaats b ON o.id = b.object_id
     JOIN objecten.opstelplaats_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
    JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.points_of_interest RENAME COLUMN bijzonderheid TO opmerking;

DROP VIEW IF EXISTS objecten.object_points_of_interest;
CREATE OR REPLACE VIEW objecten.object_points_of_interest
AS SELECT b.id,
    b.geom,
    b.soort,
    b.label,
    b.opmerking,
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

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        symbol_name TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.points_of_interest (geom, soort, label, opmerking, rotatie, object_id, fotografie_id, label_positie, formaat_object)
            VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
                    COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        ELSE
            symbol_name := (SELECT vt.symbol_name FROM objecten.points_of_interest_type vt WHERE vt.naam = new.soort);
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, object_id, rotatie, symbol_name, fotografie_id, accepted, label, opmerking, label_positie, formaat_object)
            VALUES (new.geom, 'INSERT', 'points_of_interest', NULL, objectid, NEW.rotatie, symbol_name, new.fotografie_id, false, new.label, new.opmerking, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
                    COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
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
        symbol_name TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
                UPDATE objecten.points_of_interest SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, opmerking = new.opmerking, 
						label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_object=new.formaat_object
                WHERE (points_of_interest.id = new.id);
        ELSE
            symbol_name := (SELECT vt.symbol_name FROM objecten.points_of_interest_type vt WHERE vt.naam = new.soort);

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, object_id, rotatie, symbol_name, fotografie_id, accepted, label, opmerking, label_positie, formaat_object)
            VALUES (new.geom, 'UPDATE', 'points_of_interest', old.id, new.object_id, NEW.rotatie, symbol_name, new.fotografie_id, false, new.label, new.opmerking, new.label_positie, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'points_of_interest');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.points_of_interest WHERE (points_of_interest.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, object_id, rotatie, symbol_name, fotografie_id, accepted, label, opmerking, label_positie, formaat_object)
            VALUES (OLD.geom, 'DELETE', 'points_of_interest', OLD.id, OLD.object_id, OLD.rotatie, OLD.symbol_name, OLD.fotografie_id, false, old.label, old.opmerking, old.label_positie, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW IF EXISTS objecten.view_points_of_interest;
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
    b.opmerking,
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
	b.label_positie,
    h2.typeobject
   FROM objecten.object o
     JOIN objecten.points_of_interest b ON o.id = b.object_id
     JOIN objecten.points_of_interest_type vt ON b.soort = vt.naam
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
    JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.sleutelkluis RENAME aanduiding_locatie TO opmerking;

DROP VIEW IF EXISTS objecten.bouwlaag_sleutelkluis;
CREATE OR REPLACE VIEW objecten.bouwlaag_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.sleuteldoel,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
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
    v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.sleutelkluis v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.sleutelkluis_type st ON v.soort = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_sleutelkluis_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_del('bouwlaag');
CREATE TRIGGER bouwlaag_sleutelkluis_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_ins('bouwlaag');
CREATE TRIGGER bouwlaag_sleutelkluis_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_upd('bouwlaag');

DROP VIEW IF EXISTS objecten.object_sleutelkluis;
CREATE OR REPLACE VIEW objecten.object_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.sleuteldoel,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    CONCAT(st.symbol_name, '_', st.symbol_type) AS symbol_name,
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
   FROM objecten.sleutelkluis v
     JOIN objecten.sleutelkluis_type st ON v.soort = st.naam
     JOIN objecten.object b ON v.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_sleutelkluis_del INSTEAD OF
DELETE
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_del('object');
CREATE TRIGGER object_sleutelkluis_ins INSTEAD OF
INSERT
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_ins('object');
CREATE TRIGGER object_sleutelkluis_upd INSTEAD OF
UPDATE
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_upd('object');

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer := NULL;
		bouwlaagid integer := NULL;
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.sleutelkluis (geom, soort, label, rotatie, opmerking, sleuteldoel, bouwlaag_id, object_id, 
												fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.soort, new.label, new.rotatie, new.opmerking, new.sleuteldoel, new.bouwlaag_id, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
					COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.naam = new.soort);

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag = new.bouwlaag;
            ELSEIF bouwlaag_object = 'object'::text THEN
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'INSERT', 'sleutelkluis', NULL, bouwlaagid, objectid, NEW.rotatie, symbol_name, bouwlaag, new.fotografie_id, false, new.label, new.opmerking, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
					COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN 
            UPDATE objecten.sleutelkluis SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, opmerking = new.opmerking, sleuteldoel = new.sleuteldoel, 
                    bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (sleutelkluis.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.naam = new.soort);

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'UPDATE', 'sleutelkluis', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, symbol_name, bouwlaag,
						new.fotografie_id, false, new.label, new.opmerking, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'sleutelkluis', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	    mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.sleutelkluis WHERE (sleutelkluis.id = old.id);
        ELSE
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, 'DELETE', 'sleutelkluis', OLD.id, OLD.bouwlaag_id, old.object_id, OLD.rotatie, OLD.symbol_name, bouwlaag, 
						OLD.fotografie_id, false, old.label, old.opmerking, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW IF EXISTS objecten.view_sleutelkluis_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.opmerking,
    d.sleuteldoel,
    d.rotatie,
    d.label,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    d.bouwlaag_id,
    CONCAT(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    CASE
        WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
        WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
        WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
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
     JOIN objecten.sleutelkluis d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.sleutelkluis_type st ON d.soort = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.view_sleutelkluis_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.opmerking,
    d.sleuteldoel,
    d.rotatie,
    d.label,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    d.object_id,
    CONCAT(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN d.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN d.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    d.label_positie,
    h2.typeobject
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.sleutelkluis d ON o.id = d.object_id
     JOIN objecten.sleutelkluis_type st ON d.soort = st.naam
    JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.veiligh_install RENAME COLUMN bijzonderheid TO opmerking;

DROP VIEW IF EXISTS objecten.bouwlaag_veiligh_install;
CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_install
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.soort,
    v.label,
    v.opmerking,
    v.bouwlaag_id,
    v.object_id,
    v.rotatie,
    v.fotografie_id,
    b.bouwlaag,
    CASE
	    WHEN v.formaat_bouwlaag = 'klein' THEN st.size_bouwlaag_klein
	    WHEN v.formaat_bouwlaag = 'middel' THEN st.size_bouwlaag_middel
	    WHEN v.formaat_bouwlaag = 'groot' THEN st.size_bouwlaag_groot
	END AS size,
    CONCAT(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    ''::text AS applicatie,
    v.label_positie,
	v.formaat_bouwlaag,
	v.formaat_object
   FROM objecten.veiligh_install v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type st ON v.soort = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;
CREATE TRIGGER veiligh_install_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_del('bouwlaag');
CREATE TRIGGER veiligh_install_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_ins('bouwlaag');
CREATE TRIGGER veiligh_install_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_upd('bouwlaag');

DROP VIEW IF EXISTS objecten.object_veiligh_install;
CREATE OR REPLACE VIEW objecten.object_veiligh_install
AS SELECT b.id,
    b.geom,
    b.soort,
    b.label,
    b.opmerking,
    b.fotografie_id,
    b.bouwlaag_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
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
	b.formaat_object,
	b.formaat_bouwlaag
   FROM objecten.veiligh_install b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.veiligh_install_type st ON b.soort = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER veiligh_ruimtelijk_del INSTEAD OF
DELETE
    ON
    objecten.object_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_del('object');
CREATE TRIGGER veiligh_ruimtelijk_ins INSTEAD OF
INSERT
    ON
    objecten.object_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_ins('object');
CREATE TRIGGER veiligh_ruimtelijk_upd INSTEAD OF
UPDATE
    ON
    objecten.object_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_upd('object');

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.veiligh_install (geom, soort, label, opmerking, rotatie, bouwlaag_id, object_id, fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
					COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        ELSE
            symbol_name := (SELECT vt.symbol_name FROM objecten.veiligh_install_type vt WHERE vt.naam = new.soort);

			IF bouwlaag_object = 'object'::text THEN
				objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
			ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
            	bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
				bouwlaag := new.bouwlaag;
			END IF;
            
            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, accepted, fotografie_id, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'INSERT', 'veiligh_install', NULL, bouwlaagid, objectid, NEW.rotatie, symbol_name, bouwlaag, false, new.fotografie_id, new.label, new.opmerking, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
					COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.veiligh_install SET geom = new.geom, soort = new.soort, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id,
					label = new.label, opmerking = new.opmerking, rotatie = new.rotatie, fotografie_id = new.fotografie_id, label_positie = new.label_positie, 
					formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (veiligh_install.id = new.id);
        ELSE
            symbol_name := (SELECT vt.symbol_name FROM objecten.veiligh_install_type vt WHERE vt.naam = new.soort);

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, accepted, bouwlaag, 
													fotografie_id, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'UPDATE', 'veiligh_install', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, symbol_name, false, bouwlaag, 
						new.fotografie_id, new.label, new.opmerking, new.label_positie, new.formaat_bouwlaag, new.formaat_object);
            
            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'veiligh_install', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;


CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN  
            DELETE FROM objecten.veiligh_install WHERE (veiligh_install.id = old.id);
        ELSE
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag,
					accepted, fotografie_id, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, 'DELETE', 'veiligh_install', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag,
					false, OLD.fotografie_id, old.label, old.opmerking, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW IF EXISTS objecten.view_veiligh_install;
CREATE OR REPLACE VIEW objecten.view_veiligh_install
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
    d.opmerking,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.symbol_name,
    CASE
        WHEN d.formaat_bouwlaag = 'klein' THEN dt.size_bouwlaag_klein
        WHEN d.formaat_bouwlaag = 'middel' THEN dt.size_bouwlaag_middel
        WHEN d.formaat_bouwlaag = 'groot' THEN dt.size_bouwlaag_groot
    END as size,
    o.share,
	d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.veiligh_install d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type dt ON d.soort = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.view_veiligh_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_veiligh_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.opmerking,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    CASE
        WHEN b.formaat_object = 'klein' THEN vt.size_object_klein
        WHEN b.formaat_object = 'middel' THEN vt.size_object_middel
        WHEN b.formaat_object = 'groot' THEN vt.size_object_groot
    END as size,
    o.share,
	b.label_positie,
    h2.typeobject
   FROM objecten.object o
     JOIN objecten.veiligh_install b ON o.id = b.object_id
     JOIN objecten.veiligh_install_type vt ON b.soort = vt.naam
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
    JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW objecten.object_objecten
AS SELECT DISTINCT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.basisreg_identifier,
    b.formelenaam,
    b.bijzonderheden,
    b.pers_max,
    b.pers_nietz_max,
    b.datum_geldig_tot,
    b.datum_geldig_vanaf,
    b.bron,
    b.bron_tabel,
    b.fotografie_id,
    b.bodemgesteldheid_type_id,
    b.min_bouwlaag,
    b.max_bouwlaag,
    part.typeobject,
    b.share,
    concat(ot.symbol_name, '_', ot.symbol_type) AS symbol_name,
    ot.size
   FROM objecten.object b
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
     LEFT JOIN objecten.object_type ot ON part.typeobject::text = ot.naam::text
  WHERE b.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.scenario_locatie RENAME COLUMN locatie TO opmerking;

DROP VIEW IF EXISTS objecten.bouwlaag_scenario_locatie;
CREATE OR REPLACE VIEW objecten.bouwlaag_scenario_locatie
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.opmerking,
    v.bouwlaag_id,
    v.object_id,
    v.fotografie_id,
    v.rotatie,
    b.bouwlaag,
    st.symbol_name,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    ''::text AS applicatie,
    v.label,
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object,
    v.soort
   FROM objecten.scenario_locatie v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.scenario_locatie_type st ON v.soort::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_scenario_locatie_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_ins('bouwlaag');
CREATE TRIGGER bouwlaag_scenario_locatie_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_del('bouwlaag');
CREATE TRIGGER bouwlaag_scenario_locatie_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_upd('bouwlaag');

DROP VIEW IF EXISTS objecten.object_scenario_locatie;
CREATE OR REPLACE VIEW objecten.object_scenario_locatie
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.opmerking,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
        CASE
            WHEN o.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN o.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN o.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    st.symbol_name,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    o.label,
    o.label_positie,
    o.formaat_object,
    o.formaat_bouwlaag,
    o.soort
   FROM objecten.scenario_locatie o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.scenario_locatie_type st ON o.soort = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.parent_deleted = 'infinity'::timestamp with time zone AND o.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_scenario_locatie_ins INSTEAD OF
INSERT
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_ins('object');
CREATE TRIGGER object_scenario_locatie_del INSTEAD OF
DELETE
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_del('object');
CREATE TRIGGER object_scenario_locatie_upd INSTEAD OF
UPDATE
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_upd('object');

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.scenario_locatie (geom, opmerking, bouwlaag_id, object_id, fotografie_id, rotatie, label, label_positie, soort, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.opmerking, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie, new.label, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition), new.soort,
					COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.scenario_locatie_type st WHERE st.naam = new.soort);

            IF bouwlaag_object = 'object'::text THEN
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object, opmerking)
            VALUES (new.geom, 'INSERT', 'scenario_locatie', NULL, bouwlaagid, objectid, NEW.rotatie, symbol_name, bouwlaag, new.fotografie_id, false, new.label, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
					COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat), new.opmerking);

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.scenario_locatie SET geom = new.geom, opmerking = new.opmerking, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id,
								label = new.label, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object, soort = new.soort
            WHERE (scenario_locatie.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.scenario_locatie_type st WHERE st.naam = new.soort);

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object, opmerking)
            VALUES (new.geom, 'UPDATE', 'scenario_locatie', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, symbol_name, bouwlaag, 
													new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object, new.opmerking);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'scenario_locatie', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.scenario_locatie WHERE (scenario_locatie.id = old.id);
        ELSE

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object, opmerking)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'scenario_locatie', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.symbol_name, bouwlaag, 
													old.fotografie_id, false, old.label, old.label_positie, old.formaat_bouwlaag, old.formaat_object, old.opmerking);
        END IF;
        RETURN OLD;
    END;
    $function$
;

ALTER TABLE objecten.scenario DROP CONSTRAINT scenario_type_id_fk;
ALTER TABLE objecten.scenario RENAME COLUMN scenario_type_id TO soort;

DROP VIEW IF EXISTS objecten.view_scenario_bouwlaag;
DROP VIEW IF EXISTS objecten.view_scenario_ruimtelijk;
DROP VIEW IF EXISTS objecten.mview_scenario_bouwlaag;
DROP VIEW IF EXISTS objecten.mview_scenario_ruimtelijk;

ALTER TABLE objecten.scenario ALTER COLUMN soort TYPE varchar(50);
UPDATE objecten.scenario SET soort = sub.naam
FROM 
(
	SELECT id::varchar, naam FROM objecten.scenario_type
) sub
WHERE soort = sub.id;

ALTER TABLE objecten.scenario_type ADD CONSTRAINT scenario_type_naam_uc UNIQUE (naam);
ALTER TABLE objecten.scenario ADD CONSTRAINT scenario_type_fk FOREIGN KEY (soort) REFERENCES objecten.scenario_type(naam) ON UPDATE CASCADE;

DROP VIEW IF EXISTS objecten.view_scenario_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_scenario_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.soort as locatie_type,
    d.omschrijving,
    d.soort,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.opmerking,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    slt.symbol_name,
        CASE
            WHEN op.formaat_bouwlaag = 'klein'::algemeen.formaat THEN slt.size_bouwlaag_klein
            WHEN op.formaat_bouwlaag = 'middel'::algemeen.formaat THEN slt.size_bouwlaag_middel
            WHEN op.formaat_bouwlaag = 'groot'::algemeen.formaat THEN slt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url,
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
     JOIN objecten.scenario_locatie op ON st_intersects(t.geom, op.geom)
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id
     JOIN objecten.scenario_locatie_type slt ON op.soort::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.soort = st.naam
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.view_scenario_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_scenario_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.soort AS locatie_type,
    d.omschrijving,
    d.soort,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.opmerking,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    slt.symbol_name,
    CASE
        WHEN op.formaat_object = 'klein'::algemeen.formaat THEN slt.size_object_klein
        WHEN op.formaat_object = 'middel'::algemeen.formaat THEN slt.size_object_middel
        WHEN op.formaat_object = 'groot'::algemeen.formaat THEN slt.size_object_groot
        ELSE NULL::numeric
    END AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url,
    o.share,
    op.label,
    op.label_positie,
    h2.typeobject
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.scenario_locatie op ON o.id = op.object_id
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id
     JOIN objecten.scenario_locatie_type slt ON op.soort::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.soort = st.naam
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
     JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.label ADD COLUMN opmerking text;
ALTER TABLE mobiel.werkvoorraad_label ADD COLUMN opmerking text;

DROP VIEW objecten.bouwlaag_label;
CREATE OR REPLACE VIEW objecten.bouwlaag_label
AS SELECT v.id,
    v.geom,
    v.soort,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    st.symbol_name,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    ''::text AS applicatie,
    v.formaat_object,
    v.formaat_bouwlaag,
    v.opmerking
   FROM objecten.label v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.label_type st ON v.soort::text = st.naam::text
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_label_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_del('bouwlaag');
CREATE TRIGGER bouwlaag_label_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_ins('bouwlaag');
CREATE TRIGGER bouwlaag_label_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_upd('bouwlaag');

DROP VIEW objecten.object_label;
CREATE OR REPLACE VIEW objecten.object_label
AS SELECT l.id,
    l.geom,
    l.soort,
    l.omschrijving,
    l.bouwlaag_id,
    l.object_id,
    b.formelenaam,
    l.rotatie,
    st.symbol_name,
        CASE
            WHEN l.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN l.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN l.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    l.formaat_object,
    l.formaat_bouwlaag,
    l.opmerking
   FROM objecten.label l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN objecten.label_type st ON l.soort::text = st.naam::text
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_label_del INSTEAD OF
DELETE
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_del('object');
CREATE TRIGGER object_label_ins INSTEAD OF
INSERT
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_ins('object');
CREATE TRIGGER object_label_upd INSTEAD OF
UPDATE
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_upd('object');

CREATE OR REPLACE FUNCTION objecten.func_label_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.label (geom, soort, omschrijving, rotatie, bouwlaag_id, object_id, opmerking, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id, new.object_id, new.opmerking,
					COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.label_type dt WHERE dt.naam = new.soort);

            IF bouwlaag_object = 'object'::text THEN
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_label (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, rotatie, symbol_name, bouwlaag, accepted, opmerking, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'INSERT', 'label', NULL, bouwlaagid, objectid, NEW.omschrijving, NEW.rotatie, symbol_name, bouwlaag, false, new.opmerking,
					COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_label_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id,
                    formaat_bouwlaag = new.formaat_bouwlaag, formaat_object = new.formaat_object, opmerking = new.opmerking
            WHERE (label.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.label_type dt WHERE dt.naam = new.soort);

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_label (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, rotatie, symbol_name, bouwlaag, accepted, opmerking, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'UPDATE', 'label', OLD.id, NEW.bouwlaag_id, NEW.object_id, NEW.omschrijving, NEW.rotatie, symbol_name, bouwlaag, false, new.opmerking, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'label', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_label_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.label WHERE (label.id = old.id);
        ELSE
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_label (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, rotatie, symbol_name, bouwlaag, accepted, opmerking, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, 'DELETE', 'label', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.omschrijving, OLD.rotatie, OLD.symbol_name, bouwlaag, false, old.opmerking, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW IF EXISTS objecten.view_label_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_label_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    concat(vt.prefix, d.omschrijving)::character varying(254) AS omschrijving,
    d.opmerking,
    d.soort,
    d.rotatie,
    d.bouwlaag_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vt.style_ids,
    CASE
        WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
        WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
        WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
        ELSE NULL::numeric
    END AS size,
    o.share
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone AND historie.self_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.label d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.label_type vt ON d.soort::text = vt.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.view_label_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_label_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    concat(vt.prefix, b.omschrijving)::character varying(254) AS omschrijving,
    b.opmerking,
    b.rotatie,
    b.bouwlaag_id,
    b.object_id,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    CASE
        WHEN b.formaat_object= 'klein'::algemeen.formaat THEN vt.size_object_klein
        WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
        WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
        ELSE NULL::numeric
    END AS size,
    vt.style_ids,
    o.share,
    h2.typeobject
   FROM objecten.object o
     JOIN objecten.label b ON o.id = b.object_id
     JOIN objecten.label_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone AND historie.self_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
    JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.bereikbaarheid ADD COLUMN opmerking text;
UPDATE objecten.bereikbaarheid SET opmerking = CONCAT(obstakels, CASE WHEN obstakels IS NOT NULL THEN CONCAT(CHR(13), CHR(10)) ELSE '' END, wegafzetting);
ALTER TABLE mobiel.werkvoorraad_lijn ADD COLUMN opmerking TEXT;

DROP VIEW objecten.object_bereikbaarheid;
CREATE OR REPLACE VIEW objecten.object_bereikbaarheid
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.opmerking,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    part.typeobject
   FROM objecten.bereikbaarheid l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bereikbaarheid_del INSTEAD OF
DELETE
    ON
    objecten.object_bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.func_bereikbaarheid_del();
CREATE TRIGGER bereikbaarheid_ins INSTEAD OF
INSERT
    ON
    objecten.object_bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.func_bereikbaarheid_ins();
CREATE TRIGGER bereikbaarheid_upd INSTEAD OF
UPDATE
    ON
    objecten.object_bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.func_bereikbaarheid_upd();

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.bereikbaarheid (geom, opmerking, soort, object_id, fotografie_id, label)
            VALUES (new.geom, new.opmerking, new.soort, new.object_id, new.fotografie_id, new.label);
        ELSE
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, opmerking, accepted)
            VALUES (new.geom, 'INSERT', 'bereikbaarheid', NULL, objectid, NEW.soort, new.fotografie_id, new.opmerking, false);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN 
            UPDATE objecten.bereikbaarheid SET geom = new.geom, opmerking = new.opmerking, soort = new.soort, object_id = new.object_id, fotografie_id = new.fotografie_id, label = new.label
            WHERE (bereikbaarheid.id = new.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, opmerking, accepted)
            VALUES (new.geom, 'UPDATE', 'bereikbaarheid', old.id, new.object_id, NEW.soort, new.fotografie_id, new.opmerking, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) 
                    VALUES (ST_MakeLine(ST_LineInterpolatePoint(ST_LineMerge(old.geom), 0.5), ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5)), old.id, 'bereikbaarheid');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.bereikbaarheid WHERE (bereikbaarheid.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, opmerking, accepted)
            VALUES (OLD.geom, 'DELETE', 'bereikbaarheid', OLD.id, OLD.object_id, OLD.soort, old.fotografie_id, old.opmerking, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW objecten.view_bereikbaarheid;
CREATE OR REPLACE VIEW objecten.view_bereikbaarheid
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.opmerking,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    o.formelenaam,
    st.style_ids,
    o.SHARE,
    h2.typeobject
   FROM objecten.object o
     JOIN objecten.bereikbaarheid b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.bereikbaarheid_type st ON b.soort::text = st.naam::TEXT
     JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.gebiedsgerichte_aanpak RENAME COLUMN bijzonderheden TO opmerking;

DROP VIEW objecten.object_gebiedsgerichte_aanpak;
CREATE OR REPLACE VIEW objecten.object_gebiedsgerichte_aanpak
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.opmerking,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot
   FROM objecten.gebiedsgerichte_aanpak l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER gebiedsgerichte_aanpak_del INSTEAD OF
DELETE
    ON
    objecten.object_gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.func_gebiedsgerichte_aanpak_del();
CREATE TRIGGER gebiedsgerichte_aanpak_ins INSTEAD OF
INSERT
    ON
    objecten.object_gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.func_gebiedsgerichte_aanpak_ins();
CREATE TRIGGER gebiedsgerichte_aanpak_upd INSTEAD OF
UPDATE
    ON
    objecten.object_gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.func_gebiedsgerichte_aanpak_upd();

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.gebiedsgerichte_aanpak (geom, soort, label, opmerking, object_id, fotografie_id)
            VALUES (new.geom, new.soort, new.label, new.opmerking, new.object_id, new.fotografie_id);
        ELSE
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted, opmerking)
            VALUES (new.geom, 'INSERT', 'gebiedsgerichte_aanpak', NULL, objectid, NEW.soort, new.fotografie_id, false, new.opmerking);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.gebiedsgerichte_aanpak SET geom = new.geom, soort = new.soort, label = new.label, opmerking = new.opmerking, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (gebiedsgerichte_aanpak.id = new.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted, opmerking)
            VALUES (new.geom, 'UPDATE', 'gebiedsgerichte_aanpak', old.id, new.object_id, NEW.soort, new.fotografie_id, false, new.opmerking);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) 
                    VALUES (ST_MakeLine(ST_LineInterpolatePoint(ST_LineMerge(old.geom), 0.5), ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5)), old.id, 'gebiedsgerichte_aanpak');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.gebiedsgerichte_aanpak WHERE (gebiedsgerichte_aanpak.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted, opmerking)
            VALUES (OLD.geom, 'DELETE', 'gebiedsgerichte_aanpak', OLD.id, OLD.object_id, OLD.soort, old.fotografie_id, false, old.opmerking);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW IF EXISTS objecten.view_gebiedsgerichte_aanpak;
CREATE OR REPLACE VIEW objecten.view_gebiedsgerichte_aanpak
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.opmerking,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    st.style_ids,
    o.SHARE,
    h2.typeobject
   FROM objecten.object o
     JOIN objecten.gebiedsgerichte_aanpak b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.gebiedsgerichte_aanpak_type st ON b.soort::text = st.naam::TEXT
     JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.isolijnen RENAME COLUMN omschrijving TO opmerking;

DROP VIEW objecten.object_isolijnen;
CREATE OR REPLACE VIEW objecten.object_isolijnen
AS SELECT l.id,
    l.geom,
    l.hoogte,
    l.opmerking,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.isolijnen l
     LEFT JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER isolijnen_del INSTEAD OF
DELETE
    ON
    objecten.object_isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.func_isolijnen_del();
CREATE TRIGGER isolijnen_ins INSTEAD OF
INSERT
    ON
    objecten.object_isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.func_isolijnen_ins();
CREATE TRIGGER isolijnen_upd INSTEAD OF
UPDATE
    ON
    objecten.object_isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.func_isolijnen_upd();

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.isolijnen (geom, hoogte, opmerking, object_id)
            VALUES (new.geom, new.hoogte, new.opmerking, new.object_id);
        ELSE
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, object_id, symbol_name, accepted, opmerking)
            VALUES (new.geom, 'INSERT', 'isolijnen', NULL, objectid, NEW.hoogte::text, false, new.opmerking);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN 
            UPDATE objecten.isolijnen SET geom = new.geom, hoogte = new.hoogte, opmerking = new.opmerking, object_id = new.object_id
            WHERE (isolijnen.id = new.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, object_id, symbol_name, accepted, opmerking)
            VALUES (new.geom, 'UPDATE', 'isolijnen', old.id, new.object_id, NEW.hoogte::text, false, new.opmerking);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) 
                    VALUES (ST_MakeLine(ST_LineInterpolatePoint(ST_LineMerge(old.geom), 0.5), ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5)), old.id, 'isolijnen');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.isolijnen WHERE (isolijnen.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, accepted, opmerking)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'isolijnen', OLD.id, OLD.object_id, OLD.hoogte::text, false, old.opmerking);
        END IF;
        RETURN OLD;
    END;
    $function$
;

ALTER TABLE objecten.veiligh_bouwk ADD COLUMN opmerking TEXT;

DROP VIEW objecten.bouwlaag_veiligh_bouwk;
CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_bouwk
AS SELECT v.id,
    v.geom,
    v.soort,
    v.fotografie_id,
    v.bouwlaag_id,
    v.opmerking,
    b.bouwlaag,
    ''::text AS applicatie
   FROM objecten.veiligh_bouwk v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER veiligh_bouwk_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_bouwk_del();
CREATE TRIGGER veiligh_bouwk_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_bouwk_ins();
CREATE TRIGGER veiligh_bouwk_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_bouwk_upd();

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.veiligh_bouwk (geom, soort, bouwlaag_id, fotografie_id, opmerking)
            VALUES (new.geom, new.soort, new.bouwlaag_id, new.fotografie_id, new.opmerking);
        ELSE
            bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.bouwlagen b 
                                                        WHERE b.bouwlaag = new.bouwlaag 
                                                        ORDER BY dist LIMIT 1) b);
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted, opmerking)
            VALUES (new.geom, 'INSERT', 'veiligh_bouwk', NULL, bouwlaagid, NEW.soort, new.bouwlaag, new.fotografie_id, false, new.opmerking);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	DECLARE
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.veiligh_bouwk SET geom = new.geom, soort = new.soort, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id, opmerking = new.opmerking
            WHERE (veiligh_bouwk.id = new.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted, opmerking)
            VALUES (new.geom, 'UPDATE', 'veiligh_bouwk', old.id, new.bouwlaag_id, NEW.soort, new.bouwlaag, new.fotografie_id, false, new.opmerking);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_LineInterpolatePoint(ST_LineMerge(old.geom), 0.5), ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5)), old.id, 'veiligh_bouwk', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	DECLARE
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.veiligh_bouwk WHERE (veiligh_bouwk.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted, opmerking)
            VALUES (OLD.geom, 'DELETE', 'veiligh_bouwk', OLD.id, OLD.bouwlaag_id, OLD.soort, OLD.bouwlaag, old.fotografie_id, false, old.opmerking);
        END IF;
        RETURN OLD;
    END;
    $function$
;

ALTER TABLE objecten.ruimten RENAME COLUMN omschrijving TO opmerking;
ALTER TABLE mobiel.werkvoorraad_vlak ADD COLUMN opmerking TEXT;

DROP VIEW IF EXISTS objecten.bouwlaag_ruimten;
CREATE OR REPLACE VIEW objecten.bouwlaag_ruimten
AS SELECT v.id,
    v.geom,
    v.soort,
    v.opmerking,
    v.fotografie_id,
    v.bouwlaag_id,
    b.bouwlaag,
    ''::text AS applicatie
   FROM objecten.ruimten v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER ruimten_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_ruimten FOR EACH ROW EXECUTE FUNCTION objecten.func_ruimten_del();
CREATE TRIGGER ruimten_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_ruimten FOR EACH ROW EXECUTE FUNCTION objecten.func_ruimten_ins();
CREATE TRIGGER ruimten_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_ruimten FOR EACH ROW EXECUTE FUNCTION objecten.func_ruimten_upd();

CREATE OR REPLACE FUNCTION objecten.func_ruimten_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.ruimten (geom, soort, opmerking, bouwlaag_id, fotografie_id)
            VALUES (new.geom, new.soort, new.opmerking, new.bouwlaag_id, new.fotografie_id);
        ELSE
            bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> ST_Centroid(new.geom) AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
            
            INSERT INTO mobiel.werkvoorraad_vlak (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted, opmerking)
            VALUES (new.geom, 'INSERT', 'ruimten', NULL, bouwlaagid, NEW.soort, new.bouwlaag, new.fotografie_id, false, new.opmerking);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.ruimten SET geom = new.geom, soort = new.soort, opmerking = new.opmerking, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
            WHERE (ruimten.id = new.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_vlak (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted, opmerking)
            VALUES (new.geom, 'UPDATE', 'ruimten', old.id, new.bouwlaag_id, NEW.soort, new.bouwlaag, new.fotografie_id, false, new.opmerking);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.id, 'ruimten', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.ruimten WHERE (ruimten.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_vlak (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted, opmerking)
            VALUES (OLD.geom, 'DELETE', 'ruimten', OLD.id, OLD.bouwlaag_id, OLD.soort, OLD.bouwlaag, old.fotografie_id, false, new.opmerking);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW IF EXISTS objecten.view_ruimten;
CREATE OR REPLACE VIEW objecten.view_ruimten
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.opmerking,
    d.bouwlaag_id,
    d.fotografie_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    st.style_ids,
    o.share
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.ruimten d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.ruimten_type st ON d.soort = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.sectoren RENAME COLUMN omschrijving TO opmerking;

DROP VIEW IF EXISTS objecten.object_sectoren;
CREATE OR REPLACE VIEW objecten.object_sectoren
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.opmerking,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.sectoren l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER sectoren_del INSTEAD OF
DELETE
    ON
    objecten.object_sectoren FOR EACH ROW EXECUTE FUNCTION objecten.func_sectoren_del();
CREATE TRIGGER sectoren_ins INSTEAD OF
INSERT
    ON
    objecten.object_sectoren FOR EACH ROW EXECUTE FUNCTION objecten.func_sectoren_ins();
CREATE TRIGGER sectoren_upd INSTEAD OF
UPDATE
    ON
    objecten.object_sectoren FOR EACH ROW EXECUTE FUNCTION objecten.func_sectoren_upd();

CREATE OR REPLACE FUNCTION objecten.func_sectoren_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.sectoren (geom, soort, opmerking, label, object_id, fotografie_id)
            VALUES (new.geom, new.soort, new.opmerking, new.label, new.object_id, new.fotografie_id);
        ELSE
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_Centroid(new.geom) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_vlak (geom, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted, opmerking)
            VALUES (new.geom, 'INSERT', 'sectoren', NULL, objectid, NEW.soort, new.fotografie_id, false, new.opmerking);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN 
            UPDATE objecten.sectoren SET geom = new.geom, soort = new.soort, opmerking = new.opmerking, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (sectoren.id = new.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_vlak (geom, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted, opmerking)
            VALUES (new.geom, 'UPDATE', 'sectoren', old.id, new.object_id, NEW.soort, new.fotografie_id, false, new.opmerking);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.id, 'sectoren');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.sectoren WHERE (sectoren.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_vlak (geom, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted, opmerking)
            VALUES (OLD.geom, 'DELETE', 'sectoren', OLD.id, OLD.object_id, OLD.soort, old.fotografie_id, false, new.opmerking);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW IF EXISTS objecten.view_sectoren;
CREATE OR REPLACE VIEW objecten.view_sectoren
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.opmerking,
    b.label,
    b.object_id,
    b.fotografie_id,
    b.soort,
    o.formelenaam,
    st.style_ids,
    o.SHARE,
    h2.typeobject
   FROM objecten.object o
     JOIN objecten.sectoren b ON o.id = b.object_id
     JOIN objecten.sectoren_type st ON b.soort::text = st.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 367; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
