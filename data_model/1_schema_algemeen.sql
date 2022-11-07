-- DROP SCHEMA algemeen;

CREATE SCHEMA algemeen AUTHORIZATION oiv_admin;

COMMENT ON SCHEMA algemeen IS 'OIV algemeen';

-- DROP TYPE algemeen.eindstijl_type;

CREATE TYPE algemeen.eindstijl_type AS ENUM (
	'square',
	'flat',
	'round');

-- DROP DOMAIN algemeen.emailadres;

CREATE DOMAIN algemeen.emailadres AS character varying(254)
	COLLATE "default"
	CONSTRAINT CHECK (VALUE::text ~ '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'::text);
-- DROP TYPE algemeen.lijnstijl_type;

CREATE TYPE algemeen.lijnstijl_type AS ENUM (
	'no',
	'solid',
	'dash',
	'dot',
	'dash dot',
	'dash dot dot');

-- DROP TYPE algemeen.verbindingsstijl_type;

CREATE TYPE algemeen.verbindingsstijl_type AS ENUM (
	'bevel',
	'miter',
	'round');

-- DROP TYPE algemeen.vulstijl_type;

CREATE TYPE algemeen.vulstijl_type AS ENUM (
	'solid',
	'horizontal',
	'vertical',
	'cross',
	'b_diagonal',
	'f_diagonal',
	'diagonal_x',
	'dense1',
	'dense2',
	'dense3',
	'dense4',
	'dense5',
	'dense6',
	'dense7',
	'no');

-- DROP SEQUENCE algemeen.bag_extent_gid_seq;

CREATE SEQUENCE algemeen.bag_extent_gid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE algemeen.bag_extent_gid_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE algemeen.bag_extent_gid_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE algemeen.bag_extent_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.bag_extent_gid_seq TO oiv_write;

-- DROP SEQUENCE algemeen.bgt_extent_gid_seq;

CREATE SEQUENCE algemeen.bgt_extent_gid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE algemeen.bgt_extent_gid_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE algemeen.bgt_extent_gid_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE algemeen.bgt_extent_gid_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.bgt_extent_gid_seq TO oiv_write;

-- DROP SEQUENCE algemeen.fotografie_id_seq;

CREATE SEQUENCE algemeen.fotografie_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE algemeen.fotografie_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE algemeen.fotografie_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE algemeen.fotografie_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.fotografie_id_seq TO oiv_write;

-- DROP SEQUENCE algemeen.settings_id_seq;

CREATE SEQUENCE algemeen.settings_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE algemeen.settings_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE algemeen.settings_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE algemeen.settings_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.settings_id_seq TO oiv_write;

-- DROP SEQUENCE algemeen.styles_id_seq;

CREATE SEQUENCE algemeen.styles_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE algemeen.styles_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE algemeen.styles_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE algemeen.styles_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.styles_id_seq TO oiv_write;

-- DROP SEQUENCE algemeen.team_id_seq;

CREATE SEQUENCE algemeen.team_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE algemeen.team_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE algemeen.team_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE algemeen.team_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.team_id_seq TO oiv_write;

-- DROP SEQUENCE algemeen.teamlid_id_seq;

CREATE SEQUENCE algemeen.teamlid_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE algemeen.teamlid_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE algemeen.teamlid_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE algemeen.teamlid_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.teamlid_id_seq TO oiv_write;
-- algemeen.applicatie definition

-- Drop table

-- DROP TABLE algemeen.applicatie;

