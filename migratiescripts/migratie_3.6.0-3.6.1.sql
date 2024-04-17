SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE OR REPLACE FUNCTION objecten.set_delete_timestamp_info_of_interest()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
      command text := ' SET datum_deleted = now() WHERE id = $1';
    BEGIN
      EXECUTE 'UPDATE "' || TG_TABLE_SCHEMA || '"."' || TG_TABLE_NAME || '" ' || command USING OLD.id;
      RETURN NULL;
    END;
  $function$
;

ALTER TABLE bluswater.alternatieve ALTER COLUMN self_deleted SET DEFAULT 'infinity';
UPDATE bluswater.alternatieve SET self_deleted = 'infinity' WHERE self_deleted IS NULL;

DROP TRIGGER trg_set_delete ON info_of_interest.labels_of_interest;
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    info_of_interest.labels_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp_info_of_interest();

DROP TRIGGER trg_set_delete ON info_of_interest.lines_of_interest;
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    info_of_interest.lines_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp_info_of_interest();
    
DROP TRIGGER trg_set_delete ON info_of_interest.points_of_interest;
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    info_of_interest.points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp_info_of_interest();

DROP TABLE IF EXISTS mobiel.annotaties;
CREATE TABLE mobiel.annotaties (
	id serial NOT NULL PRIMARY KEY,
	geom public.geometry(point, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	tekst text NOT NULL,
	plaatsing int DEFAULT 0,
	self_deleted timestamptz NULL DEFAULT 'infinity'::timestamp with time zone
);
CREATE INDEX annotaties_geom_gist ON mobiel.annotaties USING btree (geom);

CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    mobiel.annotaties FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    mobiel.annotaties FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    mobiel.annotaties FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

CREATE OR REPLACE VIEW mobiel.bouwlagen_binnen_object
AS SELECT DISTINCT sub.object_id,
    sub.bouwlaag
   FROM ( 
         SELECT DISTINCT t.object_id,
            w.bouwlaag
           FROM mobiel.werkvoorraad_punt w
             JOIN objecten.terrein t ON st_intersects(w.geom, t.geom)
          WHERE w.object_id IS NULL
          GROUP BY t.object_id, w.bouwlaag
        UNION
         SELECT DISTINCT t.object_id,
            w.bouwlaag
           FROM mobiel.werkvoorraad_label w
             JOIN objecten.terrein t ON st_intersects(w.geom, t.geom)
          WHERE w.object_id IS NULL
          GROUP BY t.object_id, w.bouwlaag
        UNION
         SELECT DISTINCT t.object_id,
            w.bouwlaag
           FROM mobiel.werkvoorraad_lijn w
             JOIN objecten.terrein t ON st_intersects(w.geom, t.geom)
          WHERE w.object_id IS NULL
          GROUP BY t.object_id, w.bouwlaag
        UNION
         SELECT DISTINCT t.object_id,
            w.bouwlaag
           FROM mobiel.werkvoorraad_vlak w
             JOIN objecten.terrein t ON st_intersects(w.geom, t.geom)
          WHERE w.object_id IS NULL
          GROUP BY t.object_id, w.bouwlaag
         ) sub;

CREATE OR REPLACE VIEW mobiel.object_binnen_bouwlaag AS
	SELECT DISTINCT b.pand_id, t.object_id FROM objecten.bouwlagen b 
	INNER JOIN objecten.terrein t ON ST_INTERSECTS(b.geom, t.geom)
	WHERE object_id IN 
	(
		SELECT DISTINCT object_id FROM mobiel.werkvoorraad_punt w
		UNION
		SELECT DISTINCT object_id FROM mobiel.werkvoorraad_label lb
		UNION
		SELECT DISTINCT object_id FROM mobiel.werkvoorraad_lijn l
		UNION
		SELECT DISTINCT object_id FROM mobiel.werkvoorraad_vlak v
	);

CREATE OR REPLACE VIEW mobiel.symbolen
AS SELECT row_number() OVER (ORDER BY sub.id) AS id,
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
    sub.binnen_buiten
   FROM ( SELECT werkvoorraad_punt.id,
            werkvoorraad_punt.geom,
            werkvoorraad_punt.waarden_new,
            werkvoorraad_punt.operatie,
            werkvoorraad_punt.brontabel,
            werkvoorraad_punt.bron_id,
            werkvoorraad_punt.object_id,
            werkvoorraad_punt.bouwlaag_id,
            werkvoorraad_punt.rotatie,
            werkvoorraad_punt.size,
            werkvoorraad_punt.symbol_name,
            werkvoorraad_punt.bouwlaag,
            ''::text AS binnen_buiten,
            'werkvoorraad'::text AS bron
           FROM mobiel.werkvoorraad_punt
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.bijzonderheid) d)) AS waarden_new,
            ''::character varying AS operatie,
            'veiligh_install'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.veiligh_install v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.veiligh_install_type vt ON v.veiligh_install_type_id = vt.id
          WHERE v.self_deleted = 'infinity'
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.bijzonderheid) d)) AS waarden_new,
            ''::character varying AS operatie,
            'veiligh_ruimtelijk'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.veiligh_ruimtelijk v
             JOIN objecten.veiligh_ruimtelijk_type vt ON v.veiligh_ruimtelijk_type_id = vt.id
          WHERE v.self_deleted = 'infinity'
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.omschrijving) d)) AS waarden_new,
            ''::character varying AS operatie,
            'dreiging'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.dreiging v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.dreiging_type vt ON v.dreiging_type_id = vt.id
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.omschrijving) d)) AS waarden_new,
            ''::character varying AS operatie,
            'dreiging'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.dreiging v
             JOIN objecten.dreiging_type vt ON v.dreiging_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.handelingsaanwijzing) d)) AS waarden_new,
            ''::character varying AS operatie,
            'afw_binnendekking'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.afw_binnendekking v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.afw_binnendekking_type vt ON v.soort::text = vt.naam::text
          WHERE v.self_deleted = 'infinity'
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.belemmering,
                            v.voorzieningen) d)) AS waarden_new,
            ''::character varying AS operatie,
            'ingang'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.ingang v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.ingang_type vt ON v.ingang_type_id = vt.id
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.belemmering,
                            v.voorzieningen) d)) AS waarden_new,
            ''::character varying AS operatie,
            'ingang'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.ingang v
             JOIN objecten.ingang_type vt ON v.ingang_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label) d)) AS waarden_new,
            ''::character varying AS operatie,
            'opstelplaats'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.opstelplaats v
             JOIN objecten.opstelplaats_type vt ON v.soort::text = vt.naam::text
          WHERE v.self_deleted = 'infinity'
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.aanduiding_locatie) d)) AS waarden_new,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            i.bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.sleutelkluis v
             JOIN objecten.ingang i ON v.ingang_id = i.id
             JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE i.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.aanduiding_locatie) d)) AS waarden_new,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            i.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.sleutelkluis v
             JOIN objecten.ingang i ON v.ingang_id = i.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE i.object_id IS NOT NULL AND v.self_deleted = 'infinity'
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.bijzonderheid) d)) AS waarden_new,
            ''::character varying AS operatie,
            'points_of_interest'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.points_of_interest v
             JOIN objecten.points_of_interest_type vt ON v.points_of_interest_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity') sub;

