SET ROLE oiv_admin;

ALTER TABLE algemeen.teamlid ALTER COLUMN id TYPE int USING id::int;

UPDATE objecten.bereikbaarheid SET geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 2)) WHERE geom IS NOT NULL AND NOT ST_IsValid(geom);
UPDATE objecten.bouwlagen SET geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 3)) WHERE geom IS NOT NULL AND NOT ST_IsValid(geom);
UPDATE objecten.gebiedsgerichte_aanpak SET geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 2)) WHERE geom IS NOT NULL AND NOT ST_IsValid(geom);
UPDATE objecten.isolijnen SET geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 2)) WHERE geom IS NOT NULL AND NOT ST_IsValid(geom);
UPDATE objecten.ruimten SET geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 3)) WHERE geom IS NOT NULL AND NOT ST_IsValid(geom);
UPDATE objecten.sectoren SET geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 3)) WHERE geom IS NOT NULL AND NOT ST_IsValid(geom);
UPDATE objecten.terrein SET geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 3)) WHERE geom IS NOT NULL AND NOT ST_IsValid(geom);
UPDATE objecten.veiligh_bouwk SET geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(geom), 2)) WHERE geom IS NOT NULL AND NOT ST_IsValid(geom);

ALTER TABLE objecten.bereikbaarheid ADD CONSTRAINT enforce_valid_geom CHECK (ST_IsValid(geom));
ALTER TABLE objecten.bouwlagen ADD CONSTRAINT enforce_valid_geom CHECK (ST_IsValid(geom));
ALTER TABLE objecten.gebiedsgerichte_aanpak ADD CONSTRAINT enforce_valid_geom CHECK (ST_IsValid(geom));
ALTER TABLE objecten.isolijnen ADD CONSTRAINT enforce_valid_geom CHECK (ST_IsValid(geom));
ALTER TABLE objecten.ruimten ADD CONSTRAINT enforce_valid_geom CHECK (ST_IsValid(geom));
ALTER TABLE objecten.sectoren ADD CONSTRAINT enforce_valid_geom CHECK (ST_IsValid(geom));
ALTER TABLE objecten.terrein ADD CONSTRAINT enforce_valid_geom CHECK (ST_IsValid(geom));
ALTER TABLE objecten.veiligh_bouwk ADD CONSTRAINT enforce_valid_geom CHECK (ST_IsValid(geom));

ALTER TABLE objecten.bouwlagen RENAME TO verdiepingen;
ALTER TABLE objecten.verdiepingen RENAME COLUMN bouwlaag TO verdieping;
ALTER SEQUENCE objecten.bouwlagen_id_seq RENAME TO verdiepingen_id_seq;
UPDATE objecten.verdiepingen SET verdieping = verdieping - 1 WHERE verdieping > 0;

ALTER TABLE objecten.object RENAME COLUMN min_bouwlaag TO min_verdieping;
ALTER TABLE objecten.object RENAME COLUMN max_bouwlaag TO max_verdieping;
UPDATE objecten.object SET min_verdieping = min_verdieping - 1 WHERE min_verdieping > 0;
UPDATE objecten.object SET max_verdieping = max_verdieping - 1 WHERE max_verdieping > 0;

ALTER TABLE mobiel_sync.werkvoorraad_label RENAME COLUMN bouwlaag TO verdieping;
ALTER TABLE mobiel_sync.werkvoorraad_label RENAME COLUMN bouwlaag_id TO verdieping_id;
UPDATE mobiel_sync.werkvoorraad_label SET verdieping = verdieping - 1 WHERE verdieping > 0;

ALTER TABLE mobiel_sync.werkvoorraad_lijn RENAME COLUMN bouwlaag TO verdieping;
ALTER TABLE mobiel_sync.werkvoorraad_lijn RENAME COLUMN bouwlaag_id TO verdieping_id;
UPDATE mobiel_sync.werkvoorraad_lijn SET verdieping = verdieping - 1 WHERE verdieping > 0;

ALTER TABLE mobiel_sync.werkvoorraad_symbool RENAME COLUMN bouwlaag TO verdieping;
ALTER TABLE mobiel_sync.werkvoorraad_symbool RENAME COLUMN bouwlaag_id TO verdieping_id;
UPDATE mobiel_sync.werkvoorraad_symbool SET verdieping = verdieping - 1 WHERE verdieping > 0;

ALTER TABLE mobiel_sync.werkvoorraad_vlak RENAME COLUMN bouwlaag TO verdieping;
ALTER TABLE mobiel_sync.werkvoorraad_vlak RENAME COLUMN bouwlaag_id TO verdieping_id;
UPDATE mobiel_sync.werkvoorraad_vlak SET verdieping = verdieping - 1 WHERE verdieping > 0;

DROP VIEW mobiel_sync.annotaties;

ALTER TABLE mobiel.annotaties RENAME COLUMN bouwlaag TO verdieping;
UPDATE mobiel.annotaties SET verdieping = verdieping - 1 WHERE verdieping > 0;

CREATE OR REPLACE VIEW mobiel_sync.annotaties
AS SELECT annotaties.id,
    annotaties.geom,
    annotaties.tekst,
    annotaties.plaatsing,
    annotaties.modified_at,
    annotaties.modified_by,
    annotaties.verdieping,
    annotaties.bouwlaag_object,
    (mobiel_sync.bepaal_koppeling(annotaties.geom, annotaties.bouwlaag_object::text, annotaties.verdieping)).bouwlaag_id AS verdieping_id,
    (mobiel_sync.bepaal_koppeling(annotaties.geom, annotaties.bouwlaag_object::text, annotaties.verdieping)).object_id AS object_id,
    ''::text AS operatie,
    'Annotatie'::text AS soort,
    'annotatie'::text AS brontabel,
    'OPEN'::text AS status
   FROM mobiel.annotaties;

DROP VIEW mobiel_sync.werkvoorraad_hulplijnen;
CREATE OR REPLACE VIEW mobiel_sync.werkvoorraad_hulplijnen
AS SELECT sub.id,
    sub.objecttype,
    sub.werkvoorraad_id,
    sub.geom,
    sub.verdieping_id,
    sub.object_id,
    sub.verdieping
   FROM ( SELECT 'symbool_'::text || w.id AS id,
            'symbool'::text AS objecttype,
            w.id AS werkvoorraad_id,
            mobiel_sync.bepaal_hulplijn(s.geom, w.geom) AS geom,
            w.verdieping_id,
            w.object_id,
            w.verdieping
           FROM mobiel_sync.werkvoorraad_symbool w
             JOIN mobiel_sync.symbolen_source s ON s.brontabel::text = w.brontabel::text AND s.bron_id = w.bron_id
          WHERE w.operatie::text = 'UPDATE'::text
        UNION ALL
         SELECT 'lijn_'::text || w.id AS id,
            'lijn'::text AS objecttype,
            w.id AS werkvoorraad_id,
            mobiel_sync.bepaal_hulplijn(s.geom, w.geom) AS geom,
            w.verdieping_id,
            w.object_id,
            w.verdieping
           FROM mobiel_sync.werkvoorraad_lijn w
             JOIN mobiel_sync.lijnen_source s ON s.brontabel::text = w.brontabel::text AND s.bron_id = w.bron_id
          WHERE w.operatie::text = 'UPDATE'::text
        UNION ALL
         SELECT 'vlak_'::text || w.id AS id,
            'vlak'::text AS objecttype,
            w.id AS werkvoorraad_id,
            mobiel_sync.bepaal_hulplijn(s.geom, w.geom) AS geom,
            w.verdieping_id,
            w.object_id,
            w.verdieping
           FROM mobiel_sync.werkvoorraad_vlak w
             JOIN mobiel_sync.vlakken_source s ON s.brontabel::text = w.brontabel::text AND s.bron_id = w.bron_id
          WHERE w.operatie::text = 'UPDATE'::text
        UNION ALL
         SELECT 'label_'::text || w.id AS id,
            'label'::text AS objecttype,
            w.id AS werkvoorraad_id,
            mobiel_sync.bepaal_hulplijn(s.geom, w.geom) AS geom,
            w.verdieping_id,
            w.object_id,
            w.verdieping
           FROM mobiel_sync.werkvoorraad_label w
             JOIN mobiel_sync.labels_source s ON s.brontabel::text = w.brontabel::text AND s.bron_id = w.bron_id
          WHERE w.operatie::text = 'UPDATE'::text) sub
  WHERE sub.geom IS NOT NULL;

CREATE OR REPLACE VIEW objecten.verdieping_verdiepingen
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.verdieping,
    b.bouwdeel,
    b.pand_id,
    b.self_deleted
   FROM objecten.verdiepingen b
  WHERE b.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE FUNCTION objecten.func_verdiepingen_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.verdiepingen (geom, verdieping, bouwdeel, pand_id)
        VALUES (ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 3)), NEW.verdieping, NEW.bouwdeel, NEW.pand_id)
        RETURNING id INTO NEW.id;
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.verdiepingen
        SET geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 3)), verdieping = NEW.verdieping,
            bouwdeel = NEW.bouwdeel, pand_id = NEW.pand_id
        WHERE id = NEW.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.verdiepingen WHERE id = OLD.id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;

CREATE TRIGGER verdiepingen_ins
INSTEAD OF INSERT ON objecten.verdieping_verdiepingen
FOR EACH ROW
EXECUTE FUNCTION objecten.func_verdiepingen_sync();

CREATE TRIGGER verdiepingen_upd
INSTEAD OF UPDATE ON objecten.verdieping_verdiepingen
FOR EACH ROW
EXECUTE FUNCTION objecten.func_verdiepingen_sync();

CREATE TRIGGER verdiepingen_del
INSTEAD OF DELETE ON objecten.verdieping_verdiepingen
FOR EACH ROW
EXECUTE FUNCTION objecten.func_verdiepingen_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_bouwlagen;

ALTER TABLE objecten.afw_binnendekking RENAME COLUMN bouwlaag_id TO verdieping_id;
ALTER TABLE objecten.afw_binnendekking RENAME COLUMN formaat_bouwlaag TO formaat_verdieping;
ALTER TABLE objecten.afw_binnendekking_type RENAME COLUMN size_bouwlaag_klein TO size_verdieping_klein;
ALTER TABLE objecten.afw_binnendekking_type RENAME COLUMN size_bouwlaag_middel TO size_verdieping_middel;
ALTER TABLE objecten.afw_binnendekking_type RENAME COLUMN size_bouwlaag_groot TO size_verdieping_groot;

