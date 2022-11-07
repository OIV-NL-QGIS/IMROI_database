-- DROP SCHEMA bluswater;

CREATE SCHEMA bluswater AUTHORIZATION oiv_admin;

COMMENT ON SCHEMA bluswater IS 'OIV bluswater';

-- DROP SEQUENCE bluswater.alternatieve_id_seq;

CREATE SEQUENCE bluswater.alternatieve_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE bluswater.alternatieve_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE bluswater.alternatieve_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE bluswater.alternatieve_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE bluswater.alternatieve_id_seq TO oiv_write;

-- DROP SEQUENCE bluswater.brandkranen_landelijk_id_seq;

CREATE SEQUENCE bluswater.brandkranen_landelijk_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE bluswater.brandkranen_landelijk_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE bluswater.brandkranen_landelijk_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE bluswater.brandkranen_landelijk_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE bluswater.brandkranen_landelijk_id_seq TO oiv_write;

-- DROP SEQUENCE bluswater.enum_conditie_id_seq;

CREATE SEQUENCE bluswater.enum_conditie_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE bluswater.enum_conditie_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE bluswater.enum_conditie_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE bluswater.enum_conditie_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE bluswater.enum_conditie_id_seq TO oiv_write;

-- DROP SEQUENCE bluswater.inspectie_id_seq;

CREATE SEQUENCE bluswater.inspectie_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE bluswater.inspectie_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE bluswater.inspectie_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE bluswater.inspectie_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE bluswater.inspectie_id_seq TO oiv_write;

-- DROP SEQUENCE bluswater.kavels_kavel_seq;

CREATE SEQUENCE bluswater.kavels_kavel_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE bluswater.kavels_kavel_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE bluswater.kavels_kavel_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE bluswater.kavels_kavel_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE bluswater.kavels_kavel_seq TO oiv_write;

-- DROP SEQUENCE bluswater.leidingen_id_seq;

CREATE SEQUENCE bluswater.leidingen_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE bluswater.leidingen_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE bluswater.leidingen_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE bluswater.leidingen_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE bluswater.leidingen_id_seq TO oiv_write;

-- DROP SEQUENCE bluswater.plusinformatie_id_seq;

CREATE SEQUENCE bluswater.plusinformatie_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE bluswater.plusinformatie_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE bluswater.plusinformatie_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE bluswater.plusinformatie_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE bluswater.plusinformatie_id_seq TO oiv_write;
-- bluswater.alternatieve_type definition

-- Drop table

-- DROP TABLE bluswater.alternatieve_type;

