SET role oiv_admin;
SET search_path = mobiel, pg_catalog, public;

UPDATE objecten.label_type SET symbol_name = naam;

DROP SCHEMA IF EXISTS mobiel CASCADE;
CREATE SCHEMA mobiel;
GRANT USAGE ON SCHEMA mobiel TO oiv_read;

CREATE TABLE mobiel.log_werkvoorraad (
    id serial NOT NULL,
    datum_aangemaakt timestamp,
    datum_gewijzigd timestamp,
    geom geometry(geometry, 28992),
    record json,
    CONSTRAINT log_werkvoorraad_pkey PRIMARY KEY (id)
);

CREATE INDEX log_werkvoorraad_geom_gist ON mobiel.log_werkvoorraad USING gist (geom);

CREATE TABLE mobiel.werkvoorraad_punt (
    id serial NOT NULL,
    datum_aangemaakt timestamp DEFAULT now(),
    datum_gewijzigd timestamp,
    geom geometry(point, 28992),
    waarden_new json,
    operatie varchar(10),
    brontabel varchar(50),
    bron_id integer,
    object_id integer,
    bouwlaag_id integer,
    rotatie integer,
    SIZE integer,
    symbol_name TEXT,
    accepted bool,
    bouwlaag integer,
    fotografie_id integer,
    CONSTRAINT werkvoorraad_punt_pkey PRIMARY KEY (id)
);

CREATE TABLE mobiel.werkvoorraad_lijn (
    id serial NOT NULL,
    datum_aangemaakt timestamp DEFAULT now(),
    datum_gewijzigd timestamp,
    geom geometry(MultiLineString, 28992),
    waarden_new json,
    operatie varchar(10),
    brontabel varchar(50),
    bron_id integer,
    object_id integer,
    bouwlaag_id integer,
    symbol_name text,
    accepted bool,
    bouwlaag integer,
    fotografie_id integer,
    CONSTRAINT werkvoorraad_lijn_pkey PRIMARY KEY (id)
);

CREATE TABLE mobiel.werkvoorraad_vlak (
    id serial NOT NULL,
    datum_aangemaakt timestamp DEFAULT now(),
    datum_gewijzigd timestamp,
    geom geometry(MultiPolygon, 28992),
    waarden_new json,
    operatie varchar(10),
    brontabel varchar(50),
    bron_id integer,
    object_id integer,
    bouwlaag_id integer,
    symbol_name text,
    accepted bool,
    bouwlaag integer,
    fotografie_id integer,
    CONSTRAINT werkvoorraad_vlak_pkey PRIMARY KEY (id)
);

CREATE TABLE mobiel.werkvoorraad_hulplijnen (
    id serial NOT NULL,
    datum_aangemaakt timestamp DEFAULT now(),
    geom geometry(LineString, 28992),
    bron_id integer,
    brontabel varchar(50),
    bouwlaag_id integer,
    object_id integer,
    bouwlaag integer,
    CONSTRAINT werkvoorraad_hulplijnen_pkey PRIMARY KEY (id)
);

CREATE OR REPLACE VIEW mobiel.bouwlagen_binnen_object AS
SELECT DISTINCT t.object_id, bouwlaag FROM mobiel.werkvoorraad_punt w 
                INNER JOIN objecten.terrein t ON ST_INTERSECTS(w.geom, t.geom) 
                WHERE w.object_id IS NULL
                GROUP BY t.object_id, bouwlaag;

CREATE INDEX werkvoorraad_punt_geom_gist ON mobiel.werkvoorraad_punt USING gist (geom);
CREATE INDEX werkvoorraad_lijn_geom_gist ON mobiel.werkvoorraad_lijn USING gist (geom);
CREATE INDEX werkvoorraad_vlak_geom_gist ON mobiel.werkvoorraad_vlak USING gist (geom);
CREATE INDEX werkvoorraad_hulplijnen_geom_gist ON mobiel.werkvoorraad_hulplijnen USING gist (geom);

-- Table Triggers
CREATE TRIGGER trg_set_mutatie BEFORE
    UPDATE ON mobiel.werkvoorraad_punt FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE 
    INSERT ON mobiel.werkvoorraad_punt FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie BEFORE
    UPDATE ON mobiel.werkvoorraad_lijn FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE 
    INSERT ON mobiel.werkvoorraad_lijn FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie BEFORE
    UPDATE ON mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE 
    INSERT ON mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert BEFORE 
    INSERT ON mobiel.werkvoorraad_hulplijnen FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');


CREATE OR REPLACE VIEW mobiel.werkvoorraad_objecten
AS SELECT DISTINCT o.id,
    o.geom,
    sub.object_id
   FROM ( SELECT DISTINCT werkvoorraad_punt.object_id
           FROM mobiel.werkvoorraad_punt
        UNION
         SELECT DISTINCT werkvoorraad_lijn.object_id
           FROM mobiel.werkvoorraad_lijn
        UNION
         SELECT DISTINCT werkvoorraad_vlak.object_id
           FROM mobiel.werkvoorraad_vlak) sub
     JOIN objecten.object o ON sub.object_id = o.id;

