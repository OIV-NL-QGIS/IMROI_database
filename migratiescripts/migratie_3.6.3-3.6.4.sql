SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

DELETE FROM algemeen.styles WHERE laagnaam = 'isolijnen' and soortnaam= '-3';

INSERT INTO algemeen.styles (id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
	VALUES(141, 'Bereikbaarheid', 'poort_bottom', 2.4, '#ff000000', 'solid'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'round'::algemeen.eindstijl_type);
INSERT INTO algemeen.styles (id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
	VALUES(142, 'Bereikbaarheid', 'poort_top', 2, '#ffffffff', 'solid'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'round'::algemeen.eindstijl_type);

INSERT INTO algemeen.styles (id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
VALUES(143, 'Bereikbaarheid', 'oever-kade-bereikbaar', 0.3, '#ff58b65c', 'markbordered'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'flat'::algemeen.eindstijl_type);

INSERT INTO algemeen.styles (id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
VALUES(144, 'Bereikbaarheid', 'oever-kade-niet-bereikbaar', 0.3, '#ffe31a1c', 'markbordered'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'flat'::algemeen.eindstijl_type);
	
INSERT INTO objecten.bereikbaarheid_type (id, naam, style_ids) VALUES(30, 'poort', '141,140');
INSERT INTO objecten.bereikbaarheid_type (id, naam, style_ids) VALUES(31, 'oever-kade-bereikbaar', '142');
INSERT INTO objecten.bereikbaarheid_type (id, naam, style_ids) VALUES(32, 'oever-kade-niet-bereikbaar', '143');

CREATE OR REPLACE VIEW mobiel.werkvoorraad_objecten
AS SELECT DISTINCT o.id,
    o.geom,
    sub.object_id,
    part.typeobject
   FROM ( SELECT DISTINCT werkvoorraad_punt.object_id
           FROM mobiel.werkvoorraad_punt
          WHERE werkvoorraad_punt.object_id IS NOT NULL
        UNION
         SELECT DISTINCT werkvoorraad_label.object_id
           FROM mobiel.werkvoorraad_label
          WHERE werkvoorraad_label.object_id IS NOT NULL
        UNION
         SELECT DISTINCT werkvoorraad_lijn.object_id
           FROM mobiel.werkvoorraad_lijn
          WHERE werkvoorraad_lijn.object_id IS NOT NULL
        UNION
         SELECT DISTINCT werkvoorraad_vlak.object_id
           FROM mobiel.werkvoorraad_vlak
          WHERE werkvoorraad_vlak.object_id IS NOT NULL
        UNION
         SELECT DISTINCT t.object_id
           FROM mobiel.werkvoorraad_punt w
             JOIN objecten.bouwlagen b ON w.bouwlaag_id = b.id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w.bouwlaag_id IS NOT NULL
        UNION
         SELECT DISTINCT t.object_id
           FROM mobiel.werkvoorraad_label w
             JOIN objecten.bouwlagen b ON w.bouwlaag_id = b.id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w.bouwlaag_id IS NOT NULL
        UNION
         SELECT DISTINCT t.object_id
           FROM mobiel.werkvoorraad_lijn w
             JOIN objecten.bouwlagen b ON w.bouwlaag_id = b.id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w.bouwlaag_id IS NOT NULL
        UNION
         SELECT DISTINCT t.object_id
           FROM mobiel.werkvoorraad_vlak w
             JOIN objecten.bouwlagen b ON w.bouwlaag_id = b.id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w.bouwlaag_id IS NOT NULL) sub
     JOIN objecten.object o ON sub.object_id = o.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  	 WHERE o.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS mobiel.symbolen;
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
    sub.label
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
            vt.size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
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
            vt.size,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
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
            vt.size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
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
            vt.size_object,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
           FROM objecten.dreiging v
             JOIN objecten.dreiging_type vt ON v.dreiging_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.handelingsaanwijzing) d)) AS waarden_new,
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
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
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
            vt.size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
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
            vt.size_object,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
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
            vt.size,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
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
            i.bouwlaag_id,
            v.rotatie,
            vt.size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
           FROM objecten.sleutelkluis v
             JOIN objecten.ingang i ON v.ingang_id = i.id
             JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE i.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.aanduiding_locatie) d)) AS waarden_new,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            i.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            vt.size_object,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
           FROM objecten.sleutelkluis v
             JOIN objecten.ingang i ON v.ingang_id = i.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE i.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
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
            vt.size,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label
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
            CASE WHEN object_id IS NOT NULL THEN 'object'::TEXT
            	 WHEN bouwlaag_id IS NOT NULL THEN 'bouwlaag'
            	 ELSE ''::TEXT 
            END AS binnen_buiten,
            'werkvoorraad'::text AS bron,
            werkvoorraad_punt.datum_aangemaakt,
            werkvoorraad_punt.datum_gewijzigd,
            werkvoorraad_punt.label
           FROM mobiel.werkvoorraad_punt) sub;

DROP TRIGGER IF EXISTS trg_symbolen_del ON mobiel.symbolen;
CREATE TRIGGER trg_symbolen_del INSTEAD OF
DELETE
    ON
    mobiel.symbolen FOR EACH ROW EXECUTE FUNCTION mobiel.funct_symbol_delete();