CREATE OR REPLACE VIEW objecten.verdieping_afw_binnendekking
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.verdieping_id,
    b.verdieping,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_verdieping = 'klein'::algemeen.formaat THEN st.size_verdieping_klein
            WHEN v.formaat_verdieping = 'middel'::algemeen.formaat THEN st.size_verdieping_middel
            WHEN v.formaat_verdieping = 'groot'::algemeen.formaat THEN st.size_verdieping_groot
            ELSE NULL::numeric
        END AS size,
    v.label_positie,
    v.formaat_verdieping
   FROM objecten.afw_binnendekking v
     JOIN objecten.verdiepingen b ON v.verdieping_id = b.id
     JOIN objecten.afw_binnendekking_type st ON v.soort::text = st.naam::text
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN

        INSERT INTO objecten.afw_binnendekking (geom, soort, label, rotatie, opmerking, verdieping_id, label_positie, formaat_verdieping)
        VALUES (
            NEW.geom,
            NEW.soort,
            NEW.label,
            NEW.rotatie,
            NEW.opmerking,
            NEW.verdieping_id,
            COALESCE(NEW.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(NEW.formaat_verdieping, 'middel'::algemeen.formaat)
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.afw_binnendekking
        SET
            geom = NEW.geom,
            soort = NEW.soort,
            rotatie = NEW.rotatie,
            label = NEW.label,
            opmerking = NEW.opmerking,
            verdieping_id = NEW.verdieping_id,
            label_positie = NEW.label_positie,
            formaat_verdieping = NEW.formaat_verdieping
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM objecten.afw_binnendekking
        WHERE id = OLD.id;

        RETURN OLD;

    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER afw_binnendekking_del INSTEAD OF
DELETE
    ON
    objecten.verdieping_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_sync();
CREATE TRIGGER afw_binnendekking_ins INSTEAD OF
INSERT
    ON
    objecten.verdieping_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_sync();
CREATE TRIGGER afw_binnendekking_upd INSTEAD OF
UPDATE
    ON
    objecten.verdieping_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_afw_binnendekking;
DROP FUNCTION IF EXISTS objecten.func_afw_binnendekking_del;
DROP FUNCTION IF EXISTS objecten.func_afw_binnendekking_ins;
DROP FUNCTION IF EXISTS objecten.func_afw_binnendekking_upd;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.bereikbaarheid (
            geom,
            opmerking,
            soort,
            object_id,
            fotografie_id,
            label
        )
        VALUES (
            ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 2)),
            NEW.opmerking,
            NEW.soort,
            NEW.object_id,
            NEW.fotografie_id,
            NEW.label
        );
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.bereikbaarheid
        SET
            geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 2)),
            opmerking = NEW.opmerking,
            soort = NEW.soort,
            object_id = NEW.object_id,
            fotografie_id = NEW.fotografie_id,
            label = NEW.label
        WHERE id = OLD.id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.bereikbaarheid
        WHERE id = OLD.id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$function$;

DROP TRIGGER IF EXISTS bereikbaarheid_del ON objecten.object_bereikbaarheid;
DROP TRIGGER IF EXISTS bereikbaarheid_ins ON objecten.object_bereikbaarheid;
DROP TRIGGER IF EXISTS bereikbaarheid_upd ON objecten.object_bereikbaarheid;

DROP FUNCTION objecten.func_bereikbaarheid_del();
DROP FUNCTION objecten.func_bereikbaarheid_ins();
DROP FUNCTION objecten.func_bereikbaarheid_upd();

CREATE TRIGGER bereikbaarheid_del INSTEAD OF
DELETE
    ON
    objecten.object_bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.func_bereikbaarheid_sync();

CREATE TRIGGER bereikbaarheid_ins INSTEAD OF
INSERT
    ON
    objecten.object_bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.func_bereikbaarheid_sync();

CREATE TRIGGER bereikbaarheid_upd INSTEAD OF
UPDATE
    ON
    objecten.object_bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.func_bereikbaarheid_sync();


ALTER TABLE objecten.dreiging RENAME COLUMN bouwlaag_id TO verdieping_id;
ALTER TABLE objecten.dreiging RENAME COLUMN formaat_bouwlaag TO formaat_verdieping;
ALTER TABLE objecten.dreiging_type RENAME COLUMN size_bouwlaag_klein TO size_verdieping_klein;
ALTER TABLE objecten.dreiging_type RENAME COLUMN size_bouwlaag_middel TO size_verdieping_middel;
ALTER TABLE objecten.dreiging_type RENAME COLUMN size_bouwlaag_groot TO size_verdieping_groot;

CREATE OR REPLACE VIEW objecten.verdieping_dreiging AS
SELECT
    v.id,
    v.geom,
    v.soort,
    v.label,
    v.fotografie_id,
    v.opmerking,
    v.verdieping_id,
    v.object_id,
    b.verdieping,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    CASE
        WHEN v.formaat_verdieping = 'klein'::algemeen.formaat THEN st.size_verdieping_klein
        WHEN v.formaat_verdieping = 'middel'::algemeen.formaat THEN st.size_verdieping_middel
        WHEN v.formaat_verdieping = 'groot'::algemeen.formaat THEN st.size_verdieping_groot
        ELSE NULL::numeric
    END AS size,
    v.label_positie,
    v.formaat_verdieping,
    v.formaat_object
FROM objecten.dreiging v
JOIN objecten.verdiepingen b ON v.verdieping_id = b.id
JOIN objecten.dreiging_type st ON v.soort::text = st.naam
WHERE
    v.parent_deleted = 'infinity'::timestamp with time zone
    AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN

        INSERT INTO objecten.dreiging (
            geom,
            soort,
            label,
            opmerking,
            rotatie,
            verdieping_id,
            object_id,
            fotografie_id,
            label_positie,
            formaat_verdieping,
            formaat_object
        )
        VALUES (
            NEW.geom,
            NEW.soort,
            NEW.label,
            NEW.opmerking,
            NEW.rotatie,
            NEW.verdieping_id,
            NEW.object_id,
            NEW.fotografie_id,
            COALESCE(NEW.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(NEW.formaat_verdieping, 'middel'::algemeen.formaat),
            COALESCE(NEW.formaat_object, 'middel'::algemeen.formaat)
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        UPDATE objecten.dreiging
        SET
            geom = NEW.geom,
            soort = NEW.soort,
            opmerking = NEW.opmerking,
            rotatie = NEW.rotatie,
            label = NEW.label,
            verdieping_id = NEW.verdieping_id,
            object_id = NEW.object_id,
            fotografie_id = NEW.fotografie_id,
            label_positie = NEW.label_positie,
            formaat_verdieping = NEW.formaat_verdieping,
            formaat_object = NEW.formaat_object
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM objecten.dreiging
        WHERE id = OLD.id;

        RETURN OLD;

    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER verdieping_dreiging_ins
INSTEAD OF INSERT ON objecten.verdieping_dreiging
FOR EACH ROW
EXECUTE FUNCTION objecten.func_dreiging_sync();

CREATE TRIGGER verdieping_dreiging_upd
INSTEAD OF UPDATE ON objecten.verdieping_dreiging
FOR EACH ROW
EXECUTE FUNCTION objecten.func_dreiging_sync();

CREATE TRIGGER verdieping_dreiging_del
INSTEAD OF DELETE ON objecten.verdieping_dreiging
FOR EACH ROW
EXECUTE FUNCTION objecten.func_dreiging_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_dreiging;

DROP TRIGGER IF EXISTS object_dreiging_del ON objecten.object_dreiging;
DROP TRIGGER IF EXISTS object_dreiging_upd ON objecten.object_dreiging;
DROP TRIGGER IF EXISTS object_dreiging_ins ON objecten.object_dreiging;

CREATE TRIGGER object_dreiging_ins
INSTEAD OF INSERT ON objecten.object_dreiging
FOR EACH ROW
EXECUTE FUNCTION objecten.func_dreiging_sync();

CREATE TRIGGER object_dreiging_upd
INSTEAD OF UPDATE ON objecten.object_dreiging
FOR EACH ROW
EXECUTE FUNCTION objecten.func_dreiging_sync();

CREATE TRIGGER object_dreiging_del
INSTEAD OF DELETE ON objecten.object_dreiging
FOR EACH ROW
EXECUTE FUNCTION objecten.func_dreiging_sync();

DROP FUNCTION IF EXISTS objecten.func_dreiging_del;
DROP FUNCTION IF EXISTS objecten.func_dreiging_ins;
DROP FUNCTION IF EXISTS objecten.func_dreiging_upd;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN

        INSERT INTO objecten.gebiedsgerichte_aanpak (
            geom,
            soort,
            label,
            opmerking,
            object_id,
            fotografie_id
        )
        VALUES (
            ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 2)),
            NEW.soort,
            NEW.label,
            NEW.opmerking,
            NEW.object_id,
            NEW.fotografie_id
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        UPDATE objecten.gebiedsgerichte_aanpak
        SET
            geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 2)),
            soort = NEW.soort,
            label = NEW.label,
            opmerking = NEW.opmerking,
            object_id = NEW.object_id,
            fotografie_id = NEW.fotografie_id
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM objecten.gebiedsgerichte_aanpak
        WHERE id = OLD.id;

        RETURN OLD;

    END IF;

    RETURN NULL;
END;
$function$;

DROP TRIGGER IF EXISTS gebiedsgerichte_aanpak_del ON objecten.object_gebiedsgerichte_aanpak;
DROP TRIGGER IF EXISTS gebiedsgerichte_aanpak_ins ON objecten.object_gebiedsgerichte_aanpak;
DROP TRIGGER IF EXISTS gebiedsgerichte_aanpak_upd ON objecten.object_gebiedsgerichte_aanpak;

DROP FUNCTION objecten.func_gebiedsgerichte_aanpak_del();
DROP FUNCTION objecten.func_gebiedsgerichte_aanpak_ins();
DROP FUNCTION objecten.func_gebiedsgerichte_aanpak_upd();

CREATE TRIGGER gebiedsgerichte_aanpak_del INSTEAD OF
DELETE
    ON
    objecten.object_gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.func_gebiedsgerichte_aanpak_sync();

CREATE TRIGGER gebiedsgerichte_aanpak_ins INSTEAD OF
INSERT
    ON
    objecten.object_gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.func_gebiedsgerichte_aanpak_sync();

CREATE TRIGGER gebiedsgerichte_aanpak_upd INSTEAD OF
UPDATE
    ON
    objecten.object_gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.func_gebiedsgerichte_aanpak_sync();

ALTER TABLE objecten.ingang RENAME COLUMN bouwlaag_id TO verdieping_id;
ALTER TABLE objecten.ingang RENAME COLUMN formaat_bouwlaag TO formaat_verdieping;
ALTER TABLE objecten.ingang_type RENAME COLUMN size_bouwlaag_klein TO size_verdieping_klein;
ALTER TABLE objecten.ingang_type RENAME COLUMN size_bouwlaag_middel TO size_verdieping_middel;
ALTER TABLE objecten.ingang_type RENAME COLUMN size_bouwlaag_groot TO size_verdieping_groot;

CREATE OR REPLACE VIEW objecten.verdieping_ingang AS
SELECT
    v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.fotografie_id,
    v.verdieping_id,
    v.object_id,
    b.verdieping,
    v.rotatie,
    concat_ws('_'::text, st.symbol_name, st.symbol_type) AS symbol_name,
    CASE
        WHEN v.formaat_verdieping = 'klein'::algemeen.formaat THEN st.size_verdieping_klein
        WHEN v.formaat_verdieping = 'middel'::algemeen.formaat THEN st.size_verdieping_middel
        WHEN v.formaat_verdieping = 'groot'::algemeen.formaat THEN st.size_verdieping_groot
        ELSE NULL::numeric
    END AS size,
    v.label_positie,
    v.formaat_verdieping,
    v.formaat_object