--create function/trigger installatietechnische veiligheidsvoorzieningen
DROP VIEW IF EXISTS objecten.bouwlaag_veiligh_install;
CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_install
AS SELECT v.id, v.geom, v.datum_aangemaakt, v.datum_gewijzigd, v.veiligh_install_type_id, v.label, v.bijzonderheid, v.bouwlaag_id, v.rotatie, v.fotografie_id, b.bouwlaag, vt.size, vt.symbol_name, ''::text as applicatie
    FROM objecten.veiligh_install v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type vt ON v.veiligh_install_type_id = vt.id;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.veiligh_install (geom, veiligh_install_type_id, label, bijzonderheid, rotatie, bouwlaag_id, fotografie_id)
            VALUES (new.geom, new.veiligh_install_type_id, new.label, new.bijzonderheid, new.rotatie, new.bouwlaag_id, new.fotografie_id);
        ELSE
            size := (SELECT vt."size" FROM objecten.veiligh_install_type vt WHERE vt.id = new.veiligh_install_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.veiligh_install_type vt WHERE vt.id = new.veiligh_install_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.bijzonderheid) d));
            bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
            
            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted, fotografie_id)
            VALUES (new.geom, jsonstring, 'INSERT', 'veiligh_install', NULL, bouwlaagid, NEW.rotatie, size, symbol_name, new.bouwlaag, false, new.fotografie_id);
        
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.veiligh_install WHERE (veiligh_install.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.bijzonderheid) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted, fotografie_id)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'veiligh_install', OLD.id, OLD.bouwlaag_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.bouwlaag, false, OLD.fotografie_id);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.veiligh_install SET geom = new.geom, veiligh_install_type_id = new.veiligh_install_type_id, bouwlaag_id = new.bouwlaag_id, label = new.label, rotatie = new.rotatie, fotografie_id = new.fotografie_id
            WHERE (veiligh_install.id = new.id);
        ELSE
            size := (SELECT vt."size" FROM objecten.veiligh_install_type vt WHERE vt.id = new.veiligh_install_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.veiligh_install_type vt WHERE vt.id = new.veiligh_install_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.bijzonderheid) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, accepted, bouwlaag, fotografie_id)
            VALUES (new.geom, jsonstring, 'UPDATE', 'veiligh_install', old.id, new.bouwlaag_id, NEW.rotatie, size, symbol_name, false, new.bouwlaag, new.fotografie_id);
            
            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'veiligh_install', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER veiligh_install_ins
    INSTEAD OF INSERT ON objecten.bouwlaag_veiligh_install
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_veiligh_install_ins();

CREATE TRIGGER veiligh_install_del
    INSTEAD OF DELETE ON objecten.bouwlaag_veiligh_install
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_veiligh_install_del();

CREATE TRIGGER veiligh_install_upd
    INSTEAD OF UPDATE ON objecten.bouwlaag_veiligh_install
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_veiligh_install_upd();


--create function/trigger opslag stoffen
DROP VIEW IF EXISTS objecten.bouwlaag_opslag;
CREATE OR REPLACE VIEW objecten.bouwlaag_opslag
AS SELECT o.id, o.geom, o.datum_aangemaakt, o.datum_gewijzigd, o.locatie, o.bouwlaag_id, o.object_id, o.fotografie_id, o.rotatie, b.bouwlaag, st.symbol_name, st.size, ''::text as applicatie 
   FROM objecten.gevaarlijkestof_opslag o
     JOIN objecten.bouwlagen b ON o.bouwlaag_id = b.id
     JOIN algemeen.styles_symbols_type st ON 'Opslag stoffen'::text = st.naam;

DROP VIEW IF EXISTS objecten.object_opslag;
CREATE OR REPLACE VIEW objecten.object_opslag AS 
 SELECT o.id, o.geom, o.datum_aangemaakt, o.datum_gewijzigd, o.locatie, o.bouwlaag_id, o.object_id, o.fotografie_id, b.formelenaam, o.rotatie, st.size, st.symbol_name, ''::text as applicatie
   FROM objecten.gevaarlijkestof_opslag o
     INNER JOIN objecten.object b ON o.object_id = b.id
     INNER JOIN algemeen.styles_symbols_type st ON 'Opslag stoffen' = st.naam;


