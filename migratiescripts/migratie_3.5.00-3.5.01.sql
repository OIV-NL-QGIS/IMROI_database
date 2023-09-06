SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE algemeen.applicatie ADD COLUMN mobiel boolean;
UPDATE algemeen.applicatie SET mobiel = True WHERE id = 1;

CREATE OR REPLACE VIEW objecten.schade_cirkel_calc
AS SELECT sc.id,
    sc.datum_aangemaakt,
    sc.datum_gewijzigd,
    sc.straal,
    sc.soort,
    sc.gevaarlijkestof_id,
    st_buffer(part.geom, sc.straal::double precision)::geometry(Polygon,28992) AS geom_cirkel
   FROM objecten.gevaarlijkestof_schade_cirkel sc
     LEFT JOIN ( SELECT gb.id,
            ops.geom
           FROM objecten.gevaarlijkestof gb
             LEFT JOIN objecten.gevaarlijkestof_opslag ops ON gb.opslag_id = ops.id) part ON sc.gevaarlijkestof_id = part.id
   WHERE sc.datum_deleted IS NULL;

UPDATE objecten.gevaarlijkestof_vnnr SET vn_nr = ' ' WHERE vn_nr = 'geen vn nummer';

ALTER TABLE objecten.historie ALTER COLUMN matrix_code_id DROP NOT NULL;
ALTER TABLE objecten.aanwezig ALTER COLUMN aanwezig_type_id DROP NOT NULL;

--CREATE SCHEMA mobiel

DROP SCHEMA IF EXISTS mobiel CASCADE;

CREATE SCHEMA mobiel AUTHORIZATION oiv_admin;

-- DROP SEQUENCE mobiel.label_type_gid_seq;

CREATE SEQUENCE mobiel.label_type_gid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.label_type_gid_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.label_type_gid_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.label_type_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.label_type_gid_seq TO oiv_write;

-- DROP SEQUENCE mobiel.lijnen_type_gid_seq;

CREATE SEQUENCE mobiel.lijnen_type_gid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.lijnen_type_gid_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.lijnen_type_gid_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.lijnen_type_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.lijnen_type_gid_seq TO oiv_write;

-- DROP SEQUENCE mobiel.log_werkvoorraad_id_seq;

CREATE SEQUENCE mobiel.log_werkvoorraad_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.log_werkvoorraad_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.log_werkvoorraad_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.log_werkvoorraad_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.log_werkvoorraad_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq;

CREATE SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq TO oiv_write;

-- DROP SEQUENCE mobiel.punten_type_gid_seq;

CREATE SEQUENCE mobiel.punten_type_gid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.punten_type_gid_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.punten_type_gid_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.punten_type_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.punten_type_gid_seq TO oiv_write;

-- DROP SEQUENCE mobiel.scratchpad_id_seq;

CREATE SEQUENCE mobiel.scratchpad_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.scratchpad_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.scratchpad_id_seq TO oiv_admin;

-- DROP SEQUENCE mobiel.vlakken_type_gid_seq;

CREATE SEQUENCE mobiel.vlakken_type_gid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.vlakken_type_gid_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.vlakken_type_gid_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.vlakken_type_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.vlakken_type_gid_seq TO oiv_write;

-- DROP SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq;

CREATE SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.werkvoorraad_label_id_seq;

CREATE SEQUENCE mobiel.werkvoorraad_label_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.werkvoorraad_label_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.werkvoorraad_label_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.werkvoorraad_label_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_label_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.werkvoorraad_lijn_id_seq;

CREATE SEQUENCE mobiel.werkvoorraad_lijn_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.werkvoorraad_lijn_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.werkvoorraad_lijn_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.werkvoorraad_lijn_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_lijn_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.werkvoorraad_punt_id_seq;

CREATE SEQUENCE mobiel.werkvoorraad_punt_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.werkvoorraad_punt_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.werkvoorraad_punt_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.werkvoorraad_punt_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_punt_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.werkvoorraad_vlak_id_seq;

CREATE SEQUENCE mobiel.werkvoorraad_vlak_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.werkvoorraad_vlak_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.werkvoorraad_vlak_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE mobiel.werkvoorraad_vlak_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_vlak_id_seq TO oiv_write;
-- mobiel.gt_pk_metadata_table definition

-- Drop table

-- DROP TABLE mobiel.gt_pk_metadata_table;

CREATE TABLE mobiel.gt_pk_metadata_table (
	table_schema varchar(32) NOT NULL,
	table_name varchar(32) NOT NULL,
	pk_column varchar(32) NOT NULL,
	pk_column_idx int4 NULL,
	pk_policy varchar(32) NULL,
	pk_sequence varchar(64) NULL,
	CONSTRAINT gt_pk_metadata_table_pk_policy_check CHECK (((pk_policy)::text = ANY (ARRAY[('sequence'::character varying)::text, ('assigned'::character varying)::text, ('autogenerated'::character varying)::text]))),
	CONSTRAINT gt_pk_metadata_table_table_schema_table_name_pk_column_key UNIQUE (table_schema, table_name, pk_column)
);

-- Permissions

ALTER TABLE mobiel.gt_pk_metadata_table OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.gt_pk_metadata_table TO oiv_admin;
GRANT SELECT ON TABLE mobiel.gt_pk_metadata_table TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.gt_pk_metadata_table TO oiv_write;


-- mobiel.label_type definition

-- Drop table

-- DROP TABLE mobiel.label_type;

CREATE TABLE mobiel.label_type (
	gid serial4 NOT NULL,
	bron_id int4 NULL,
	brontabel varchar(50) NULL,
	naam text NULL,
	categorie text NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	evenement bool NULL,
	gebouw bool NULL,
	waterongeval bool NULL,
	bluswater bool NULL,
	natuur bool NULL,
	bouwlaag_object varchar(50) NULL,
	CONSTRAINT label_type_pkey PRIMARY KEY (gid)
);

-- Permissions

ALTER TABLE mobiel.label_type OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.label_type TO oiv_admin;
GRANT SELECT ON TABLE mobiel.label_type TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.label_type TO oiv_write;


-- mobiel.lijnen_type definition

-- Drop table