FROM objecten.ingang v
JOIN objecten.verdiepingen b ON v.verdieping_id = b.id
JOIN objecten.ingang_type st ON v.soort::text = st.naam
WHERE
    v.parent_deleted = 'infinity'::timestamp with time zone
    AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE OR REPLACE FUNCTION objecten.func_ingang_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN

        INSERT INTO objecten.ingang (
            geom,
            soort,
            label,
            opmerking,
            rotatie,
            verdieping_id,
            object_id,
            fotografie_id,
            label_positie,
            formaat_verdieping,
            formaat_object
        )
        VALUES (
            NEW.geom,
            NEW.soort,
            NEW.label,
            NEW.opmerking,
            NEW.rotatie,
            NEW.verdieping_id,
            NEW.object_id,
            NEW.fotografie_id,
            COALESCE(NEW.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(NEW.formaat_verdieping, 'middel'::algemeen.formaat),
            COALESCE(NEW.formaat_object, 'middel'::algemeen.formaat)
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        UPDATE objecten.ingang
        SET
            geom = NEW.geom,
            soort = NEW.soort,
            rotatie = NEW.rotatie,
            label = NEW.label,
            opmerking = NEW.opmerking,
            verdieping_id = NEW.verdieping_id,
            object_id = NEW.object_id,
            fotografie_id = NEW.fotografie_id,
            label_positie = NEW.label_positie,
            formaat_verdieping = NEW.formaat_verdieping,
            formaat_object = NEW.formaat_object
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM objecten.ingang
        WHERE id = OLD.id;

        RETURN OLD;

    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER verdieping_ingang_ins
INSTEAD OF INSERT ON objecten.verdieping_ingang
FOR EACH ROW
EXECUTE FUNCTION objecten.func_ingang_sync();

CREATE TRIGGER verdieping_ingang_upd
INSTEAD OF UPDATE ON objecten.verdieping_ingang
FOR EACH ROW
EXECUTE FUNCTION objecten.func_ingang_sync();

CREATE TRIGGER verdieping_ingang_del
INSTEAD OF DELETE ON objecten.verdieping_ingang
FOR EACH ROW
EXECUTE FUNCTION objecten.func_ingang_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_ingang;

DROP TRIGGER IF EXISTS object_ingang_del ON objecten.object_ingang;
DROP TRIGGER IF EXISTS object_ingang_upd ON objecten.object_ingang;
DROP TRIGGER IF EXISTS object_ingang_ins ON objecten.object_ingang;

CREATE TRIGGER object_ingang_ins
INSTEAD OF INSERT ON objecten.object_ingang
FOR EACH ROW
EXECUTE FUNCTION objecten.func_ingang_sync();

CREATE TRIGGER object_ingang_upd
INSTEAD OF UPDATE ON objecten.object_ingang
FOR EACH ROW
EXECUTE FUNCTION objecten.func_ingang_sync();

CREATE TRIGGER object_ingang_del
INSTEAD OF DELETE ON objecten.object_ingang
FOR EACH ROW
EXECUTE FUNCTION objecten.func_ingang_sync();

DROP FUNCTION IF EXISTS objecten.func_ingang_del;
DROP FUNCTION IF EXISTS objecten.func_ingang_ins;
DROP FUNCTION IF EXISTS objecten.func_ingang_upd;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN

        INSERT INTO objecten.isolijnen (
            geom,
            hoogte,
            opmerking,
            object_id
        )
        VALUES (
            ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 2)),
            NEW.hoogte,
            NEW.opmerking,
            NEW.object_id
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        UPDATE objecten.isolijnen
        SET
            geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 2)),
            hoogte = NEW.hoogte,
            opmerking = NEW.opmerking,
            object_id = NEW.object_id
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM objecten.isolijnen
        WHERE id = OLD.id;

        RETURN OLD;

    END IF;

    RETURN NULL;
END;
$function$;

DROP TRIGGER IF EXISTS isolijnen_del ON objecten.object_isolijnen;
DROP TRIGGER IF EXISTS isolijnen_ins ON objecten.object_isolijnen;
DROP TRIGGER IF EXISTS isolijnen_upd ON objecten.object_isolijnen;

DROP FUNCTION objecten.func_isolijnen_del();
DROP FUNCTION objecten.func_isolijnen_ins();
DROP FUNCTION objecten.func_isolijnen_upd();

CREATE TRIGGER isolijnen_del INSTEAD OF
DELETE
    ON
    objecten.object_isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.func_isolijnen_sync();

CREATE TRIGGER isolijnen_ins INSTEAD OF
INSERT
    ON
    objecten.object_isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.func_isolijnen_sync();

CREATE TRIGGER isolijnen_upd INSTEAD OF
UPDATE
    ON
    objecten.object_isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.func_isolijnen_sync();

ALTER TABLE objecten.label RENAME COLUMN bouwlaag_id TO verdieping_id;
ALTER TABLE objecten.label RENAME COLUMN formaat_bouwlaag TO formaat_verdieping;
ALTER TABLE objecten.label_type RENAME COLUMN size_bouwlaag_klein TO size_verdieping_klein;
ALTER TABLE objecten.label_type RENAME COLUMN size_bouwlaag_middel TO size_verdieping_middel;
ALTER TABLE objecten.label_type RENAME COLUMN size_bouwlaag_groot TO size_verdieping_groot;

CREATE OR REPLACE VIEW objecten.verdieping_label
AS
SELECT
    v.id,
    v.geom,
    v.soort,
    v.omschrijving,
    v.verdieping_id,
    v.object_id,
    b.verdieping,
    v.rotatie,
    st.symbol_name,
    CASE
        WHEN v.formaat_verdieping = 'klein'::algemeen.formaat THEN st.size_verdieping_klein
        WHEN v.formaat_verdieping = 'middel'::algemeen.formaat THEN st.size_verdieping_middel
        WHEN v.formaat_verdieping = 'groot'::algemeen.formaat THEN st.size_verdieping_groot
        ELSE NULL::numeric
    END AS size,
    v.formaat_object,
    v.formaat_verdieping,
    v.opmerking
