SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- opslaan bijzonderheid issue #341
CREATE OR REPLACE FUNCTION objecten.func_veiligh_ruimtelijk_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.veiligh_ruimtelijk SET geom = new.geom, veiligh_ruimtelijk_type_id = new.veiligh_ruimtelijk_type_id, rotatie = new.rotatie, label = new.label, object_id = new.object_id
            , fotografie_id = new.fotografie_id, bijzonderheid = NEW.bijzonderheid
            WHERE (veiligh_ruimtelijk.id = new.id);
        ELSE
            size := (SELECT vt."size" FROM objecten.veiligh_ruimtelijk_type vt WHERE vt.id = new.veiligh_ruimtelijk_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.veiligh_ruimtelijk_type vt WHERE vt.id = new.veiligh_ruimtelijk_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.bijzonderheid) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, row_to_json(NEW.*), 'UPDATE', 'veiligh_ruimtelijk', old.id, new.object_id, NEW.rotatie, size, symbol_name, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'veiligh_ruimtelijk');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;



-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 5;
UPDATE algemeen.applicatie SET db_versie = 345; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