CREATE OR REPLACE FUNCTION objecten.func_opslag_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.gevaarlijkestof_opslag (geom, locatie, bouwlaag_id, object_id, fotografie_id, rotatie)
            VALUES (new.geom, new.locatie, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie);
        ELSE
            size := (SELECT st."size" FROM algemeen.styles_symbols_type st WHERE st.naam = 'Opslag stoffen'::text);
            symbol_name := (SELECT st.symbol_name FROM algemeen.styles_symbols_type st WHERE st.naam = 'Opslag stoffen'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'object'::text THEN
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'gevaarlijkestof_opslag', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_opslag_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.gevaarlijkestof_opslag WHERE (gevaarlijkestof_opslag.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'gevaarlijkestof_opslag', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_opslag_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (gevaarlijkestof_opslag.id = new.id);
        ELSE
            size := (SELECT st."size" FROM algemeen.styles_symbols_type st WHERE st.naam = 'Opslag stoffen'::text);
            symbol_name := (SELECT st.symbol_name FROM algemeen.styles_symbols_type st WHERE st.naam = 'Opslag stoffen'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'gevaarlijkestof_opslag', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'gevaarlijkestof_opslag', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER bouwlaag_opslag_ins
    INSTEAD OF INSERT ON objecten.bouwlaag_opslag
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_opslag_ins('bouwlaag');

CREATE TRIGGER object_opslag_ins
    INSTEAD OF INSERT ON objecten.object_opslag
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_opslag_ins('object');

CREATE TRIGGER bouwlaag_opslag_del
    INSTEAD OF DELETE ON objecten.bouwlaag_opslag
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_opslag_del('bouwlaag');

CREATE TRIGGER object_opslag_del
    INSTEAD OF DELETE ON objecten.object_opslag
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_opslag_del('object');

CREATE TRIGGER bouwlaag_opslag_upd
    INSTEAD OF UPDATE ON objecten.bouwlaag_opslag
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_opslag_upd('bouwlaag');

CREATE TRIGGER object_opslag_upd
    INSTEAD OF UPDATE ON objecten.object_opslag
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_opslag_upd('object');


-- labels
DROP VIEW IF EXISTS objecten.bouwlaag_label;
CREATE OR REPLACE VIEW objecten.bouwlaag_label AS 
 SELECT l.id, l.geom, l.soort, l.omschrijving, l.bouwlaag_id, l.object_id, b.bouwlaag, l.rotatie, st.symbol_name, st.size, ''::text as applicatie
   FROM objecten.label l
     JOIN objecten.bouwlagen b ON l.bouwlaag_id = b.id
     INNER JOIN objecten.label_type st ON l.soort::TEXT = st.naam;

DROP VIEW IF EXISTS objecten.object_label;
CREATE OR REPLACE VIEW objecten.object_label AS 
 SELECT l.id, l.geom, l.soort, l.omschrijving, l.bouwlaag_id, l.object_id, b.formelenaam, l.rotatie, st.symbol_name, st.size, ''::text as applicatie
   FROM objecten.label l
     INNER JOIN objecten.object b ON l.object_id = b.id
     INNER JOIN objecten.label_type st ON l.soort::TEXT = st.naam;

CREATE OR REPLACE FUNCTION objecten.func_label_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.label (geom, soort, omschrijving, rotatie, bouwlaag_id, object_id)
            VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id, new.object_id);
        ELSE
            size := (SELECT dt."size" FROM objecten.label_type dt WHERE dt.naam = new.soort);
            symbol_name := (SELECT dt.symbol_name FROM objecten.label_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'object'::text THEN
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'label', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_label_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.label WHERE (label.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.omschrijving) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'label', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_label_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id
            WHERE (label.id = new.id);
        ELSE
            size := (SELECT dt."size" FROM objecten.label_type dt WHERE dt.naam = new.soort);
            symbol_name := (SELECT dt.symbol_name FROM objecten.label_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'label', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, size, symbol_name, bouwlaag, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'label', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER bouwlaag_label_ins
    INSTEAD OF INSERT ON objecten.bouwlaag_label
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_label_ins('bouwlaag');

CREATE TRIGGER object_label_ins
    INSTEAD OF INSERT ON objecten.object_label
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_label_ins('object');

CREATE TRIGGER bouwlaag_label_del
    INSTEAD OF DELETE ON objecten.bouwlaag_label
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_label_del('bouwlaag');

CREATE TRIGGER object_label_del
    INSTEAD OF DELETE ON objecten.object_label
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_label_del('object');

CREATE TRIGGER bouwlaag_label_upd
    INSTEAD OF UPDATE ON objecten.bouwlaag_label
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_label_upd('bouwlaag');

CREATE TRIGGER object_label_upd
    INSTEAD OF UPDATE ON objecten.object_label
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_label_upd('object');


--dreiging
DROP VIEW IF EXISTS objecten.bouwlaag_dreiging;
CREATE OR REPLACE VIEW objecten.bouwlaag_dreiging AS 
 SELECT v.id, v.geom, v.dreiging_type_id, v.label, v.fotografie_id, v.omschrijving, v.bouwlaag_id, v.object_id, b.bouwlaag, v.rotatie, st.symbol_name, st.size, ''::text as applicatie
 FROM objecten.dreiging v 
   INNER JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
   INNER JOIN objecten.dreiging_type st ON v.dreiging_type_id = st.id;

DROP VIEW IF EXISTS objecten.object_dreiging;
CREATE OR REPLACE VIEW objecten.object_dreiging AS 
 SELECT v.id, v.geom, v.dreiging_type_id, v.label, v.fotografie_id, v.omschrijving, v.bouwlaag_id, v.object_id, b.formelenaam, v.rotatie, st.symbol_name, st.size, ''::text as applicatie
 FROM objecten.dreiging v 
   INNER JOIN objecten.object b ON v.object_id = b.id
   INNER JOIN objecten.dreiging_type st ON v.dreiging_type_id = st.id;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.dreiging (geom, dreiging_type_id, label, rotatie, bouwlaag_id, object_id, fotografie_id)
            VALUES (new.geom, new.dreiging_type_id, new.label, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id);
        ELSE
            size := (SELECT dt."size" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.omschrijving) d));

            IF bouwlaag_object = 'object'::text THEN
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'dreiging', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.dreiging WHERE (dreiging.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.omschrijving) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'dreiging', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (dreiging.id = new.id);
        ELSE
            size := (SELECT dt."size" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.omschrijving) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'dreiging', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag , new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'dreiging', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER bouwlaag_dreiging_ins
    INSTEAD OF INSERT ON objecten.bouwlaag_dreiging
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_dreiging_ins('bouwlaag');

CREATE TRIGGER object_dreiging_ins
    INSTEAD OF INSERT ON objecten.object_dreiging
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_dreiging_ins('object');

CREATE TRIGGER bouwlaag_dreiging_del
    INSTEAD OF DELETE ON objecten.bouwlaag_dreiging
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_dreiging_del('bouwlaag');

CREATE TRIGGER object_dreiging_del
    INSTEAD OF DELETE ON objecten.object_dreiging
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_dreiging_del('object');

CREATE TRIGGER bouwlaag_dreiging_upd
    INSTEAD OF UPDATE ON objecten.bouwlaag_dreiging
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_dreiging_upd('bouwlaag');

CREATE TRIGGER object_dreiging_upd
    INSTEAD OF UPDATE ON objecten.object_dreiging
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_dreiging_upd('object');


--ingang
DROP VIEW IF EXISTS objecten.bouwlaag_ingang;
CREATE OR REPLACE VIEW objecten.bouwlaag_ingang AS 
 SELECT v.id, v.geom, v.ingang_type_id, v.label, v.belemmering, v.voorzieningen, v.fotografie_id, v.bouwlaag_id, v.object_id, b.bouwlaag, v.rotatie, it.symbol_name, it.size, ''::text as applicatie
   FROM objecten.ingang v
     INNER JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     INNER JOIN objecten.ingang_type it ON v.ingang_type_id = it.id ;

DROP VIEW IF EXISTS objecten.object_ingang;
CREATE OR REPLACE VIEW objecten.object_ingang AS 
 SELECT v.id, v.geom, v.ingang_type_id, v.label, v.belemmering, v.voorzieningen, v.fotografie_id, v.bouwlaag_id, v.object_id, b.formelenaam, v.rotatie, it.symbol_name, it.size, ''::text as applicatie
   FROM objecten.ingang v
     INNER JOIN objecten.object b ON v.object_id = b.id
     INNER JOIN objecten.ingang_type it ON v.ingang_type_id = it.id ;

CREATE OR REPLACE FUNCTION objecten.func_ingang_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.ingang (geom, ingang_type_id, label, rotatie, belemmering, voorzieningen, bouwlaag_id, object_id, fotografie_id)
            VALUES (new.geom, new.ingang_type_id, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.bouwlaag_id, new.object_id, new.fotografie_id);
        ELSE
            size := (SELECT dt."size" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.belemmering, new.voorzieningen) d));

            IF bouwlaag_object = 'object'::text THEN
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'ingang', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_ingang_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.ingang WHERE (ingang.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.belemmering, old.voorzieningen) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'ingang', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_ingang_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, 
                    bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (ingang.id = new.id);
        ELSE
            size := (SELECT dt."size" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.belemmering, new.voorzieningen) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'ingang', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'ingang', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER bouwlaag_ingang_ins
    INSTEAD OF INSERT ON objecten.bouwlaag_ingang
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_ingang_ins('bouwlaag');

