SET ROLE oiv_admin;

CREATE OR REPLACE FUNCTION objecten.set_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE nextValFn text; newId INTEGER;
BEGIN
    IF (TG_OP = 'DELETE') THEN
        RAISE NOTICE 'Delete not supported';
    ELSIF (TG_OP = 'UPDATE') THEN
        IF NEW.datum_gewijzigd IS NULL THEN NEW.datum_gewijzigd = now(); END IF;
    ELSIF (TG_OP = 'INSERT') THEN
        IF NEW.datum_aangemaakt IS NULL THEN NEW.datum_aangemaakt = now(); END IF;
        BEGIN
            NEW.self_deleted := COALESCE(NEW.self_deleted, 'infinity');
        EXCEPTION
            WHEN undefined_column THEN
                NULL;
        END;
        BEGIN
            NEW.parent_deleted := COALESCE(NEW.parent_deleted, 'infinity');
        EXCEPTION
            WHEN undefined_column THEN
                NULL;
        END;
        IF NEW.id IS NULL THEN 
        nextValFn := (SELECT column_default
            FROM  information_schema.columns
            WHERE (table_schema, table_name, column_name) = (quote_ident(TG_TABLE_SCHEMA), quote_ident(TG_TABLE_NAME), 'id'));
        EXECUTE 'SELECT ' || nextValFn INTO newId;
        NEW.id = newId; 
        END IF;
    END IF;
    RETURN NEW;   
END
$function$
;

CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_punt_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name,
	            		bouwlaag, accepted, bouwlaag_object, opmerking, label, label_positie, formaat_bouwlaag, formaat_object)
  			VALUES (old.geom, 'DELETE', old.brontabel, old.bron_id, old.bouwlaag_id, old.object_id, old.rotatie, old.symbol_name,
					old.bouwlaag, FALSE, OLD.bouwlaag_object, old.opmerking, OLD.label, old.label_positie, old.formaat, old.formaat);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_punt WHERE (id = OLD.orig_id);
			DELETE FROM mobiel.werkvoorraad_hulplijnen WHERE (bron_id = old.bron_id AND brontabel = old.brontabel);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_lijn_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, symbol_name, bouwlaag, accepted, bouwlaag_object, opmerking)
  			VALUES (old.geom, 'DELETE', old.brontabel, old.id, old.bouwlaag_id, old.object_id, old.symbol_name, old.bouwlaag, FALSE, OLD.bouwlaag_object, old.opmerking);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_lijn WHERE (id = OLD.orig_id);
			DELETE FROM mobiel.werkvoorraad_hulplijnen WHERE (bron_id = old.bron_id AND brontabel = old.brontabel);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel.func_werkvoorraad_vlak_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_vlak (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, symbol_name, bouwlaag, accepted, bouwlaag_object, opmerking)
  			VALUES (old.geom, 'DELETE', old.brontabel, old.id, old.bouwlaag_id, old.object_id, old.symbol_name, old.bouwlaag, FALSE, OLD.bouwlaag_object, old.opmerking);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_vlak WHERE (id = OLD.orig_id);
			DELETE FROM mobiel.werkvoorraad_hulplijnen WHERE (bron_id = old.bron_id AND brontabel = old.brontabel);
	    END IF;
	    RETURN NULL;
    END;
$function$
;


CREATE OR REPLACE FUNCTION objecten.set_delete_timestamp_info_of_interest()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
      command text := ' SET self_deleted = now() WHERE id = $1';
    BEGIN
      EXECUTE 'UPDATE "' || TG_TABLE_SCHEMA || '"."' || TG_TABLE_NAME || '" ' || command USING OLD.id;
      RETURN NULL;
    END;
  $function$
;

INSERT INTO objecten.ingang_type
(id, naam, symbol_name, size_bouwlaag_klein, size_bouwlaag_middel, size_bouwlaag_groot, size_object_klein, size_object_middel, size_object_groot, tabbladen, volgnummer, actief_bouwlaag, actief_ruimtelijk, snap, anchorpoint, symbol_svg_png)
VALUES(799, 'Deur', 'deur', 2.0, 3.0, 6.0, 6.0, 6.0, 10.0, '{"Water": 0, "Gebouw": 0, "Natuur": 0, "Algemeen": 0, "Bouwlaag": 1, "Evenement": 0, "Infrastructuur": 0}'::json, 22, true, false, true, 'center'::algemeen.anchorpoint, 'png');

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 7;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 3722; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();