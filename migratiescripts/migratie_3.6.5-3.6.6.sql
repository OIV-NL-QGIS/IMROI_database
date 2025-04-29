SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE objecten.sleutelkluis DROP CONSTRAINT sleutelkluis_ingang_id_fk;
ALTER TABLE objecten.sleutelkluis ADD COLUMN bouwlaag_id integer;
ALTER TABLE objecten.sleutelkluis ADD COLUMN object_id integer;

UPDATE objecten.sleutelkluis SET bouwlaag_id = sub.bouwlaag_id, parent_deleted = sub.parent_deleted
FROM
( 
	SELECT bouwlaag_id, id as ingang_id, parent_deleted FROM objecten.ingang WHERE bouwlaag_id IS NOT NULL
) sub
WHERE sleutelkluis.ingang_id = sub.ingang_id;

UPDATE objecten.sleutelkluis SET object_id = sub.object_id, parent_deleted = sub.parent_deleted
FROM
( 
	SELECT object_id, id as ingang_id, parent_deleted FROM objecten.ingang WHERE object_id IS NOT NULL
) sub
WHERE sleutelkluis.ingang_id = sub.ingang_id;

ALTER TABLE objecten.sleutelkluis ADD CONSTRAINT sleutelkluis_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES objecten.bouwlagen(id, self_deleted) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE objecten.sleutelkluis ADD CONSTRAINT sleutelkluis_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES objecten.object(id, self_deleted) ON UPDATE CASCADE ON DELETE CASCADE;

