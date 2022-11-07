-- DROP SCHEMA info_of_interest;

CREATE SCHEMA info_of_interest AUTHORIZATION oiv_admin;

-- DROP SEQUENCE info_of_interest.labels_of_interest_id_seq;

CREATE SEQUENCE info_of_interest.labels_of_interest_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE info_of_interest.labels_of_interest_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE info_of_interest.labels_of_interest_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE info_of_interest.labels_of_interest_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE info_of_interest.labels_of_interest_id_seq TO oiv_write;

-- DROP SEQUENCE info_of_interest.lines_of_interest_id_seq;

CREATE SEQUENCE info_of_interest.lines_of_interest_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE info_of_interest.lines_of_interest_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE info_of_interest.lines_of_interest_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE info_of_interest.lines_of_interest_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE info_of_interest.lines_of_interest_id_seq TO oiv_write;

-- DROP SEQUENCE info_of_interest.points_of_interest_id_seq;

CREATE SEQUENCE info_of_interest.points_of_interest_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE info_of_interest.points_of_interest_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE info_of_interest.points_of_interest_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE info_of_interest.points_of_interest_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE info_of_interest.points_of_interest_id_seq TO oiv_write;
-- info_of_interest.labels_of_interest_type definition

-- Drop table

-- DROP TABLE info_of_interest.labels_of_interest_type;

CREATE TABLE info_of_interest.labels_of_interest_type (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	CONSTRAINT labels_naam_uk UNIQUE (naam),
	CONSTRAINT labels_of_interest_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE info_of_interest.labels_of_interest_type OWNER TO oiv_admin;
GRANT ALL ON TABLE info_of_interest.labels_of_interest_type TO oiv_admin;
GRANT SELECT ON TABLE info_of_interest.labels_of_interest_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE info_of_interest.labels_of_interest_type TO oiv_write;


-- info_of_interest.lines_of_interest_type definition

-- Drop table

-- DROP TABLE info_of_interest.lines_of_interest_type;

CREATE TABLE info_of_interest.lines_of_interest_type (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	CONSTRAINT lines_naam_uk UNIQUE (naam),
	CONSTRAINT lines_of_interest_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE info_of_interest.lines_of_interest_type OWNER TO oiv_admin;
GRANT ALL ON TABLE info_of_interest.lines_of_interest_type TO oiv_admin;
GRANT SELECT ON TABLE info_of_interest.lines_of_interest_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE info_of_interest.lines_of_interest_type TO oiv_write;


-- info_of_interest.points_of_interest_type definition

-- Drop table

-- DROP TABLE info_of_interest.points_of_interest_type;

CREATE TABLE info_of_interest.points_of_interest_type (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	CONSTRAINT points_naam_uk UNIQUE (naam),
	CONSTRAINT points_of_interest_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE info_of_interest.points_of_interest_type OWNER TO oiv_admin;
GRANT ALL ON TABLE info_of_interest.points_of_interest_type TO oiv_admin;
GRANT SELECT ON TABLE info_of_interest.points_of_interest_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE info_of_interest.points_of_interest_type TO oiv_write;


-- info_of_interest.labels_of_interest definition

-- Drop table

-- DROP TABLE info_of_interest.labels_of_interest;

CREATE TABLE info_of_interest.labels_of_interest (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	omschrijving varchar(254) NOT NULL,
	rotatie int4 NULL,
	soort varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT labels_of_interest_pkey PRIMARY KEY (id),
	CONSTRAINT labels_soort_id_fk FOREIGN KEY (soort) REFERENCES info_of_interest.labels_of_interest_type(naam)
);
CREATE INDEX labels_of_interest_geom_gist ON info_of_interest.labels_of_interest USING btree (geom);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    info_of_interest.labels_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    info_of_interest.labels_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    info_of_interest.labels_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE info_of_interest.labels_of_interest OWNER TO oiv_admin;
GRANT ALL ON TABLE info_of_interest.labels_of_interest TO oiv_admin;
GRANT SELECT ON TABLE info_of_interest.labels_of_interest TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE info_of_interest.labels_of_interest TO oiv_write;


-- info_of_interest.lines_of_interest definition

-- Drop table

-- DROP TABLE info_of_interest.lines_of_interest;

CREATE TABLE info_of_interest.lines_of_interest (
	id serial4 NOT NULL,
	geom geometry(multilinestring, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	soort varchar(50) NULL,
	"label" text NULL,
	fotografie_id int4 NULL,
	bijzonderheid text NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT lines_of_interest_pkey PRIMARY KEY (id)
);
CREATE INDEX lines_of_interest_geom_gist ON info_of_interest.lines_of_interest USING gist (geom);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    info_of_interest.lines_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    info_of_interest.lines_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    info_of_interest.lines_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE info_of_interest.lines_of_interest OWNER TO oiv_admin;
GRANT ALL ON TABLE info_of_interest.lines_of_interest TO oiv_admin;
GRANT SELECT ON TABLE info_of_interest.lines_of_interest TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE info_of_interest.lines_of_interest TO oiv_write;


-- info_of_interest.points_of_interest definition

-- Drop table

-- DROP TABLE info_of_interest.points_of_interest;

CREATE TABLE info_of_interest.points_of_interest (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	points_of_interest_type_id int4 NULL,
	"label" text NULL,
	rotatie int4 NULL DEFAULT 0,
	fotografie_id int4 NULL,
	bijzonderheid text NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT points_of_interest_pkey PRIMARY KEY (id)
);
CREATE INDEX points_of_interest_geom_gist ON info_of_interest.points_of_interest USING btree (geom);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    info_of_interest.points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    info_of_interest.points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    info_of_interest.points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE info_of_interest.points_of_interest OWNER TO oiv_admin;
GRANT ALL ON TABLE info_of_interest.points_of_interest TO oiv_admin;
GRANT SELECT ON TABLE info_of_interest.points_of_interest TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE info_of_interest.points_of_interest TO oiv_write;


-- info_of_interest.lines_of_interest foreign keys

ALTER TABLE info_of_interest.lines_of_interest ADD CONSTRAINT lines_of_interest_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE info_of_interest.lines_of_interest ADD CONSTRAINT lines_of_interest_soort_fk FOREIGN KEY (soort) REFERENCES info_of_interest.lines_of_interest_type(naam);


-- info_of_interest.points_of_interest foreign keys

ALTER TABLE info_of_interest.points_of_interest ADD CONSTRAINT points_of_interest_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE info_of_interest.points_of_interest ADD CONSTRAINT points_of_interest_type_id_fk FOREIGN KEY (points_of_interest_type_id) REFERENCES info_of_interest.points_of_interest_type(id);




-- Permissions

GRANT ALL ON SCHEMA info_of_interest TO oiv_admin;
GRANT USAGE ON SCHEMA info_of_interest TO oiv_read;
GRANT USAGE ON SCHEMA info_of_interest TO oiv_write;
