SET ROLE oiv_admin;

DROP TYPE IF EXISTS algemeen.tabbladen;

UPDATE objecten.afw_binnendekking_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.bereikbaarheid_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.dreiging_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.gebiedsgerichte_aanpak_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.gevaarlijkestof_opslag_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.ingang_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.isolijnen_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.label_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.opstelplaats_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.points_of_interest_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.ruimten_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.scenario_locatie_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.sectoren_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.sleutelkluis_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.veiligh_bouwk_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.veiligh_install_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE objecten.veiligh_ruimtelijk_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;
UPDATE bluswater.alternatieve_type set tabbladen = '{"Bouwlaag": 1}' :: jsonb || tabbladen::jsonb;

CREATE OR REPLACE VIEW mobiel.symbol_types AS
SELECT 
row_number() OVER (ORDER BY sub.naam) AS id, sub.* FROM
(
SELECT naam, symbol_name, size_bouwlaag_klein AS size_klein, size_bouwlaag_middel AS size_middel, size_bouwlaag_groot AS size_groot, symbol_type, 
		anchorpoint, 'Bereikbaarheid' AS categorie, 'bouwlaag' AS bouwlaag_object, 'afw_binnendekking' AS brontabel  FROM objecten.afw_binnendekking_type
WHERE actief_bouwlaag = TRUE
UNION ALL
SELECT naam, symbol_name, size_bouwlaag_klein, size_bouwlaag_middel, size_bouwlaag_groot, symbol_type,
		anchorpoint, 'Dreiging' AS categorie, 'bouwlaag' AS bouwlaag_object, 'dreiging' AS brontabel FROM objecten.dreiging_type
WHERE actief_bouwlaag = TRUE
UNION ALL
SELECT naam, symbol_name, size_object_klein, size_object_middel, size_object_groot, symbol_type,
		anchorpoint, 'Dreiging' AS categorie, 'object' AS bouwlaag_object, 'dreiging' AS brontabel FROM objecten.dreiging_type
WHERE actief_ruimtelijk = TRUE
UNION ALL
SELECT naam, symbol_name, size_bouwlaag_klein, size_bouwlaag_middel, size_bouwlaag_groot, symbol_type,
		anchorpoint, 'Toegang' AS categorie, 'bouwlaag' AS bouwlaag_object, 'ingang' AS brontabel FROM objecten.ingang_type
WHERE actief_bouwlaag = TRUE
UNION ALL
SELECT naam, symbol_name, size_object_klein, size_object_middel, size_object_groot, symbol_type,
		anchorpoint, 'Toegang' AS categorie, 'object' AS bouwlaag_object, 'ingang' AS brontabel FROM objecten.ingang_type
WHERE actief_ruimtelijk = TRUE
UNION ALL
SELECT naam, symbol_name, size_object_klein, size_object_middel, size_object_groot, symbol_type,
		anchorpoint, 'Opstelplaats' AS categorie, 'object' AS bouwlaag_object, 'opstelplaats' AS brontabel FROM objecten.opstelplaats_type
WHERE actief_ruimtelijk = TRUE
UNION ALL
SELECT naam, symbol_name, size_object_klein, size_object_middel, size_object_groot, symbol_type,
		anchorpoint, 'Points of interest' AS categorie, 'object' AS bouwlaag_object, 'points_of_interest' AS brontabel FROM objecten.points_of_interest_type
WHERE actief_ruimtelijk = TRUE
UNION ALL
SELECT naam, symbol_name, size_bouwlaag_klein, size_bouwlaag_middel, size_bouwlaag_groot, symbol_type,
		anchorpoint, 'Sleutelkluis' AS categorie, 'bouwlaag' AS bouwlaag_object, 'sleutelkluis' AS brontabel FROM objecten.sleutelkluis_type
WHERE actief_bouwlaag = TRUE
UNION ALL
SELECT naam, symbol_name, size_object_klein, size_object_middel, size_object_groot, symbol_type,
		anchorpoint, 'Sleutelkluis' AS categorie, 'object' AS bouwlaag_object, 'sleutelkluis' AS brontabel FROM objecten.sleutelkluis_type
WHERE actief_ruimtelijk = TRUE
UNION ALL
SELECT naam, symbol_name, size_bouwlaag_klein, size_bouwlaag_middel, size_bouwlaag_groot, symbol_type,
		anchorpoint, 'Veiligheidsvoorziening' AS categorie, 'bouwlaag' AS bouwlaag_object, 'veiligh_install' AS brontabel FROM objecten.veiligh_install_type
WHERE actief_bouwlaag = TRUE
UNION ALL
SELECT naam, symbol_name, size_object_klein, size_object_middel, size_object_groot, symbol_type,
		anchorpoint, 'Veiligheidsvoorziening' AS categorie, 'object' AS bouwlaag_object, 'veiligh_install' AS brontabel FROM objecten.veiligh_install_type
WHERE actief_ruimtelijk = TRUE
) sub;

