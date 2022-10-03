SET role oiv_admin;
SET search_path = info_of_interest, pg_catalog, public;

DROP SCHEMA IF EXISTS info_of_interest CASCADE;
CREATE SCHEMA info_of_interest;

GRANT USAGE ON SCHEMA info_of_interest TO oiv_read;
GRANT USAGE ON SCHEMA info_of_interest TO oiv_write;

CREATE TABLE labels_of_interest_type (
    id int2 NOT NULL,
    naam varchar(50) NULL,
    symbol_name text NULL,
    "size" int4 NULL,
    CONSTRAINT labels_of_interest_type_new_pkey PRIMARY KEY (id),
    CONSTRAINT labels_naam_uk UNIQUE (naam)
);

CREATE TABLE points_of_interest_type (
    id int2 NOT NULL,
    naam varchar(50) NULL,
    symbol_name text NULL,
    "size" int4 NULL,
    CONSTRAINT points_of_interest_type_new_pkey PRIMARY KEY (id),
    CONSTRAINT points_naam_uk UNIQUE (naam)
);

CREATE TABLE lines_of_interest_type (
    id int2 NOT NULL,
    naam varchar(50) NULL,
    CONSTRAINT lines_of_interest_type_new_pkey PRIMARY KEY (id),
    CONSTRAINT lines_naam_uk UNIQUE (naam)
);

CREATE TABLE labels_of_interest (
    id serial4 NOT NULL,
    geom geometry(point, 28992) NULL,
    datum_aangemaakt timestamptz NULL DEFAULT now(),
    datum_gewijzigd timestamptz NULL,
    omschrijving varchar(254) NOT NULL,
    rotatie int4 NULL,
    soort varchar(50) NULL,
    CONSTRAINT labels_of_interest_pkey PRIMARY KEY (id)
);
CREATE INDEX labels_of_interest_geom_gist ON labels_of_interest USING btree (geom);

CREATE TABLE points_of_interest (
    id serial4 NOT NULL,
    geom geometry(point, 28992) NULL,
    datum_aangemaakt timestamp NULL DEFAULT now(),
    datum_gewijzigd timestamp NULL,
    points_of_interest_type_id int4 NULL,
    "label" text NULL,
    rotatie int4 NULL DEFAULT 0,
    fotografie_id int4 NULL,
    bijzonderheid text NULL,
    CONSTRAINT points_of_interest_pkey PRIMARY KEY (id)
);
CREATE INDEX points_of_interest_geom_gist ON points_of_interest USING btree (geom);

CREATE TABLE lines_of_interest (
    id serial4 NOT NULL,
    geom geometry(multilinestring, 28992) NULL,
    datum_aangemaakt timestamp NULL DEFAULT now(),
    datum_gewijzigd timestamp NULL,
    soort varchar(50) NULL,
    "label" text NULL,
    fotografie_id int4 NULL,
    bijzonderheid text NULL,
    CONSTRAINT lines_of_interest_pkey PRIMARY KEY (id)
);
CREATE INDEX lines_of_interest_geom_gist ON lines_of_interest USING gist (geom);

-- Table Triggers
CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    labels_of_interest FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    labels_of_interest FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    points_of_interest FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    points_of_interest FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    lines_of_interest FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    lines_of_interest FOR EACH ROW EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');


-- labels_of_interest foreign keys
ALTER TABLE labels_of_interest ADD CONSTRAINT labels_soort_id_fk FOREIGN KEY (soort) REFERENCES labels_of_interest_type(naam);

-- points_of_interest foreign keys
ALTER TABLE points_of_interest ADD CONSTRAINT points_of_interest_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE points_of_interest ADD CONSTRAINT points_of_interest_type_id_fk FOREIGN KEY (points_of_interest_type_id) REFERENCES points_of_interest_type(id);

-- lines_of_interest foreign keys
ALTER TABLE lines_of_interest ADD CONSTRAINT lines_of_interest_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE lines_of_interest ADD CONSTRAINT lines_of_interest_soort_fk FOREIGN KEY (soort) REFERENCES lines_of_interest_type(naam);

--label types
INSERT INTO labels_of_interest_type 
SELECT * FROM objecten.label_type;

--points types
INSERT INTO points_of_interest_type (id, naam, symbol_name, size) VALUES
     (149,'Stijgleiding afnamepunt','stijgleiding_ld_afnamepunt', 6),
     (154,'Waterkanon','waterkanon', 6),
     (152,'Stijgleiding HD vulpunt','stijgleiding_hd_vulpunt', 6),
     (151,'Stijgleiding HD afnamepunt','stijgleiding_hd_afnamepunt', 6),
     (150,'Stijgleiding vulpunt','stijgleiding_ld_vulpunt', 6),
     (18,'Bereik DMO','dekkingsprobleem_dmo', 6),
     (17,'Asbest','asbest', 6),
     (146,'Rietenkap','rietenkap', 6),
     (20,'Bereik TMO','dekkingsprobleem_tmo', 6),
     (148,'Sleutelkluis','sleutelkluis', 6);

INSERT INTO points_of_interest_type (id, naam, symbol_name, size)
SELECT * FROM objecten.points_of_interest_type WHERE id > 50;

--pictogrammen zonder object overzetten en opruimen
INSERT INTO points_of_interest (geom, points_of_interest_type_id, rotatie, label)
SELECT geom, voorziening_pictogram_id, rotatie, label FROM objecten.pictogram_zonder_object;

--line types
INSERT INTO lines_of_interest_type (id,naam) VALUES
     (2,'hekwerk'),
     (8,'blusleiding'),
     (10,'slagboom');

INSERT INTO algemeen.styles (laagnaam,soortnaam,lijndikte,lijnkleur,lijnstijl,verbindingsstijl,eindstijl) VALUES
     ('Bereikbaarheid','hekwerk',0.2,'#ffa2a2a2','solid','bevel','round');

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 8;
UPDATE algemeen.applicatie SET db_versie = 338; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();