-- DROP TABLE mobiel.lijnen_type;

CREATE TABLE mobiel.lijnen_type (
	gid serial4 NOT NULL,
	bron_id int4 NULL,
	brontabel varchar(50) NULL,
	naam text NULL,
	categorie text NULL,
	evenement bool NULL,
	gebouw bool NULL,
	waterongeval bool NULL,
	bluswater bool NULL,
	natuur bool NULL,
	bouwlaag_object varchar(50) NULL,
	CONSTRAINT lijnen_type_pkey PRIMARY KEY (gid)
);

-- Permissions

ALTER TABLE mobiel.lijnen_type OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.lijnen_type TO oiv_admin;
GRANT SELECT ON TABLE mobiel.lijnen_type TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.lijnen_type TO oiv_write;


-- mobiel.log_werkvoorraad definition

-- Drop table

-- DROP TABLE mobiel.log_werkvoorraad;

CREATE TABLE mobiel.log_werkvoorraad (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL,
	datum_gewijzigd timestamp NULL,
	geom public.geometry(geometry, 28992) NULL,
	record json NULL,
	CONSTRAINT log_werkvoorraad_pkey PRIMARY KEY (id)
);
CREATE INDEX log_werkvoorraad_geom_gist ON mobiel.log_werkvoorraad USING gist (geom);

-- Permissions

ALTER TABLE mobiel.log_werkvoorraad OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.log_werkvoorraad TO oiv_admin;
GRANT SELECT ON TABLE mobiel.log_werkvoorraad TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.log_werkvoorraad TO oiv_write;


-- mobiel.punten_ruimtelijk_type definition

-- Drop table

-- DROP TABLE mobiel.punten_ruimtelijk_type;

CREATE TABLE mobiel.punten_ruimtelijk_type (
	gid serial4 NOT NULL,
	bron_id int4 NULL,
	brontabel varchar(50) NULL,
	naam text NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	size_object int4 NULL,
	evenement bool NULL,
	gebouw bool NULL,
	waterongeval bool NULL,
	bluswater bool NULL,
	natuur bool NULL
);

-- Permissions

ALTER TABLE mobiel.punten_ruimtelijk_type OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.punten_ruimtelijk_type TO oiv_admin;
GRANT SELECT ON TABLE mobiel.punten_ruimtelijk_type TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.punten_ruimtelijk_type TO oiv_write;


-- mobiel.punten_type definition

-- Drop table

-- DROP TABLE mobiel.punten_type;

CREATE TABLE mobiel.punten_type (
	gid serial4 NOT NULL,
	bron_id int4 NULL,
	brontabel varchar(50) NULL,
	naam text NULL,
	categorie text NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	evenement bool NULL,
	gebouw bool NULL,
	waterongeval bool NULL,
	bluswater bool NULL,
	natuur bool NULL,
	bouwlaag_object varchar(50) NULL,
	CONSTRAINT punten_type_pkey PRIMARY KEY (gid)
);

-- Permissions

ALTER TABLE mobiel.punten_type OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.punten_type TO oiv_admin;
GRANT SELECT ON TABLE mobiel.punten_type TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.punten_type TO oiv_write;


-- mobiel.scratchpad definition

-- Drop table

-- DROP TABLE mobiel.scratchpad;

CREATE TABLE mobiel.scratchpad (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	geom public.geometry(multilinestring, 28992) NULL,
	color varchar(10) NULL,
	CONSTRAINT scratchpad_id_pkey PRIMARY KEY (id)
);
CREATE INDEX scratchpad_geom_gist ON mobiel.scratchpad USING gist (geom);

-- Permissions

ALTER TABLE mobiel.scratchpad OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.scratchpad TO oiv_admin;
GRANT SELECT ON TABLE mobiel.scratchpad TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.scratchpad TO oiv_write;


-- mobiel.vlakken_type definition

-- Drop table

-- DROP TABLE mobiel.vlakken_type;

CREATE TABLE mobiel.vlakken_type (
	gid serial4 NOT NULL,
	bron_id int4 NULL,
	brontabel varchar(50) NULL,
	naam text NULL,
	categorie text NULL,
	symbol_name text NULL,
	evenement bool NULL,
	gebouw bool NULL,
	waterongeval bool NULL,
	bluswater bool NULL,
	natuur bool NULL,
	bouwlaag_object varchar(50) NULL,
	CONSTRAINT vlakken_type_pkey PRIMARY KEY (gid)
);

-- Permissions

ALTER TABLE mobiel.vlakken_type OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.vlakken_type TO oiv_admin;
GRANT SELECT ON TABLE mobiel.vlakken_type TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.vlakken_type TO oiv_write;


-- mobiel.werkvoorraad_hulplijnen definition

-- Drop table

-- DROP TABLE mobiel.werkvoorraad_hulplijnen;

CREATE TABLE mobiel.werkvoorraad_hulplijnen (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	geom public.geometry(linestring, 28992) NULL,
	bron_id int4 NULL,
	brontabel varchar(50) NULL,
	bouwlaag_id int4 NULL,
	object_id int4 NULL,
	bouwlaag int4 NULL,
	CONSTRAINT werkvoorraad_hulplijnen_pkey PRIMARY KEY (id)
);
CREATE INDEX werkvoorraad_hulplijnen_geom_gist ON mobiel.werkvoorraad_hulplijnen USING gist (geom);

-- Table Triggers

CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    mobiel.werkvoorraad_hulplijnen FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');

-- Permissions

ALTER TABLE mobiel.werkvoorraad_hulplijnen OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.werkvoorraad_hulplijnen TO oiv_admin;
GRANT SELECT ON TABLE mobiel.werkvoorraad_hulplijnen TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.werkvoorraad_hulplijnen TO oiv_write;


-- mobiel.werkvoorraad_label definition

-- Drop table

-- DROP TABLE mobiel.werkvoorraad_label;