CREATE TRIGGER object_ingang_ins
    INSTEAD OF INSERT ON objecten.object_ingang
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_ingang_ins('object');

CREATE TRIGGER bouwlaag_ingang_del
    INSTEAD OF DELETE ON objecten.bouwlaag_ingang
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_ingang_del('bouwlaag');

CREATE TRIGGER object_ingang_del
    INSTEAD OF DELETE ON objecten.object_ingang
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_ingang_del('object');

CREATE TRIGGER bouwlaag_ingang_upd
    INSTEAD OF UPDATE ON objecten.bouwlaag_ingang
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_ingang_upd('bouwlaag');

CREATE TRIGGER object_ingang_upd
    INSTEAD OF UPDATE ON objecten.object_ingang
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_ingang_upd('object');


--sleutelkluis
DROP VIEW IF EXISTS objecten.bouwlaag_sleutelkluis;
CREATE OR REPLACE VIEW objecten.bouwlaag_sleutelkluis AS 
 SELECT v.id, v.geom, v.sleutelkluis_type_id, v.label, v.aanduiding_locatie, v.sleuteldoel_type_id, v.fotografie_id, v.ingang_id, part.bouwlaag, v.rotatie, it.symbol_name, it.size, ''::text as applicatie
   FROM objecten.sleutelkluis v
     JOIN ( SELECT b.bouwlaag, ib.id, ib.bouwlaag_id FROM objecten.ingang ib JOIN objecten.bouwlagen b ON ib.bouwlaag_id = b.id) part ON v.ingang_id = part.id
     INNER JOIN objecten.sleutelkluis_type it ON v.sleutelkluis_type_id = it.id;