UPDATE mobiel.werkvoorraad_punt SET label_positie = 'onder - midden' WHERE label_positie IS NULL;
UPDATE mobiel.werkvoorraad_punt SET formaat_bouwlaag = 'middel' WHERE bouwlaag_id IS NOT NULL;
UPDATE mobiel.werkvoorraad_punt SET formaat_object = 'middel' WHERE object_id IS NOT NULL;

UPDATE mobiel.werkvoorraad_label SET formaat_bouwlaag = 'middel' WHERE bouwlaag_id IS NOT NULL;
UPDATE mobiel.werkvoorraad_label SET formaat_object = 'middel' WHERE object_id IS NOT NULL;

UPDATE mobiel.werkvoorraad_punt SET bouwlaag_object = 
  CASE WHEN bouwlaag_id IS NOT NULL THEN 'bouwlaag' ELSE 'object' END;
UPDATE mobiel.werkvoorraad_label SET bouwlaag_object = 
  CASE WHEN bouwlaag_id IS NOT NULL THEN 'bouwlaag' ELSE 'object' END;
UPDATE mobiel.werkvoorraad_lijn SET bouwlaag_object = 
  CASE WHEN bouwlaag_id IS NOT NULL THEN 'bouwlaag' ELSE 'object' END;
UPDATE mobiel.werkvoorraad_vlak SET bouwlaag_object = 
  CASE WHEN bouwlaag_id IS NOT NULL THEN 'bouwlaag' ELSE 'object' END;