CREATE TABLE mobiel.werkvoorraad_label (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	geom public.geometry(point, 28992) NULL,
	waarden_new json NULL,
	operatie varchar(10) NULL,
	brontabel varchar(50) NULL,
	bron_id int4 NULL,
	object_id int4 NULL,
	bouwlaag_id int4 NULL,
	omschrijving text NULL,
	rotatie int4 NULL,
	"size" int4 NULL,
	symbol_name text NULL,
	accepted bool NULL,
	bouwlaag int4 NULL,
	fotografie_id int4 NULL,
	bouwlaag_object varchar(50) NULL,
	CONSTRAINT werkvoorraad_label_pkey PRIMARY KEY (id)
);
CREATE INDEX werkvoorraad_label_geom_gist ON mobiel.werkvoorraad_label USING gist (geom);

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
	    	UPDATE mobiel.werkvoorraad_label SET "size" = sub."size", bouwlaag_id = bouwlaagid
			FROM
			  (
			    SELECT * FROM mobiel.label_type WHERE symbol_name = new.symbol_name AND bouwlaag_object = 'bouwlaag'
			  ) sub
			WHERE werkvoorraad_label.id = NEW.id;
	    ELSE
	    	objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
	    	UPDATE mobiel.werkvoorraad_label SET "size" = sub."size", object_id = objectid
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

-- Permissions

ALTER FUNCTION mobiel.complement_record_label() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.complement_record_label() TO oiv_admin;

CREATE OR REPLACE FUNCTION mobiel.complement_record_lijn()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE 
    	objectid integer := NULL;
    	bouwlaagid integer := NULL;
    BEGIN 
	    IF (NEW.bouwlaag_object = 'bouwlaag' OR NEW.bouwlaag_id IS NOT NULL) THEN
	    	bouwlaagid := (SELECT b.id FROM (SELECT b.id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = NEW.bouwlaag ORDER BY dist LIMIT 1) b);
	    ELSE
	    	objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
	    END IF;
		UPDATE mobiel.werkvoorraad_lijn SET object_id = objectid, bouwlaag_id = bouwlaagid
		WHERE werkvoorraad_lijn.id = NEW.id;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION mobiel.complement_record_lijn() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.complement_record_lijn() TO oiv_admin;

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
	    	UPDATE mobiel.werkvoorraad_punt SET "size" = sub."size", bouwlaag_id = bouwlaagid
			FROM
			  (
			    SELECT * FROM mobiel.punten_type WHERE symbol_name = new.symbol_name AND bouwlaag_object = 'bouwlaag'
			  ) sub
			WHERE werkvoorraad_punt.id = NEW.id;
	    ELSE
	    	objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
	    	UPDATE mobiel.werkvoorraad_punt SET "size" = sub."size", object_id = objectid
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

-- Permissions

ALTER FUNCTION mobiel.complement_record_punt() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.complement_record_punt() TO oiv_admin;

CREATE OR REPLACE FUNCTION mobiel.complement_record_vlak()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE 
    	objectid integer := NULL;
    	bouwlaagid integer := NULL;
    BEGIN 
	    IF (NEW.bouwlaag_object = 'bouwlaag' OR NEW.bouwlaag_id IS NOT NULL) THEN
	    	bouwlaagid := (SELECT b.id FROM (SELECT b.id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = NEW.bouwlaag ORDER BY dist LIMIT 1) b);
	    ELSE
	    	objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
	    END IF;
		UPDATE mobiel.werkvoorraad_vlak SET object_id = objectid, bouwlaag_id = bouwlaagid 
		WHERE werkvoorraad_vlak.id = NEW.id;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION mobiel.complement_record_vlak() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.complement_record_vlak() TO oiv_admin;

CREATE OR REPLACE FUNCTION mobiel.funct_label_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_label (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, size, symbol_name, bouwlaag, accepted)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.id, old.bouwlaag_id, old.rotatie, old.size, old.symbol_name, old.bouwlaag, false);
  		
			UPDATE mobiel.werkvoorraad_label
			SET geom=old.geom, waarden_new=old.waarden_new, operatie=old.operatie, brontabel=old.brontabel, bron_id=old.id, 
				object_id=old.object_id, bouwlaag_id=old.bouwlaag_id, rotatie=old.rotatie, "size"=old.size, symbol_name=old.symbol_name, bouwlaag=old.bouwlaag
			WHERE werkvoorraad_label.id = old.id;
	    ELSE
			DELETE FROM mobiel.werkvoorraad_label WHERE (id = OLD.id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

-- Permissions

ALTER FUNCTION mobiel.funct_label_delete() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.funct_label_delete() TO oiv_admin;

CREATE OR REPLACE FUNCTION mobiel.funct_label_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_label (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, omschrijving, rotatie, size, symbol_name, bouwlaag, accepted)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, old.id, new.bouwlaag_id, new.omschrijving, new.rotatie, new.size, new.symbol_name, new.bouwlaag, false);
  		
			UPDATE mobiel.werkvoorraad_label
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.id, omschrijving=new.omschrijving,
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, rotatie=NEW.rotatie, "size"=NEW.size, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag
			WHERE werkvoorraad_label.id = NEW.id;
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.id, new.brontabel, new.bouwlaag);
            END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_label
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, omschrijving=new.omschrijving, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, rotatie=NEW.rotatie, "size"=NEW.size, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag
			WHERE werkvoorraad_label.id = NEW.id;
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag);
            END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

-- Permissions

ALTER FUNCTION mobiel.funct_label_update() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.funct_label_update() TO oiv_admin;

CREATE OR REPLACE FUNCTION mobiel.funct_lijn_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, accepted)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.id, old.bouwlaag_id, old.symbol_name, old.bouwlaag, false);
  		
			UPDATE mobiel.werkvoorraad_lijn
			SET geom=old.geom, waarden_new=old.waarden_new, operatie=old.operatie, brontabel=old.brontabel, bron_id=old.id, 
				object_id=old.object_id, bouwlaag_id=old.bouwlaag_id, symbol_name=old.symbol_name, bouwlaag=old.bouwlaag
			WHERE werkvoorraad_lijn.id = old.id;
	    ELSE
			DELETE FROM mobiel.werkvoorraad_lijn WHERE (id = OLD.id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

-- Permissions

ALTER FUNCTION mobiel.funct_lijn_delete() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.funct_lijn_delete() TO oiv_admin;

CREATE OR REPLACE FUNCTION mobiel.funct_lijn_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, accepted)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, old.bron_id, new.bouwlaag_id, new.symbol_name, new.bouwlaag, false);
  		
			UPDATE mobiel.werkvoorraad_lijn
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag
			WHERE werkvoorraad_lijn.id = NEW.id;
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag);
			END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_lijn
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag
			WHERE werkvoorraad_lijn.id = NEW.id;
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag);
			END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

