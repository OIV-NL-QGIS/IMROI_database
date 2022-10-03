SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.scenario_locatie SET geom = new.geom, locatie = new.locatie, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (scenario_locatie.id = new.id);
        ELSE
            
            symbol_name := (SELECT st.symbol_name FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT st."size_object" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'scenario_locatie', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'scenario_locatie', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

ALTER TABLE objecten.bereikbaarheid ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTILINESTRING'::text) AND (geom IS NOT NULL));
ALTER TABLE objecten.gebiedsgerichte_aanpak ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTILINESTRING'::text) AND (geom IS NOT NULL));
ALTER TABLE objecten.isolijnen ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTILINESTRING'::text) AND (geom IS NOT NULL));
ALTER TABLE objecten.veiligh_bouwk ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTILINESTRING'::text) AND (geom IS NOT NULL));

ALTER TABLE objecten.bouwlagen ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTIPOLYGON'::text) AND (geom IS NOT NULL));
ALTER TABLE objecten.grid ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTIPOLYGON'::text) AND (geom IS NOT NULL));
ALTER TABLE objecten.ruimten ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTIPOLYGON'::text) AND (geom IS NOT NULL));
ALTER TABLE objecten.sectoren ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTIPOLYGON'::text) AND (geom IS NOT NULL));
ALTER TABLE objecten.terrein ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTIPOLYGON'::text) AND (geom IS NOT NULL));


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 342; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