DROP VIEW objecten.bouwlaag_sleutelkluis;
CREATE OR REPLACE VIEW objecten.bouwlaag_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.sleutelkluis_type_id,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.fotografie_id,
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
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.sleutelkluis v
	 JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.sleutelkluis_type st ON v.sleutelkluis_type_id = st.id
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

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.sleutelkluis WHERE (sleutelkluis.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.aanduiding_locatie, old.sleuteldoel_type_id) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'sleutelkluis', OLD.id, OLD.bouwlaag_id, old.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, 
						OLD.fotografie_id, false, old.label, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer := NULL;
		bouwlaagid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, bouwlaag_id, object_id, 
												fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.sleutelkluis_type_id, new.label, new.rotatie, new.aanduiding_locatie, new.sleuteldoel_type_id, new.bouwlaag_id, new.object_id, 
						new.fotografie_id, new.label_positie, new.formaat_bouwlaag, new.formaat_object);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag = new.bouwlaag;
            ELSEIF bouwlaag_object = 'object'::text THEN
                size := (SELECT st."size_object" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, row_to_json(NEW.*), 'INSERT', 'sleutelkluis', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

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
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN 
            UPDATE objecten.sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, sleuteldoel_type_id = new.sleuteldoel_type_id, 
                    bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (sleutelkluis.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT st."size_object" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'UPDATE', 'sleutelkluis', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag,
						new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'sleutelkluis', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

DROP VIEW objecten.object_sleutelkluis;
CREATE OR REPLACE VIEW objecten.object_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.sleutelkluis_type_id,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    st.symbol_name,
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
     JOIN objecten.sleutelkluis_type st ON v.sleutelkluis_type_id = st.id
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

DROP VIEW objecten.view_sleutelkluis_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.sleutelkluis_type_id,
    d.aanduiding_locatie,
    d.sleuteldoel_type_id,
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
    dd.naam AS doel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size,
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
     JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     LEFT JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_sleutelkluis_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.sleutelkluis_type_id,
    d.aanduiding_locatie,
    d.sleuteldoel_type_id,
    d.rotatie,
    d.label,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    d.object_id,
    dd.naam AS doel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size_object AS size,
    o.share,
    d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.sleutelkluis d ON o.id = d.object_id
     JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     LEFT JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW mobiel.symbolen
AS SELECT concat(sub.brontabel, '_', sub.id::character varying) AS id,
    sub.geom,
    sub.waarden_new,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.rotatie,
    sub.size,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.binnen_buiten,
    sub.id AS orig_id,
    sub.datum_aangemaakt,
    sub.datum_gewijzigd,
    sub.label,
    sub.label_positie,
    sub.formaat
   FROM ( SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.bijzonderheid) d)) AS waarden_new,
            ''::character varying AS operatie,
            'veiligh_install'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag AS formaat
           FROM objecten.veiligh_install v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.veiligh_install_type vt ON v.veiligh_install_type_id = vt.id
          WHERE v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.bijzonderheid) d)) AS waarden_new,
            ''::character varying AS operatie,
            'veiligh_ruimtelijk'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.veiligh_ruimtelijk v
             JOIN objecten.veiligh_ruimtelijk_type vt ON v.veiligh_ruimtelijk_type_id = vt.id
          WHERE v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.omschrijving) d)) AS waarden_new,
            ''::character varying AS operatie,
            'dreiging'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag
           FROM objecten.dreiging v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.dreiging_type vt ON v.dreiging_type_id = vt.id
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.omschrijving) d)) AS waarden_new,
            ''::character varying AS operatie,
            'dreiging'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.dreiging v
             JOIN objecten.dreiging_type vt ON v.dreiging_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.toelichting AS handelingsaanwijzing) d)) AS waarden_new,
            ''::character varying AS operatie,
            'afw_binnendekking'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag
           FROM objecten.afw_binnendekking v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.afw_binnendekking_type vt ON v.soort::text = vt.naam::text
          WHERE v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.belemmering,
                            v.voorzieningen) d)) AS waarden_new,
            ''::character varying AS operatie,
            'ingang'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag
           FROM objecten.ingang v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.ingang_type vt ON v.ingang_type_id = vt.id
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.belemmering,
                            v.voorzieningen) d)) AS waarden_new,
            ''::character varying AS operatie,
            'ingang'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.ingang v
             JOIN objecten.ingang_type vt ON v.ingang_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            NULL::json AS waarden_new,
            ''::character varying AS operatie,
            'opstelplaats'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.opstelplaats v
             JOIN objecten.opstelplaats_type vt ON v.soort::text = vt.naam::text
          WHERE v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.aanduiding_locatie) d)) AS waarden_new,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag
           FROM objecten.sleutelkluis v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.aanduiding_locatie) d)) AS waarden_new,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.sleutelkluis v
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.bijzonderheid) d)) AS waarden_new,
            ''::character varying AS operatie,
            'points_of_interest'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.points_of_interest v
             JOIN objecten.points_of_interest_type vt ON v.points_of_interest_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT werkvoorraad_punt.id,
            werkvoorraad_punt.geom,
            werkvoorraad_punt.waarden_new,
            werkvoorraad_punt.operatie,
            'werkvoorraad'::character varying AS brontabel,
            werkvoorraad_punt.bron_id,
            werkvoorraad_punt.object_id,
            werkvoorraad_punt.bouwlaag_id,
            werkvoorraad_punt.rotatie,
            werkvoorraad_punt.size,
            werkvoorraad_punt.symbol_name,
            werkvoorraad_punt.bouwlaag,
            ''::text AS binnen_buiten,
            'werkvoorraad'::text AS bron,
            werkvoorraad_punt.datum_aangemaakt,
            werkvoorraad_punt.datum_gewijzigd,
            werkvoorraad_punt.label,
            werkvoorraad_punt.label_positie,
            werkvoorraad_punt.formaat_bouwlaag AS formaat
           FROM mobiel.werkvoorraad_punt) sub;

ALTER TABLE objecten.sleutelkluis DROP COLUMN ingang_id;

ALTER TABLE mobiel.werkvoorraad_punt ADD COLUMN formaat_bouwlaag algemeen.formaat;
ALTER TABLE mobiel.werkvoorraad_punt ADD COLUMN formaat_object algemeen.formaat;
UPDATE mobiel.werkvoorraad_punt SET formaat_bouwlaag = 'middel' WHERE bouwlaag_id IS NOT NULL;
UPDATE mobiel.werkvoorraad_punt SET formaat_object = 'middel' WHERE object_id IS NOT NULL;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 6;
UPDATE algemeen.applicatie SET db_versie = 366; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