-- Permissions

ALTER FUNCTION mobiel.funct_lijn_update() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.funct_lijn_update() TO oiv_admin;

CREATE OR REPLACE FUNCTION mobiel.funct_symbol_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, size, symbol_name, bouwlaag, accepted)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.id, old.bouwlaag_id, old.rotatie, old.size, old.symbol_name, old.bouwlaag, false);
  		
			UPDATE mobiel.werkvoorraad_punt
			SET geom=old.geom, waarden_new=old.waarden_new, operatie=old.operatie, brontabel=old.brontabel, bron_id=old.id, 
				object_id=old.object_id, bouwlaag_id=old.bouwlaag_id, rotatie=old.rotatie, "size"=old.size, symbol_name=old.symbol_name, bouwlaag=old.bouwlaag
			WHERE werkvoorraad_punt.id = old.id;
	    ELSE
			DELETE FROM mobiel.werkvoorraad_punt WHERE (id = OLD.id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

-- Permissions

ALTER FUNCTION mobiel.funct_symbol_delete() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.funct_symbol_delete() TO oiv_admin;

CREATE OR REPLACE FUNCTION mobiel.funct_symbol_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, size, symbol_name, bouwlaag, accepted)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, old.id, new.bouwlaag_id, new.rotatie, new.size, new.symbol_name, new.bouwlaag, false);
  		
			UPDATE mobiel.werkvoorraad_punt
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, rotatie=NEW.rotatie, "size"=NEW.size, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag
			WHERE werkvoorraad_punt.id = NEW.id;
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.id, new.brontabel, new.bouwlaag);
			END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_punt
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie='UPDATE', brontabel=NEW.brontabel, bron_id=old.bron_id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, rotatie=NEW.rotatie, "size"=NEW.size, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag
			WHERE werkvoorraad_punt.id = NEW.id;
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag);
			END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

-- Permissions

ALTER FUNCTION mobiel.funct_symbol_update() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.funct_symbol_update() TO oiv_admin;

CREATE OR REPLACE FUNCTION mobiel.funct_vlak_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, accepted)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.id, old.bouwlaag_id, old.symbol_name, old.bouwlaag, false);
  		
			UPDATE mobiel.werkvoorraad_vlak
			SET geom=old.geom, waarden_new=old.waarden_new, operatie=old.operatie, brontabel=old.brontabel, bron_id=old.id, 
				object_id=old.object_id, bouwlaag_id=old.bouwlaag_id, symbol_name=old.symbol_name, bouwlaag=old.bouwlaag
			WHERE werkvoorraad_vlak.id = old.id;
	    ELSE
			DELETE FROM mobiel.werkvoorraad_vlak WHERE (id = OLD.id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

-- Permissions

ALTER FUNCTION mobiel.funct_vlak_delete() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.funct_vlak_delete() TO oiv_admin;

CREATE OR REPLACE FUNCTION mobiel.funct_vlak_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, accepted)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, old.bron_id, new.bouwlaag_id, new.symbol_name, new.bouwlaag, false);
  		
			UPDATE mobiel.werkvoorraad_vlak
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag
			WHERE werkvoorraad_vlak.id = NEW.id;
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag);
			END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_vlak
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=NEW.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag
			WHERE werkvoorraad_vlak.id = NEW.id;
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag);
			END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

-- Permissions

ALTER FUNCTION mobiel.funct_vlak_update() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION mobiel.funct_vlak_update() TO oiv_admin;


-- Permissions

GRANT ALL ON SCHEMA mobiel TO oiv_admin;
GRANT USAGE ON SCHEMA mobiel TO oiv_read;

-- Table Triggers
CREATE TRIGGER trg_after_insert AFTER
INSERT
    ON
    mobiel.werkvoorraad_label FOR EACH ROW EXECUTE FUNCTION mobiel.complement_record_label();
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    mobiel.werkvoorraad_label FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_upd BEFORE
UPDATE
    ON
    mobiel.werkvoorraad_label FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');

-- Permissions

ALTER TABLE mobiel.werkvoorraad_label OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.werkvoorraad_label TO oiv_admin;
GRANT SELECT ON TABLE mobiel.werkvoorraad_label TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.werkvoorraad_label TO oiv_write;


-- mobiel.werkvoorraad_lijn definition

-- Drop table

-- DROP TABLE mobiel.werkvoorraad_lijn;

CREATE TABLE mobiel.werkvoorraad_lijn (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	geom public.geometry(multilinestring, 28992) NULL,
	waarden_new json NULL,
	operatie varchar(10) NULL,
	brontabel varchar(50) NULL,
	bron_id int4 NULL,
	object_id int4 NULL,
	bouwlaag_id int4 NULL,
	symbol_name text NULL,
	accepted bool NULL,
	bouwlaag int4 NULL,
	fotografie_id int4 NULL,
	bouwlaag_object varchar(50) NULL,
	CONSTRAINT werkvoorraad_lijn_pkey PRIMARY KEY (id)
);
CREATE INDEX werkvoorraad_lijn_geom_gist ON mobiel.werkvoorraad_lijn USING gist (geom);

-- Table Triggers

CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    mobiel.werkvoorraad_lijn FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    mobiel.werkvoorraad_lijn FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_upd BEFORE
INSERT
    ON
    mobiel.werkvoorraad_lijn FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_after_insert AFTER
INSERT
    ON
    mobiel.werkvoorraad_lijn FOR EACH ROW EXECUTE FUNCTION mobiel.complement_record_lijn();

-- Permissions

ALTER TABLE mobiel.werkvoorraad_lijn OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.werkvoorraad_lijn TO oiv_admin;
GRANT SELECT ON TABLE mobiel.werkvoorraad_lijn TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.werkvoorraad_lijn TO oiv_write;


