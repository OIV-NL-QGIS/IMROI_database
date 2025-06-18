SET ROLE oiv_admin;

--  TODO:
--    oiv mobiel compleet aanpassen
--		symbolen toevoegen aan database

CREATE OR REPLACE VIEW mobiel.symbolen
AS SELECT concat(sub.brontabel, '_', sub.id::character varying) AS id,
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
    sub.binnen_buiten,
    sub.id AS orig_id,
    sub.datum_aangemaakt,
    sub.datum_gewijzigd,
    sub.label,
    sub.label_positie,
    sub.formaat
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
          WHERE v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('veiligh_install', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'veiligh_ruimtelijk'::character varying AS brontabel,
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
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.veiligh_ruimtelijk v
             JOIN objecten.veiligh_ruimtelijk_type vt ON v.veiligh_ruimtelijk_type_id = vt.id
          WHERE v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('veiligh_ruimtelijk', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
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
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.dreiging v
             JOIN objecten.dreiging_type vt ON v.dreiging_type_id = vt.id
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
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag
           FROM objecten.afw_binnendekking v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.afw_binnendekking_type vt ON v.soort::text = vt.naam::text AND CONCAT('afw_binnendekking', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
          WHERE v.self_deleted = 'infinity'::timestamp with time zone
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
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.ingang v
             JOIN objecten.ingang_type vt ON v.ingang_type_id = vt.id
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
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
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
            i.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END,
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
             JOIN objecten.ingang i ON v.ingang_id = i.id
             JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE i.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('sleutelkluis', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            i.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
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
             JOIN objecten.ingang i ON v.ingang_id = i.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE i.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('sleutelkluis', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
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
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.points_of_interest v
             JOIN objecten.points_of_interest_type vt ON v.points_of_interest_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('points_of_interest', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT werkvoorraad_punt.id,
            werkvoorraad_punt.geom,
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
            'werkvoorraad'::text AS bron,
            werkvoorraad_punt.datum_aangemaakt,
            werkvoorraad_punt.datum_gewijzigd,
            werkvoorraad_punt.label,
            werkvoorraad_punt.label_positie,
            werkvoorraad_punt.formaat
           FROM mobiel.werkvoorraad_punt) sub;

CREATE RULE symbolen_ins AS
    ON INSERT TO mobiel.symbolen DO INSTEAD  INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, size, symbol_name,
                bouwlaag, accepted, bouwlaag_object, label, label_positie, formaat)
  VALUES (new.geom, new.waarden_new, 'INSERT'::character varying, new.brontabel, new.bron_id, new.bouwlaag_id, new.object_id, new.rotatie, new.size, new.symbol_name,
                new.bouwlaag, false, new.binnen_buiten, new.label, new.label_positie, new.formaat);

CREATE OR REPLACE FUNCTION mobiel.funct_symbol_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, 
				object_id, rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object, label, label_positie, formaat)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, new.bron_id, NEW.bouwlaag_id, 
  				NEW.object_id, new.rotatie, new.size, new.symbol_name, new.bouwlaag, FALSE, NEW.binnen_buiten, NEW.label, new.label_positie, new.formaat);
  		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), new.bron_id, new.brontabel, new.bouwlaag, new.bouwlaag_id, new.object_id);
			END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_punt
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=OLD.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, rotatie=NEW.rotatie, "size"=NEW.size, symbol_name=NEW.symbol_name,
				bouwlaag=NEW.bouwlaag, bouwlaag_object=NEW.binnen_buiten, label=NEW.label, label_positie=new.label_positie, formaat=new.formaat
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

CREATE OR REPLACE FUNCTION mobiel.funct_symbol_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id,
				  object_id, rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object, label, label_positie, formaat)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.bron_id, old.bouwlaag_id,
  				OLD.object_id, old.rotatie, old.size, old.symbol_name, old.bouwlaag, FALSE, OLD.binnen_buiten, OLD.label, old.label_positie, old.formaat);
	    ELSE
			  DELETE FROM mobiel.werkvoorraad_punt WHERE (id = OLD.orig_id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;







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
            CASE
                WHEN l.formaat_bouwlaag = 'klein'::algemeen.formaat THEN lt.size_bouwlaag_klein
                WHEN l.formaat_bouwlaag = 'middel'::algemeen.formaat THEN lt.size_bouwlaag_middel
                WHEN l.formaat_bouwlaag = 'groot'::algemeen.formaat THEN lt.size_bouwlaag_groot
                ELSE NULL::numeric
            END AS size,
            lt.symbol_name,
            bl.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.label l
             JOIN objecten.bouwlagen bl ON l.bouwlaag_id = bl.id
             JOIN objecten.label_type lt ON l.soort::text = lt.naam::text
          WHERE l.bouwlaag_id IS NOT NULL AND l.self_deleted = 'infinity'::timestamp with time zone
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
            CASE
                WHEN l.formaat_object = 'klein'::algemeen.formaat THEN lt.size_object_klein
                WHEN l.formaat_object = 'middel'::algemeen.formaat THEN lt.size_object_middel
                WHEN l.formaat_object = 'groot'::algemeen.formaat THEN lt.size_object_groot
                ELSE NULL::numeric
            END AS size,
            lt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.label l
             JOIN objecten.label_type lt ON l.soort::text = lt.naam::text
          WHERE l.object_id IS NOT NULL AND l.self_deleted = 'infinity'::timestamp with time zone) sub;

CREATE TRIGGER trg_labels_del INSTEAD OF
DELETE
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel.funct_label_delete();
CREATE TRIGGER trg_labels_upd INSTEAD OF
UPDATE
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel.funct_label_update();



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
             JOIN objecten.sectoren_type bt ON b.soort::text = bt.naam::text
          WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone
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
            b.soort,
            bl.bouwlaag,
            'oiv'::text AS bron,
            'bouwlaag'::text AS binnen_buiten
           FROM objecten.ruimten b
             JOIN objecten.bouwlagen bl ON b.bouwlaag_id = bl.id
             JOIN objecten.ruimten_type bt ON b.soort = bt.naam
          WHERE b.bouwlaag_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone) sub;



-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 8;
UPDATE algemeen.applicatie SET db_versie = 368; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();