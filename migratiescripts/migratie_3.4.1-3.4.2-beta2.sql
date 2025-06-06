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

ALTER TABLE objecten.bereikbaarheid DISABLE TRIGGER trg_set_delete;
DELETE FROM objecten.bereikbaarheid WHERE geom is null;
ALTER TABLE objecten.bereikbaarheid ENABLE TRIGGER trg_set_delete;

ALTER TABLE objecten.gebiedsgerichte_aanpak DISABLE TRIGGER trg_set_delete;
DELETE FROM objecten.gebiedsgerichte_aanpak WHERE geom is null;
ALTER TABLE objecten.gebiedsgerichte_aanpak ENABLE TRIGGER trg_set_delete;

ALTER TABLE objecten.veiligh_bouwk DISABLE TRIGGER trg_set_delete;
DELETE FROM objecten.veiligh_bouwk WHERE geom is null;
ALTER TABLE objecten.veiligh_bouwk ENABLE TRIGGER trg_set_delete;

ALTER TABLE objecten.isolijnen DISABLE TRIGGER trg_set_delete;
DELETE FROM objecten.isolijnen WHERE geom is null;
ALTER TABLE objecten.isolijnen ENABLE TRIGGER trg_set_delete;

ALTER TABLE objecten.bouwlagen DISABLE TRIGGER trg_set_delete;
DELETE FROM objecten.bouwlagen WHERE geom is null;
ALTER TABLE objecten.bouwlagen ENABLE TRIGGER trg_set_delete;

ALTER TABLE objecten.ruimten DISABLE TRIGGER trg_set_delete;
DELETE FROM objecten.ruimten WHERE geom is null;
ALTER TABLE objecten.ruimten ENABLE TRIGGER trg_set_delete;

ALTER TABLE objecten.grid DISABLE TRIGGER trg_set_delete;
DELETE FROM objecten.grid WHERE geom is null;
ALTER TABLE objecten.grid ENABLE TRIGGER trg_set_delete;

ALTER TABLE objecten.sectoren DISABLE TRIGGER trg_set_delete;
DELETE FROM objecten.sectoren WHERE geom is null;
ALTER TABLE objecten.sectoren ENABLE TRIGGER trg_set_delete;

ALTER TABLE objecten.terrein DISABLE TRIGGER trg_set_delete;
DELETE FROM objecten.terrein WHERE geom is null;
ALTER TABLE objecten.terrein ENABLE TRIGGER trg_set_delete;

ALTER TABLE objecten.bereikbaarheid DROP CONSTRAINT IF EXISTS enforce_geotype_geom;
ALTER TABLE objecten.bereikbaarheid ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTILINESTRING'::text) AND (geom IS NOT NULL));

ALTER TABLE objecten.gebiedsgerichte_aanpak DROP CONSTRAINT IF EXISTS enforce_geotype_geom;
ALTER TABLE objecten.gebiedsgerichte_aanpak ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTILINESTRING'::text) AND (geom IS NOT NULL));

ALTER TABLE objecten.isolijnen DROP CONSTRAINT IF EXISTS enforce_geotype_geom;
ALTER TABLE objecten.isolijnen ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTILINESTRING'::text) AND (geom IS NOT NULL));

ALTER TABLE objecten.veiligh_bouwk DROP CONSTRAINT IF EXISTS enforce_geotype_geom;
ALTER TABLE objecten.veiligh_bouwk ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTILINESTRING'::text) AND (geom IS NOT NULL));

ALTER TABLE objecten.bouwlagen DROP CONSTRAINT IF EXISTS enforce_geotype_geom;
ALTER TABLE objecten.bouwlagen ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTIPOLYGON'::text) AND (geom IS NOT NULL));

ALTER TABLE objecten.grid DROP CONSTRAINT IF EXISTS enforce_geotype_geom;
ALTER TABLE objecten.grid ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTIPOLYGON'::text) AND (geom IS NOT NULL));

ALTER TABLE objecten.ruimten DROP CONSTRAINT IF EXISTS enforce_geotype_geom;
ALTER TABLE objecten.ruimten ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTIPOLYGON'::text) AND (geom IS NOT NULL));

ALTER TABLE objecten.sectoren DROP CONSTRAINT IF EXISTS enforce_geotype_geom;
ALTER TABLE objecten.sectoren ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTIPOLYGON'::text) AND (geom IS NOT NULL));

ALTER TABLE objecten.terrein DROP CONSTRAINT IF EXISTS enforce_geotype_geom;
ALTER TABLE objecten.terrein ADD CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = 'MULTIPOLYGON'::text) AND (geom IS NOT NULL));


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 342; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = 'beta2';
UPDATE algemeen.applicatie SET datum = now();