-- mobiel.werkvoorraad_punt definition

-- Drop table

-- DROP TABLE mobiel.werkvoorraad_punt;

CREATE TABLE mobiel.werkvoorraad_punt (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	geom public.geometry(point, 28992) NULL,
	waarden_new json NULL,
	operatie varchar(10) NULL,
	brontabel varchar(50) NULL,
	bron_id int4 NULL,
	object_id int4 NULL,
	bouwlaag_id int4 NULL,
	rotatie int4 NULL,
	"size" int4 NULL,
	symbol_name text NULL,
	accepted bool NULL,
	bouwlaag int4 NULL,
	fotografie_id int4 NULL,
	bouwlaag_object varchar(50) NULL,
	CONSTRAINT werkvoorraad_punt_pkey PRIMARY KEY (id)
);
CREATE INDEX werkvoorraad_punt_geom_gist ON mobiel.werkvoorraad_punt USING gist (geom);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    mobiel.werkvoorraad_punt FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    mobiel.werkvoorraad_punt FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_upd BEFORE
INSERT
    ON
    mobiel.werkvoorraad_punt FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_after_insert AFTER
INSERT
    ON
    mobiel.werkvoorraad_punt FOR EACH ROW EXECUTE FUNCTION mobiel.complement_record_punt();

-- Permissions

ALTER TABLE mobiel.werkvoorraad_punt OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.werkvoorraad_punt TO oiv_admin;
GRANT SELECT ON TABLE mobiel.werkvoorraad_punt TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.werkvoorraad_punt TO oiv_write;


-- mobiel.werkvoorraad_vlak definition

-- Drop table

-- DROP TABLE mobiel.werkvoorraad_vlak;

CREATE TABLE mobiel.werkvoorraad_vlak (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	geom public.geometry(multipolygon, 28992) NULL,
	waarden_new json NULL,
	operatie varchar(10) NULL,
	brontabel varchar(50) NULL,
	bron_id int4 NULL,
	object_id int4 NULL,
	bouwlaag_id int4 NULL,
	symbol_name text NULL,
	accepted bool NULL,
	bouwlaag int4 NULL,
	fotografie_id int4 NULL,
	bouwlaag_object varchar(50) NULL,
	CONSTRAINT werkvoorraad_vlak_pkey PRIMARY KEY (id)
);
CREATE INDEX werkvoorraad_vlak_geom_gist ON mobiel.werkvoorraad_vlak USING gist (geom);

-- Table Triggers

CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_after_insert AFTER
INSERT
    ON
    mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE FUNCTION mobiel.complement_record_vlak();
CREATE TRIGGER trg_set_upd BEFORE
INSERT
    ON
    mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');

-- Permissions

ALTER TABLE mobiel.werkvoorraad_vlak OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.werkvoorraad_vlak TO oiv_admin;
GRANT SELECT ON TABLE mobiel.werkvoorraad_vlak TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.werkvoorraad_vlak TO oiv_write;


-- mobiel.bouwlagen_binnen_object source

CREATE OR REPLACE VIEW mobiel.bouwlagen_binnen_object
AS SELECT DISTINCT t.object_id,
    w.bouwlaag
   FROM mobiel.werkvoorraad_punt w
     JOIN objecten.terrein t ON st_intersects(w.geom, t.geom)
  WHERE w.object_id IS NULL
  GROUP BY t.object_id, w.bouwlaag;

-- Permissions

ALTER TABLE mobiel.bouwlagen_binnen_object OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.bouwlagen_binnen_object TO oiv_admin;
GRANT SELECT ON TABLE mobiel.bouwlagen_binnen_object TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.bouwlagen_binnen_object TO oiv_write;


-- mobiel.categorie_labels source

CREATE OR REPLACE VIEW mobiel.categorie_labels
AS SELECT DISTINCT label_type.categorie,
    label_type.brontabel,
    label_type.bouwlaag_object
   FROM mobiel.label_type;

-- Permissions

ALTER TABLE mobiel.categorie_labels OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.categorie_labels TO oiv_admin;
GRANT SELECT ON TABLE mobiel.categorie_labels TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.categorie_labels TO oiv_write;


-- mobiel.categorie_lijnen source

CREATE OR REPLACE VIEW mobiel.categorie_lijnen
AS SELECT DISTINCT lijnen_type.categorie,
    lijnen_type.brontabel,
    lijnen_type.bouwlaag_object
   FROM mobiel.lijnen_type;

-- Permissions

ALTER TABLE mobiel.categorie_lijnen OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.categorie_lijnen TO oiv_admin;
GRANT SELECT ON TABLE mobiel.categorie_lijnen TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.categorie_lijnen TO oiv_write;


-- mobiel.categorie_punten source

CREATE OR REPLACE VIEW mobiel.categorie_punten
AS SELECT DISTINCT punten_type.categorie,
    punten_type.brontabel,
    punten_type.bouwlaag_object
   FROM mobiel.punten_type;

-- Permissions

ALTER TABLE mobiel.categorie_punten OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.categorie_punten TO oiv_admin;
GRANT SELECT ON TABLE mobiel.categorie_punten TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.categorie_punten TO oiv_write;


-- mobiel.categorie_vlakken source

CREATE OR REPLACE VIEW mobiel.categorie_vlakken
AS SELECT DISTINCT vlakken_type.categorie,
    vlakken_type.brontabel,
    vlakken_type.bouwlaag_object
   FROM mobiel.vlakken_type;

-- Permissions

ALTER TABLE mobiel.categorie_vlakken OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.categorie_vlakken TO oiv_admin;
GRANT SELECT ON TABLE mobiel.categorie_vlakken TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.categorie_vlakken TO oiv_write;


-- mobiel.labels source

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
            NULL::json,
            ''::character varying,
            'label'::character varying,
            l.id,
            NULL::integer AS object_id,
            l.bouwlaag_id,
            l.omschrijving,
            l.rotatie,
            lt.size,
            lt.symbol_name,
            l.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.bouwlaag_label l
             JOIN objecten.label_type lt ON l.soort::text = lt.naam::text
        UNION ALL
         SELECT l.id,
            l.geom,
            NULL::json,
            ''::character varying,
            'label'::character varying,
            l.id,
            l.object_id,
            NULL::integer AS bouwlaag_id,
            l.omschrijving,
            l.rotatie,
            lt.size,
            lt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron
           FROM objecten.object_label l
             JOIN objecten.label_type lt ON l.soort::text = lt.naam::text) sub;