FROM objecten.label v
JOIN objecten.verdiepingen b ON v.verdieping_id = b.id
JOIN objecten.label_type st ON v.soort::text = st.naam::text
WHERE
    v.parent_deleted = 'infinity'::timestamp with time zone
    AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE OR REPLACE FUNCTION objecten.func_label_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN

        INSERT INTO objecten.label (
            geom,
            soort,
            omschrijving,
            rotatie,
            verdieping_id,
            object_id,
            opmerking,
            formaat_verdieping,
            formaat_object
        )
        VALUES (
            NEW.geom,
            NEW.soort,
            NEW.omschrijving,
            NEW.rotatie,
            NEW.verdieping_id,
            NEW.object_id,
            NEW.opmerking,
            COALESCE(NEW.formaat_verdieping, 'middel'::algemeen.formaat),
            COALESCE(NEW.formaat_object, 'middel'::algemeen.formaat)
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        UPDATE objecten.label
        SET
            geom = NEW.geom,
            soort = NEW.soort,
            omschrijving = NEW.omschrijving,
            rotatie = NEW.rotatie,
            verdieping_id = NEW.verdieping_id,
            object_id = NEW.object_id,
            formaat_verdieping = NEW.formaat_verdieping,
            formaat_object = NEW.formaat_object,
            opmerking = NEW.opmerking
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM objecten.label
        WHERE id = OLD.id;

        RETURN OLD;

    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER verdieping_label_ins
INSTEAD OF INSERT ON objecten.verdieping_label
FOR EACH ROW
EXECUTE FUNCTION objecten.func_label_sync();

CREATE TRIGGER verdieping_label_upd
INSTEAD OF UPDATE ON objecten.verdieping_label
FOR EACH ROW
EXECUTE FUNCTION objecten.func_label_sync();

CREATE TRIGGER verdieping_label_del
INSTEAD OF DELETE ON objecten.verdieping_label
FOR EACH ROW
EXECUTE FUNCTION objecten.func_label_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_label;

DROP TRIGGER IF EXISTS object_label_del ON objecten.object_label;
DROP TRIGGER IF EXISTS object_label_upd ON objecten.object_label;
DROP TRIGGER IF EXISTS object_label_ins ON objecten.object_label;

CREATE TRIGGER object_label_ins
INSTEAD OF INSERT ON objecten.object_label
FOR EACH ROW
EXECUTE FUNCTION objecten.func_label_sync();

CREATE TRIGGER object_label_upd
INSTEAD OF UPDATE ON objecten.object_label
FOR EACH ROW
EXECUTE FUNCTION objecten.func_label_sync();

CREATE TRIGGER object_label_del
INSTEAD OF DELETE ON objecten.object_label
FOR EACH ROW
EXECUTE FUNCTION objecten.func_label_sync();

DROP FUNCTION IF EXISTS objecten.func_label_del;
DROP FUNCTION IF EXISTS objecten.func_label_ins;
DROP FUNCTION IF EXISTS objecten.func_label_upd;

ALTER TABLE objecten.gevaarlijkestof_opslag RENAME COLUMN bouwlaag_id TO verdieping_id;
ALTER TABLE objecten.gevaarlijkestof_opslag RENAME COLUMN formaat_bouwlaag TO formaat_verdieping;
ALTER TABLE objecten.gevaarlijkestof_opslag_type RENAME COLUMN size_bouwlaag_klein TO size_verdieping_klein;
ALTER TABLE objecten.gevaarlijkestof_opslag_type RENAME COLUMN size_bouwlaag_middel TO size_verdieping_middel;
ALTER TABLE objecten.gevaarlijkestof_opslag_type RENAME COLUMN size_bouwlaag_groot TO size_verdieping_groot;

CREATE OR REPLACE VIEW objecten.verdieping_opslag
AS
SELECT
    v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.opmerking,
    v.verdieping_id,
    v.object_id,
    v.fotografie_id,
    v.rotatie,
    b.verdieping,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    CASE
        WHEN v.formaat_verdieping = 'klein'::algemeen.formaat THEN st.size_verdieping_klein
        WHEN v.formaat_verdieping = 'middel'::algemeen.formaat THEN st.size_verdieping_middel
        WHEN v.formaat_verdieping = 'groot'::algemeen.formaat THEN st.size_verdieping_groot
        ELSE NULL::numeric
    END AS size,
    v.self_deleted,
    v.label,
    v.label_positie,
    v.formaat_verdieping,
    v.formaat_object,
    v.soort
FROM objecten.gevaarlijkestof_opslag v
JOIN objecten.verdiepingen b ON v.verdieping_id = b.id
JOIN objecten.gevaarlijkestof_opslag_type st ON v.soort::text = st.naam
WHERE
    v.parent_deleted = 'infinity'::timestamp with time zone
    AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE OR REPLACE FUNCTION objecten.func_opslag_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.gevaarlijkestof_opslag (
            geom, opmerking, verdieping_id, object_id, fotografie_id,
            rotatie, label, soort, label_positie, formaat_verdieping,
            formaat_object
        )
        VALUES (
            NEW.geom, NEW.opmerking, NEW.verdieping_id, NEW.object_id,
            NEW.fotografie_id, NEW.rotatie, NEW.label, NEW.soort,
            COALESCE(NEW.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(NEW.formaat_verdieping, 'middel'::algemeen.formaat),
            COALESCE(NEW.formaat_object, 'middel'::algemeen.formaat)
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.gevaarlijkestof_opslag
        SET
            geom = NEW.geom,
            opmerking = NEW.opmerking,
            verdieping_id = NEW.verdieping_id,
            object_id = NEW.object_id,
            rotatie = NEW.rotatie,
            soort = NEW.soort,
            fotografie_id = NEW.fotografie_id,
            label = NEW.label,
            label_positie = NEW.label_positie,
            formaat_verdieping = NEW.formaat_verdieping,
            formaat_object = NEW.formaat_object
        WHERE id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.gevaarlijkestof_opslag
        WHERE id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER verdieping_opslag_ins
INSTEAD OF INSERT ON objecten.verdieping_opslag
FOR EACH ROW
EXECUTE FUNCTION objecten.func_opslag_sync();

CREATE TRIGGER verdieping_opslag_upd
INSTEAD OF UPDATE ON objecten.verdieping_opslag
FOR EACH ROW
EXECUTE FUNCTION objecten.func_opslag_sync();

CREATE TRIGGER verdieping_opslag_del
INSTEAD OF DELETE ON objecten.verdieping_opslag
FOR EACH ROW
EXECUTE FUNCTION objecten.func_opslag_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_opslag;

DROP TRIGGER IF EXISTS object_opslag_del ON objecten.object_opslag;
DROP TRIGGER IF EXISTS object_opslag_upd ON objecten.object_opslag;
DROP TRIGGER IF EXISTS object_opslag_ins ON objecten.object_opslag;

CREATE TRIGGER object_opslag_ins
INSTEAD OF INSERT ON objecten.object_opslag
FOR EACH ROW
EXECUTE FUNCTION objecten.func_opslag_sync();

CREATE TRIGGER object_opslag_upd
INSTEAD OF UPDATE ON objecten.object_opslag
FOR EACH ROW
EXECUTE FUNCTION objecten.func_opslag_sync();

CREATE TRIGGER object_opslag_del
INSTEAD OF DELETE ON objecten.object_opslag
FOR EACH ROW
EXECUTE FUNCTION objecten.func_opslag_sync();

DROP FUNCTION IF EXISTS objecten.func_opslag_del;
DROP FUNCTION IF EXISTS objecten.func_opslag_ins;
DROP FUNCTION IF EXISTS objecten.func_opslag_upd;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.opstelplaats (
            geom, soort, label, opmerking, rotatie, object_id,
            fotografie_id, label_positie, formaat_object
        )
        VALUES (
            NEW.geom, NEW.soort, NEW.label, NEW.opmerking, NEW.rotatie,
            NEW.object_id, NEW.fotografie_id,
            COALESCE(NEW.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(NEW.formaat_object, 'middel'::algemeen.formaat)
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.opstelplaats
        SET
            geom = NEW.geom,
            soort = NEW.soort,
            rotatie = NEW.rotatie,
            label = NEW.label,
            opmerking = NEW.opmerking,
            object_id = NEW.object_id,
            fotografie_id = NEW.fotografie_id,
            label_positie = NEW.label_positie,
            formaat_object = NEW.formaat_object
        WHERE id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.opstelplaats
        WHERE id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

DROP TRIGGER IF EXISTS object_opstelplaats_del ON objecten.object_opstelplaats;
DROP TRIGGER IF EXISTS object_opstelplaats_upd ON objecten.object_opstelplaats;
DROP TRIGGER IF EXISTS object_opstelplaats_ins ON objecten.object_opstelplaats;
DROP TRIGGER IF EXISTS opstelplaats_del ON objecten.object_opstelplaats;
DROP TRIGGER IF EXISTS opstelplaats_upd ON objecten.object_opstelplaats;
DROP TRIGGER IF EXISTS opstelplaats_ins ON objecten.object_opstelplaats;

CREATE TRIGGER object_opstelplaats_ins
INSTEAD OF INSERT ON objecten.object_opstelplaats
FOR EACH ROW
EXECUTE FUNCTION objecten.func_opstelplaats_sync();

CREATE TRIGGER object_opstelplaats_upd
INSTEAD OF UPDATE ON objecten.object_opstelplaats
FOR EACH ROW
EXECUTE FUNCTION objecten.func_opstelplaats_sync();

CREATE TRIGGER object_opstelplaats_del
INSTEAD OF DELETE ON objecten.object_opstelplaats
FOR EACH ROW
EXECUTE FUNCTION objecten.func_opstelplaats_sync();

DROP FUNCTION IF EXISTS objecten.func_opstelplaats_del;
DROP FUNCTION IF EXISTS objecten.func_opstelplaats_ins;
DROP FUNCTION IF EXISTS objecten.func_opstelplaats_upd;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.points_of_interest (
            geom, soort, label, opmerking, rotatie, object_id,
            fotografie_id, label_positie, formaat_object
        )
        VALUES (
            NEW.geom, NEW.soort, NEW.label, NEW.opmerking, NEW.rotatie,
            NEW.object_id, NEW.fotografie_id,
            COALESCE(NEW.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(NEW.formaat_object, 'middel'::algemeen.formaat)
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.points_of_interest
        SET
            geom = NEW.geom,
            soort = NEW.soort,
            rotatie = NEW.rotatie,
            opmerking = NEW.opmerking,
            label = NEW.label,
            object_id = NEW.object_id,
            fotografie_id = NEW.fotografie_id,
            label_positie = NEW.label_positie,
            formaat_object = NEW.formaat_object
        WHERE id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.points_of_interest
        WHERE id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

DROP TRIGGER IF EXISTS object_points_of_interest_del ON objecten.object_points_of_interest;
DROP TRIGGER IF EXISTS object_points_of_interest_upd ON objecten.object_points_of_interest;
DROP TRIGGER IF EXISTS object_points_of_interest_ins ON objecten.object_points_of_interest;
DROP TRIGGER IF EXISTS points_of_interest_del ON objecten.object_points_of_interest;
DROP TRIGGER IF EXISTS points_of_interest_upd ON objecten.object_points_of_interest;
DROP TRIGGER IF EXISTS points_of_interest_ins ON objecten.object_points_of_interest;

CREATE TRIGGER object_points_of_interest_ins
INSTEAD OF INSERT ON objecten.object_points_of_interest
FOR EACH ROW
EXECUTE FUNCTION objecten.func_points_of_interest_sync();

CREATE TRIGGER object_points_of_interest_upd
INSTEAD OF UPDATE ON objecten.object_points_of_interest
FOR EACH ROW
EXECUTE FUNCTION objecten.func_points_of_interest_sync();

CREATE TRIGGER object_points_of_interest_del
INSTEAD OF DELETE ON objecten.object_points_of_interest
FOR EACH ROW
EXECUTE FUNCTION objecten.func_points_of_interest_sync();

DROP FUNCTION IF EXISTS objecten.func_points_of_interest_del;
DROP FUNCTION IF EXISTS objecten.func_points_of_interest_ins;
DROP FUNCTION IF EXISTS objecten.func_points_of_interest_upd;

ALTER TABLE objecten.ruimten RENAME COLUMN bouwlaag_id TO verdieping_id;

CREATE OR REPLACE VIEW objecten.verdieping_ruimten
AS
SELECT
    v.id,
    v.geom,
    v.soort,
    v.opmerking,
    v.fotografie_id,
    v.verdieping_id,
    b.verdieping
FROM objecten.ruimten v
JOIN objecten.verdiepingen b ON v.verdieping_id = b.id
WHERE
    v.parent_deleted = 'infinity'::timestamp with time zone
    AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.ruimten (
            geom, soort, opmerking, verdieping_id, fotografie_id
        )
        VALUES (
            ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 3)),
            NEW.soort,
            NEW.opmerking,
            NEW.verdieping_id,
            NEW.fotografie_id
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.ruimten
        SET
            geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 3)),
            soort = NEW.soort,
            opmerking = NEW.opmerking,
            verdieping_id = NEW.verdieping_id,
            fotografie_id = NEW.fotografie_id
        WHERE id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.ruimten
        WHERE id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER verdieping_ruimten_ins
INSTEAD OF INSERT ON objecten.verdieping_ruimten
FOR EACH ROW
EXECUTE FUNCTION objecten.func_ruimten_sync();

CREATE TRIGGER verdieping_ruimten_upd
INSTEAD OF UPDATE ON objecten.verdieping_ruimten
FOR EACH ROW
EXECUTE FUNCTION objecten.func_ruimten_sync();

CREATE TRIGGER verdieping_ruimten_del
INSTEAD OF DELETE ON objecten.verdieping_ruimten
FOR EACH ROW
EXECUTE FUNCTION objecten.func_ruimten_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_ruimten;

DROP FUNCTION IF EXISTS objecten.func_ruimten_del;
DROP FUNCTION IF EXISTS objecten.func_ruimten_ins;
DROP FUNCTION IF EXISTS objecten.func_ruimten_upd;

ALTER TABLE objecten.scenario_locatie RENAME COLUMN bouwlaag_id TO verdieping_id;
ALTER TABLE objecten.scenario_locatie RENAME COLUMN formaat_bouwlaag TO formaat_verdieping;
ALTER TABLE objecten.scenario_locatie_type RENAME COLUMN size_bouwlaag_klein TO size_verdieping_klein;
ALTER TABLE objecten.scenario_locatie_type RENAME COLUMN size_bouwlaag_middel TO size_verdieping_middel;
ALTER TABLE objecten.scenario_locatie_type RENAME COLUMN size_bouwlaag_groot TO size_verdieping_groot;

CREATE OR REPLACE VIEW objecten.verdieping_scenario_locatie
AS
SELECT
    v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.opmerking,
    v.verdieping_id,
    v.object_id,
    v.fotografie_id,
    v.rotatie,
    b.verdieping,
    st.symbol_name,
    CASE
        WHEN v.formaat_verdieping = 'klein'::algemeen.formaat THEN st.size_verdieping_klein
        WHEN v.formaat_verdieping = 'middel'::algemeen.formaat THEN st.size_verdieping_middel
        WHEN v.formaat_verdieping = 'groot'::algemeen.formaat THEN st.size_verdieping_groot
        ELSE NULL::numeric
    END AS size,
    v.label,
    v.label_positie,
    v.formaat_verdieping,
    v.formaat_object,
    v.soort
FROM objecten.scenario_locatie v
JOIN objecten.verdiepingen b ON v.verdieping_id = b.id
JOIN objecten.scenario_locatie_type st ON v.soort::text = st.naam
WHERE
    v.parent_deleted = 'infinity'::timestamp with time zone
    AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.scenario_locatie (
            geom, opmerking, verdieping_id, object_id, fotografie_id,
            rotatie, label, label_positie, soort, formaat_verdieping,
            formaat_object
        )
        VALUES (
            NEW.geom, NEW.opmerking, NEW.verdieping_id, NEW.object_id,
            NEW.fotografie_id, NEW.rotatie, NEW.label,
            COALESCE(NEW.label_positie, 'onder - midden'::algemeen.labelposition),
            NEW.soort,
            COALESCE(NEW.formaat_verdieping, 'middel'::algemeen.formaat),
            COALESCE(NEW.formaat_object, 'middel'::algemeen.formaat)
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.scenario_locatie
        SET
            geom = NEW.geom,
            opmerking = NEW.opmerking,
            rotatie = NEW.rotatie,
            verdieping_id = NEW.verdieping_id,
            object_id = NEW.object_id,
            fotografie_id = NEW.fotografie_id,
            label = NEW.label,
            label_positie = NEW.label_positie,
            formaat_verdieping = NEW.formaat_verdieping,
            formaat_object = NEW.formaat_object,
            soort = NEW.soort
        WHERE id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.scenario_locatie
        WHERE id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER verdieping_scenario_locatie_ins
INSTEAD OF INSERT ON objecten.verdieping_scenario_locatie
FOR EACH ROW
EXECUTE FUNCTION objecten.func_scenario_locatie_sync();

CREATE TRIGGER verdieping_scenario_locatie_upd
INSTEAD OF UPDATE ON objecten.verdieping_scenario_locatie
FOR EACH ROW
EXECUTE FUNCTION objecten.func_scenario_locatie_sync();

CREATE TRIGGER verdieping_scenario_locatie_del
INSTEAD OF DELETE ON objecten.verdieping_scenario_locatie
FOR EACH ROW
EXECUTE FUNCTION objecten.func_scenario_locatie_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_scenario_locatie;

DROP TRIGGER IF EXISTS object_scenario_locatie_del ON objecten.object_scenario_locatie;
DROP TRIGGER IF EXISTS object_scenario_locatie_upd ON objecten.object_scenario_locatie;
DROP TRIGGER IF EXISTS object_scenario_locatie_ins ON objecten.object_scenario_locatie;

CREATE TRIGGER object_scenario_locatie_ins
INSTEAD OF INSERT ON objecten.object_scenario_locatie
FOR EACH ROW
EXECUTE FUNCTION objecten.func_scenario_locatie_sync();

CREATE TRIGGER object_scenario_locatie_upd
INSTEAD OF UPDATE ON objecten.object_scenario_locatie
FOR EACH ROW
EXECUTE FUNCTION objecten.func_scenario_locatie_sync();

CREATE TRIGGER object_scenario_locatie_del
INSTEAD OF DELETE ON objecten.object_scenario_locatie
FOR EACH ROW
EXECUTE FUNCTION objecten.func_scenario_locatie_sync();

DROP FUNCTION IF EXISTS objecten.func_scenario_locatie_del;
DROP FUNCTION IF EXISTS objecten.func_scenario_locatie_ins;
DROP FUNCTION IF EXISTS objecten.func_scenario_locatie_upd;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.sectoren (
            geom, soort, opmerking, label, object_id, fotografie_id
        )
        VALUES (
            ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 3)),
            NEW.soort,
            NEW.opmerking,
            NEW.label,
            NEW.object_id,
            NEW.fotografie_id
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.sectoren
        SET
            geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 3)),
            soort = NEW.soort,
            opmerking = NEW.opmerking,
            label = NEW.label,
            object_id = NEW.object_id,
            fotografie_id = NEW.fotografie_id
        WHERE id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.sectoren
        WHERE id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;


DROP TRIGGER IF EXISTS sectoren_del ON objecten.object_sectoren;
DROP TRIGGER IF EXISTS sectoren_upd ON objecten.object_sectoren;
DROP TRIGGER IF EXISTS sectoren_ins ON objecten.object_sectoren;
DROP TRIGGER IF EXISTS object_sectoren_del ON objecten.object_sectoren;
DROP TRIGGER IF EXISTS object_sectoren_upd ON objecten.object_sectoren;
DROP TRIGGER IF EXISTS object_sectoren_ins ON objecten.object_sectoren;

CREATE TRIGGER object_sectoren_ins
INSTEAD OF INSERT ON objecten.object_sectoren
FOR EACH ROW
EXECUTE FUNCTION objecten.func_sectoren_sync();

CREATE TRIGGER object_sectoren_upd
INSTEAD OF UPDATE ON objecten.object_sectoren
FOR EACH ROW
EXECUTE FUNCTION objecten.func_sectoren_sync();

CREATE TRIGGER object_sectoren_del
INSTEAD OF DELETE ON objecten.object_sectoren
FOR EACH ROW
EXECUTE FUNCTION objecten.func_sectoren_sync();

DROP FUNCTION IF EXISTS objecten.func_sectoren_del;
DROP FUNCTION IF EXISTS objecten.func_sectoren_ins;
DROP FUNCTION IF EXISTS objecten.func_sectoren_upd;

ALTER TABLE objecten.sleutelkluis RENAME COLUMN bouwlaag_id TO verdieping_id;
ALTER TABLE objecten.sleutelkluis RENAME COLUMN formaat_bouwlaag TO formaat_verdieping;
ALTER TABLE objecten.sleutelkluis_type RENAME COLUMN size_bouwlaag_klein TO size_verdieping_klein;
ALTER TABLE objecten.sleutelkluis_type RENAME COLUMN size_bouwlaag_middel TO size_verdieping_middel;
ALTER TABLE objecten.sleutelkluis_type RENAME COLUMN size_bouwlaag_groot TO size_verdieping_groot;

CREATE OR REPLACE VIEW objecten.verdieping_sleutelkluis
AS
SELECT
    v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.sleuteldoel,
    v.fotografie_id,
    v.verdieping_id,
    v.object_id,
    b.verdieping,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    CASE
        WHEN v.formaat_verdieping = 'klein'::algemeen.formaat THEN st.size_verdieping_klein
        WHEN v.formaat_verdieping = 'middel'::algemeen.formaat THEN st.size_verdieping_middel
        WHEN v.formaat_verdieping = 'groot'::algemeen.formaat THEN st.size_verdieping_groot
        ELSE NULL::numeric
    END AS size,
    v.label_positie,
    v.formaat_verdieping,
    v.formaat_object
FROM objecten.sleutelkluis v
JOIN objecten.verdiepingen b ON v.verdieping_id = b.id
JOIN objecten.sleutelkluis_type st ON v.soort::text = st.naam
WHERE
    v.parent_deleted = 'infinity'::timestamp with time zone
    AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.sleutelkluis (
            geom, soort, label, rotatie, opmerking, sleuteldoel,
            verdieping_id, object_id, fotografie_id, label_positie,
            formaat_verdieping, formaat_object
        )
        VALUES (
            NEW.geom, NEW.soort, NEW.label, NEW.rotatie, NEW.opmerking,
            NEW.sleuteldoel, NEW.verdieping_id, NEW.object_id,
            NEW.fotografie_id,
            COALESCE(NEW.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(NEW.formaat_verdieping, 'middel'::algemeen.formaat),
            COALESCE(NEW.formaat_object, 'middel'::algemeen.formaat)
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.sleutelkluis
        SET
            geom = NEW.geom,
            soort = NEW.soort,
            rotatie = NEW.rotatie,
            label = NEW.label,
            opmerking = NEW.opmerking,
            sleuteldoel = NEW.sleuteldoel,
            verdieping_id = NEW.verdieping_id,
            object_id = NEW.object_id,
            fotografie_id = NEW.fotografie_id,
            label_positie = NEW.label_positie,
            formaat_verdieping = NEW.formaat_verdieping,
            formaat_object = NEW.formaat_object
        WHERE id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.sleutelkluis
        WHERE id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER verdieping_sleutelkluis_ins
INSTEAD OF INSERT ON objecten.verdieping_sleutelkluis
FOR EACH ROW
EXECUTE FUNCTION objecten.func_sleutelkluis_sync();

CREATE TRIGGER verdieping_sleutelkluis_upd
INSTEAD OF UPDATE ON objecten.verdieping_sleutelkluis
FOR EACH ROW
EXECUTE FUNCTION objecten.func_sleutelkluis_sync();

CREATE TRIGGER verdieping_sleutelkluis_del
INSTEAD OF DELETE ON objecten.verdieping_sleutelkluis
FOR EACH ROW
EXECUTE FUNCTION objecten.func_sleutelkluis_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_sleutelkluis;

DROP TRIGGER IF EXISTS object_sleutelkluis_del ON objecten.object_sleutelkluis;
DROP TRIGGER IF EXISTS object_sleutelkluis_upd ON objecten.object_sleutelkluis;
DROP TRIGGER IF EXISTS object_sleutelkluis_ins ON objecten.object_sleutelkluis;

CREATE TRIGGER object_sleutelkluis_ins
INSTEAD OF INSERT ON objecten.object_sleutelkluis
FOR EACH ROW
EXECUTE FUNCTION objecten.func_sleutelkluis_sync();

CREATE TRIGGER object_sleutelkluis_upd
INSTEAD OF UPDATE ON objecten.object_sleutelkluis
FOR EACH ROW
EXECUTE FUNCTION objecten.func_sleutelkluis_sync();

CREATE TRIGGER object_sleutelkluis_del
INSTEAD OF DELETE ON objecten.object_sleutelkluis
FOR EACH ROW
EXECUTE FUNCTION objecten.func_sleutelkluis_sync();

DROP FUNCTION IF EXISTS objecten.func_sleutelkluis_del;
DROP FUNCTION IF EXISTS objecten.func_sleutelkluis_ins;
DROP FUNCTION IF EXISTS objecten.func_sleutelkluis_upd;

ALTER TABLE objecten.veiligh_bouwk RENAME COLUMN bouwlaag_id TO verdieping_id;

CREATE OR REPLACE VIEW objecten.verdieping_veiligh_bouwk
AS
SELECT
    v.id,
    v.geom,
    v.soort,
    v.fotografie_id,
    v.verdieping_id,
    v.opmerking,
    b.verdieping
FROM objecten.veiligh_bouwk v
JOIN objecten.verdiepingen b ON v.verdieping_id = b.id
WHERE
    v.parent_deleted = 'infinity'::timestamp with time zone
    AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.veiligh_bouwk (
            geom, soort, verdieping_id, fotografie_id, opmerking
        )
        VALUES (
            ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 2)),
            NEW.soort,
            NEW.verdieping_id,
            NEW.fotografie_id,
            NEW.opmerking
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.veiligh_bouwk
        SET
            geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 2)),
            soort = NEW.soort,
            verdieping_id = NEW.verdieping_id,
            fotografie_id = NEW.fotografie_id,
            opmerking = NEW.opmerking
        WHERE id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.veiligh_bouwk
        WHERE id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER verdieping_veiligh_bouwk_ins
INSTEAD OF INSERT ON objecten.verdieping_veiligh_bouwk
FOR EACH ROW
EXECUTE FUNCTION objecten.func_veiligh_bouwk_sync();

CREATE TRIGGER verdieping_veiligh_bouwk_upd
INSTEAD OF UPDATE ON objecten.verdieping_veiligh_bouwk
FOR EACH ROW
EXECUTE FUNCTION objecten.func_veiligh_bouwk_sync();

CREATE TRIGGER verdieping_veiligh_bouwk_del
INSTEAD OF DELETE ON objecten.verdieping_veiligh_bouwk
FOR EACH ROW
EXECUTE FUNCTION objecten.func_veiligh_bouwk_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_veiligh_bouwk;

DROP FUNCTION IF EXISTS objecten.func_veiligh_bouwk_del;
DROP FUNCTION IF EXISTS objecten.func_veiligh_bouwk_ins;
DROP FUNCTION IF EXISTS objecten.func_veiligh_bouwk_upd;

ALTER TABLE objecten.veiligh_install RENAME COLUMN bouwlaag_id TO verdieping_id;
ALTER TABLE objecten.veiligh_install RENAME COLUMN formaat_bouwlaag TO formaat_verdieping;
ALTER TABLE objecten.veiligh_install_type RENAME COLUMN size_bouwlaag_klein TO size_verdieping_klein;
ALTER TABLE objecten.veiligh_install_type RENAME COLUMN size_bouwlaag_middel TO size_verdieping_middel;
ALTER TABLE objecten.veiligh_install_type RENAME COLUMN size_bouwlaag_groot TO size_verdieping_groot;

CREATE OR REPLACE VIEW objecten.verdieping_veiligh_install
AS
SELECT
    v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.soort,
    v.label,
    v.opmerking,
    v.verdieping_id,
    v.object_id,
    v.rotatie,
    v.fotografie_id,
    b.verdieping,
    CASE
        WHEN v.formaat_verdieping = 'klein'::algemeen.formaat THEN st.size_verdieping_klein
        WHEN v.formaat_verdieping = 'middel'::algemeen.formaat THEN st.size_verdieping_middel
        WHEN v.formaat_verdieping = 'groot'::algemeen.formaat THEN st.size_verdieping_groot
        ELSE NULL::numeric
    END AS size,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    v.label_positie,
    v.formaat_verdieping,
    v.formaat_object
FROM objecten.veiligh_install v
JOIN objecten.verdiepingen b ON v.verdieping_id = b.id
JOIN objecten.veiligh_install_type st ON v.soort::text = st.naam
WHERE
    v.parent_deleted = 'infinity'::timestamp with time zone
    AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.veiligh_install (
            geom, soort, label, opmerking, rotatie, verdieping_id,
            object_id, fotografie_id, label_positie, formaat_verdieping,
            formaat_object
        )
        VALUES (
            NEW.geom, NEW.soort, NEW.label, NEW.opmerking, NEW.rotatie,
            NEW.verdieping_id, NEW.object_id, NEW.fotografie_id,
            COALESCE(NEW.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(NEW.formaat_verdieping, 'middel'::algemeen.formaat),
            COALESCE(NEW.formaat_object, 'middel'::algemeen.formaat)
        );
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.veiligh_install
        SET
            geom = NEW.geom,
            soort = NEW.soort,
            verdieping_id = NEW.verdieping_id,
            object_id = NEW.object_id,
            label = NEW.label,
            opmerking = NEW.opmerking,
            rotatie = NEW.rotatie,
            fotografie_id = NEW.fotografie_id,
            label_positie = NEW.label_positie,
            formaat_verdieping = NEW.formaat_verdieping,
            formaat_object = NEW.formaat_object
        WHERE id = OLD.id;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.veiligh_install
        WHERE id = OLD.id;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER verdieping_veiligh_install_ins
INSTEAD OF INSERT ON objecten.verdieping_veiligh_install
FOR EACH ROW
EXECUTE FUNCTION objecten.func_veiligh_install_sync();

CREATE TRIGGER verdieping_veiligh_install_upd
INSTEAD OF UPDATE ON objecten.verdieping_veiligh_install
FOR EACH ROW
EXECUTE FUNCTION objecten.func_veiligh_install_sync();

CREATE TRIGGER verdieping_veiligh_install_del
INSTEAD OF DELETE ON objecten.verdieping_veiligh_install
FOR EACH ROW
EXECUTE FUNCTION objecten.func_veiligh_install_sync();

DROP VIEW IF EXISTS objecten.bouwlaag_veiligh_install;

DROP TRIGGER IF EXISTS object_veiligh_install_del ON objecten.object_veiligh_install;
DROP TRIGGER IF EXISTS object_veiligh_install_upd ON objecten.object_veiligh_install;
DROP TRIGGER IF EXISTS object_veiligh_install_ins ON objecten.object_veiligh_install;
DROP TRIGGER IF EXISTS veiligh_install_del ON objecten.object_veiligh_install;
DROP TRIGGER IF EXISTS veiligh_install_upd ON objecten.object_veiligh_install;
DROP TRIGGER IF EXISTS veiligh_install_ins ON objecten.object_veiligh_install;
DROP TRIGGER IF EXISTS veiligh_ruimtelijk_del ON objecten.object_veiligh_install;
DROP TRIGGER IF EXISTS veiligh_ruimtelijk_upd ON objecten.object_veiligh_install;
DROP TRIGGER IF EXISTS veiligh_ruimtelijk_ins ON objecten.object_veiligh_install;

CREATE TRIGGER object_veiligh_install_ins
INSTEAD OF INSERT ON objecten.object_veiligh_install
FOR EACH ROW
EXECUTE FUNCTION objecten.func_veiligh_install_sync();

CREATE TRIGGER object_veiligh_install_upd
INSTEAD OF UPDATE ON objecten.object_veiligh_install
FOR EACH ROW
EXECUTE FUNCTION objecten.func_veiligh_install_sync();

CREATE TRIGGER object_veiligh_install_del
INSTEAD OF DELETE ON objecten.object_veiligh_install
FOR EACH ROW
EXECUTE FUNCTION objecten.func_veiligh_install_sync();

DROP FUNCTION IF EXISTS objecten.func_veiligh_install_del;
DROP FUNCTION IF EXISTS objecten.func_veiligh_install_ins;
DROP FUNCTION IF EXISTS objecten.func_veiligh_install_upd;

CREATE OR REPLACE FUNCTION objecten.func_terrein_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.terrein (
            geom,
            omschrijving,
            object_id
        )
        VALUES (
            ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 3)),
            NEW.omschrijving,
            NEW.object_id
        )
        RETURNING id INTO NEW.id;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.terrein
        SET
            geom = ST_Multi(ST_CollectionExtract(ST_MakeValid(NEW.geom), 3)),
            omschrijving = NEW.omschrijving,
            object_id = NEW.object_id
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.terrein
        WHERE id = OLD.id;

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