DROP TRIGGER IF EXISTS trg_symbolen_upd ON mobiel.symbolen;
CREATE TRIGGER trg_symbolen_upd INSTEAD OF
UPDATE
    ON
    mobiel.symbolen FOR EACH ROW EXECUTE FUNCTION mobiel.funct_symbol_update();

DROP TRIGGER IF EXISTS trg_lijnen_del ON mobiel.lijnen;
CREATE TRIGGER trg_lijnen_del INSTEAD OF
DELETE
    ON
    mobiel.lijnen FOR EACH ROW EXECUTE FUNCTION mobiel.funct_lijn_delete();

DROP TRIGGER IF EXISTS trg_lijnen_upd ON mobiel.lijnen;
CREATE TRIGGER trg_lijnen_upd INSTEAD OF
UPDATE
    ON
    mobiel.lijnen FOR EACH ROW EXECUTE FUNCTION mobiel.funct_lijn_update();

DROP TRIGGER IF EXISTS trg_vlakken_del ON mobiel.vlakken;
CREATE TRIGGER trg_vlakken_del INSTEAD OF
DELETE
    ON
    mobiel.vlakken FOR EACH ROW EXECUTE FUNCTION mobiel.funct_vlak_delete();

DROP TRIGGER IF EXISTS trg_vlakken_upd ON mobiel.vlakken;
CREATE TRIGGER trg_vlakken_upd INSTEAD OF
UPDATE
    ON
    mobiel.vlakken FOR EACH ROW EXECUTE FUNCTION mobiel.funct_vlak_update();

DROP TRIGGER IF EXISTS trg_labels_del ON mobiel.labels;
CREATE TRIGGER trg_labels_del INSTEAD OF
DELETE
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel.funct_label_delete();

DROP TRIGGER IF EXISTS trg_labels_upd ON mobiel.labels;
CREATE TRIGGER trg_labels_upd INSTEAD OF
UPDATE
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel.funct_label_update();

DROP TRIGGER IF EXISTS trg_set_upd ON mobiel.werkvoorraad_label;
DROP TRIGGER IF EXISTS trg_set_upd ON mobiel.werkvoorraad_punt;
DROP TRIGGER IF EXISTS trg_set_upd ON mobiel.werkvoorraad_lijn;
DROP TRIGGER IF EXISTS trg_set_upd ON mobiel.werkvoorraad_vlak;

-- DROP FUNCTION mobiel.complement_record_punt();

CREATE OR REPLACE FUNCTION mobiel.complement_record_punt()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE 
    	objectid integer := NULL;
    	bouwlaagid integer := NULL;
    BEGIN 
	    IF (NEW.bouwlaag_object = 'bouwlaag' OR NEW.bouwlaag_id IS NOT NULL) THEN
	    	bouwlaagid := (SELECT b.id FROM (SELECT b.id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = NEW.bouwlaag ORDER BY dist LIMIT 1) b);
	    	UPDATE mobiel.werkvoorraad_punt SET "size" = sub."size", bouwlaag_id = bouwlaagid, object_id = NULL
			FROM
			  (
			    SELECT * FROM mobiel.punten_type WHERE symbol_name = new.symbol_name AND bouwlaag_object = 'bouwlaag'
			  ) sub
			WHERE werkvoorraad_punt.id = NEW.id;
	    ELSE
	    	objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
	    	UPDATE mobiel.werkvoorraad_punt SET "size" = sub."size", object_id = objectid, bouwlaag_id = NULL
			FROM
			  (
			    SELECT * FROM mobiel.punten_type WHERE symbol_name = new.symbol_name AND bouwlaag_object = 'object'
			  ) sub
			WHERE werkvoorraad_punt.id = NEW.id;
	    END IF;
	   RETURN NULL;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION mobiel.complement_record_label()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE 
    	objectid integer := NULL;
    	bouwlaagid integer := NULL;
    BEGIN 
	    IF (NEW.bouwlaag_object = 'bouwlaag' OR NEW.bouwlaag_id IS NOT NULL) THEN
	    	bouwlaagid := (SELECT b.id FROM (SELECT b.id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = NEW.bouwlaag ORDER BY dist LIMIT 1) b);
	    	UPDATE mobiel.werkvoorraad_label SET "size" = sub."size", bouwlaag_id = bouwlaagid, object_id = NULL
			FROM
			  (
			    SELECT * FROM mobiel.label_type WHERE symbol_name = new.symbol_name AND bouwlaag_object = 'bouwlaag'
			  ) sub
			WHERE werkvoorraad_label.id = NEW.id;
	    ELSE
	    	objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
	    	UPDATE mobiel.werkvoorraad_label SET "size" = sub."size", object_id = objectid, bouwlaag_id = NULL
			FROM
			  (
			    SELECT * FROM mobiel.label_type WHERE symbol_name = new.symbol_name AND bouwlaag_object = 'object'
			  ) sub
			WHERE werkvoorraad_label.id = NEW.id;
	    END IF;
	   RETURN NULL;
    END;
    $function$
;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 364; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