DROP VIEW IF EXISTS objecten.object_sleutelkluis;
CREATE OR REPLACE VIEW objecten.object_sleutelkluis AS
 SELECT v.id, v.geom, v.sleutelkluis_type_id, v.label, v.aanduiding_locatie, v.sleuteldoel_type_id, v.fotografie_id, v.ingang_id, part.formelenaam, v.rotatie, it.symbol_name, it.size, ''::text as applicatie
   FROM objecten.sleutelkluis v
     INNER JOIN ( SELECT b.formelenaam, ib.id, ib.object_id FROM objecten.ingang ib JOIN objecten.object b ON ib.object_id = b.id) part ON v.ingang_id = part.id
     INNER JOIN objecten.sleutelkluis_type it ON v.sleutelkluis_type_id = it.id;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        ingangid integer;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, fotografie_id)
            VALUES (new.geom, new.sleutelkluis_type_id, new.label, new.rotatie, new.aanduiding_locatie, new.sleuteldoel_type_id, new.ingang_id, new.fotografie_id);
        ELSE
            size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                ingangid := (SELECT i.ingang_id FROM (SELECT i.id AS ingang_id, b.geom <-> new.geom AS dist FROM objecten.ingang i
                                INNER JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) i);
                bouwlaag = new.bouwlaag;
            ELSEIF bouwlaag_object = 'object'::text THEN
                ingangid := (SELECT b.ingang_id FROM (SELECT b.id AS ingang_id, b.geom <-> new.geom AS dist FROM objecten.ingang b ORDER BY dist LIMIT 1) b);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, row_to_json(NEW.*), 'INSERT', 'sleutelkluis', NULL, ingangid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.sleutelkluis WHERE (sleutelkluis.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.aanduiding_locatie, old.sleuteldoel_type_id) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'sleutelkluis', OLD.id, OLD.ingang_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, OLD.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, 
                    bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (ingang.id = new.id);
        ELSE
            size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'sleutelkluis', old.id, new.ingang_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'sleutelkluis', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER bouwlaag_sleutelkluis_ins
    INSTEAD OF INSERT ON objecten.bouwlaag_sleutelkluis
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_sleutelkluis_ins('bouwlaag');

CREATE TRIGGER object_sleutelkluis_ins
    INSTEAD OF INSERT ON objecten.object_sleutelkluis
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_sleutelkluis_ins('object');

CREATE TRIGGER bouwlaag_sleutelkluis_del
    INSTEAD OF DELETE ON objecten.bouwlaag_sleutelkluis
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_sleutelkluis_del('bouwlaag');

CREATE TRIGGER object_sleutelkluis_del
    INSTEAD OF DELETE ON objecten.object_sleutelkluis
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_sleutelkluis_del('object');

CREATE TRIGGER bouwlaag_sleutelkluis_upd
    INSTEAD OF UPDATE ON objecten.bouwlaag_sleutelkluis
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_sleutelkluis_upd('bouwlaag');

CREATE TRIGGER object_sleutelkluis_upd
    INSTEAD OF UPDATE ON objecten.object_sleutelkluis
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_sleutelkluis_upd('object');


--bouwlaag afwijkende binnendekking
DROP VIEW IF EXISTS objecten.bouwlaag_afw_binnendekking;
CREATE OR REPLACE VIEW objecten.bouwlaag_afw_binnendekking AS 
 SELECT v.id, v.geom, v.soort, v.label, v.handelingsaanwijzing, v.bouwlaag_id, b.bouwlaag, v.rotatie, st.symbol_name, st.size, ''::text as applicatie
   FROM objecten.afw_binnendekking v
     INNER JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     INNER JOIN objecten.afw_binnendekking_type st ON v.soort::TEXT = st.naam;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.afw_binnendekking (geom, soort, label, rotatie, handelingsaanwijzing, bouwlaag_id)
            VALUES (new.geom, new.soort, new.label, new.rotatie, new.handelingsaanwijzing, new.bouwlaag_id);
        ELSE
            size := (SELECT at."size" FROM objecten.afw_binnendekking_type at WHERE naam = new.soort);
            symbol_name := (SELECT at.symbol_name FROM objecten.afw_binnendekking_type at WHERE naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.handelingsaanwijzing) d));
            bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
    
            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'afw_binnendekking', NULL, bouwlaagid, NEW.rotatie, size, symbol_name, new.bouwlaag, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.afw_binnendekking WHERE (afw_binnendekking.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.handelingsaanwijzing) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'afw_binnendekking', OLD.id, OLD.bouwlaag_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.bouwlaag, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.afw_binnendekking SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, handelingsaanwijzing = new.handelingsaanwijzing, bouwlaag_id = new.bouwlaag_id
            WHERE (afw_binnendekking.id = new.id);
        ELSE
            size := (SELECT at."size" FROM objecten.afw_binnendekking_type at WHERE naam = new.soort);
            symbol_name := (SELECT at.symbol_name FROM objecten.afw_binnendekking_type at WHERE naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.handelingsaanwijzing) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'afw_binnendekking', old.id, new.bouwlaag_id, NEW.rotatie, size, symbol_name, new.bouwlaag, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'afw_binnendekking', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER afw_binnendekking_ins
    INSTEAD OF INSERT ON objecten.bouwlaag_afw_binnendekking
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_afw_binnendekking_ins();

CREATE TRIGGER afw_binnendekking_del
    INSTEAD OF DELETE ON objecten.bouwlaag_afw_binnendekking
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_afw_binnendekking_del();

CREATE TRIGGER afw_binnendekking_upd
    INSTEAD OF UPDATE ON objecten.bouwlaag_afw_binnendekking
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_afw_binnendekking_upd();