DROP RULE IF EXISTS object_terrein_del ON objecten.object_terrein;
DROP RULE IF EXISTS object_terrein_ins ON objecten.object_terrein;
DROP RULE IF EXISTS object_terrein_upd ON objecten.object_terrein;

CREATE TRIGGER object_terrein_ins
INSTEAD OF INSERT ON objecten.object_terrein
FOR EACH ROW
EXECUTE FUNCTION objecten.func_terrein_sync();

CREATE TRIGGER object_terrein_upd
INSTEAD OF UPDATE ON objecten.object_terrein
FOR EACH ROW
EXECUTE FUNCTION objecten.func_terrein_sync();

CREATE TRIGGER object_terrein_del
INSTEAD OF DELETE ON objecten.object_terrein
FOR EACH ROW
EXECUTE FUNCTION objecten.func_terrein_sync();


CREATE OR REPLACE FUNCTION objecten.func_object_objecten_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.object (
            geom,
            basisreg_identifier,
            formelenaam,
            bron,
            bron_tabel
        )
        VALUES (
            NEW.geom,
            NEW.basisreg_identifier,
            NEW.formelenaam,
            NEW.bron,
            NEW.bron_tabel
        )
        RETURNING id INTO NEW.id;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.object
        SET
            geom = NEW.geom,
            basisreg_identifier = NEW.basisreg_identifier,
            formelenaam = NEW.formelenaam,
            pers_max = NEW.pers_max,
            pers_nietz_max = NEW.pers_nietz_max,
            datum_geldig_tot = NEW.datum_geldig_tot,
            datum_geldig_vanaf = NEW.datum_geldig_vanaf,
            bron = NEW.bron,
            bron_tabel = NEW.bron_tabel,
            fotografie_id = NEW.fotografie_id,
            bodemgesteldheid_type_id = NEW.bodemgesteldheid_type_id,
            bijzonderheden = NEW.bijzonderheden,
            min_verdieping = NEW.min_bouwlaag,
            max_verdieping = NEW.max_bouwlaag,
            share = NEW.share
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.object
        WHERE id = OLD.id;

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER object_ins
INSTEAD OF INSERT ON objecten.object_objecten
FOR EACH ROW
EXECUTE FUNCTION objecten.func_object_objecten_sync();

