-- DROP SCHEMA mobiel;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.label_type_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.label_type_gid_seq TO oiv_write;

-- DROP SEQUENCE mobiel.label_type_gid_seq1;

CREATE SEQUENCE mobiel.label_type_gid_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.label_type_gid_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.label_type_gid_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.label_type_gid_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.label_type_gid_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.lijnen_type_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.lijnen_type_gid_seq TO oiv_write;

-- DROP SEQUENCE mobiel.lijnen_type_gid_seq1;

CREATE SEQUENCE mobiel.lijnen_type_gid_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.lijnen_type_gid_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.lijnen_type_gid_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.lijnen_type_gid_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.lijnen_type_gid_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.log_werkvoorraad_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.log_werkvoorraad_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.log_werkvoorraad_id_seq1;

CREATE SEQUENCE mobiel.log_werkvoorraad_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.log_werkvoorraad_id_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.log_werkvoorraad_id_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.log_werkvoorraad_id_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.log_werkvoorraad_id_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq TO oiv_write;

-- DROP SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq1;

CREATE SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.punten_ruimtelijk_type_gid_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.punten_type_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.punten_type_gid_seq TO oiv_write;

-- DROP SEQUENCE mobiel.punten_type_gid_seq1;

CREATE SEQUENCE mobiel.punten_type_gid_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.punten_type_gid_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.punten_type_gid_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.punten_type_gid_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.punten_type_gid_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.scratchpad_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.scratchpad_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.scratchpad_id_seq1;

CREATE SEQUENCE mobiel.scratchpad_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.scratchpad_id_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.scratchpad_id_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.scratchpad_id_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.scratchpad_id_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.vlakken_type_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.vlakken_type_gid_seq TO oiv_write;

-- DROP SEQUENCE mobiel.vlakken_type_gid_seq1;

CREATE SEQUENCE mobiel.vlakken_type_gid_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.vlakken_type_gid_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.vlakken_type_gid_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.vlakken_type_gid_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.vlakken_type_gid_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq1;

CREATE SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_hulplijnen_id_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.werkvoorraad_label_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_label_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.werkvoorraad_label_id_seq1;

CREATE SEQUENCE mobiel.werkvoorraad_label_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.werkvoorraad_label_id_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.werkvoorraad_label_id_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.werkvoorraad_label_id_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_label_id_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.werkvoorraad_lijn_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_lijn_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.werkvoorraad_lijn_id_seq1;

CREATE SEQUENCE mobiel.werkvoorraad_lijn_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.werkvoorraad_lijn_id_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.werkvoorraad_lijn_id_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.werkvoorraad_lijn_id_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_lijn_id_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.werkvoorraad_punt_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_punt_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.werkvoorraad_punt_id_seq1;

CREATE SEQUENCE mobiel.werkvoorraad_punt_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.werkvoorraad_punt_id_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.werkvoorraad_punt_id_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.werkvoorraad_punt_id_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_punt_id_seq1 TO oiv_write;

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
GRANT SELECT, USAGE ON SEQUENCE mobiel.werkvoorraad_vlak_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_vlak_id_seq TO oiv_write;

-- DROP SEQUENCE mobiel.werkvoorraad_vlak_id_seq1;

CREATE SEQUENCE mobiel.werkvoorraad_vlak_id_seq1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE mobiel.werkvoorraad_vlak_id_seq1 OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE mobiel.werkvoorraad_vlak_id_seq1 TO oiv_admin;
GRANT SELECT, USAGE ON SEQUENCE mobiel.werkvoorraad_vlak_id_seq1 TO oiv_read;
GRANT UPDATE ON SEQUENCE mobiel.werkvoorraad_vlak_id_seq1 TO oiv_write;
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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.gt_pk_metadata_table TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.label_type TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.lijnen_type TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.log_werkvoorraad TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.punten_ruimtelijk_type TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.punten_type TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.scratchpad TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.vlakken_type TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.werkvoorraad_hulplijnen TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.werkvoorraad_label TO oiv_write;


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