-- View Triggers
CREATE TRIGGER trg_labels_del INSTEAD OF
DELETE
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel.funct_label_delete();
CREATE TRIGGER trg_labels_upd INSTEAD OF
UPDATE
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel.funct_label_update();

-- Permissions
ALTER TABLE mobiel.labels OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.labels TO oiv_admin;
GRANT SELECT ON TABLE mobiel.labels TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.labels TO oiv_write;


-- mobiel.lijnen source
CREATE OR REPLACE VIEW mobiel.lijnen
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
   FROM ( SELECT werkvoorraad_lijn.id,
            werkvoorraad_lijn.geom,
            werkvoorraad_lijn.waarden_new,
            werkvoorraad_lijn.operatie,
            werkvoorraad_lijn.brontabel,
            werkvoorraad_lijn.bron_id,
            werkvoorraad_lijn.object_id,
            werkvoorraad_lijn.bouwlaag_id,
            werkvoorraad_lijn.symbol_name,
            werkvoorraad_lijn.bouwlaag,
            'werkvoorraad'::text AS bron,
            ''::text AS binnen_buiten
           FROM mobiel.werkvoorraad_lijn
        UNION ALL
         SELECT b.id,
            b.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT b.label,
                            b.obstakels,
                            b.wegafzetting) d)) AS waarden_new,
            ''::character varying AS operatie,
            'bereikbaarheid'::character varying AS brontabel,
            b.id AS bron_id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS binnen_buiten
           FROM objecten.object_bereikbaarheid b
             JOIN objecten.bereikbaarheid_type bt ON b.soort::text = bt.naam::text
        UNION ALL
         SELECT b.id,
            b.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT b.label,
                            b.bijzonderheden) d)) AS waarden_new,
            ''::character varying AS operatie,
            'gebiedsgerichte_aanpak'::character varying AS brontabel,
            b.id AS bron_id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS binnen_buiten
           FROM objecten.object_gebiedsgerichte_aanpak b
             JOIN objecten.gebiedsgerichte_aanpak_type bt ON b.soort::text = bt.naam::text
        UNION ALL
         SELECT object_isolijnen.id,
            object_isolijnen.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT object_isolijnen.omschrijving) d)) AS waarden_new,
            ''::character varying AS operatie,
            'isolijnen'::character varying AS brontabel,
            object_isolijnen.id AS bron_id,
            object_isolijnen.object_id,
            NULL::integer AS bouwlaag_id,
            object_isolijnen.hoogte::character varying AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS binnen_buiten
           FROM objecten.object_isolijnen
        UNION ALL
         SELECT b.id,
            b.geom,
            NULL::json AS waarden_new,
            ''::character varying AS operatie,
            'veiligh_bouwk'::character varying AS brontabel,
            b.id AS bron_id,
            NULL::integer AS object_id,
            b.bouwlaag_id,
            b.soort AS symbol_name,
            b.bouwlaag,
            'oiv'::text AS bron,
            'bouwlaag'::text AS binnen_buiten
           FROM objecten.bouwlaag_veiligh_bouwk b
             JOIN objecten.veiligh_bouwk_type bt ON b.soort::text = bt.naam::text) sub;

-- View Triggers
CREATE TRIGGER trg_lijnen_del INSTEAD OF
DELETE
    ON
    mobiel.lijnen FOR EACH ROW EXECUTE FUNCTION mobiel.funct_lijn_delete();
CREATE TRIGGER trg_lijnen_upd INSTEAD OF
UPDATE
    ON
    mobiel.lijnen FOR EACH ROW EXECUTE FUNCTION mobiel.funct_lijn_update();

-- Permissions
ALTER TABLE mobiel.lijnen OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.lijnen TO oiv_admin;
GRANT SELECT ON TABLE mobiel.lijnen TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.lijnen TO oiv_write;

-- mobiel.symbolen source
CREATE OR REPLACE VIEW mobiel.symbolen
AS SELECT row_number() OVER (ORDER BY sub.id) AS id,
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
    sub.binnen_buiten
   FROM ( SELECT werkvoorraad_punt.id,
            werkvoorraad_punt.geom,
            werkvoorraad_punt.waarden_new,
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
            'werkvoorraad'::text AS bron
           FROM mobiel.werkvoorraad_punt
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.bijzonderheid) d)) AS waarden_new,
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
            'oiv'::text AS bron
           FROM objecten.veiligh_install v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.veiligh_install_type vt ON v.veiligh_install_type_id = vt.id
          WHERE v.datum_deleted IS NULL
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.bijzonderheid) d)) AS waarden_new,
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
            'oiv'::text AS bron
           FROM objecten.veiligh_ruimtelijk v
             JOIN objecten.veiligh_ruimtelijk_type vt ON v.veiligh_ruimtelijk_type_id = vt.id
          WHERE v.datum_deleted IS NULL
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.omschrijving) d)) AS waarden_new,
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
            'oiv'::text AS bron
           FROM objecten.dreiging v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.dreiging_type vt ON v.dreiging_type_id = vt.id
          WHERE v.bouwlaag_id IS NOT NULL AND v.datum_deleted IS NULL
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.omschrijving) d)) AS waarden_new,
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
            'oiv'::text AS bron
           FROM objecten.dreiging v
             JOIN objecten.dreiging_type vt ON v.dreiging_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.datum_deleted IS NULL
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.handelingsaanwijzing) d)) AS waarden_new,
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
            'oiv'::text AS bron
           FROM objecten.afw_binnendekking v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.afw_binnendekking_type vt ON v.soort::text = vt.naam::text
          WHERE v.datum_deleted IS NULL
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.belemmering,
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
            'oiv'::text AS bron
           FROM objecten.ingang v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.ingang_type vt ON v.ingang_type_id = vt.id
          WHERE v.bouwlaag_id IS NOT NULL AND v.datum_deleted IS NULL
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.belemmering,
                            v.voorzieningen) d)) AS waarden_new,
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
            'oiv'::text AS bron
           FROM objecten.ingang v
             JOIN objecten.ingang_type vt ON v.ingang_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.datum_deleted IS NULL
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label) d)) AS waarden_new,
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
            'oiv'::text AS bron
           FROM objecten.opstelplaats v
             JOIN objecten.opstelplaats_type vt ON v.soort::text = vt.naam::text
          WHERE v.datum_deleted IS NULL
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.aanduiding_locatie) d)) AS waarden_new,
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
            'oiv'::text AS bron
           FROM objecten.sleutelkluis v
             JOIN objecten.ingang i ON v.ingang_id = i.id
             JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE i.bouwlaag_id IS NOT NULL AND v.datum_deleted IS NULL
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.aanduiding_locatie) d)) AS waarden_new,
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
            'oiv'::text AS bron
           FROM objecten.sleutelkluis v
             JOIN objecten.ingang i ON v.ingang_id = i.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE i.object_id IS NOT NULL AND v.datum_deleted IS NULL
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.label,
                            v.bijzonderheid) d)) AS waarden_new,
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
            'oiv'::text AS bron
           FROM objecten.points_of_interest v
             JOIN objecten.points_of_interest_type vt ON v.points_of_interest_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.datum_deleted IS NULL) sub;