CREATE TABLE algemeen.applicatie (
	id int2 NOT NULL,
	versie int2 NULL,
	sub int2 NULL,
	revisie int2 NULL,
	omschrijving text NULL,
	datum timestamptz NULL DEFAULT now(),
	db_versie int2 NULL,
	CONSTRAINT applicatie_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX applicatie_idx ON algemeen.applicatie USING btree ((1));

-- Permissions

ALTER TABLE algemeen.applicatie OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.applicatie TO oiv_admin;
GRANT SELECT ON TABLE algemeen.applicatie TO oiv_read;


-- algemeen.bag_extent definition

-- Drop table

-- DROP TABLE algemeen.bag_extent;

CREATE TABLE algemeen.bag_extent (
	gid serial4 NOT NULL,
	identificatie text NULL,
	status text NULL,
	geovlak geometry(multipolygon, 28992) NULL,
	gebruiksdoel text NULL,
	bron varchar(10) NULL,
	bron_tbl varchar(254) NULL,
	CONSTRAINT bag_extent_pkey PRIMARY KEY (gid)
);
CREATE INDEX sidx_bag_extent_geom ON algemeen.bag_extent USING gist (geovlak);

-- Permissions

ALTER TABLE algemeen.bag_extent OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.bag_extent TO oiv_admin;
GRANT SELECT ON TABLE algemeen.bag_extent TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE algemeen.bag_extent TO oiv_write;


-- algemeen.bgt_extent definition

-- Drop table

-- DROP TABLE algemeen.bgt_extent;

CREATE TABLE algemeen.bgt_extent (
	gid serial4 NOT NULL,
	identificatie varchar NULL, -- gml_id vanuit BGT
	geovlak geometry(curvepolygon, 28992) NULL,
	lokaalid varchar NULL,
	bron_tbl varchar(254) NULL,
	bron varchar(10) NULL,
	CONSTRAINT bgt_extent_pkey PRIMARY KEY (gid)
);
CREATE INDEX sidx_bgt_extent_geom ON algemeen.bgt_extent USING gist (geovlak);

-- Column comments

COMMENT ON COLUMN algemeen.bgt_extent.identificatie IS 'gml_id vanuit BGT';

-- Permissions

ALTER TABLE algemeen.bgt_extent OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.bgt_extent TO oiv_admin;
GRANT SELECT ON TABLE algemeen.bgt_extent TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE algemeen.bgt_extent TO oiv_write;


-- algemeen.fotografie definition

-- Drop table

-- DROP TABLE algemeen.fotografie;

CREATE TABLE algemeen.fotografie (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NOT NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	uitgesloten bool NULL DEFAULT false,
	src text NOT NULL,
	exif json NULL,
	datum varchar(255) NULL,
	rd_x numeric NULL,
	rd_y numeric NULL,
	bestand varchar(255) NULL,
	fotograaf varchar(255) NULL,
	omschrijving text NULL,
	bijzonderheden text NULL,
	CONSTRAINT fotografie_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_fotografie_geom ON algemeen.fotografie USING gist (geom);
COMMENT ON TABLE algemeen.fotografie IS 'Algemene fotografie tabel';

-- Permissions

ALTER TABLE algemeen.fotografie OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.fotografie TO oiv_admin;
GRANT SELECT ON TABLE algemeen.fotografie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE algemeen.fotografie TO oiv_write;


-- algemeen.gemeente_zonder_wtr definition

-- Drop table

-- DROP TABLE algemeen.gemeente_zonder_wtr;

CREATE TABLE algemeen.gemeente_zonder_wtr (
	id int8 NOT NULL,
	geom geometry(multipolygon, 28992) NULL,
	objectid int8 NULL,
	gml_id varchar(254) NULL,
	code varchar(6) NULL,
	gemeentena varchar(30) NULL,
	shape_leng float8 NULL,
	shape_le_1 float8 NULL,
	shape_area float8 NULL,
	inpoly_fid int8 NULL,
	simpgnflag int4 NULL,
	maxsimptol float8 NULL,
	minsimptol float8 NULL,
	CONSTRAINT gemeente_zonder_wtr_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_gemeente_geom ON algemeen.gemeente_zonder_wtr USING gist (geom);

-- Permissions

ALTER TABLE algemeen.gemeente_zonder_wtr OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.gemeente_zonder_wtr TO oiv_admin;
GRANT SELECT ON TABLE algemeen.gemeente_zonder_wtr TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE algemeen.gemeente_zonder_wtr TO oiv_write;


-- algemeen.gt_pk_metadata_table definition

-- Drop table

-- DROP TABLE algemeen.gt_pk_metadata_table;

CREATE TABLE algemeen.gt_pk_metadata_table (
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

ALTER TABLE algemeen.gt_pk_metadata_table OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.gt_pk_metadata_table TO oiv_admin;
GRANT SELECT ON TABLE algemeen.gt_pk_metadata_table TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE algemeen.gt_pk_metadata_table TO oiv_write;


-- algemeen.settings definition

-- Drop table

-- DROP TABLE algemeen.settings;

CREATE TABLE algemeen.settings (
	id serial4 NOT NULL,
	setting_key varchar(100) NULL,
	setting_value text NULL,
	CONSTRAINT settings_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE algemeen.settings OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.settings TO oiv_admin;
GRANT SELECT ON TABLE algemeen.settings TO oiv_read;


-- algemeen.styles definition

-- Drop table

-- DROP TABLE algemeen.styles;

CREATE TABLE algemeen.styles (
	id serial4 NOT NULL,
	laagnaam varchar(100) NULL,
	soortnaam varchar(100) NULL,
	lijndikte numeric NULL,
	lijnkleur varchar(9) NULL,
	lijnstijl algemeen.lijnstijl_type NULL,
	vulkleur varchar(9) NULL,
	vulstijl algemeen.vulstijl_type NULL,
	verbindingsstijl algemeen.verbindingsstijl_type NULL,
	eindstijl algemeen.eindstijl_type NULL,
	CONSTRAINT styles_pkey PRIMARY KEY (id),
	CONSTRAINT styles_soortnaam_key UNIQUE (soortnaam)
);

-- Permissions

ALTER TABLE algemeen.styles OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.styles TO oiv_admin;
GRANT SELECT ON TABLE algemeen.styles TO oiv_read;


-- algemeen.veiligheidsregio definition

-- Drop table

-- DROP TABLE algemeen.veiligheidsregio;

CREATE TABLE algemeen.veiligheidsregio (
	id int4 NOT NULL,
	geom geometry(multipolygon, 28992) NULL,
	statcode text NOT NULL,
	statnaam text NULL,
	rubriek text NULL,
	CONSTRAINT veiligheidsregio_pkey PRIMARY KEY (id),
	CONSTRAINT veiligheidsregio_statcode_key UNIQUE (statcode)
);
CREATE INDEX sidx_veiligheidsregio_geom ON algemeen.veiligheidsregio USING gist (geom);

-- Permissions

ALTER TABLE algemeen.veiligheidsregio OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.veiligheidsregio TO oiv_admin;
GRANT SELECT ON TABLE algemeen.veiligheidsregio TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE algemeen.veiligheidsregio TO oiv_write;


-- algemeen.veiligheidsregio_watergrenzen definition

-- Drop table

-- DROP TABLE algemeen.veiligheidsregio_watergrenzen;

CREATE TABLE algemeen.veiligheidsregio_watergrenzen (
	id int4 NOT NULL,
	geom geometry(multipolygon, 28992) NULL,
	code varchar NULL,
	naam varchar NULL,
	CONSTRAINT veiligheidsregio_code_key UNIQUE (code),
	CONSTRAINT veiligheidsregio_watergrens_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_veiligheidsregio_watergrens_geom ON algemeen.veiligheidsregio_watergrenzen USING gist (geom);

-- Permissions

ALTER TABLE algemeen.veiligheidsregio_watergrenzen OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.veiligheidsregio_watergrenzen TO oiv_admin;
GRANT SELECT ON TABLE algemeen.veiligheidsregio_watergrenzen TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE algemeen.veiligheidsregio_watergrenzen TO oiv_write;


-- algemeen.team definition

-- Drop table

-- DROP TABLE algemeen.team;

CREATE TABLE algemeen.team (
	id serial4 NOT NULL,
	statcode text NOT NULL,
	naam varchar(255) NOT NULL,
	email algemeen.emailadres NULL,
	geom geometry(multipolygon, 28992) NULL,
	CONSTRAINT team_pkey PRIMARY KEY (id),
	CONSTRAINT team_statcode_fk FOREIGN KEY (statcode) REFERENCES algemeen.veiligheidsregio(statcode)
);

-- Permissions

ALTER TABLE algemeen.team OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.team TO oiv_admin;
GRANT SELECT ON TABLE algemeen.team TO oiv_read;


-- algemeen.teamlid definition

-- Drop table

-- DROP TABLE algemeen.teamlid;

CREATE TABLE algemeen.teamlid (
	id serial4 NOT NULL,
	team_id int4 NOT NULL,
	login varchar(255) NOT NULL,
	wachtwoord varchar(255) NULL,
	naam varchar NULL,
	email algemeen.emailadres NULL,
	actief bool NULL,
	CONSTRAINT teamlid_pkey PRIMARY KEY (id),
	CONSTRAINT gebruiker_team_id_fk FOREIGN KEY (team_id) REFERENCES algemeen.team(id)
);

-- Permissions

ALTER TABLE algemeen.teamlid OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.teamlid TO oiv_admin;
GRANT SELECT ON TABLE algemeen.teamlid TO oiv_read;


-- algemeen.fotografie_cogo source

CREATE OR REPLACE VIEW algemeen.fotografie_cogo
AS SELECT fotografie.id,
    fotografie.geom,
    fotografie.src,
    fotografie.exif::text AS exif,
    fotografie.datum AS datetime,
    fotografie.bestand AS filename,
    fotografie.fotograaf,
    fotografie.omschrijving,
    fotografie.bijzonderheden
   FROM algemeen.fotografie
  WHERE fotografie.uitgesloten <> true;

-- Permissions

ALTER TABLE algemeen.fotografie_cogo OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.fotografie_cogo TO oiv_admin;
GRANT SELECT ON TABLE algemeen.fotografie_cogo TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE algemeen.fotografie_cogo TO oiv_write;


-- algemeen.veiligheidsregio_huidig source

CREATE OR REPLACE VIEW algemeen.veiligheidsregio_huidig
AS SELECT veiligheidsregio.id,
    veiligheidsregio.geom,
    veiligheidsregio.statcode,
    veiligheidsregio.statnaam,
    veiligheidsregio.rubriek
   FROM algemeen.veiligheidsregio
  WHERE veiligheidsregio.statcode = 'VR11'::text;

-- Permissions

ALTER TABLE algemeen.veiligheidsregio_huidig OWNER TO oiv_admin;
GRANT ALL ON TABLE algemeen.veiligheidsregio_huidig TO oiv_admin;
GRANT SELECT ON TABLE algemeen.veiligheidsregio_huidig TO oiv_read;




-- Permissions

GRANT ALL ON SCHEMA algemeen TO oiv_admin;
GRANT USAGE ON SCHEMA algemeen TO oiv_read;