DROP VIEW IF EXISTS mobiel.symbolen;
CREATE OR REPLACE VIEW mobiel.symbolen
AS SELECT 
	row_number() OVER () AS fid,
	concat(sub.brontabel, '_', sub.id::character varying) AS id,
    sub.geom,
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
    sub.bouwlaag_object,
    sub.id AS orig_id,
    sub.datum_aangemaakt,
    sub.datum_gewijzigd,
    sub.label,
    sub.label_positie,
    sub.formaat,
    sub.opmerking
   FROM ( SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'veiligh_install'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END AS size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag AS formaat,
            v.opmerking
           FROM objecten.veiligh_install v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.veiligh_install_type vt ON v.soort = vt.naam
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('veiligh_install', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'veiligh_install'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object AS formaat,
            v.opmerking
           FROM objecten.veiligh_install v
             JOIN objecten.veiligh_install_type vt ON v.soort = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('veiligh_install', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'dreiging'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag,
            v.opmerking
           FROM objecten.dreiging v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.dreiging_type vt ON v.soort = vt.naam
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('dreiging', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'dreiging'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object,
            v.opmerking
           FROM objecten.dreiging v
             JOIN objecten.dreiging_type vt ON v.soort = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('dreiging', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'afw_binnendekking'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag AS formaat,
            v.opmerking
           FROM objecten.afw_binnendekking v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.afw_binnendekking_type vt ON v.soort::text = vt.naam::text
          WHERE v.self_deleted = 'infinity'::timestamp with time ZONE AND CONCAT('afw_binnendekking', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'ingang'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag,
            v.opmerking
           FROM objecten.ingang v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.ingang_type vt ON v.soort = vt.naam
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('ingang', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'ingang'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object,
            v.opmerking
           FROM objecten.ingang v
             JOIN objecten.ingang_type vt ON v.soort = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('ingang', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'opstelplaats'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object,
            v.opmerking
           FROM objecten.opstelplaats v
             JOIN objecten.opstelplaats_type vt ON v.soort::text = vt.naam::text
          WHERE v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('opstelplaats', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag,
            v.opmerking
           FROM objecten.sleutelkluis v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.sleutelkluis_type vt ON v.soort = vt.naam
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('sleutelkluis', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
                UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object,
            v.opmerking
           FROM objecten.sleutelkluis v
             JOIN objecten.sleutelkluis_type vt ON v.soort = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('sleutelkluis', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'points_of_interest'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object,
            v.opmerking
           FROM objecten.points_of_interest v
             JOIN objecten.points_of_interest_type vt ON v.soort = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('points_of_interest', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT w.id,
            w.geom,
            w.operatie,
            w.brontabel,
            w.bron_id,
            w.object_id,
            w.bouwlaag_id,
            w.rotatie,
            CASE
                WHEN w.formaat_object = 'klein' THEN vt.size_klein
                WHEN w.formaat_object = 'middel' THEN vt.size_middel
                WHEN w.formaat_object = 'groot' THEN vt.size_groot
                WHEN w.formaat_bouwlaag = 'klein' THEN vt.size_klein
                WHEN w.formaat_bouwlaag = 'middel' THEN vt.size_middel
                WHEN w.formaat_bouwlaag = 'groot' THEN vt.size_groot
            END,
            w.symbol_name,
            w.bouwlaag,
            w.bouwlaag_object,
            'werkvoorraad'::text AS bron,
            w.datum_aangemaakt,
            w.datum_gewijzigd,
            w.label,
            w.label_positie,
            CASE 
	            WHEN w.object_id IS NOT NULL THEN w.formaat_object 
	            ELSE w.formaat_bouwlaag
            END,
            w.opmerking
           FROM mobiel.werkvoorraad_punt w
		   INNER JOIN mobiel.symbol_types vt ON w.symbol_name = vt.symbol_name AND w.bouwlaag_object = vt.bouwlaag_object
           ) sub;

CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_punt_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
      bouwlaagid integer := NULL;
		  objectid integer := NULL;
    BEGIN
		IF new.bouwlaag_object = 'bouwlaag' THEN
        	bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
		ELSE
			objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
		END IF;
		INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name,
            		bouwlaag, accepted, bouwlaag_object, opmerking, label, label_positie, formaat_bouwlaag, formaat_object)
		VALUES (new.geom, 'INSERT'::character varying, new.brontabel, new.bron_id, bouwlaagid, objectid, new.rotatie, new.symbol_name, new.bouwlaag, false, new.bouwlaag_object, new.opmerking, new.label,
				COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition), 
				COALESCE(CASE WHEN new.bouwlaag_object = 'bouwlaag' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat),
				COALESCE(CASE WHEN new.bouwlaag_object = 'object' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat));
        RETURN NEW;
    END;
    $function$
;

DROP FUNCTION IF EXISTS mobiel.funct_symbol_update;
CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_punt_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
		objectid integer := NULL;
    BEGIN
		IF new.bouwlaag_object != old.bouwlaag_object THEN
			IF new.bouwlaag_object = 'bouwlaag' THEN
	        	bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
			ELSE
				objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
			END IF;
		ELSE
			bouwlaagid = new.bouwlaag_id;
			objectid = new.object_id;
		END IF;
	    IF NEW.bron = 'oiv' THEN
        INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name,
                    bouwlaag, accepted, bouwlaag_object, opmerking, label, label_positie, formaat_bouwlaag, formaat_object)
        VALUES (new.geom, 'UPDATE'::character varying, new.brontabel, new.bron_id, new.bouwlaag_id, new.object_id, new.rotatie, new.symbol_name, new.bouwlaag, false, new.bouwlaag_object, new.opmerking, new.label,
            COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition), 
            COALESCE(CASE WHEN new.bouwlaag_object = 'bouwlaag' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat),
            COALESCE(CASE WHEN new.bouwlaag_object = 'object' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat));
        
        IF NOT ST_Equals(new.geom, old.geom) THEN
                  INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                      VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), new.bron_id, new.brontabel, new.bouwlaag, bouwlaagid, objectid);
        END IF;
        ELSE
        UPDATE mobiel.werkvoorraad_punt
        SET geom=NEW.geom, operatie=OLD.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, object_id=objectid, bouwlaag_id=bouwlaagid, rotatie=NEW.rotatie, symbol_name=NEW.symbol_name,
          bouwlaag_object=NEW.bouwlaag_object, label=NEW.label, label_positie=new.label_positie, opmerking=new.opmerking,
          bouwlaag=CASE WHEN new.bouwlaag_object = 'bouwlaag' THEN NEW.bouwlaag ELSE NULL END, 
          formaat_bouwlaag=COALESCE(CASE WHEN new.bouwlaag_object = 'bouwlaag' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat),
          formaat_object=COALESCE(CASE WHEN new.bouwlaag_object = 'object' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat)
        WHERE werkvoorraad_punt.id = OLD.orig_id;

        IF NOT ST_Equals(new.geom, old.geom) AND NEW.bron_id IS NOT NULL THEN
                  INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                      VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag, OLD.bouwlaag_id, OLD.object_id);
        END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

DROP FUNCTION IF EXISTS mobiel.funct_symbol_delete;
CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_punt_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name,
	            		bouwlaag, accepted, bouwlaag_object, opmerking, label, label_positie, formaat_bouwlaag, formaat_object)
  			VALUES (old.geom, 'DELETE', old.brontabel, old.bron_id, old.bouwlaag_id, old.object_id, old.rotatie, old.size, old.symbol_name,
					old.bouwlaag, FALSE, OLD.bouwlaag_object, old.opmerking, OLD.label, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_punt WHERE (id = OLD.orig_id);
			DELETE FROM mobiel.werkvoorraad_hulplijnen WHERE (bron_id = old.bron_id AND brontabel = old.brontabel);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE TRIGGER symbolen_del INSTEAD OF
DELETE
    ON
    mobiel.symbolen FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_punt_del();
CREATE TRIGGER symbolen_ins INSTEAD OF
INSERT
    ON
    mobiel.symbolen FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_punt_ins();
CREATE TRIGGER symbolen_upd INSTEAD OF
UPDATE
    ON
    mobiel.symbolen FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_punt_upd();

DROP TRIGGER trg_after_insert ON mobiel.werkvoorraad_punt;
DROP TRIGGER trg_set_upd ON mobiel.werkvoorraad_punt;
DROP FUNCTION mobiel.complement_record_punt();

CREATE OR REPLACE VIEW mobiel.label_types
AS SELECT row_number() OVER (ORDER BY sub.naam) AS id,
    sub.naam,
    sub.symbol_name,
    sub.size_klein,
    sub.size_middel,
    sub.size_groot,
    sub.categorie,
    sub.bouwlaag_object,
    sub.brontabel
   FROM ( SELECT label_type.naam,
            label_type.symbol_name,
            label_type.size_bouwlaag_klein AS size_klein,
            label_type.size_bouwlaag_middel AS size_middel,
            label_type.size_bouwlaag_groot AS size_groot,
            'Label'::text AS categorie,
            'bouwlaag'::text AS bouwlaag_object,
            'label'::text AS brontabel
           FROM objecten.label_type
          WHERE label_type.actief_bouwlaag = true
        UNION ALL
         SELECT label_type.naam,
            label_type.symbol_name,
            label_type.size_object_klein,
            label_type.size_object_middel,
            label_type.size_object_groot,
            'Label'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'label'::text AS brontabel
           FROM objecten.label_type
          WHERE label_type.actief_ruimtelijk = true) sub;

DROP VIEW IF EXISTS mobiel.labels;
CREATE OR REPLACE VIEW mobiel.labels AS
SELECT row_number() OVER (ORDER BY sub.id) AS id,
    sub.geom,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.omschrijving,
    sub.rotatie,
	sub.SIZE,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.datum_aangemaakt,
    sub.datum_gewijzigd,
    sub.bouwlaag_object,
    sub.opmerking
   FROM ( SELECT w.id,
            w.geom,
            w.operatie,
            w.brontabel,
            w.bron_id,
            w.object_id,
            w.bouwlaag_id,
            w.omschrijving,
            w.rotatie,
		    CASE
		        WHEN w.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
		        WHEN w.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
		        WHEN w.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
		        WHEN w.formaat_object = 'klein' THEN vt.size_object_klein
		        WHEN w.formaat_object = 'middel' THEN vt.size_object_middel
		        WHEN w.formaat_object = 'groot' THEN vt.size_object_groot
		    END AS size,
            w.symbol_name,
            w.bouwlaag,
            w.bouwlaag_object,
            'werkvoorraad'::text AS bron,
            w.datum_aangemaakt,
            w.datum_gewijzigd,
            CASE 
	            WHEN w.object_id IS NOT NULL THEN w.formaat_object 
	            ELSE w.formaat_bouwlaag
            END,
            w.opmerking
           FROM mobiel.werkvoorraad_label w
           JOIN objecten.label_type vt ON w.symbol_name = vt.naam
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'label'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.omschrijving,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.formaat_bouwlaag,
            v.opmerking
           FROM objecten.label v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.label_type vt ON v.soort = vt.naam
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('label', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'label'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.omschrijving,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.formaat_object,
            v.opmerking
           FROM objecten.label v
             JOIN objecten.label_type vt ON v.soort = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('label', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
) sub;

CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_label_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
      bouwlaagid integer := NULL;
		  objectid integer := NULL;
    BEGIN
		IF new.bouwlaag_object = 'bouwlaag' THEN
      bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
		ELSE
			objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
		END IF;
		INSERT INTO mobiel.werkvoorraad_label (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, rotatie, symbol_name,
            		bouwlaag, accepted, bouwlaag_object, opmerking, formaat_bouwlaag, formaat_object)
		VALUES (new.geom, 'INSERT'::character varying, new.brontabel, new.bron_id, bouwlaagid, objectid, new.omschrijving, new.rotatie, new.symbol_name, 
            new.bouwlaag, false, new.bouwlaag_object, new.opmerking,
				COALESCE(CASE WHEN new.bouwlaag_object = 'bouwlaag' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat),
				COALESCE(CASE WHEN new.bouwlaag_object = 'object' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat));
    RETURN NEW;
  END;
$function$
;

DROP FUNCTION IF EXISTS mobiel.funct_label_update;
CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_label_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
		objectid integer := NULL;
    BEGIN
		IF new.bouwlaag_object != old.bouwlaag_object THEN
			IF new.bouwlaag_object = 'bouwlaag' THEN
	        	bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
			ELSE
				objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
			END IF;
		ELSE
			bouwlaagid = new.bouwlaag_id;
			objectid = new.object_id;
		END IF;
	    IF NEW.bron = 'oiv' THEN
        INSERT INTO mobiel.werkvoorraad_label (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, rotatie, symbol_name,
                    bouwlaag, accepted, bouwlaag_object, opmerking, formaat_bouwlaag, formaat_object)
        VALUES (new.geom, 'UPDATE'::character varying, new.brontabel, new.bron_id, new.bouwlaag_id, new.object_id, new.omschrijving, new.rotatie, new.symbol_name, 
            new.bouwlaag, false, new.bouwlaag_object, new.opmerking,
            COALESCE(CASE WHEN new.bouwlaag_object = 'bouwlaag' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat),
            COALESCE(CASE WHEN new.bouwlaag_object = 'object' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat));
        
        IF NOT ST_Equals(new.geom, old.geom) THEN
                  INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                      VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), new.bron_id, new.brontabel, new.bouwlaag, bouwlaagid, objectid);
        END IF;
	    ELSE
        UPDATE mobiel.werkvoorraad_label
        SET geom=NEW.geom, operatie=OLD.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, object_id=objectid, bouwlaag_id=bouwlaagid, rotatie=NEW.rotatie, symbol_name=NEW.symbol_name,
          bouwlaag_object=NEW.bouwlaag_object, opmerking=new.opmerking, omschrijving=new.omschrijving,
          bouwlaag=CASE WHEN new.bouwlaag_object = 'bouwlaag' THEN NEW.bouwlaag ELSE NULL END, 
          formaat_bouwlaag=COALESCE(CASE WHEN new.bouwlaag_object = 'bouwlaag' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat),
          formaat_object=COALESCE(CASE WHEN new.bouwlaag_object = 'object' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat)
        WHERE werkvoorraad_label.id = OLD.orig_id;

        IF NOT ST_Equals(new.geom, old.geom) AND NEW.bron_id IS NOT NULL THEN
                  INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                      VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag, OLD.bouwlaag_id, OLD.object_id);
        END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

DROP FUNCTION IF EXISTS mobiel.funct_label_delete;
CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_label_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
        INSERT INTO mobiel.werkvoorraad_label (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, rotatie, symbol_name,
                    bouwlaag, accepted, bouwlaag_object, opmerking, formaat_bouwlaag, formaat_object)
        VALUES (new.geom, 'UPDATE'::character varying, new.brontabel, new.bron_id, new.bouwlaag_id, new.object_id, new.omschrijving, new.rotatie, new.symbol_name, 
            new.bouwlaag, false, new.bouwlaag_object, new.opmerking,
            COALESCE(CASE WHEN new.bouwlaag_object = 'bouwlaag' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat),
            COALESCE(CASE WHEN new.bouwlaag_object = 'object' THEN new.formaat ELSE NULL END, 'middel'::algemeen.formaat));
	    ELSE
        DELETE FROM mobiel.werkvoorraad_label WHERE (id = OLD.orig_id);
        DELETE FROM mobiel.werkvoorraad_hulplijnen WHERE (bron_id = old.bron_id AND brontabel = old.brontabel);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE TRIGGER trg_labels_ins INSTEAD OF
INSERT
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_label_ins();
CREATE TRIGGER trg_labels_upd INSTEAD OF
UPDATE
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_label_upd();
CREATE TRIGGER trg_labels_del INSTEAD OF
DELETE
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_label_del();

DROP FUNCTION IF EXISTS mobiel.complement_record_label();
DROP TRIGGER IF EXISTS trg_after_insert ON mobiel.werkvoorraad_label;
ALTER TRIGGER trg_set_upd ON mobiel.werkvoorraad_label RENAME TO trg_set_mutatie;

CREATE OR REPLACE VIEW mobiel.lijn_types
AS SELECT row_number() OVER (ORDER BY sub.naam) AS id,
    sub.naam,
    sub.categorie,
    sub.bouwlaag_object,
    sub.brontabel
   FROM (SELECT naam, 'Bereikbaarheid'::text AS categorie, 'object'::text AS bouwlaag_object, 'bereikbaarheid'::text AS brontabel
          FROM objecten.bereikbaarheid_type
          WHERE actief_ruimtelijk = true
        UNION ALL
         SELECT naam, 'Gebiedsgerichte aanpak'::text AS categorie, 'object'::text AS bouwlaag_object, 'gebiedsgerichte_aanpak'::text AS brontabel
          FROM objecten.label_type
          WHERE actief_ruimtelijk = true
        UNION ALL
         SELECT naam, 'Veiligheidsvoorziening bouwkundig'::text AS categorie, 'bouwlaag'::text AS bouwlaag_object, 'veiligh_bouwk'::text AS brontabel
          FROM objecten.label_type
          WHERE actief_bouwlaag = true          
        ) sub;

DROP VIEW IF EXISTS mobiel.lijnen;
CREATE OR REPLACE VIEW mobiel.lijnen
AS SELECT row_number() OVER (ORDER BY sub.id) AS id,
    sub.geom,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.bouwlaag_object,
    sub.opmerking,
    sub.datum_aangemaakt,
    sub.datum_gewijzigd
   FROM ( SELECT w.id,
            w.geom,
            w.operatie,
            w.brontabel,
            w.bron_id,
            w.object_id,
            w.bouwlaag_id,
            w.symbol_name,
            w.bouwlaag,
            'werkvoorraad'::text AS bron,
            w.bouwlaag_object,
            w.opmerking,
            w.datum_aangemaakt,
            w.datum_gewijzigd
           FROM mobiel.werkvoorraad_lijn w
        UNION ALL
         SELECT b.id,
            b.geom,
            ''::character varying AS operatie,
            'bereikbaarheid'::character varying AS brontabel,
            b.id AS bron_id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS bouwlaag_object,
            b.opmerking,
            b.datum_aangemaakt,
            b.datum_gewijzigd
           FROM objecten.bereikbaarheid b
             JOIN objecten.bereikbaarheid_type bt ON b.soort::text = bt.naam::text
          WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT b.id,
            b.geom,
            ''::character varying AS operatie,
            'gebiedsgerichte_aanpak'::character varying AS brontabel,
            b.id AS bron_id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS bouwlaag_object,
            b.opmerking,
            b.datum_aangemaakt,
            b.datum_gewijzigd
           FROM objecten.gebiedsgerichte_aanpak b
             JOIN objecten.gebiedsgerichte_aanpak_type bt ON b.soort::text = bt.naam::text
          WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT b.id,
            b.geom,
            ''::character varying AS operatie,
            'veiligh_bouwk'::character varying AS brontabel,
            b.id AS bron_id,
            NULL::integer AS object_id,
            b.bouwlaag_id,
            b.soort AS symbol_name,
            bl.bouwlaag,
            'oiv'::text AS bron,
            'bouwlaag'::text AS bouwlaag_object,
            b.opmerking,
            b.datum_aangemaakt,
            b.datum_gewijzigd
           FROM objecten.veiligh_bouwk b
             JOIN objecten.bouwlagen bl ON b.bouwlaag_id = bl.id
             JOIN objecten.veiligh_bouwk_type bt ON b.soort::text = bt.naam::text
          WHERE b.bouwlaag_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone) sub;

CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_lijn_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
      bouwlaagid integer := NULL;
	  objectid integer := NULL;
    BEGIN
		IF new.bouwlaag_object = 'bouwlaag' THEN
      bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b
			                WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
		ELSE
			objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
		END IF;
		INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, symbol_name,
            		bouwlaag, accepted, bouwlaag_object, opmerking)
		VALUES (new.geom, 'INSERT'::character varying, new.brontabel, new.bron_id, bouwlaagid, objectid, new.symbol_name, 
            new.bouwlaag, false, new.bouwlaag_object, new.opmerking);
    RETURN NEW;
  END;
$function$
;

DROP FUNCTION IF EXISTS mobiel.funct_lijn_update;
CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_lijn_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
      bouwlaagid integer := NULL;
	  objectid integer := NULL;
    BEGIN
		IF new.bouwlaag_object != old.bouwlaag_object THEN
			IF new.bouwlaag_object = 'bouwlaag' THEN
	        	bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
			ELSE
				objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
			END IF;
		ELSE
			bouwlaagid = new.bouwlaag_id;
			objectid = new.object_id;
		END IF;
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, symbol_name,
	            		bouwlaag, accepted, bouwlaag_object, opmerking)
			VALUES (new.geom, 'UPDATE'::character varying, new.brontabel, new.bron_id, bouwlaagid, objectid, new.symbol_name, 
	            new.bouwlaag, false, new.bouwlaag_object, new.opmerking);
  		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag, new.bouwlaag_id, new.object_id);
			END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_lijn
			SET geom=NEW.geom, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, opmerking=new.opmerking,
				object_id=objectid, bouwlaag_id=bouwlaagid, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag, bouwlaag_object=NEW.bouwlaag_object
			WHERE werkvoorraad_lijn.id = OLD.orig_id;
		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag, OLD.bouwlaag_id, OLD.object_id);
			END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