--opstelplaats
DROP VIEW IF EXISTS objecten.object_opstelplaats;
CREATE OR REPLACE VIEW objecten.object_opstelplaats AS 
 SELECT l.id, l.geom, l.soort, l.label, l.fotografie_id, l.object_id, b.formelenaam, l.rotatie, st.symbol_name, st.size, ''::text as applicatie
   FROM objecten.opstelplaats l
     INNER JOIN objecten.object b ON l.object_id = b.id
     INNER JOIN objecten.opstelplaats_type st ON l.soort::TEXT = st.naam;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        objectid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.opstelplaats (geom, soort, label, rotatie, object_id, fotografie_id)
            VALUES (new.geom, new.soort, new.label, new.rotatie, new.object_id, new.fotografie_id);
        ELSE
            size := (SELECT ot."size" FROM objecten.opstelplaats_type ot WHERE ot.naam = new.soort);
            symbol_name := (SELECT ot.symbol_name FROM objecten.opstelplaats_type ot WHERE ot.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label) d));
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'opstelplaats', NULL, objectid, NEW.rotatie, size, symbol_name, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.opstelplaats WHERE (opstelplaats.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'opstelplaats', OLD.id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.opstelplaats SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (opstelplaats.id = new.id);
        ELSE
            size := (SELECT ot."size" FROM objecten.opstelplaats_type ot WHERE ot.naam = new.soort);
            symbol_name := (SELECT ot.symbol_name FROM objecten.opstelplaats_type ot WHERE ot.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'opstelplaats', old.id, new.object_id, NEW.rotatie, size, symbol_name, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'opstelplaats');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER opstelplaats_ins
    INSTEAD OF INSERT ON objecten.object_opstelplaats
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_opstelplaats_ins();

CREATE TRIGGER opstelplaats_del
    INSTEAD OF DELETE ON objecten.object_opstelplaats
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_opstelplaats_del();

CREATE TRIGGER opstelplaats_upd
    INSTEAD OF UPDATE ON objecten.object_opstelplaats
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_opstelplaats_upd();


--object veiligheidsvoorzieningen ruimtelijk
DROP VIEW IF EXISTS objecten.object_veiligh_ruimtelijk;
CREATE OR REPLACE VIEW objecten.object_veiligh_ruimtelijk
AS SELECT b.id, b.geom, b.veiligh_ruimtelijk_type_id, b.label, b.bijzonderheid, b.fotografie_id, b.object_id, o.formelenaam, b.rotatie, vt.symbol_name, vt.size, ''::text as applicatie
   FROM objecten.veiligh_ruimtelijk b
     INNER JOIN objecten.object o ON b.object_id = o.id
     INNER JOIN objecten.veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_ruimtelijk_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        objectid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.veiligh_ruimtelijk (geom, veiligh_ruimtelijk_type_id, label, rotatie, object_id, fotografie_id)
            VALUES (new.geom, new.veiligh_ruimtelijk_type_id, new.label, new.rotatie, new.object_id, new.fotografie_id);
        ELSE
            size := (SELECT vt."size" FROM objecten.veiligh_ruimtelijk_type vt WHERE vt.id = new.veiligh_ruimtelijk_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.veiligh_ruimtelijk_type vt WHERE vt.id = new.veiligh_ruimtelijk_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.bijzonderheid) d));        
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'veiligh_ruimtelijk', NULL, objectid, NEW.rotatie, size, symbol_name, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_ruimtelijk_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.veiligh_ruimtelijk WHERE (veiligh_ruimtelijk.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.bijzonderheid) d));        

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'veiligh_ruimtelijk', OLD.id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_ruimtelijk_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.veiligh_ruimtelijk SET geom = new.geom, veiligh_ruimtelijk_type_id = new.veiligh_ruimtelijk_type_id, rotatie = new.rotatie, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
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
    $$;

CREATE TRIGGER veiligh_ruimtelijk_ins
    INSTEAD OF INSERT ON objecten.object_veiligh_ruimtelijk
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_veiligh_ruimtelijk_ins();

CREATE TRIGGER veiligh_ruimtelijk_del
    INSTEAD OF DELETE ON objecten.object_veiligh_ruimtelijk
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_veiligh_ruimtelijk_del();

CREATE TRIGGER veiligh_ruimtelijk_upd
    INSTEAD OF UPDATE ON objecten.object_veiligh_ruimtelijk
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_veiligh_ruimtelijk_upd();


--object point-of-interest
DROP VIEW IF EXISTS objecten.object_points_of_interest;
CREATE OR REPLACE VIEW objecten.object_points_of_interest
AS SELECT b.id, b.geom, b.points_of_interest_type_id, b.label, b.bijzonderheid, b.fotografie_id, b.object_id, o.formelenaam, b.rotatie, vt.symbol_name, vt.size, ''::text as applicatie
   FROM objecten.points_of_interest b
     INNER JOIN objecten.object o ON b.object_id = o.id
     INNER JOIN objecten.points_of_interest_type vt ON b.points_of_interest_type_id = vt.id;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        objectid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.points_of_interest (geom, points_of_interest_type_id, label, bijzonderheid, rotatie, object_id, fotografie_id)
            VALUES (new.geom, new.points_of_interest_type_id, new.label, new.bijzonderheid, new.rotatie, new.object_id, new.fotografie_id);
        ELSE
            size := (SELECT vt."size" FROM objecten.points_of_interest_type vt WHERE vt.id = new.points_of_interest_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.points_of_interest_type vt WHERE vt.id = new.points_of_interest_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.bijzonderheid) d));
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'points_of_interest', NULL, objectid, NEW.rotatie, size, symbol_name, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF old.applicatie = 'OIV' THEN 
            DELETE FROM objecten.points_of_interest WHERE (points_of_interest.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.bijzonderheid) d)); 

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'points_of_interest', OLD.id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
                UPDATE objecten.points_of_interest SET geom = new.geom, points_of_interest_type_id = new.points_of_interest_type_id, rotatie = new.rotatie, bijzonderheid = new.bijzonderheid, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
                WHERE (points_of_interest.id = new.id);
        ELSE
            size := (SELECT vt."size" FROM objecten.points_of_interest_type vt WHERE vt.id = new.points_of_interest_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.points_of_interest_type vt WHERE vt.id = new.points_of_interest_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.bijzonderheid) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'points_of_interest', old.id, new.object_id, NEW.rotatie, size, symbol_name, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'points_of_interest');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER points_of_interest_ins
    INSTEAD OF INSERT ON objecten.object_points_of_interest
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_points_of_interest_ins();