CREATE OR REPLACE VIEW mobiel.vlakken
AS SELECT row_number() OVER (ORDER BY sub.id) AS id,
    sub.geom,
    sub.waarden_new,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.binnen_buiten
   FROM ( SELECT werkvoorraad_vlak.id,
            werkvoorraad_vlak.geom,
            werkvoorraad_vlak.waarden_new,
            werkvoorraad_vlak.operatie,
            werkvoorraad_vlak.brontabel,
            werkvoorraad_vlak.bron_id,
            werkvoorraad_vlak.object_id,
            werkvoorraad_vlak.bouwlaag_id,
            werkvoorraad_vlak.symbol_name,
            werkvoorraad_vlak.bouwlaag,
            'werkvoorraad'::text AS bron,
            ''::text AS binnen_buiten
           FROM mobiel.werkvoorraad_vlak
        UNION ALL
         SELECT b.id,
            b.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT b.omschrijving) d)) AS waarden_new,
            ''::character varying AS "varchar",
            'sectoren'::character varying AS "varchar",
            b.id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS binnen_buiten
           FROM objecten.sectoren b
             JOIN objecten.sectoren_type bt ON b.soort::text = bt.naam::TEXT
           WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'
        UNION ALL
         SELECT b.id,
            b.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT b.omschrijving) d)) AS waarden_new,
            ''::character varying AS "varchar",
            'ruimten'::character varying AS "varchar",
            b.id,
            NULL::integer AS object_id,
            b.bouwlaag_id,
            b.ruimten_type_id,
            bl.bouwlaag,
            'oiv'::text AS bron,
            'bouwlaag'::text AS binnen_buiten
           FROM objecten.ruimten b
             JOIN objecten.bouwlagen bl ON b.bouwlaag_id = bl.id
             JOIN objecten.ruimten_type bt ON b.ruimten_type_id = bt.naam
           WHERE b.bouwlaag_id IS NOT NULL AND b.self_deleted = 'infinity') sub;

