SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        objectid integer;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.gebiedsgerichte_aanpak (geom, soort, label, bijzonderheden, object_id, fotografie_id)
            VALUES (new.geom, new.soort, new.label, new.bijzonderheden, new.object_id, new.fotografie_id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.bijzonderheden) d));
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'gebiedsgerichte_aanpak', NULL, objectid, NEW.soort, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.gebiedsgerichte_aanpak SET geom = new.geom, soort = new.soort, label = new.label, bijzonderheden = new.bijzonderheden, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (gebiedsgerichte_aanpak.id = new.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.bijzonderheden) d));

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'gebiedsgerichte_aanpak', old.id, new.object_id, NEW.soort, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) 
                    VALUES (ST_MakeLine(ST_LineInterpolatePoint(ST_LineMerge(old.geom), 0.5), ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5)), old.id, 'gebiedsgerichte_aanpak');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.veiligh_bouwk (geom, soort, bouwlaag_id, fotografie_id)
            VALUES (new.geom, new.soort, new.bouwlaag_id, new.fotografie_id);
        ELSE
            bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.bouwlagen b 
                                                        WHERE b.bouwlaag = new.bouwlaag 
                                                        ORDER BY dist LIMIT 1) b);
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, 'INSERT', 'veiligh_bouwk', NULL, bouwlaagid, NEW.soort, new.bouwlaag, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.veiligh_bouwk SET geom = new.geom, soort = new.soort, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
            WHERE (veiligh_bouwk.id = new.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, 'UPDATE', 'veiligh_bouwk', old.id, new.bouwlaag_id, NEW.soort, new.bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_LineInterpolatePoint(ST_LineMerge(old.geom), 0.5), ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5)), old.id, 'veiligh_bouwk', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        objectid integer;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.bereikbaarheid (geom, obstakels, wegafzetting, soort, object_id, fotografie_id, label)
            VALUES (new.geom, new.obstakels, new.wegafzetting, new.soort, new.object_id, new.fotografie_id, new.label);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.obstakels, new.wegafzetting) d));
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'bereikbaarheid', NULL, objectid, NEW.soort, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.bereikbaarheid SET geom = new.geom, obstakels = new.obstakels, wegafzetting = new.wegafzetting, soort = new.soort, object_id = new.object_id, fotografie_id = new.fotografie_id, label = new.label
            WHERE (bereikbaarheid.id = new.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.obstakels, new.wegafzetting) d));

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'bereikbaarheid', old.id, new.object_id, NEW.soort, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) 
                    VALUES (ST_MakeLine(ST_LineInterpolatePoint(ST_LineMerge(old.geom), 0.5), ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5)), old.id, 'bereikbaarheid');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        objectid integer;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.isolijnen (geom, hoogte, omschrijving, object_id)
            VALUES (new.geom, new.hoogte, new.omschrijving, new.object_id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'isolijnen', NULL, objectid, NEW.hoogte::text, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.isolijnen SET geom = new.geom, hoogte = new.hoogte, omschrijving = new.omschrijving, object_id = new.object_id
            WHERE (isolijnen.id = new.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'isolijnen', old.id, new.object_id, NEW.hoogte::text, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) 
                    VALUES (ST_MakeLine(ST_LineInterpolatePoint(ST_LineMerge(old.geom), 0.5), ST_LineInterpolatePoint(ST_LineMerge(new.geom), 0.5)), old.id, 'isolijnen');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 9;
UPDATE algemeen.applicatie SET db_versie = 339; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();