CREATE TRIGGER points_of_interest_del
    INSTEAD OF DELETE ON objecten.object_points_of_interest
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_points_of_interest_del();

CREATE TRIGGER points_of_interest_upd
    INSTEAD OF UPDATE ON objecten.object_points_of_interest
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_points_of_interest_upd();


--object gebiedsgerichte aanpak
DROP VIEW IF EXISTS objecten.object_gebiedsgerichte_aanpak;
CREATE OR REPLACE VIEW objecten.object_gebiedsgerichte_aanpak AS 
 SELECT l.id, l.geom, l.soort, l.label, l.bijzonderheden, l.fotografie_id, l.object_id, b.formelenaam, ''::text as applicatie
   FROM objecten.gebiedsgerichte_aanpak l
     INNER JOIN objecten.object b ON l.object_id = b.id;

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
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_Line_Interpolate_Point(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'gebiedsgerichte_aanpak', NULL, objectid, NEW.soort, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.gebiedsgerichte_aanpak WHERE (gebiedsgerichte_aanpak.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.bijzonderheden) d)); 

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'gebiedsgerichte_aanpak', OLD.id, OLD.object_id, OLD.soort, old.fotografie_id, false);
        END IF;
        RETURN OLD;
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
                    VALUES (ST_MakeLine(ST_Line_Interpolate_Point(ST_LineMerge(old.geom), 0.5), ST_Line_Interpolate_Point(ST_LineMerge(new.geom), 0.5)), old.id, 'gebiedsgerichte_aanpak');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER gebiedsgerichte_aanpak_ins
    INSTEAD OF INSERT ON objecten.object_gebiedsgerichte_aanpak
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_gebiedsgerichte_aanpak_ins();

CREATE TRIGGER gebiedsgerichte_aanpak_del
    INSTEAD OF DELETE ON objecten.object_gebiedsgerichte_aanpak
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_gebiedsgerichte_aanpak_del();

CREATE TRIGGER gebiedsgerichte_aanpak_upd
    INSTEAD OF UPDATE ON objecten.object_gebiedsgerichte_aanpak
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_gebiedsgerichte_aanpak_upd();

--bouwlaag veiligheidsvoorzieningen bouwkundig
DROP VIEW IF EXISTS objecten.bouwlaag_veiligh_bouwk;
CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_bouwk AS
  SELECT v.id, v.geom, v.soort, v.fotografie_id, v.bouwlaag_id, b.bouwlaag, ''::text as applicatie 
  FROM objecten.veiligh_bouwk v JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id;

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
            bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> ST_Line_Interpolate_Point(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.bouwlagen b 
                                                        WHERE b.bouwlaag = new.bouwlaag 
                                                        ORDER BY dist LIMIT 1) b);
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, 'INSERT', 'veiligh_bouwk', NULL, bouwlaagid, NEW.soort, new.bouwlaag, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.veiligh_bouwk WHERE (veiligh_bouwk.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, 'DELETE', 'veiligh_bouwk', OLD.id, OLD.bouwlaag_id, OLD.soort, OLD.bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
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
                    VALUES (ST_MakeLine(ST_Line_Interpolate_Point(ST_LineMerge(old.geom), 0.5), ST_Line_Interpolate_Point(ST_LineMerge(new.geom), 0.5)), old.id, 'veiligh_bouwk', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER veiligh_bouwk_ins
    INSTEAD OF INSERT ON objecten.bouwlaag_veiligh_bouwk
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_veiligh_bouwk_ins();

CREATE TRIGGER veiligh_bouwk_del
    INSTEAD OF DELETE ON objecten.bouwlaag_veiligh_bouwk
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_veiligh_bouwk_del();

CREATE TRIGGER veiligh_bouwk_upd
    INSTEAD OF UPDATE ON objecten.bouwlaag_veiligh_bouwk
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_veiligh_bouwk_upd();


--bouwlaag ruimten
DROP VIEW IF EXISTS objecten.bouwlaag_ruimten;
CREATE OR REPLACE VIEW objecten.bouwlaag_ruimten AS 
 SELECT v.id, v.geom, v.ruimten_type_id, v.omschrijving, v.fotografie_id, v.bouwlaag_id, b.bouwlaag, ''::text as applicatie
   FROM objecten.ruimten v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.ruimten (geom, ruimten_type_id, omschrijving, bouwlaag_id, fotografie_id)
            VALUES (new.geom, new.ruimten_type_id, new.omschrijving, new.bouwlaag_id, new.fotografie_id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));
            bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> ST_Centroid(new.geom) AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
            
            INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'ruimten', NULL, bouwlaagid, NEW.ruimten_type_id, new.bouwlaag, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.ruimten WHERE (ruimten.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.omschrijving) d));

            INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'ruimten', OLD.id, OLD.bouwlaag_id, OLD.ruimten_type_id, OLD.bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.ruimten SET geom = new.geom, ruimten_type_id = new.ruimten_type_id, omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
            WHERE (ruimten.id = new.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'ruimten', old.id, new.bouwlaag_id, NEW.ruimten_type_id, new.bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.id, 'ruimten', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER ruimten_ins
    INSTEAD OF INSERT ON objecten.bouwlaag_ruimten
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_ruimten_ins();

CREATE TRIGGER ruimten_del
    INSTEAD OF DELETE ON objecten.bouwlaag_ruimten
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_ruimten_del();

CREATE TRIGGER ruimten_upd
    INSTEAD OF UPDATE ON objecten.bouwlaag_ruimten
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_ruimten_upd();


--object bereikbaarheid
DROP VIEW IF EXISTS objecten.object_bereikbaarheid;
CREATE OR REPLACE VIEW objecten.object_bereikbaarheid AS 
 SELECT l.id, l.geom, l.soort, l.label, l.obstakels, l.wegafzetting, l.fotografie_id, l.object_id, b.formelenaam, ''::text as applicatie
   FROM objecten.bereikbaarheid l
     INNER JOIN objecten.object b ON l.object_id = b.id;

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
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_Line_Interpolate_Point(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'bereikbaarheid', NULL, objectid, NEW.soort, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.bereikbaarheid WHERE (bereikbaarheid.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.obstakels, old.wegafzetting) d));

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'bereikbaarheid', OLD.id, OLD.object_id, OLD.soort, old.fotografie_id, false);
        END IF;
        RETURN OLD;
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
                    VALUES (ST_MakeLine(ST_Line_Interpolate_Point(ST_LineMerge(old.geom), 0.5), ST_Line_Interpolate_Point(ST_LineMerge(new.geom), 0.5)), old.id, 'bereikbaarheid');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER bereikbaarheid_ins
    INSTEAD OF INSERT ON objecten.object_bereikbaarheid
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_bereikbaarheid_ins();