-- View Triggers

CREATE TRIGGER trg_symbolen_del INSTEAD OF
DELETE
    ON
    mobiel.symbolen FOR EACH ROW EXECUTE FUNCTION mobiel.funct_symbol_delete();
CREATE TRIGGER trg_symbolen_upd INSTEAD OF
UPDATE
    ON
    mobiel.symbolen FOR EACH ROW EXECUTE FUNCTION mobiel.funct_symbol_update();

-- Permissions

ALTER TABLE mobiel.symbolen OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.symbolen TO oiv_admin;
GRANT SELECT ON TABLE mobiel.symbolen TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.symbolen TO oiv_write;


-- mobiel.vlakken source

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
            ''::character varying,
            'sectoren'::character varying,
            b.id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS binnen_buiten
           FROM objecten.object_sectoren b
             JOIN objecten.sectoren_type bt ON b.soort::text = bt.naam::text
        UNION ALL
         SELECT b.id,
            b.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT b.omschrijving) d)) AS waarden_new,
            ''::character varying,
            'ruimten'::character varying,
            b.id,
            NULL::integer AS object_id,
            b.bouwlaag_id,
            b.ruimten_type_id,
            b.bouwlaag,
            'oiv'::text AS bron,
            'bouwlaag'::text AS binnen_buiten
           FROM objecten.bouwlaag_ruimten b
             JOIN objecten.ruimten_type bt ON b.ruimten_type_id = bt.naam) sub;

-- View Triggers

CREATE TRIGGER trg_vlakken_del INSTEAD OF
DELETE
    ON
    mobiel.vlakken FOR EACH ROW EXECUTE FUNCTION mobiel.funct_vlak_delete();
CREATE TRIGGER trg_vlakken_upd INSTEAD OF
UPDATE
    ON
    mobiel.vlakken FOR EACH ROW EXECUTE FUNCTION mobiel.funct_vlak_update();

-- Permissions

ALTER TABLE mobiel.vlakken OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.vlakken TO oiv_admin;
GRANT SELECT ON TABLE mobiel.vlakken TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.vlakken TO oiv_write;


-- mobiel.werkvoorraad_objecten source

CREATE OR REPLACE VIEW mobiel.werkvoorraad_objecten
AS SELECT DISTINCT o.id,
    o.geom,
    sub.object_id
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
     JOIN objecten.object o ON sub.object_id = o.id;

-- Permissions