DROP FUNCTION IF EXISTS mobiel.funct_lijn_delete;
CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_lijn_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, symbol_name, bouwlaag, accepted, bouwlaag_object, opmerking)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.id, old.bouwlaag_id, old.object_id, old.symbol_name, old.bouwlaag, FALSE, OLD.bouwlaag_object, old.opmerking);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_lijn WHERE (id = OLD.orig_id);
			DELETE FROM mobiel.werkvoorraad_hulplijnen WHERE (bron_id = old.bron_id AND brontabel = old.brontabel);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

DROP TRIGGER IF EXISTS trg_after_insert ON mobiel.werkvoorraad_lijn;
DROP FUNCTION IF EXISTS mobiel.complement_record_lijn();
DROP TRIGGER IF EXISTS trg_set_upd ON mobiel.werkvoorraad_lijn;
DROP TRIGGER IF EXISTS trg_set_mutatie ON mobiel.werkvoorraad_lijn;

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    mobiel.werkvoorraad_lijn FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_lijnen_ins INSTEAD OF
INSERT
    ON
    mobiel.lijnen FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_lijn_ins();
CREATE TRIGGER trg_lijnen_upd INSTEAD OF
UPDATE
    ON
    mobiel.lijnen FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_lijn_upd();
CREATE TRIGGER trg_lijnen_del INSTEAD OF
DELETE
    ON
    mobiel.lijnen FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_lijn_del();