CREATE TRIGGER bereikbaarheid_del
    INSTEAD OF DELETE ON objecten.object_bereikbaarheid
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_bereikbaarheid_del();

CREATE TRIGGER bereikbaarheid_upd
    INSTEAD OF UPDATE ON objecten.object_bereikbaarheid
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_bereikbaarheid_upd();


--object isolijnen
DROP VIEW IF EXISTS objecten.object_isolijnen;
CREATE OR REPLACE VIEW objecten.object_isolijnen AS 
 SELECT l.id, l.geom, l.hoogte, l.omschrijving, l.object_id, b.formelenaam, ''::text as applicatie
   FROM objecten.isolijnen l
     INNER JOIN objecten.object b ON l.object_id = b.id;

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
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_Line_Interpolate_Point(ST_LineMerge(new.geom), 0.5) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'isolijnen', NULL, objectid, NEW.hoogte::text, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.isolijnen WHERE (isolijnen.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.omschrijving) d));

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'isolijnen', OLD.id, OLD.object_id, OLD.hoogte::text, false);
        END IF;
        RETURN OLD;
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
                    VALUES (ST_MakeLine(ST_Line_Interpolate_Point(ST_LineMerge(old.geom), 0.5), ST_Line_Interpolate_Point(ST_LineMerge(new.geom), 0.5)), old.id, 'isolijnen');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER isolijnen_ins
    INSTEAD OF INSERT ON objecten.object_isolijnen
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_isolijnen_ins();

CREATE TRIGGER isolijnen_del
    INSTEAD OF DELETE ON objecten.object_isolijnen
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_isolijnen_del();

CREATE TRIGGER isolijnen_upd
    INSTEAD OF UPDATE ON objecten.object_isolijnen
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_isolijnen_upd();


--object sectoren
DROP VIEW IF EXISTS objecten.object_sectoren;
CREATE OR REPLACE VIEW objecten.object_sectoren AS 
 SELECT l.id, l.geom, l.soort, l.label, l.omschrijving, l.fotografie_id, l.object_id, b.formelenaam, ''::text as applicatie
   FROM objecten.sectoren l
     INNER JOIN objecten.object b ON l.object_id = b.id;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        objectid integer;
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.sectoren (geom, soort, omschrijving, label, object_id, fotografie_id)
            VALUES (new.geom, new.soort, new.omschrijving, new.label, new.object_id, new.fotografie_id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving, new.label) d));
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> ST_Centroid(new.geom) AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'sectoren', NULL, objectid, NEW.soort, new.fotografie_id, false);
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.sectoren WHERE (sectoren.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.omschrijving, old.label) d));

            INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'sectoren', OLD.id, OLD.object_id, OLD.soort, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.sectoren SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (sectoren.id = new.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving, new.label) d));

            INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'sectoren', old.id, new.object_id, NEW.soort, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.id, 'sectoren');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER sectoren_ins
    INSTEAD OF INSERT ON objecten.object_sectoren
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_sectoren_ins();

CREATE TRIGGER sectoren_del
    INSTEAD OF DELETE ON objecten.object_sectoren
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_sectoren_del();

CREATE TRIGGER sectoren_upd
    INSTEAD OF UPDATE ON objecten.object_sectoren
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_sectoren_upd();



-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 337; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