ALTER TABLE mobiel.werkvoorraad_objecten OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.werkvoorraad_objecten TO oiv_admin;
GRANT SELECT ON TABLE mobiel.werkvoorraad_objecten TO oiv_read;
GRANT INSERT, DELETE, UPDATE ON TABLE mobiel.werkvoorraad_objecten TO oiv_write;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.afw_binnendekking WHERE (afw_binnendekking.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.handelingsaanwijzing) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'afw_binnendekking', OLD.id, OLD.bouwlaag_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.bouwlaag, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_afw_binnendekking_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_afw_binnendekking_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_afw_binnendekking_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_afw_binnendekking_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_afw_binnendekking_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_afw_binnendekking_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.bereikbaarheid WHERE (bereikbaarheid.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.obstakels, old.wegafzetting) d));

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'bereikbaarheid', OLD.id, OLD.object_id, OLD.soort, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_bereikbaarheid_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_bereikbaarheid_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_bereikbaarheid_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_bereikbaarheid_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN 
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_bereikbaarheid_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_bereikbaarheid_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_dreiging_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_dreiging_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.dreiging (geom, dreiging_type_id, label, rotatie, bouwlaag_id, object_id, fotografie_id)
            VALUES (new.geom, new.dreiging_type_id, new.label, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.omschrijving) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'dreiging', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_dreiging_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_dreiging_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, omschrijving = new.omschrijving, rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (dreiging.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.omschrijving) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
                size := (SELECT dt."size" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            ELSE
                size := (SELECT dt."size_object" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'dreiging', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag , new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'dreiging', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_dreiging_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_dreiging_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.gebiedsgerichte_aanpak WHERE (gebiedsgerichte_aanpak.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.bijzonderheden) d)); 

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'gebiedsgerichte_aanpak', OLD.id, OLD.object_id, OLD.soort, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_gebiedsgerichte_aanpak_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_gebiedsgerichte_aanpak_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_gebiedsgerichte_aanpak_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_gebiedsgerichte_aanpak_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_gebiedsgerichte_aanpak_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_gebiedsgerichte_aanpak_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_ingang_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_ingang_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_ingang_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_ingang_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.ingang (geom, ingang_type_id, label, rotatie, belemmering, voorzieningen, bouwlaag_id, object_id, fotografie_id)
            VALUES (new.geom, new.ingang_type_id, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.bouwlaag_id, new.object_id, new.fotografie_id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.belemmering, new.voorzieningen) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'ingang', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_ingang_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_ingang_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_ingang_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, 
                    bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (ingang.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.belemmering, new.voorzieningen) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT dt."size_object" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'ingang', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'ingang', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_ingang_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_ingang_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.isolijnen WHERE (isolijnen.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.omschrijving) d));

            INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'isolijnen', OLD.id, OLD.object_id, OLD.hoogte::text, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_isolijnen_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_isolijnen_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_isolijnen_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_isolijnen_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN 
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_isolijnen_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_isolijnen_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_label_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_label_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_label_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_label_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.label (geom, soort, omschrijving, rotatie, bouwlaag_id, object_id)
            VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id, new.object_id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.label_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.label_type dt WHERE dt.naam = new.soort);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.label_type dt WHERE dt.naam = new.soort);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'label', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, false);

        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_label_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_label_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_label_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id
            WHERE (label.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.label_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
                size := (SELECT dt."size" FROM objecten.label_type dt WHERE dt.naam = new.soort);
            ELSE
                size := (SELECT dt."size_object" FROM objecten.label_type dt WHERE dt.naam = new.soort);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'label', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, size, symbol_name, bouwlaag, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'label', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_label_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_label_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_opslag_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_opslag_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_opslag_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_opslag_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.gevaarlijkestof_opslag (geom, locatie, bouwlaag_id, object_id, fotografie_id, rotatie)
            VALUES (new.geom, new.locatie, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT st."size_object" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'gevaarlijkestof_opslag', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_opslag_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_opslag_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_opslag_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (gevaarlijkestof_opslag.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
                size := (SELECT st."size" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            ELSE
                size := (SELECT st."size_object" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'gevaarlijkestof_opslag', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'gevaarlijkestof_opslag', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_opslag_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_opslag_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.opstelplaats WHERE (opstelplaats.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'opstelplaats', OLD.id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_opstelplaats_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_opstelplaats_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_opstelplaats_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_opstelplaats_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_opstelplaats_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_opstelplaats_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.points_of_interest WHERE (points_of_interest.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.bijzonderheid) d)); 

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'points_of_interest', OLD.id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_points_of_interest_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_points_of_interest_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_points_of_interest_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_points_of_interest_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_points_of_interest_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_points_of_interest_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.ruimten WHERE (ruimten.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.omschrijving) d));

            INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'ruimten', OLD.id, OLD.bouwlaag_id, OLD.ruimten_type_id, OLD.bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_ruimten_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_ruimten_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_ruimten_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_ruimten_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_ruimten_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_ruimten_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.scenario_locatie WHERE (scenario_locatie.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'scenario_locatie', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_scenario_locatie_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_scenario_locatie_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.scenario_locatie (geom, locatie, bouwlaag_id, object_id, fotografie_id, rotatie)
            VALUES (new.geom, new.locatie, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT st."size_object" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'scenario_locatie', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_scenario_locatie_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_scenario_locatie_ins() TO oiv_admin;

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
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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

-- Permissions

ALTER FUNCTION objecten.func_scenario_locatie_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_scenario_locatie_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.sectoren WHERE (sectoren.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.omschrijving, old.label) d));

            INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, object_id, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'sectoren', OLD.id, OLD.object_id, OLD.soort, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_sectoren_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_sectoren_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_sectoren_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_sectoren_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN 
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_sectoren_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_sectoren_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_sleutelkluis_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_sleutelkluis_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        ingangid integer;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, fotografie_id)
            VALUES (new.geom, new.sleutelkluis_type_id, new.label, new.rotatie, new.aanduiding_locatie, new.sleuteldoel_type_id, new.ingang_id, new.fotografie_id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                ingangid := (SELECT i.ingang_id FROM (SELECT i.id AS ingang_id, b.geom <-> new.geom AS dist FROM objecten.ingang i
                                INNER JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) i);
                bouwlaag = new.bouwlaag;
            ELSEIF bouwlaag_object = 'object'::text THEN
                size := (SELECT st."size_object" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                ingangid := (SELECT b.ingang_id FROM (SELECT b.id AS ingang_id, b.geom <-> new.geom AS dist FROM objecten.ingang b ORDER BY dist LIMIT 1) b);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, row_to_json(NEW.*), 'INSERT', 'sleutelkluis', NULL, ingangid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_sleutelkluis_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_sleutelkluis_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN 
            UPDATE objecten.sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, sleuteldoel_type_id = new.sleuteldoel_type_id, 
                    ingang_id = new.ingang_id, fotografie_id = new.fotografie_id
            WHERE (sleutelkluis.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT st."size_object" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'sleutelkluis', old.id, new.ingang_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'sleutelkluis', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_sleutelkluis_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_sleutelkluis_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	DECLARE
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.veiligh_bouwk WHERE (veiligh_bouwk.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_lijn (geom, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, 'DELETE', 'veiligh_bouwk', OLD.id, OLD.bouwlaag_id, OLD.soort, OLD.bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_veiligh_bouwk_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_bouwk_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_veiligh_bouwk_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_bouwk_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	DECLARE
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_veiligh_bouwk_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_bouwk_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN  
            DELETE FROM objecten.veiligh_install WHERE (veiligh_install.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.bijzonderheid) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted, fotografie_id)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'veiligh_install', OLD.id, OLD.bouwlaag_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.bouwlaag, false, OLD.fotografie_id);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_veiligh_install_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_install_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_veiligh_install_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_install_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_veiligh_install_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_install_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_ruimtelijk_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.veiligh_ruimtelijk WHERE (veiligh_ruimtelijk.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.bijzonderheid) d));        

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'veiligh_ruimtelijk', OLD.id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_veiligh_ruimtelijk_del() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_ruimtelijk_del() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_ruimtelijk_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_veiligh_ruimtelijk_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_ruimtelijk_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_ruimtelijk_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
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

-- Permissions

ALTER FUNCTION objecten.func_veiligh_ruimtelijk_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_ruimtelijk_upd() TO oiv_admin;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 5;
UPDATE algemeen.applicatie SET revisie = 1;
UPDATE algemeen.applicatie SET db_versie = 351; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