CREATE TABLE bluswater.alternatieve_type (
	id int2 NOT NULL,
	naam varchar(25) NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	CONSTRAINT alternatieve_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE bluswater.alternatieve_type IS 'Opzoeklijst voor alternatieve bluswatervoorzieningen';

-- Permissions

ALTER TABLE bluswater.alternatieve_type OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.alternatieve_type TO oiv_admin;
GRANT SELECT ON TABLE bluswater.alternatieve_type TO oiv_read;


-- bluswater.brandkranen definition

-- Drop table

-- DROP TABLE bluswater.brandkranen;

CREATE TABLE bluswater.brandkranen (
	nummer varchar NOT NULL,
	geom geometry(point, 28992) NULL,
	"type" varchar NULL,
	diameter int2 NULL,
	postcode varchar NULL,
	straat varchar NULL,
	huisnummer varchar NULL,
	capaciteit int2 NULL,
	plaats varchar NULL,
	gemeentenaam varchar NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT brandkranen_pkey PRIMARY KEY (nummer)
);
CREATE INDEX brandkranen_geom_gist ON bluswater.brandkranen USING gist (geom);

-- Table Triggers

CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    bluswater.brandkranen FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE bluswater.brandkranen OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.brandkranen TO oiv_admin;
GRANT SELECT ON TABLE bluswater.brandkranen TO oiv_read;


-- bluswater.brandkranen_landelijk definition

-- Drop table

-- DROP TABLE bluswater.brandkranen_landelijk;

CREATE TABLE bluswater.brandkranen_landelijk (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	bronhouder varchar NULL,
	nen3610id varchar NULL,
	volgnummer varchar NULL,
	kraantype varchar NULL,
	x float8 NULL,
	y float8 NULL,
	status varchar NULL,
	ligging varchar NULL,
	spindeltype varchar NULL,
	diameter varchar NULL,
	leidingmateriaal varchar NULL,
	datum_aanleg varchar NULL,
	datum_laatste_inspectie varchar NULL,
	einddatum varchar NULL,
	adres varchar NULL,
	beveiligd varchar NULL,
	gemeentecode varchar NULL,
	gemeentenaam varchar NULL,
	soortleiding varchar NULL,
	mutatiedatum varchar NULL,
	CONSTRAINT brandkranen_landelijk_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE bluswater.brandkranen_landelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.brandkranen_landelijk TO oiv_admin;
GRANT SELECT ON TABLE bluswater.brandkranen_landelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.brandkranen_landelijk TO oiv_write;


-- bluswater.enum_conditie definition

-- Drop table

-- DROP TABLE bluswater.enum_conditie;

CREATE TABLE bluswater.enum_conditie (
	id serial4 NOT NULL,
	value text NULL,
	CONSTRAINT enum_conditie_pkey PRIMARY KEY (id),
	CONSTRAINT enum_conditie_value_new_key UNIQUE (value)
);

-- Permissions

ALTER TABLE bluswater.enum_conditie OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.enum_conditie TO oiv_admin;
GRANT SELECT ON TABLE bluswater.enum_conditie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.enum_conditie TO oiv_write;


-- bluswater.gt_pk_metadata_table definition

-- Drop table

-- DROP TABLE bluswater.gt_pk_metadata_table;

CREATE TABLE bluswater.gt_pk_metadata_table (
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

ALTER TABLE bluswater.gt_pk_metadata_table OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.gt_pk_metadata_table TO oiv_admin;
GRANT SELECT ON TABLE bluswater.gt_pk_metadata_table TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.gt_pk_metadata_table TO oiv_write;


-- bluswater.kavels definition

-- Drop table

-- DROP TABLE bluswater.kavels;

CREATE TABLE bluswater.kavels (
	kavel serial4 NOT NULL,
	geom geometry(multipolygon, 28992) NULL,
	post varchar(50) NULL,
	CONSTRAINT kavels_pkey PRIMARY KEY (kavel)
);
CREATE INDEX kavels_geom_gist ON bluswater.kavels USING gist (geom);

-- Permissions

ALTER TABLE bluswater.kavels OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.kavels TO oiv_admin;
GRANT SELECT ON TABLE bluswater.kavels TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.kavels TO oiv_write;


-- bluswater.leidingen definition

-- Drop table

-- DROP TABLE bluswater.leidingen;

CREATE TABLE bluswater.leidingen (
	id serial4 NOT NULL,
	geom geometry(linestring, 28992) NULL,
	materiaal varchar NULL,
	diameter numeric NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT leidingen_pkey PRIMARY KEY (id)
);
CREATE INDEX leidingen_geom_gist ON bluswater.leidingen USING gist (geom);

-- Table Triggers

CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    bluswater.leidingen FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE bluswater.leidingen OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.leidingen TO oiv_admin;
GRANT SELECT ON TABLE bluswater.leidingen TO oiv_read;


-- bluswater.plusinformatie definition

-- Drop table

-- DROP TABLE bluswater.plusinformatie;

CREATE TABLE bluswater.plusinformatie (
	id serial4 NOT NULL,
	brandkraan_nummer varchar NOT NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	verwijderd bool NULL DEFAULT false,
	frequentie int2 NULL DEFAULT 24, -- Inspectie frequentie in maanden
	opmerking text NULL,
	kavel int2 NOT NULL,
	inlognaam text NOT NULL,
	CONSTRAINT plusinformatie_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX plusinformatie_brandkraan_nummer_uindex ON bluswater.plusinformatie USING btree (brandkraan_nummer);

-- Column comments

COMMENT ON COLUMN bluswater.plusinformatie.frequentie IS 'Inspectie frequentie in maanden';

-- Permissions

ALTER TABLE bluswater.plusinformatie OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.plusinformatie TO oiv_admin;
GRANT SELECT ON TABLE bluswater.plusinformatie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.plusinformatie TO oiv_write;


-- bluswater.alternatieve definition

-- Drop table

-- DROP TABLE bluswater.alternatieve;

CREATE TABLE bluswater.alternatieve (
	id serial4 NOT NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	type_id int4 NULL,
	liters_per int4 NULL,
	"label" text NULL,
	geom geometry(point, 28992) NULL,
	opmerking text NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT alternatieve_pkey PRIMARY KEY (id),
	CONSTRAINT altern_type_id_fk FOREIGN KEY (type_id) REFERENCES bluswater.alternatieve_type(id)
);
CREATE INDEX alternatieve_geom_gist ON bluswater.alternatieve USING btree (geom);

-- Table Triggers

CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    bluswater.alternatieve FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    bluswater.alternatieve FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    bluswater.alternatieve FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE bluswater.alternatieve OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.alternatieve TO oiv_admin;
GRANT SELECT ON TABLE bluswater.alternatieve TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.alternatieve TO oiv_write;


-- bluswater.inspectie definition

-- Drop table

-- DROP TABLE bluswater.inspectie;

CREATE TABLE bluswater.inspectie (
	id serial4 NOT NULL,
	brandkraan_nummer varchar NOT NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	conditie text NOT NULL DEFAULT 'inspecteren'::text,
	inspecteur text NULL,
	plaatsaanduiding text NULL,
	plaatsaanduiding_anders text NULL,
	toegankelijkheid text NULL,
	toegankelijkheid_anders text NULL,
	klauw text NULL,
	klauw_diepte int2 NULL,
	klauw_anders text NULL,
	werking text NULL,
	werking_anders text NULL,
	opmerking text NULL,
	foto text NULL,
	uitgezet_bij_pwn bool NULL DEFAULT false,
	uitgezet_bij_gemeente bool NULL DEFAULT false,
	opmerking_beheerder text NULL,
	inlognaam text NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT inspectie_pkey PRIMARY KEY (id),
	CONSTRAINT inspectie_conditie_fkey FOREIGN KEY (conditie) REFERENCES bluswater.enum_conditie(value) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX inspectie_brandkraan_nummer_uindex ON bluswater.inspectie USING btree (brandkraan_nummer);

-- Table Triggers

CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    bluswater.inspectie FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE bluswater.inspectie OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.inspectie TO oiv_admin;
GRANT SELECT ON TABLE bluswater.inspectie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.inspectie TO oiv_write;


-- bluswater.afgekeurd_binnen_straal source

CREATE OR REPLACE VIEW bluswater.afgekeurd_binnen_straal
AS SELECT row_number() OVER (ORDER BY tot.bk_nummer) AS gid,
    tot.bk_nummer,
    tot.count,
    bk.geom
   FROM ( SELECT nearest.bk_nummer,
            count(nearest.bk_nummer) AS count
           FROM ( SELECT i.id AS bk_nummer,
                    i.b_gid,
                    st_distance(i.geom, i.b_geom) AS dist,
                    i.geom
                   FROM ( SELECT a.id,
                            b.id AS b_gid,
                            a.geom,
                            b.geom AS b_geom,
                            rank() OVER (PARTITION BY a.id ORDER BY (st_distance(a.geom, b.geom))) AS pos
                           FROM ( SELECT brandkraan_inspectie.id,
                                    brandkraan_inspectie.geom
                                   FROM bluswater.brandkraan_inspectie
                                  WHERE brandkraan_inspectie.conditie = 'afgekeurd'::text) a,
                            ( SELECT brandkraan_inspectie.id,
                                    brandkraan_inspectie.geom
                                   FROM bluswater.brandkraan_inspectie
                                  WHERE brandkraan_inspectie.conditie = 'afgekeurd'::text) b
                          WHERE a.id::text <> b.id::text) i
                  WHERE i.pos <= 5) nearest
          WHERE nearest.dist <= 120::double precision
          GROUP BY nearest.bk_nummer) tot
     JOIN bluswater.brandkranen bk ON tot.bk_nummer::text = bk.nummer::text;

-- Permissions

ALTER TABLE bluswater.afgekeurd_binnen_straal OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.afgekeurd_binnen_straal TO oiv_admin;
GRANT SELECT ON TABLE bluswater.afgekeurd_binnen_straal TO oiv_read;


-- bluswater.bluswater_stavaza_gemeente source

CREATE OR REPLACE VIEW bluswater.bluswater_stavaza_gemeente
AS SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.conditie) FILTER (WHERE s.conditie = 'inspecteren'::text) AS inspecteren,
    count(s.conditie) FILTER (WHERE s.conditie = 'goedgekeurd'::text) AS goedgekeurd,
    count(s.conditie) FILTER (WHERE s.conditie = 'werkbaar'::text) AS werkbaar,
    count(s.conditie) FILTER (WHERE s.conditie = 'afgekeurd'::text) AS afgekeurd,
    count(s.conditie) FILTER (WHERE s.conditie = 'binnenkort inspecteren'::text) AS binnenkort_inspecteren,
    g.geom
   FROM bluswater.brandkraan_inspectie s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;

-- Permissions

ALTER TABLE bluswater.bluswater_stavaza_gemeente OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.bluswater_stavaza_gemeente TO oiv_admin;
GRANT SELECT ON TABLE bluswater.bluswater_stavaza_gemeente TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.bluswater_stavaza_gemeente TO oiv_write;


-- bluswater.brandkraan_huidig source

CREATE OR REPLACE VIEW bluswater.brandkraan_huidig
AS SELECT brandkranen.nummer,
    brandkranen.geom,
    brandkranen.type,
    brandkranen.diameter,
    brandkranen.postcode,
    brandkranen.straat,
    brandkranen.huisnummer,
    brandkranen.capaciteit,
    brandkranen.plaats,
    brandkranen.gemeentenaam
   FROM bluswater.brandkranen;

-- Permissions

ALTER TABLE bluswater.brandkraan_huidig OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.brandkraan_huidig TO oiv_admin;
GRANT SELECT ON TABLE bluswater.brandkraan_huidig TO oiv_read;


-- bluswater.brandkraan_huidig_plus source

CREATE OR REPLACE VIEW bluswater.brandkraan_huidig_plus
AS SELECT brandkraan_huidig.nummer,
    brandkraan_huidig.geom,
    brandkraan_huidig.type,
    brandkraan_huidig.diameter,
    brandkraan_huidig.postcode,
    brandkraan_huidig.straat,
    brandkraan_huidig.huisnummer,
    brandkraan_huidig.capaciteit,
    brandkraan_huidig.plaats,
    brandkraan_huidig.gemeentenaam,
    COALESCE(plusinformatie.verwijderd, false) AS verwijderd,
    COALESCE(plusinformatie.frequentie::integer, 24) AS frequentie,
    plusinformatie.opmerking,
    plusinformatie.inlognaam
   FROM bluswater.brandkraan_huidig
     LEFT JOIN bluswater.plusinformatie ON brandkraan_huidig.nummer::text = plusinformatie.brandkraan_nummer::text;

-- Permissions

ALTER TABLE bluswater.brandkraan_huidig_plus OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.brandkraan_huidig_plus TO oiv_admin;
GRANT SELECT ON TABLE bluswater.brandkraan_huidig_plus TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.brandkraan_huidig_plus TO oiv_write;


-- bluswater.brandkraan_inspectie source

CREATE OR REPLACE VIEW bluswater.brandkraan_inspectie
AS SELECT brandkraan_huidig_plus.nummer AS id,
    inspectie.id AS inspectie_id,
    brandkraan_huidig_plus.nummer,
    brandkraan_huidig_plus.geom,
    inspectie.datum_aangemaakt,
    inspectie.datum_gewijzigd,
        CASE
            WHEN (inspectie.datum_aangemaakt + brandkraan_huidig_plus.frequentie::double precision * '1 mon'::interval) < now() THEN 'inspecteren'::text
            WHEN (inspectie.datum_aangemaakt + (brandkraan_huidig_plus.frequentie - 3)::double precision * '1 mon'::interval) < now() AND (inspectie.datum_aangemaakt + brandkraan_huidig_plus.frequentie::double precision * '1 mon'::interval) > now() THEN 'binnenkort inspecteren'::text
            ELSE COALESCE(inspectie.conditie, 'inspecteren'::text)
        END AS conditie,
    inspectie.inspecteur,
    inspectie.plaatsaanduiding,
    inspectie.plaatsaanduiding_anders,
    inspectie.toegankelijkheid,
    inspectie.toegankelijkheid_anders,
    inspectie.klauw,
    inspectie.klauw_diepte,
    inspectie.klauw_anders,
    inspectie.werking,
    inspectie.werking_anders,
    inspectie.opmerking,
    inspectie.foto,
    inspectie.uitgezet_bij_pwn AS uit_gezet_bij_pwn,
    inspectie.uitgezet_bij_gemeente AS uit_gezet_bij_gemeente,
    inspectie.opmerking_beheerder,
    brandkraan_huidig_plus.inlognaam,
    brandkraan_huidig_plus.gemeentenaam
   FROM bluswater.brandkraan_huidig_plus
     LEFT JOIN bluswater.inspectie ON inspectie.id = (( SELECT leegfreq.id
           FROM bluswater.inspectie leegfreq
          WHERE leegfreq.brandkraan_nummer::text = brandkraan_huidig_plus.nummer::text
          ORDER BY leegfreq.datum_aangemaakt DESC
         LIMIT 1))
  WHERE brandkraan_huidig_plus.verwijderd = false;

-- Permissions

ALTER TABLE bluswater.brandkraan_inspectie OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.brandkraan_inspectie TO oiv_admin;
GRANT SELECT ON TABLE bluswater.brandkraan_inspectie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.brandkraan_inspectie TO oiv_write;


-- bluswater.brandkraan_kavels source

CREATE OR REPLACE VIEW bluswater.brandkraan_kavels
AS SELECT b.nummer,
    concat(lower(k.post::text), '@vrnhn.nl') AS inlognaam,
    k.kavel
   FROM bluswater.brandkranen b
     JOIN bluswater.kavels k ON st_intersects(b.geom, k.geom);

-- Permissions

ALTER TABLE bluswater.brandkraan_kavels OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.brandkraan_kavels TO oiv_admin;
GRANT SELECT ON TABLE bluswater.brandkraan_kavels TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.brandkraan_kavels TO oiv_write;


-- bluswater.leiding_huidig source

CREATE OR REPLACE VIEW bluswater.leiding_huidig
AS SELECT leidingen.id,
    leidingen.geom,
    leidingen.materiaal,
    leidingen.diameter
   FROM bluswater.leidingen;

-- Permissions

ALTER TABLE bluswater.leiding_huidig OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.leiding_huidig TO oiv_admin;
GRANT SELECT ON TABLE bluswater.leiding_huidig TO oiv_read;


-- bluswater.rapport_inspectie source

CREATE OR REPLACE VIEW bluswater.rapport_inspectie
AS SELECT brandkraan_huidig_plus.nummer AS id,
    inspectie.id AS inspectie_id,
    brandkraan_huidig_plus.nummer,
    brandkraan_huidig_plus.geom,
    brandkraan_huidig_plus.type,
    brandkraan_huidig_plus.diameter,
    brandkraan_huidig_plus.postcode,
    brandkraan_huidig_plus.straat,
    brandkraan_huidig_plus.huisnummer,
    brandkraan_huidig_plus.capaciteit,
    brandkraan_huidig_plus.plaats,
    brandkraan_huidig_plus.gemeentenaam,
    inspectie.datum_aangemaakt,
    inspectie.datum_gewijzigd,
    GREATEST(inspectie.datum_aangemaakt, inspectie.datum_gewijzigd) AS mutatie,
    inspectie.conditie,
    inspectie.inspecteur,
    inspectie.plaatsaanduiding,
    inspectie.plaatsaanduiding_anders,
    inspectie.toegankelijkheid,
    inspectie.toegankelijkheid_anders,
    inspectie.klauw,
    inspectie.klauw_diepte,
    inspectie.klauw_anders,
    inspectie.werking,
    inspectie.werking_anders,
    inspectie.opmerking,
    inspectie.foto,
    inspectie.uitgezet_bij_pwn,
    inspectie.uitgezet_bij_gemeente,
    inspectie.opmerking_beheerder
   FROM bluswater.brandkraan_huidig_plus
     LEFT JOIN bluswater.inspectie ON inspectie.id = (( SELECT leegfreq.id
           FROM bluswater.inspectie leegfreq
          WHERE leegfreq.brandkraan_nummer::text = brandkraan_huidig_plus.nummer::text
          ORDER BY leegfreq.datum_aangemaakt DESC
         LIMIT 1))
  WHERE brandkraan_huidig_plus.verwijderd = false;

COMMENT ON VIEW bluswater.rapport_inspectie IS 'Algemene view voor weergave in rapporten';

-- Permissions

ALTER TABLE bluswater.rapport_inspectie OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.rapport_inspectie TO oiv_admin;
GRANT SELECT ON TABLE bluswater.rapport_inspectie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.rapport_inspectie TO oiv_write;


-- bluswater.rapport_inspectie_defect source

CREATE OR REPLACE VIEW bluswater.rapport_inspectie_defect
AS SELECT rapport_inspectie.id,
    rapport_inspectie.inspectie_id,
    rapport_inspectie.nummer,
    rapport_inspectie.geom,
    rapport_inspectie.type,
    rapport_inspectie.diameter,
    rapport_inspectie.postcode,
    rapport_inspectie.straat,
    rapport_inspectie.huisnummer,
    rapport_inspectie.capaciteit,
    rapport_inspectie.plaats,
    rapport_inspectie.gemeentenaam,
    rapport_inspectie.datum_aangemaakt,
    rapport_inspectie.datum_gewijzigd,
    rapport_inspectie.mutatie,
    rapport_inspectie.conditie,
    rapport_inspectie.inspecteur,
    rapport_inspectie.plaatsaanduiding,
    rapport_inspectie.plaatsaanduiding_anders,
    rapport_inspectie.toegankelijkheid,
    rapport_inspectie.toegankelijkheid_anders,
    rapport_inspectie.klauw,
    rapport_inspectie.klauw_diepte,
    rapport_inspectie.klauw_anders,
    rapport_inspectie.werking,
    rapport_inspectie.werking_anders,
    rapport_inspectie.opmerking,
    rapport_inspectie.foto,
    rapport_inspectie.uitgezet_bij_pwn,
    rapport_inspectie.uitgezet_bij_gemeente,
    rapport_inspectie.opmerking_beheerder
   FROM bluswater.rapport_inspectie
  WHERE rapport_inspectie.conditie ~~* 'afgekeurd'::text OR rapport_inspectie.conditie ~~* 'werkbaar'::text;

COMMENT ON VIEW bluswater.rapport_inspectie_defect IS 'View voor afgekeurd en werkbaar, basis voor rapport vandaag pwn en gemeente';

-- Permissions

ALTER TABLE bluswater.rapport_inspectie_defect OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.rapport_inspectie_defect TO oiv_admin;
GRANT SELECT ON TABLE bluswater.rapport_inspectie_defect TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.rapport_inspectie_defect TO oiv_write;


-- bluswater.rapport_inspectie_vandaag_gemeente source

CREATE OR REPLACE VIEW bluswater.rapport_inspectie_vandaag_gemeente
AS SELECT rapport_inspectie_defect.id,
    rapport_inspectie_defect.inspectie_id,
    rapport_inspectie_defect.nummer,
    rapport_inspectie_defect.geom,
    rapport_inspectie_defect.type,
    rapport_inspectie_defect.diameter,
    rapport_inspectie_defect.postcode,
    rapport_inspectie_defect.straat,
    rapport_inspectie_defect.huisnummer,
    rapport_inspectie_defect.capaciteit,
    rapport_inspectie_defect.plaats,
    rapport_inspectie_defect.gemeentenaam,
    rapport_inspectie_defect.datum_aangemaakt,
    rapport_inspectie_defect.datum_gewijzigd,
    rapport_inspectie_defect.mutatie,
    rapport_inspectie_defect.conditie,
    rapport_inspectie_defect.inspecteur,
    rapport_inspectie_defect.plaatsaanduiding,
    rapport_inspectie_defect.plaatsaanduiding_anders,
    rapport_inspectie_defect.toegankelijkheid,
    rapport_inspectie_defect.toegankelijkheid_anders,
    rapport_inspectie_defect.klauw,
    rapport_inspectie_defect.klauw_diepte,
    rapport_inspectie_defect.klauw_anders,
    rapport_inspectie_defect.werking,
    rapport_inspectie_defect.werking_anders,
    rapport_inspectie_defect.opmerking,
    rapport_inspectie_defect.foto,
    rapport_inspectie_defect.uitgezet_bij_pwn,
    rapport_inspectie_defect.uitgezet_bij_gemeente,
    rapport_inspectie_defect.opmerking_beheerder
   FROM bluswater.rapport_inspectie_defect
  WHERE rapport_inspectie_defect.mutatie::date = now()::date AND (rapport_inspectie_defect.plaatsaanduiding IS NOT NULL OR rapport_inspectie_defect.plaatsaanduiding_anders IS NOT NULL OR rapport_inspectie_defect.toegankelijkheid IS NOT NULL OR rapport_inspectie_defect.toegankelijkheid_anders IS NOT NULL);

-- Permissions

ALTER TABLE bluswater.rapport_inspectie_vandaag_gemeente OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.rapport_inspectie_vandaag_gemeente TO oiv_admin;
GRANT SELECT ON TABLE bluswater.rapport_inspectie_vandaag_gemeente TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.rapport_inspectie_vandaag_gemeente TO oiv_write;


-- bluswater.rapport_inspectie_vandaag_pwn source

CREATE OR REPLACE VIEW bluswater.rapport_inspectie_vandaag_pwn
AS SELECT rapport_inspectie_defect.id,
    rapport_inspectie_defect.inspectie_id,
    rapport_inspectie_defect.nummer,
    rapport_inspectie_defect.geom,
    rapport_inspectie_defect.type,
    rapport_inspectie_defect.diameter,
    rapport_inspectie_defect.postcode,
    rapport_inspectie_defect.straat,
    rapport_inspectie_defect.huisnummer,
    rapport_inspectie_defect.capaciteit,
    rapport_inspectie_defect.plaats,
    rapport_inspectie_defect.gemeentenaam,
    rapport_inspectie_defect.datum_aangemaakt,
    rapport_inspectie_defect.datum_gewijzigd,
    rapport_inspectie_defect.mutatie,
    rapport_inspectie_defect.conditie,
    rapport_inspectie_defect.inspecteur,
    rapport_inspectie_defect.plaatsaanduiding,
    rapport_inspectie_defect.plaatsaanduiding_anders,
    rapport_inspectie_defect.toegankelijkheid,
    rapport_inspectie_defect.toegankelijkheid_anders,
    rapport_inspectie_defect.klauw,
    rapport_inspectie_defect.klauw_diepte,
    rapport_inspectie_defect.klauw_anders,
    rapport_inspectie_defect.werking,
    rapport_inspectie_defect.werking_anders,
    rapport_inspectie_defect.opmerking,
    rapport_inspectie_defect.foto,
    rapport_inspectie_defect.uitgezet_bij_pwn,
    rapport_inspectie_defect.uitgezet_bij_gemeente,
    rapport_inspectie_defect.opmerking_beheerder
   FROM bluswater.rapport_inspectie_defect
  WHERE rapport_inspectie_defect.mutatie::date = now()::date AND (rapport_inspectie_defect.klauw IS NOT NULL OR rapport_inspectie_defect.klauw_anders IS NOT NULL OR rapport_inspectie_defect.werking IS NOT NULL OR rapport_inspectie_defect.werking_anders IS NOT NULL);

-- Permissions

ALTER TABLE bluswater.rapport_inspectie_vandaag_pwn OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.rapport_inspectie_vandaag_pwn TO oiv_admin;
GRANT SELECT ON TABLE bluswater.rapport_inspectie_vandaag_pwn TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.rapport_inspectie_vandaag_pwn TO oiv_write;


-- bluswater.rapport_weekoverzicht source

CREATE OR REPLACE VIEW bluswater.rapport_weekoverzicht
AS SELECT rapport_inspectie.id,
    rapport_inspectie.inspectie_id,
    rapport_inspectie.nummer,
    rapport_inspectie.geom,
    rapport_inspectie.type,
    rapport_inspectie.diameter,
    rapport_inspectie.postcode,
    rapport_inspectie.straat,
    rapport_inspectie.huisnummer,
    rapport_inspectie.capaciteit,
    rapport_inspectie.plaats,
    rapport_inspectie.gemeentenaam,
    rapport_inspectie.datum_aangemaakt,
    rapport_inspectie.datum_gewijzigd,
    rapport_inspectie.mutatie,
    rapport_inspectie.conditie,
    rapport_inspectie.inspecteur,
    rapport_inspectie.plaatsaanduiding,
    rapport_inspectie.plaatsaanduiding_anders,
    rapport_inspectie.toegankelijkheid,
    rapport_inspectie.toegankelijkheid_anders,
    rapport_inspectie.klauw,
    rapport_inspectie.klauw_diepte,
    rapport_inspectie.klauw_anders,
    rapport_inspectie.werking,
    rapport_inspectie.werking_anders,
    rapport_inspectie.opmerking,
    rapport_inspectie.foto,
    rapport_inspectie.uitgezet_bij_pwn,
    rapport_inspectie.uitgezet_bij_gemeente,
    rapport_inspectie.opmerking_beheerder,
    btrim(concat(rapport_inspectie.plaatsaanduiding, ' ', rapport_inspectie.plaatsaanduiding_anders, ' ', rapport_inspectie.toegankelijkheid, ' ', rapport_inspectie.toegankelijkheid_anders, ' ', rapport_inspectie.klauw, ' ', rapport_inspectie.klauw_diepte, ' ', rapport_inspectie.klauw_anders, ' ', rapport_inspectie.werking, ' ', rapport_inspectie.werking_anders)) AS resultaat
   FROM bluswater.rapport_inspectie
  WHERE date_part('week'::text, rapport_inspectie.mutatie) = date_part('week'::text, now())
  ORDER BY rapport_inspectie.mutatie;

-- Permissions

ALTER TABLE bluswater.rapport_weekoverzicht OWNER TO oiv_admin;
GRANT ALL ON TABLE bluswater.rapport_weekoverzicht TO oiv_admin;
GRANT SELECT ON TABLE bluswater.rapport_weekoverzicht TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE bluswater.rapport_weekoverzicht TO oiv_write;




-- Permissions

GRANT ALL ON SCHEMA bluswater TO oiv_admin;
GRANT USAGE ON SCHEMA bluswater TO oiv_read;
