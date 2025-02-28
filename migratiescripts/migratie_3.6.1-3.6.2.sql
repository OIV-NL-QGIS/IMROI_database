SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE OR REPLACE VIEW objecten.view_terrein
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.object_id,
    o.formelenaam,
    o.share
   FROM objecten.object o
     JOIN objecten.terrein b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;


ALTER TABLE mobiel.werkvoorraad_punt ADD COLUMN LABEL varchar(50);

DROP VIEW mobiel.symbolen;
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
            vt.size,
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
                   FROM ( SELECT v.belemmering, v.voorzieningen) d)) AS waarden_new,
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
                   FROM ( SELECT v.belemmering, v.voorzieningen) d)) AS waarden_new,
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
            NULL as waarden_new,
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
            vt.size,
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
            ''::text AS binnen_buiten,
            'werkvoorraad'::text AS bron,
            werkvoorraad_punt.datum_aangemaakt,
            werkvoorraad_punt.datum_gewijzigd,
            werkvoorraad_punt.label
           FROM mobiel.werkvoorraad_punt) sub;
           
DROP RULE IF EXISTS symbolen_ins ON mobiel.symbolen;
CREATE RULE symbolen_ins AS
    ON INSERT TO mobiel.symbolen DO INSTEAD  
    INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie,
    	size, symbol_name, bouwlaag, accepted, bouwlaag_object, label)
  VALUES (new.geom, new.waarden_new, 'INSERT'::character varying, new.brontabel, new.bron_id, new.bouwlaag_id, new.object_id, new.rotatie, 
  		new.size, new.symbol_name, new.bouwlaag, false, new.binnen_buiten, NEW.label);

CREATE OR REPLACE FUNCTION mobiel.funct_symbol_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, 
				object_id, rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object, label)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, new.bron_id, NEW.bouwlaag_id, 
  				NEW.object_id, new.rotatie, new.size, new.symbol_name, new.bouwlaag, FALSE, NEW.binnen_buiten, NEW.label);
  		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), new.bron_id, new.brontabel, new.bouwlaag, new.bouwlaag_id, new.object_id);
			END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_punt
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=OLD.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, rotatie=NEW.rotatie, "size"=NEW.size, symbol_name=NEW.symbol_name,
				bouwlaag=NEW.bouwlaag, bouwlaag_object=NEW.binnen_buiten, label=NEW.label
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
				  object_id, rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object, label)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.id, old.bouwlaag_id,
  				OLD.object_id, old.rotatie, old.size, old.symbol_name, old.bouwlaag, FALSE, OLD.binnen_buiten, OLD.label);
	    ELSE
			  DELETE FROM mobiel.werkvoorraad_punt WHERE (id = OLD.orig_id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

DROP RULE IF EXISTS labels_ins ON mobiel.labels;
CREATE RULE labels_ins AS
    ON INSERT TO mobiel.labels DO INSTEAD  INSERT INTO mobiel.werkvoorraad_label (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id,
        object_id, omschrijving, rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object)
  VALUES (new.geom, new.waarden_new, 'INSERT'::character varying, new.brontabel, new.bron_id, new.bouwlaag_id,
        NEW.object_id, new.omschrijving, new.rotatie, new.size, new.symbol_name, new.bouwlaag, false, new.binnen_buiten);

CREATE OR REPLACE FUNCTION mobiel.funct_label_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_label (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, 
				rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, new.bron_id, new.bouwlaag_id, NEW.object_id, new.omschrijving, 
  				new.rotatie, new.size, new.symbol_name, new.bouwlaag, FALSE, binnen_buiten);
  		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), new.bron_id, new.brontabel, new.bouwlaag, new.bouwlaag_id, NEW.object_id);
            END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_label
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=old.operatie, brontabel=old.brontabel, bron_id=old.bron_id, omschrijving=new.omschrijving, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, rotatie=NEW.rotatie, "size"=NEW.size, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag, bouwlaag_object=NEW.binen_buiten
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

CREATE OR REPLACE FUNCTION mobiel.funct_label_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_label (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id,
				object_id, rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object, omschrijving)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.id, old.bouwlaag_id,
  				OLD.object_id, old.rotatie, old.size, old.symbol_name, old.bouwlaag, FALSE, old_binnen_buiten, OLD.omschrijving);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_label WHERE (id = OLD.orig_id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel.funct_lijn_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id,
				object_id, symbol_name, bouwlaag, accepted, bouwlaag_object)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, new.bron_id, new.bouwlaag_id,
  				NEW.object_id, new.symbol_name, new.bouwlaag, FALSE, NEW.binnen_buiten);
  		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag, new.bouwlaag_id, new.object_id);
			END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_lijn
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag, bouwlaag_object=NEW.binnen_buiten
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

CREATE OR REPLACE FUNCTION mobiel.funct_lijn_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, accepted, bouwlaag_object)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.id, old.bouwlaag_id, old.symbol_name, old.bouwlaag, FALSE, OLD.binnen_buiten);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_lijn WHERE (id = OLD.orig_id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel.funct_vlak_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, 
				object_id, symbol_name, bouwlaag, accepted, bouwlaag_object)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, new.bron_id, new.bouwlaag_id, 
  				NEW.object_id, new.symbol_name, new.bouwlaag, FALSE, NEW.binnen_buiten);
  		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), new.bron_id, new.brontabel, new.bouwlaag, new.bouwlaag_id, NEW.object_id);
			END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_vlak
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag, bouwlaag_object=NEW.binnen_buiten
			WHERE werkvoorraad_vlak.id = old.orig_id;
		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), new.bron_id, new.brontabel, new.bouwlaag, new.bouwlaag_id, NEW.object_id);
			END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel.funct_lijn_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, accepted, bouwlaag_object)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.id, old.bouwlaag_id, old.symbol_name, old.bouwlaag, FALSE, OLD.binnen_buiten);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_lijn WHERE (id = OLD.orig_id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

ALTER TABLE objecten.label_type ADD COLUMN prefix varchar(50);

UPDATE objecten.label_type SET prefix = 'CADO ' WHERE naam = 'calamiteitendoorgang';
UPDATE objecten.label_type SET prefix = 'Ingang: ' WHERE naam = 'publieke ingang';

CREATE OR REPLACE VIEW objecten.view_label_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    CONCAT(vt.prefix, d.omschrijving)::varchar(254) AS omschrijving,
    d.soort,
    d.rotatie,
    d.bouwlaag_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vt.size,
    vt.style_ids,
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

CREATE OR REPLACE VIEW objecten.view_label_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    CONCAT(vt.prefix, b.omschrijving)::varchar(254) AS omschrijving,
    b.rotatie,
    b.bouwlaag_id,
    b.object_id,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.size_object AS size,
    vt.style_ids,
    o.share
   FROM objecten.object o
     JOIN objecten.label b ON o.id = b.object_id
     JOIN objecten.label_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone AND historie.self_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 362; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();