CREATE OR REPLACE VIEW mobiel.lijnen
AS SELECT row_number() OVER (ORDER BY sub.id) AS id,
    sub.geom,
    sub.waarden_new,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.binnen_buiten
   FROM ( SELECT werkvoorraad_lijn.id,
            werkvoorraad_lijn.geom,
            werkvoorraad_lijn.waarden_new,
            werkvoorraad_lijn.operatie,
            werkvoorraad_lijn.brontabel,
            werkvoorraad_lijn.bron_id,
            werkvoorraad_lijn.object_id,
            werkvoorraad_lijn.bouwlaag_id,
            werkvoorraad_lijn.symbol_name,
            werkvoorraad_lijn.bouwlaag,
            'werkvoorraad'::text AS bron,
            ''::text AS binnen_buiten
           FROM mobiel.werkvoorraad_lijn
        UNION ALL
         SELECT b.id,
            b.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT b.label,
                            b.obstakels,
                            b.wegafzetting) d)) AS waarden_new,
            ''::character varying AS operatie,
            'bereikbaarheid'::character varying AS brontabel,
            b.id AS bron_id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS binnen_buiten
           FROM objecten.bereikbaarheid b
             JOIN objecten.bereikbaarheid_type bt ON b.soort::text = bt.naam::TEXT
           WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'
        UNION ALL
         SELECT b.id,
            b.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT b.label,
                            b.bijzonderheden) d)) AS waarden_new,
            ''::character varying AS operatie,
            'gebiedsgerichte_aanpak'::character varying AS brontabel,
            b.id AS bron_id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS binnen_buiten
           FROM objecten.gebiedsgerichte_aanpak b
             JOIN objecten.gebiedsgerichte_aanpak_type bt ON b.soort::text = bt.naam::TEXT
           WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'
        UNION ALL
         SELECT b.id,
            b.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT b.omschrijving) d)) AS waarden_new,
            ''::character varying AS operatie,
            'isolijnen'::character varying AS brontabel,
            b.id AS bron_id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.hoogte::character varying AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS binnen_buiten
           FROM objecten.isolijnen b
             JOIN objecten.isolijnen_type bt ON b.hoogte::text = bt.naam::TEXT
           WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'
        UNION ALL
         SELECT b.id,
            b.geom,
            NULL::json AS waarden_new,
            ''::character varying AS operatie,
            'veiligh_bouwk'::character varying AS brontabel,
            b.id AS bron_id,
            NULL::integer AS object_id,
            b.bouwlaag_id,
            b.soort AS symbol_name,
            bl.bouwlaag,
            'oiv'::text AS bron,
            'bouwlaag'::text AS binnen_buiten
           FROM objecten.veiligh_bouwk b
             JOIN objecten.bouwlagen bl ON b.bouwlaag_id = bl.id
             JOIN objecten.veiligh_bouwk_type bt ON b.soort::text = bt.naam::TEXT
           WHERE b.bouwlaag_id IS NOT NULL AND b.self_deleted = 'infinity') sub;