CREATE TRIGGER trg_after_insert AFTER
INSERT
    ON
    mobiel.werkvoorraad_lijn FOR EACH ROW EXECUTE FUNCTION mobiel.complement_record_lijn();
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

-- Permissions

ALTER TABLE mobiel.werkvoorraad_lijn OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.werkvoorraad_lijn TO oiv_admin;
GRANT SELECT ON TABLE mobiel.werkvoorraad_lijn TO oiv_read;
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.werkvoorraad_lijn TO oiv_write;


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

CREATE TRIGGER trg_after_insert AFTER
INSERT
    ON
    mobiel.werkvoorraad_punt FOR EACH ROW EXECUTE FUNCTION mobiel.complement_record_punt();
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    mobiel.werkvoorraad_punt FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    mobiel.werkvoorraad_punt FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_upd BEFORE
INSERT
    ON
    mobiel.werkvoorraad_punt FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');

-- Permissions

ALTER TABLE mobiel.werkvoorraad_punt OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.werkvoorraad_punt TO oiv_admin;
GRANT SELECT ON TABLE mobiel.werkvoorraad_punt TO oiv_read;
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.werkvoorraad_punt TO oiv_write;


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

CREATE TRIGGER trg_after_insert AFTER
INSERT
    ON
    mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE FUNCTION mobiel.complement_record_vlak();
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_upd BEFORE
INSERT
    ON
    mobiel.werkvoorraad_vlak FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');

-- Permissions

ALTER TABLE mobiel.werkvoorraad_vlak OWNER TO oiv_admin;
GRANT ALL ON TABLE mobiel.werkvoorraad_vlak TO oiv_admin;
GRANT SELECT ON TABLE mobiel.werkvoorraad_vlak TO oiv_read;
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.werkvoorraad_vlak TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.bouwlagen_binnen_object TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.categorie_labels TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.categorie_lijnen TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.categorie_punten TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.categorie_vlakken TO oiv_write;


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
            NULL::json AS json,
            ''::character varying AS "varchar",
            'label'::character varying AS "varchar",
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
            NULL::json AS json,
            ''::character varying AS "varchar",
            'label'::character varying AS "varchar",
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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.labels TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.lijnen TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.symbolen TO oiv_write;


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
            ''::character varying AS "varchar",
            'sectoren'::character varying AS "varchar",
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
            ''::character varying AS "varchar",
            'ruimten'::character varying AS "varchar",
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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.vlakken TO oiv_write;


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
GRANT UPDATE, DELETE, INSERT ON TABLE mobiel.werkvoorraad_objecten TO oiv_write;



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
GRANT ALL ON FUNCTION mobiel.complement_record_label() TO public;
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
GRANT ALL ON FUNCTION mobiel.complement_record_lijn() TO public;
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
GRANT ALL ON FUNCTION mobiel.complement_record_punt() TO public;
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
GRANT ALL ON FUNCTION mobiel.complement_record_vlak() TO public;
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
GRANT ALL ON FUNCTION mobiel.funct_label_delete() TO public;
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
GRANT ALL ON FUNCTION mobiel.funct_label_update() TO public;
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
GRANT ALL ON FUNCTION mobiel.funct_lijn_delete() TO public;
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
GRANT ALL ON FUNCTION mobiel.funct_lijn_update() TO public;
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
GRANT ALL ON FUNCTION mobiel.funct_symbol_delete() TO public;
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
GRANT ALL ON FUNCTION mobiel.funct_symbol_update() TO public;
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
GRANT ALL ON FUNCTION mobiel.funct_vlak_delete() TO public;
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
GRANT ALL ON FUNCTION mobiel.funct_vlak_update() TO public;
GRANT ALL ON FUNCTION mobiel.funct_vlak_update() TO oiv_admin;


-- Permissions

GRANT ALL ON SCHEMA mobiel TO oiv_admin;
GRANT USAGE ON SCHEMA mobiel TO oiv_read;