CREATE OR REPLACE VIEW mobiel.vlak_types
AS SELECT row_number() OVER (ORDER BY sub.naam) AS id,
    sub.naam,
    sub.categorie,
    sub.bouwlaag_object,
    sub.brontabel
   FROM (SELECT naam, 'Sectoren'::text AS categorie, 'object'::text AS bouwlaag_object, 'sectoren'::text AS brontabel
          FROM objecten.sectoren_type
          WHERE actief_ruimtelijk = true
        UNION ALL
         SELECT naam, 'Ruimten'::text AS categorie, 'bouwlaag'::text AS bouwlaag_object, 'ruimten'::text AS brontabel
          FROM objecten.ruimten_type
          WHERE actief_bouwlaag = true          
        ) sub;

DROP VIEW IF EXISTS mobiel.vlakken;
CREATE OR REPLACE VIEW mobiel.vlakken
AS SELECT row_number() OVER (ORDER BY sub.id) AS id,
    sub.geom,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.bouwlaag_object,
    sub.opmerking
   FROM ( SELECT w.id,
            w.geom,
            w.operatie,
            w.brontabel,
            w.bron_id,
            w.object_id,
            w.bouwlaag_id,
            w.symbol_name,
            w.bouwlaag,
            'werkvoorraad'::text AS bron,
            w.bouwlaag_object,
            w.opmerking,
            w.datum_aangemaakt,
            w.datum_gewijzigd
           FROM mobiel.werkvoorraad_vlak w
        UNION ALL
         SELECT b.id,
            b.geom,
            ''::character varying AS operatie,
            'sectoren'::character varying AS brontabel,
            b.id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS bouwlaag_object,
            b.opmerking,
            b.datum_aangemaakt,
            b.datum_gewijzigd
           FROM objecten.sectoren b
          WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT b.id,
            b.geom,
            ''::character varying AS operatie,
            'ruimten'::character varying AS brontabel,
            b.id,
            NULL::integer AS object_id,
            b.bouwlaag_id,
            b.soort,
            bl.bouwlaag,
            'oiv'::text AS bron,
            'bouwlaag'::text AS bouwlaag_object,
            b.opmerking,
            b.datum_aangemaakt,
            b.datum_gewijzigd
           FROM objecten.ruimten b
             JOIN objecten.bouwlagen bl ON b.bouwlaag_id = bl.id
          WHERE b.bouwlaag_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone) sub;

CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_vlak_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
      bouwlaagid integer := NULL;
	  objectid integer := NULL;
    BEGIN
		IF new.bouwlaag_object = 'bouwlaag' THEN
      		bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b
			                WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
		ELSE
			objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
		END IF;
		INSERT INTO mobiel.werkvoorraad_vlak (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, symbol_name,
            		bouwlaag, accepted, bouwlaag_object, opmerking)
		VALUES (new.geom, 'INSERT'::character varying, new.brontabel, new.bron_id, bouwlaagid, objectid, new.symbol_name, 
            new.bouwlaag, false, new.bouwlaag_object, new.opmerking);
    RETURN NEW;
  END;
$function$
;

DROP FUNCTION IF EXISTS mobiel.funct_vlak_update;
CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_vlak_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
      bouwlaagid integer := NULL;
	  objectid integer := NULL;
    BEGIN
		IF new.bouwlaag_object != old.bouwlaag_object THEN
			IF new.bouwlaag_object = 'bouwlaag' THEN
	        	bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
			ELSE
				objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
			END IF;
		ELSE
			bouwlaagid = new.bouwlaag_id;
			objectid = new.object_id;
		END IF;
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_vlak (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, symbol_name,
	            		bouwlaag, accepted, bouwlaag_object, opmerking)
			VALUES (new.geom, 'UPDATE'::character varying, new.brontabel, new.bron_id, bouwlaagid, objectid, new.symbol_name, 
	            new.bouwlaag, false, new.bouwlaag_object, new.opmerking);
  		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag, new.bouwlaag_id, new.object_id);
			END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_vlak
			SET geom=NEW.geom, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, opmerking=new.opmerking,
				object_id=objectid, bouwlaag_id=bouwlaagid, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag, bouwlaag_object=NEW.bouwlaag_object
			WHERE werkvoorraad_vlak.id = OLD.orig_id;
		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag, OLD.bouwlaag_id, OLD.object_id);
			END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