CREATE TRIGGER object_upd
INSTEAD OF UPDATE ON objecten.object_objecten
FOR EACH ROW
EXECUTE FUNCTION objecten.func_object_objecten_sync();

CREATE TRIGGER object_del
INSTEAD OF DELETE ON objecten.object_objecten
FOR EACH ROW
EXECUTE FUNCTION objecten.func_object_objecten_sync();

DROP RULE IF EXISTS object_ins ON objecten.object_objecten;
DROP RULE IF EXISTS object_upd ON objecten.object_objecten;
DROP RULE IF EXISTS object_del ON objecten.object_objecten;

CREATE OR REPLACE FUNCTION objecten.func_historie_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.historie (
            object_id,
            teamlid_behandeld_id,
            teamlid_afgehandeld_id,
            matrix_code_id,
            aanpassing,
            status,
            typeobject
        )
        VALUES (
            NEW.object_id,
            NEW.teamlid_behandeld_id,
            NEW.teamlid_afgehandeld_id,
            NEW.matrix_code_id,
            NEW.aanpassing,
            NEW.status,
            NEW.typeobject
        )
        RETURNING id INTO NEW.id;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.historie
        SET
            object_id = NEW.object_id,
            teamlid_behandeld_id = NEW.teamlid_behandeld_id,
            teamlid_afgehandeld_id = NEW.teamlid_afgehandeld_id,
            matrix_code_id = NEW.matrix_code_id,
            aanpassing = NEW.aanpassing,
            status = NEW.status,
            typeobject = NEW.typeobject
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.historie
        WHERE id = OLD.id;

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER historie_ins
INSTEAD OF INSERT ON objecten._historie
FOR EACH ROW
EXECUTE FUNCTION objecten.func_historie_sync();

CREATE TRIGGER historie_upd
INSTEAD OF UPDATE ON objecten._historie
FOR EACH ROW
EXECUTE FUNCTION objecten.func_historie_sync();

CREATE TRIGGER historie_del
INSTEAD OF DELETE ON objecten._historie
FOR EACH ROW
EXECUTE FUNCTION objecten.func_historie_sync();

DROP RULE IF EXISTS historie_ins ON objecten._historie;
DROP RULE IF EXISTS historie_upd ON objecten._historie;
DROP RULE IF EXISTS historie_del ON objecten._historie;

CREATE OR REPLACE FUNCTION objecten.func_gevaarlijkestof_schade_cirkel_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.gevaarlijkestof_schade_cirkel (
            gevaarlijkestof_id,
            soort,
            straal
        )
        VALUES (
            NEW.gevaarlijkestof_id,
            NEW.soort,
            NEW.straal
        )
        RETURNING id INTO NEW.id;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.gevaarlijkestof_schade_cirkel
        SET
            gevaarlijkestof_id = NEW.gevaarlijkestof_id,
            soort = NEW.soort,
            straal = NEW.straal
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.gevaarlijkestof_schade_cirkel
        WHERE id = OLD.id;

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;