CREATE OR REPLACE VIEW mobiel.labels
AS SELECT row_number() OVER (ORDER BY sub.id) AS id,
    sub.geom,
    sub.waarden_new,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.omschrijving,
    sub.rotatie,
    sub.size,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.binnen_buiten
   FROM ( SELECT werkvoorraad_label.id,
            werkvoorraad_label.geom,
            werkvoorraad_label.waarden_new,
            werkvoorraad_label.operatie,
            werkvoorraad_label.brontabel,
            werkvoorraad_label.bron_id,
            werkvoorraad_label.object_id,
            werkvoorraad_label.bouwlaag_id,
            werkvoorraad_label.omschrijving,
            werkvoorraad_label.rotatie,
            werkvoorraad_label.size,
            werkvoorraad_label.symbol_name,
            werkvoorraad_label.bouwlaag,
            ''::text AS binnen_buiten,
            'werkvoorraad'::text AS bron
           FROM mobiel.werkvoorraad_label
        UNION ALL
         SELECT l.id,
            l.geom,
            NULL::json AS json,
            ''::character varying AS "varchar",
            'label'::character varying AS "varchar",
            l.id,
            NULL::integer AS object_id,
            l.bouwlaag_id,
            l.omschrijving,
            l.rotatie,
            lt.size,
            lt.symbol_name,
            bl.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.label l
             JOIN objecten.bouwlagen bl ON l.bouwlaag_id = bl.id
             JOIN objecten.label_type lt ON l.soort::text = lt.naam::TEXT
           WHERE l.bouwlaag_id IS NOT NULL AND l.self_deleted = 'infinity'
        UNION ALL
         SELECT l.id,
            l.geom,
            NULL::json AS json,
            ''::character varying AS "varchar",
            'label'::character varying AS "varchar",
            l.id,
            l.object_id,
            NULL::integer AS bouwlaag_id,
            l.omschrijving,
            l.rotatie,
            lt.size,
            lt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.label l
             JOIN objecten.label_type lt ON l.soort::text = lt.naam::TEXT
           WHERE l.object_id IS NOT NULL AND l.self_deleted = 'infinity') sub;

CREATE OR REPLACE VIEW mobiel.werkvoorraad_bouwlagen
AS SELECT DISTINCT sub.bouwlaag_id,
    b.pand_id
   FROM objecten.bouwlagen b
     JOIN ( SELECT DISTINCT werkvoorraad_punt.bouwlaag_id
           FROM mobiel.werkvoorraad_punt
          WHERE werkvoorraad_punt.bouwlaag_id IS NOT NULL
        UNION
         SELECT DISTINCT werkvoorraad_label.bouwlaag_id
           FROM mobiel.werkvoorraad_label
          WHERE werkvoorraad_label.bouwlaag_id IS NOT NULL
        UNION
         SELECT DISTINCT werkvoorraad_lijn.bouwlaag_id
           FROM mobiel.werkvoorraad_lijn
          WHERE werkvoorraad_lijn.bouwlaag_id IS NOT NULL
        UNION
         SELECT DISTINCT werkvoorraad_vlak.bouwlaag_id
           FROM mobiel.werkvoorraad_vlak
          WHERE werkvoorraad_vlak.bouwlaag_id IS NOT NULL) sub ON b.id = sub.bouwlaag_id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 1;
UPDATE algemeen.applicatie SET db_versie = 360; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();