DROP FUNCTION IF EXISTS mobiel.funct_vlak_delete;
CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_vlak_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_vlak (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, symbol_name, bouwlaag, accepted, bouwlaag_object, opmerking)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.id, old.bouwlaag_id, old.object_id, old.symbol_name, old.bouwlaag, FALSE, OLD.bouwlaag_object, old.opmerking);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_vlak WHERE (id = OLD.orig_id);
			DELETE FROM mobiel.werkvoorraad_hulplijnen WHERE (bron_id = old.bron_id AND brontabel = old.brontabel);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

DROP TRIGGER IF EXISTS trg_after_insert ON mobiel.werkvoorraad_vlak;
DROP FUNCTION IF EXISTS mobiel.complement_record_vlak();
DROP TRIGGER IF EXISTS trg_set_upd ON mobiel.werkvoorraad_vlak;
DROP TRIGGER IF EXISTS trg_set_mutatie ON mobiel.werkvoorraad_vlak;

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_vlakken_ins INSTEAD OF
INSERT
    ON
    mobiel.vlakken FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_vlak_ins();
CREATE TRIGGER trg_vlakken_upd INSTEAD OF
UPDATE
    ON
    mobiel.vlakken FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_vlak_upd();
CREATE TRIGGER trg_vlakken_del INSTEAD OF
DELETE
    ON
    mobiel.vlakken FOR EACH ROW EXECUTE FUNCTION mobiel.func_werkvoorraad_vlak_del();


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 11;
UPDATE algemeen.applicatie SET db_versie = 3611; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();