CREATE TRIGGER gevaarlijkestof_schade_cirkel_ins
INSTEAD OF INSERT ON objecten._gevaarlijkestof_schade_cirkel
FOR EACH ROW
EXECUTE FUNCTION objecten.func_gevaarlijkestof_schade_cirkel_sync();


CREATE TRIGGER gevaarlijkestof_schade_cirkel_upd
INSTEAD OF UPDATE ON objecten._gevaarlijkestof_schade_cirkel
FOR EACH ROW
EXECUTE FUNCTION objecten.func_gevaarlijkestof_schade_cirkel_sync();


CREATE TRIGGER gevaarlijkestof_schade_cirkel_del
INSTEAD OF DELETE ON objecten._gevaarlijkestof_schade_cirkel
FOR EACH ROW
EXECUTE FUNCTION objecten.func_gevaarlijkestof_schade_cirkel_sync();

DROP RULE IF EXISTS gevaarlijkestof_schade_cirkel_del
ON objecten._gevaarlijkestof_schade_cirkel;

DROP RULE IF EXISTS gevaarlijkestof_schade_cirkel_ins
ON objecten._gevaarlijkestof_schade_cirkel;

DROP RULE IF EXISTS gevaarlijkestof_schade_cirkel_upd
ON objecten._gevaarlijkestof_schade_cirkel;

CREATE OR REPLACE FUNCTION objecten.func_gevaarlijkestof_sync()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO objecten.gevaarlijkestof (
            opslag_id,
            omschrijving,
            gevaarlijkestof_vnnr_id,
            locatie,
            hoeveelheid,
            handelingsaanwijzing,
            eenheid,
            toestand
        )
        VALUES (
            NEW.opslag_id,
            NEW.omschrijving,
            NEW.gevaarlijkestof_vnnr_id,
            NEW.locatie,
            NEW.hoeveelheid,
            NEW.handelingsaanwijzing,
            NEW.eenheid,
            NEW.toestand
        )
        RETURNING id INTO NEW.id;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE objecten.gevaarlijkestof
        SET
            opslag_id = NEW.opslag_id,
            omschrijving = NEW.omschrijving,
            gevaarlijkestof_vnnr_id = NEW.gevaarlijkestof_vnnr_id,
            locatie = NEW.locatie,
            hoeveelheid = NEW.hoeveelheid,
            handelingsaanwijzing = NEW.handelingsaanwijzing,
            eenheid = NEW.eenheid,
            toestand = NEW.toestand
        WHERE id = OLD.id;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM objecten.gevaarlijkestof
        WHERE id = OLD.id;

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$function$;

CREATE TRIGGER gevaarlijkestof_ins
INSTEAD OF INSERT ON objecten._gevaarlijkestof
FOR EACH ROW
EXECUTE FUNCTION objecten.func_gevaarlijkestof_sync();


CREATE TRIGGER gevaarlijkestof_upd
INSTEAD OF UPDATE ON objecten._gevaarlijkestof
FOR EACH ROW
EXECUTE FUNCTION objecten.func_gevaarlijkestof_sync();


CREATE TRIGGER gevaarlijkestof_del
INSTEAD OF DELETE ON objecten._gevaarlijkestof
FOR EACH ROW
EXECUTE FUNCTION objecten.func_gevaarlijkestof_sync();

DROP RULE IF EXISTS gevaarlijkestof_del
ON objecten._gevaarlijkestof;

DROP RULE IF EXISTS gevaarlijkstof_ins
ON objecten._gevaarlijkestof;

DROP RULE IF EXISTS gevaarlijkestof_upd
ON objecten._gevaarlijkestof;

DROP VIEW objecten.object_dreiging;
CREATE OR REPLACE VIEW objecten.object_dreiging
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.fotografie_id,
    v.opmerking,
    v.verdieping_id,
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
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    v.label_positie,
    v.formaat_object,
    v.formaat_verdieping AS formaat_bouwlaag
   FROM objecten.dreiging v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.dreiging_type st ON v.soort::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_dreiging_ins INSTEAD OF
INSERT
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_sync();
CREATE TRIGGER object_dreiging_upd INSTEAD OF
UPDATE
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_sync();
CREATE TRIGGER object_dreiging_del INSTEAD OF
DELETE
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_sync();

DROP VIEW objecten.object_ingang;
CREATE OR REPLACE VIEW objecten.object_ingang
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.fotografie_id,
    v.verdieping_id,
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
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    v.label_positie,
    v.formaat_object,
    v.formaat_verdieping AS formaat_bouwlaag
   FROM objecten.ingang v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.ingang_type st ON v.soort::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_ingang_ins INSTEAD OF
INSERT
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_sync();
CREATE TRIGGER object_ingang_upd INSTEAD OF
UPDATE
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_sync();
CREATE TRIGGER object_ingang_del INSTEAD OF
DELETE
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_sync();

DROP VIEW objecten.object_label;
CREATE OR REPLACE VIEW objecten.object_label
AS SELECT l.id,
    l.geom,
    l.soort,
    l.omschrijving,
    l.verdieping_id,
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
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    l.formaat_object,
    l.formaat_verdieping AS formaat_bouwlaag,
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

CREATE TRIGGER object_label_ins INSTEAD OF
INSERT
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_sync();
CREATE TRIGGER object_label_upd INSTEAD OF
UPDATE
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_sync();
CREATE TRIGGER object_label_del INSTEAD OF
DELETE
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_sync();

DROP VIEW objecten.object_scenario_locatie;
CREATE OR REPLACE VIEW objecten.object_scenario_locatie
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.opmerking,
    o.verdieping_id,
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
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    o.label,
    o.label_positie,
    o.formaat_object,
    o.formaat_verdieping AS formaat_bouwlaag,
    o.soort
   FROM objecten.scenario_locatie o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.scenario_locatie_type st ON o.soort::text = st.naam
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
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_sync();
CREATE TRIGGER object_scenario_locatie_upd INSTEAD OF
UPDATE
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_sync();
CREATE TRIGGER object_scenario_locatie_del INSTEAD OF
DELETE
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_sync();

DROP VIEW objecten.object_sleutelkluis;
CREATE OR REPLACE VIEW objecten.object_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.sleuteldoel,
    v.fotografie_id,
    v.verdieping_id,
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
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    v.label_positie,
    v.formaat_object,
    v.formaat_verdieping AS formaat_bouwlaag
   FROM objecten.sleutelkluis v
     JOIN objecten.sleutelkluis_type st ON v.soort::text = st.naam
     JOIN objecten.object b ON v.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_sleutelkluis_ins INSTEAD OF
INSERT
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_sync();
CREATE TRIGGER object_sleutelkluis_upd INSTEAD OF
UPDATE
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_sync();
CREATE TRIGGER object_sleutelkluis_del INSTEAD OF
DELETE
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_sync();

DROP VIEW objecten.object_veiligh_install;
CREATE OR REPLACE VIEW objecten.object_veiligh_install
AS SELECT b.id,
    b.geom,
    b.soort,
    b.label,
    b.opmerking,
    b.fotografie_id,
    b.verdieping_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject,
    b.label_positie,
    b.formaat_object,
    b.formaat_verdieping AS formaat_bouwlaag
   FROM objecten.veiligh_install b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.veiligh_install_type st ON b.soort::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_veiligh_install_ins INSTEAD OF
INSERT
    ON
    objecten.object_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_sync();
CREATE TRIGGER object_veiligh_install_upd INSTEAD OF
UPDATE
    ON
    objecten.object_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_sync();
CREATE TRIGGER object_veiligh_install_del INSTEAD OF
DELETE
    ON
    objecten.object_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_sync();


INSERT INTO objecten.veiligh_install_type
(id, naam, symbol_name, size_verdieping_klein, size_verdieping_middel, size_verdieping_groot, size_object_klein, size_object_middel, size_object_groot,
	symbol_type, actief_bouwlaag, actief_ruimtelijk, snap, anchorpoint, tabbladen, volgnummer, symbol_svg_png)
SELECT (SELECT max(id)+1 FROM objecten.veiligh_install_type), naam, symbol_name, size_object_klein, size_object_middel, size_object_groot, size_object_klein, size_object_middel, size_object_groot,
	symbol_type, actief_ruimtelijk, actief_ruimtelijk, snap, anchorpoint, tabbladen, (SELECT max(volgnummer)+1 FROM objecten.veiligh_install_type), symbol_svg_png
FROM objecten.points_of_interest_type p
WHERE symbol_name = 'poi040' AND NOT EXISTS (SELECT 1 FROM objecten.veiligh_install_type v WHERE v.symbol_name = p.symbol_name);

INSERT INTO objecten.veiligh_install_type
(id, naam, symbol_name, size_verdieping_klein, size_verdieping_middel, size_verdieping_groot, size_object_klein, size_object_middel, size_object_groot,
	symbol_type, actief_bouwlaag, actief_ruimtelijk, snap, anchorpoint, tabbladen, volgnummer, symbol_svg_png)
SELECT (SELECT max(id)+1 FROM objecten.veiligh_install_type), naam, symbol_name, size_object_klein, size_object_middel, size_object_groot, size_object_klein, size_object_middel, size_object_groot,
	symbol_type, actief_ruimtelijk, actief_ruimtelijk, snap, anchorpoint, tabbladen, (SELECT max(volgnummer)+1 FROM objecten.veiligh_install_type), symbol_svg_png
FROM objecten.points_of_interest_type p
WHERE symbol_name = 'poi025' AND NOT EXISTS (SELECT 1 FROM objecten.veiligh_install_type v WHERE v.symbol_name = p.symbol_name);

INSERT INTO objecten.veiligh_install
(geom, datum_aangemaakt, datum_gewijzigd, soort, "label", object_id, rotatie, fotografie_id, opmerking, parent_deleted, self_deleted, label_positie, formaat_object)
SELECT geom, datum_aangemaakt, datum_gewijzigd, soort, "label", object_id, rotatie, fotografie_id, opmerking, parent_deleted, self_deleted, label_positie, formaat_object
FROM objecten.points_of_interest
WHERE soort IN ('Omvormer', 'Stuwrichting ventilaties');

DELETE FROM objecten.points_of_interest WHERE soort IN ('Omvormer', 'Stuwrichting ventilaties');
DELETE FROM objecten.points_of_interest_type WHERE symbol_name IN ('poi025', 'poi040');

UPDATE objecten.afw_binnendekking_type SET tabbladen = jsonb_build_object('Bouwlaag', tabbladen::jsonb -> 'Bouwlaag')::json;
UPDATE objecten.ruimten_type SET tabbladen = jsonb_build_object('Bouwlaag', tabbladen::jsonb -> 'Bouwlaag')::json;
UPDATE objecten.veiligh_bouwk_type SET tabbladen = jsonb_build_object('Bouwlaag', tabbladen::jsonb -> 'Bouwlaag')::json;

UPDATE objecten.bereikbaarheid_type SET tabbladen = (tabbladen::jsonb - 'Bouwlaag')::json;
UPDATE objecten.gebiedsgerichte_aanpak_type SET tabbladen = (tabbladen::jsonb - 'Bouwlaag')::json;
UPDATE objecten.isolijnen_type SET tabbladen = (tabbladen::jsonb - 'Bouwlaag')::json;
UPDATE objecten.opstelplaats_type SET tabbladen = (tabbladen::jsonb - 'Bouwlaag')::json;
UPDATE objecten.points_of_interest_type SET tabbladen = (tabbladen::jsonb - 'Bouwlaag')::json;
UPDATE objecten.sectoren_type SET tabbladen = (tabbladen::jsonb - 'Bouwlaag')::json;
UPDATE bluswater.alternatieve_type SET tabbladen = (tabbladen::jsonb - 'Bouwlaag')::json;

DO $$
DECLARE
    tabelnaam TEXT;
BEGIN
    FOREACH tabelnaam IN ARRAY ARRAY[
        'afw_binnendekking_type',
        'dreiging_type',
        'gevaarlijkestof_opslag_type',
        'ingang_type',
        'label_type',
        'ruimten_type',
        'scenario_locatie_type',
        'sleutelkluis_type',
        'veiligh_bouwk_type',
        'veiligh_install_type'
    ]
    LOOP
        EXECUTE format(
            'UPDATE objecten.%I
             SET tabbladen = (
                 (tabbladen::jsonb - ''Bouwlaag'')
                 ||
                 jsonb_build_object(
                     ''Verdieping'',
                     tabbladen::jsonb -> ''Bouwlaag''
                 )
             )::json
             WHERE tabbladen::jsonb ? ''Bouwlaag''',
            tabelnaam
        );
    END LOOP;
END $$;

CREATE OR REPLACE PROCEDURE mobiel_sync.push_objecten()
LANGUAGE plpgsql
AS $procedure$
BEGIN

    UPDATE objecten."object" o
    SET
        datum_gewijzigd = clock_timestamp(),
        basisreg_identifier = m.basisreg_identifier,
        formelenaam = m.formelenaam,
        bijzonderheden = m.bijzonderheden,
        pers_max = m.pers_max,
        pers_nietz_max = m.pers_nietz_max,
        datum_geldig_tot = m.datum_geldig_tot,
        datum_geldig_vanaf = m.datum_geldig_vanaf,
        bron = m.bron,
        bron_tabel = m.bron_tabel,
        fotografie_id = m.fotografie_id,
        bodemgesteldheid_type_id = m.bodemgesteldheid_type_id,
        min_bouwlaag = m.min_bouwlaag,
        max_bouwlaag = m.max_bouwlaag,
        "share" = m."share"
    FROM mobiel.objecten m
    WHERE o.id = m.id
      AND o.self_deleted = 'infinity'::timestamptz
      AND (
          o.basisreg_identifier IS DISTINCT FROM m.basisreg_identifier
          OR o.formelenaam IS DISTINCT FROM m.formelenaam
          OR o.bijzonderheden IS DISTINCT FROM m.bijzonderheden
          OR o.pers_max IS DISTINCT FROM m.pers_max
          OR o.pers_nietz_max IS DISTINCT FROM m.pers_nietz_max
          OR o.datum_geldig_tot IS DISTINCT FROM m.datum_geldig_tot
          OR o.datum_geldig_vanaf IS DISTINCT FROM m.datum_geldig_vanaf
          OR o.bron IS DISTINCT FROM m.bron
          OR o.bron_tabel IS DISTINCT FROM m.bron_tabel
          OR o.fotografie_id IS DISTINCT FROM m.fotografie_id
          OR o.bodemgesteldheid_type_id IS DISTINCT FROM m.bodemgesteldheid_type_id
          OR o.min_bouwlaag IS DISTINCT FROM m.min_bouwlaag
          OR o.max_bouwlaag IS DISTINCT FROM m.max_bouwlaag
          OR o."share" IS DISTINCT FROM m."share"
      );

END;
$procedure$;

DO $$
DECLARE
    r record;
BEGIN
    FOR r IN
        SELECT
            n.nspname,
            c.relname,
            t.tgname
        FROM pg_trigger t
        JOIN pg_class c ON c.oid = t.tgrelid
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE NOT t.tgisinternal
          AND n.nspname = 'objecten'
          AND t.tgname = 'trg_set_delete_after_parent'
    LOOP
        EXECUTE format(
            'DROP TRIGGER %I ON %I.%I',
            r.tgname,
            r.nspname,
            r.relname
        );
    END LOOP;
END;
$$;


--Herstel verwijderde bouwlaag
CREATE OR REPLACE PROCEDURE objecten.undo_verwijder_bouwlaag(
    p_bouwlaag_id integer
)
LANGUAGE plpgsql
AS $$
BEGIN

    -- Bouwlaag zelf
    UPDATE objecten.bouwlagen
    SET self_deleted = 'infinity'
    WHERE id = p_bouwlaag_id;

    -- Direct gekoppelde tabellen
    UPDATE objecten.aanwezig
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    UPDATE objecten.afw_binnendekking
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    UPDATE objecten.dreiging
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    UPDATE objecten.gevaarlijkestof_opslag
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    UPDATE objecten.ingang
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    UPDATE objecten."label"
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    UPDATE objecten.ruimten
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    UPDATE objecten.scenario_locatie
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    UPDATE objecten.sleutelkluis
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    UPDATE objecten.veiligh_bouwk
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    UPDATE objecten.veiligh_install
    SET self_deleted = 'infinity'
    WHERE bouwlaag_id = p_bouwlaag_id;

    -- Scenario's via scenario_locatie
    UPDATE objecten.scenario s
    SET self_deleted = 'infinity'
    FROM objecten.scenario_locatie sl
    WHERE s.scenario_locatie_id = sl.id
      AND sl.bouwlaag_id = p_bouwlaag_id;

    -- Gevaarlijke stoffen via gevaarlijkestof_opslag
    UPDATE objecten.gevaarlijkestof g
    SET self_deleted = 'infinity'
    FROM objecten.gevaarlijkestof_opslag go
    WHERE g.opslag_id = go.id
      AND go.bouwlaag_id = p_bouwlaag_id;

END;
$$;

DROP MATERIALIZED VIEW objecten.mview_label_bouwlaag;
CREATE MATERIALIZED VIEW objecten.mview_label_bouwlaag
TABLESPACE pg_default
AS WITH base AS (
         SELECT row_number() OVER (ORDER BY d.id) AS gid,
            d.id,
            d.geom,
            d.datum_aangemaakt,
            d.datum_gewijzigd,
            concat(vt.prefix, d.omschrijving)::character varying(254) AS omschrijving,
            replace(concat(vt.prefix, d.omschrijving)::character varying(254)::text, '\'::text, '
'::text) AS omschrijving_gs,
            d.opmerking,
            d.soort,
            d.rotatie,
            d.verdieping_id AS bouwlaag_id,
            round(st_x(d.geom)) AS x,
            round(st_y(d.geom)) AS y,
            o.formelenaam,
            o.id AS object_id,
            b.verdieping AS bouwlaag,
            b.bouwdeel,
            vt.style_ids,
                CASE
                    WHEN d.formaat_verdieping = 'klein'::algemeen.formaat THEN vt.size_verdieping_klein
                    WHEN d.formaat_verdieping = 'middel'::algemeen.formaat THEN vt.size_verdieping_middel
                    WHEN d.formaat_verdieping = 'groot'::algemeen.formaat THEN vt.size_verdieping_groot
                    ELSE NULL::numeric
                END AS size,
            o.share,
            last_hist.typeobject,
            '#'::text || "right"(s.lijnkleur::text, 6) AS lijnkleur
           FROM objecten.object o
             JOIN LATERAL ( SELECT h.typeobject,
                    h.status
                   FROM objecten.historie h
                  WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
                  ORDER BY h.datum_aangemaakt DESC
                 LIMIT 1) last_hist ON true
             JOIN objecten.terrein t ON o.id = t.object_id AND t.self_deleted = 'infinity'::timestamp with time zone
             JOIN objecten.verdiepingen b ON st_intersects(t.geom, b.geom) AND b.self_deleted = 'infinity'::timestamp with time zone
             JOIN objecten.label d ON d.verdieping_id = b.id AND d.self_deleted = 'infinity'::timestamp with time zone
             JOIN objecten.label_type vt ON d.soort::text = vt.naam::text
             JOIN algemeen.styles s ON d.soort::text = s.soortnaam::text
          WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
        ), split_lines AS (
         SELECT base_1.gid,
            base_1.id,
            base_1.geom,
            base_1.datum_aangemaakt,
            base_1.datum_gewijzigd,
            base_1.omschrijving,
            base_1.omschrijving_gs,
            base_1.opmerking,
            base_1.soort,
            base_1.rotatie,
            base_1.bouwlaag_id,
            base_1.x,
            base_1.y,
            base_1.formelenaam,
            base_1.object_id,
            base_1.bouwlaag,
            base_1.bouwdeel,
            base_1.style_ids,
            base_1.size,
            base_1.share,
            base_1.typeobject,
            base_1.lijnkleur,
            unnest(string_to_array(base_1.omschrijving_gs, '
'::text)) AS line
           FROM base base_1
        ), line_metrics AS (
         SELECT split_lines.id,
            split_lines.geom,
            split_lines.rotatie,
            split_lines.size,
            max(char_length(split_lines.line)) AS max_length,
            count(*) AS n_lines
           FROM split_lines
          GROUP BY split_lines.id, split_lines.geom, split_lines.rotatie, split_lines.size
        ), label_boxes AS (
         SELECT b.id,
            st_rotate(st_makeenvelope(st_x(b.geom) - (b.max_length::numeric * b.size * 0.3)::double precision - 1::double precision, st_y(b.geom) - (b.n_lines::numeric * b.size * 1.0 / 2::numeric)::double precision - 1::double precision, st_x(b.geom) + (b.max_length::numeric * b.size * 0.3)::double precision + 1::double precision, st_y(b.geom) + (b.n_lines::numeric * b.size * 1.0 / 2::numeric)::double precision, st_srid(b.geom)), radians((360 - COALESCE(b.rotatie, 0))::double precision), b.geom) AS label_box
           FROM line_metrics b
        )
 SELECT base.gid,
    base.id,
    base.geom,
    base.datum_aangemaakt,
    base.datum_gewijzigd,
    base.omschrijving,
    base.omschrijving_gs,
    base.opmerking,
    base.soort,
    base.rotatie,
    base.bouwlaag_id,
    base.x,
    base.y,
    base.formelenaam,
    base.object_id,
    base.bouwlaag,
    base.bouwdeel,
    base.style_ids,
    base.size,
    base.share,
    base.typeobject,
    base.lijnkleur,
    lb.label_box
   FROM base
     JOIN label_boxes lb USING (id)
WITH DATA;

-- View indexes:
CREATE INDEX mview_label_bouwlaag_bouwlaag_idx ON objecten.mview_label_bouwlaag USING btree (bouwlaag);
CREATE INDEX mview_label_bouwlaag_geom_idx ON objecten.mview_label_bouwlaag USING gist (geom);
CREATE UNIQUE INDEX mview_label_bouwlaag_gid_idx ON objecten.mview_label_bouwlaag USING btree (gid);
CREATE INDEX mview_label_bouwlaag_id_bouwlaag_idx ON objecten.mview_label_bouwlaag USING btree (bouwlaag_id);
CREATE INDEX mview_label_bouwlaag_object_id_idx ON objecten.mview_label_bouwlaag USING btree (object_id);


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 7;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 3707; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();