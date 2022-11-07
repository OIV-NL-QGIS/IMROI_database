-- DROP SCHEMA objecten;

CREATE SCHEMA objecten AUTHORIZATION oiv_admin;

COMMENT ON SCHEMA objecten IS 'OIV objecten';

-- DROP SEQUENCE objecten.aanwezig_id_seq;

CREATE SEQUENCE objecten.aanwezig_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.aanwezig_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.aanwezig_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.aanwezig_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.aanwezig_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.afw_binnendekking_id_seq;

CREATE SEQUENCE objecten.afw_binnendekking_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.afw_binnendekking_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.afw_binnendekking_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.afw_binnendekking_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.afw_binnendekking_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.bedrijfshulpverlening_id_seq;

CREATE SEQUENCE objecten.bedrijfshulpverlening_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.bedrijfshulpverlening_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.bedrijfshulpverlening_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.bedrijfshulpverlening_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.bedrijfshulpverlening_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.beheersmaatregelen_id_seq;

CREATE SEQUENCE objecten.beheersmaatregelen_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.beheersmaatregelen_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.beheersmaatregelen_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.beheersmaatregelen_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.beheersmaatregelen_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.bereikbaarheid_id_seq;

CREATE SEQUENCE objecten.bereikbaarheid_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.bereikbaarheid_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.bereikbaarheid_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.bereikbaarheid_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.bereikbaarheid_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.bouwlaag_filter_id_seq;

CREATE SEQUENCE objecten.bouwlaag_filter_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.bouwlaag_filter_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.bouwlaag_filter_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.bouwlaag_filter_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.bouwlaag_filter_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.bouwlagen_id_seq;

CREATE SEQUENCE objecten.bouwlagen_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.bouwlagen_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.bouwlagen_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.bouwlagen_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.bouwlagen_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.contactpersoon_id_seq;

CREATE SEQUENCE objecten.contactpersoon_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.contactpersoon_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.contactpersoon_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.contactpersoon_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.contactpersoon_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.dreiging_id_seq;

CREATE SEQUENCE objecten.dreiging_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.dreiging_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.dreiging_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.dreiging_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.dreiging_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.gebiedsgerichte_aanpak_id_seq;

CREATE SEQUENCE objecten.gebiedsgerichte_aanpak_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.gebiedsgerichte_aanpak_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.gebiedsgerichte_aanpak_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.gebiedsgerichte_aanpak_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.gebiedsgerichte_aanpak_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.gebruiksfunctie_id_seq;

CREATE SEQUENCE objecten.gebruiksfunctie_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.gebruiksfunctie_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.gebruiksfunctie_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.gebruiksfunctie_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.gebruiksfunctie_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.gevaarlijkestof_id_seq;

CREATE SEQUENCE objecten.gevaarlijkestof_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.gevaarlijkestof_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.gevaarlijkestof_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.gevaarlijkestof_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.gevaarlijkestof_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.gevaarlijkestof_opslag_id_seq;

CREATE SEQUENCE objecten.gevaarlijkestof_opslag_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.gevaarlijkestof_opslag_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.gevaarlijkestof_opslag_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.gevaarlijkestof_opslag_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.gevaarlijkestof_opslag_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.gevaarlijkestof_schade_cirkel_id_seq;

CREATE SEQUENCE objecten.gevaarlijkestof_schade_cirkel_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.gevaarlijkestof_schade_cirkel_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.gevaarlijkestof_schade_cirkel_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.gevaarlijkestof_schade_cirkel_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.gevaarlijkestof_schade_cirkel_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.gevaarlijkestof_vnnr_id_seq;

CREATE SEQUENCE objecten.gevaarlijkestof_vnnr_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.gevaarlijkestof_vnnr_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.gevaarlijkestof_vnnr_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.gevaarlijkestof_vnnr_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.gevaarlijkestof_vnnr_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.grid_id_seq;

CREATE SEQUENCE objecten.grid_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.grid_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.grid_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.grid_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.grid_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.historie_id_seq;

CREATE SEQUENCE objecten.historie_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.historie_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.historie_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.historie_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.historie_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.ingang_id_seq;

CREATE SEQUENCE objecten.ingang_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.ingang_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.ingang_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.ingang_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.ingang_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.isolijnen_id_seq;

CREATE SEQUENCE objecten.isolijnen_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.isolijnen_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.isolijnen_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.isolijnen_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.isolijnen_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.label_id_seq;

CREATE SEQUENCE objecten.label_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.label_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.label_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.label_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.label_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.object_id_seq;

CREATE SEQUENCE objecten.object_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.object_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.object_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.object_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.object_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.opstelplaats_id_seq;

CREATE SEQUENCE objecten.opstelplaats_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.opstelplaats_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.opstelplaats_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.opstelplaats_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.opstelplaats_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.pictogram_zonder_object_id_seq;

CREATE SEQUENCE objecten.pictogram_zonder_object_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.pictogram_zonder_object_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.pictogram_zonder_object_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.pictogram_zonder_object_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.pictogram_zonder_object_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.points_of_interest_id_seq;

CREATE SEQUENCE objecten.points_of_interest_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.points_of_interest_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.points_of_interest_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.points_of_interest_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.points_of_interest_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.ruimten_id_seq;

CREATE SEQUENCE objecten.ruimten_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.ruimten_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.ruimten_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.ruimten_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.ruimten_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.ruimten_type_id_seq;

CREATE SEQUENCE objecten.ruimten_type_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.ruimten_type_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.ruimten_type_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.ruimten_type_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.ruimten_type_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.scenario_id_seq;

CREATE SEQUENCE objecten.scenario_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.scenario_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.scenario_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.scenario_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.scenario_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.scenario_locatie_id_seq;

CREATE SEQUENCE objecten.scenario_locatie_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.scenario_locatie_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.scenario_locatie_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.scenario_locatie_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.scenario_locatie_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.sectoren_id_seq;

CREATE SEQUENCE objecten.sectoren_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.sectoren_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.sectoren_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.sectoren_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.sectoren_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.sleutelkluis_id_seq;

CREATE SEQUENCE objecten.sleutelkluis_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.sleutelkluis_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.sleutelkluis_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.sleutelkluis_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.sleutelkluis_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.terrein_id_seq;

CREATE SEQUENCE objecten.terrein_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.terrein_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.terrein_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.terrein_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.terrein_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.veiligh_bouwk_id_seq;

CREATE SEQUENCE objecten.veiligh_bouwk_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.veiligh_bouwk_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.veiligh_bouwk_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.veiligh_bouwk_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.veiligh_bouwk_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.veiligh_install_id_seq;

CREATE SEQUENCE objecten.veiligh_install_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.veiligh_install_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.veiligh_install_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.veiligh_install_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.veiligh_install_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.veiligh_ruimtelijk_id_seq;

CREATE SEQUENCE objecten.veiligh_ruimtelijk_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.veiligh_ruimtelijk_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.veiligh_ruimtelijk_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.veiligh_ruimtelijk_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.veiligh_ruimtelijk_id_seq TO oiv_write;

-- DROP SEQUENCE objecten.veilighv_org_id_seq;

CREATE SEQUENCE objecten.veilighv_org_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE objecten.veilighv_org_id_seq OWNER TO oiv_admin;
GRANT ALL ON SEQUENCE objecten.veilighv_org_id_seq TO oiv_admin;
GRANT USAGE, SELECT ON SEQUENCE objecten.veilighv_org_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.veilighv_org_id_seq TO oiv_write;
-- objecten.aanwezig_type definition

-- Drop table

-- DROP TABLE objecten.aanwezig_type;

CREATE TABLE objecten.aanwezig_type (
	id int2 NOT NULL,
	naam text NULL,
	omschrijving text NULL,
	CONSTRAINT aanwezig_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.aanwezig_type IS 'Opzoeklijst voor groep type aanwezige personen';

-- Permissions

ALTER TABLE objecten.aanwezig_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.aanwezig_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.aanwezig_type TO oiv_read;


-- objecten.afw_binnendekking_type definition

-- Drop table

-- DROP TABLE objecten.afw_binnendekking_type;

CREATE TABLE objecten.afw_binnendekking_type (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	CONSTRAINT afw_binnendekking_type_new_naam_key UNIQUE (naam),
	CONSTRAINT afw_binnendekking_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.afw_binnendekking_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.afw_binnendekking_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.afw_binnendekking_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.afw_binnendekking_type TO oiv_write;


-- objecten.beheersmaatregelen_inzetfase definition

-- Drop table

-- DROP TABLE objecten.beheersmaatregelen_inzetfase;

CREATE TABLE objecten.beheersmaatregelen_inzetfase (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	CONSTRAINT beheersmaatregelen_inzetfase_naam_key UNIQUE (naam),
	CONSTRAINT beheersmaatregelen_inzetfase_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.beheersmaatregelen_inzetfase OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.beheersmaatregelen_inzetfase TO oiv_admin;
GRANT SELECT ON TABLE objecten.beheersmaatregelen_inzetfase TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.beheersmaatregelen_inzetfase TO oiv_write;


-- objecten.bereikbaarheid_type definition

-- Drop table

-- DROP TABLE objecten.bereikbaarheid_type;

CREATE TABLE objecten.bereikbaarheid_type (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	CONSTRAINT bereikbaarheid_type_new_naam_key UNIQUE (naam),
	CONSTRAINT bereikbaarheid_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.bereikbaarheid_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bereikbaarheid_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.bereikbaarheid_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bereikbaarheid_type TO oiv_write;


-- objecten.bodemgesteldheid_type definition

-- Drop table

-- DROP TABLE objecten.bodemgesteldheid_type;

CREATE TABLE objecten.bodemgesteldheid_type (
	id int2 NOT NULL,
	naam text NULL,
	omschrijving text NULL,
	CONSTRAINT bodemgesteldheid_type_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.bodemgesteldheid_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bodemgesteldheid_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.bodemgesteldheid_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bodemgesteldheid_type TO oiv_write;


-- objecten.bouwlaag_filter definition

-- Drop table

-- DROP TABLE objecten.bouwlaag_filter;

CREATE TABLE objecten.bouwlaag_filter (
	id serial4 NOT NULL,
	bouwlaag int4 NOT NULL,
	geom geometry(multipolygon, 28992) NOT NULL,
	CONSTRAINT bouwlaag_filter_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.bouwlaag_filter OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_filter TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_filter TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_filter TO oiv_write;


-- objecten.contactpersoon_type definition

-- Drop table

-- DROP TABLE objecten.contactpersoon_type;

CREATE TABLE objecten.contactpersoon_type (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	CONSTRAINT contactpersoon_type_new_naam_key UNIQUE (naam),
	CONSTRAINT contactpersoon_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.contactpersoon_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.contactpersoon_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.contactpersoon_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.contactpersoon_type TO oiv_write;


-- objecten.dreiging_type definition

-- Drop table

-- DROP TABLE objecten.dreiging_type;

CREATE TABLE objecten.dreiging_type (
	id int2 NOT NULL,
	naam text NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	size_object int4 NULL,
	CONSTRAINT dreiging_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.dreiging_type IS 'Enumeratie van de verschillende soorten dreigingen';

-- Permissions

ALTER TABLE objecten.dreiging_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.dreiging_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.dreiging_type TO oiv_read;


-- objecten.gebiedsgerichte_aanpak_type definition

-- Drop table

-- DROP TABLE objecten.gebiedsgerichte_aanpak_type;

CREATE TABLE objecten.gebiedsgerichte_aanpak_type (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	CONSTRAINT gebiedsgerichte_aanpak_type_pkey PRIMARY KEY (id),
	CONSTRAINT naam_uk UNIQUE (naam)
);

-- Permissions

ALTER TABLE objecten.gebiedsgerichte_aanpak_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gebiedsgerichte_aanpak_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.gebiedsgerichte_aanpak_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gebiedsgerichte_aanpak_type TO oiv_write;


-- objecten.gebruiksfunctie_type definition

-- Drop table

-- DROP TABLE objecten.gebruiksfunctie_type;

CREATE TABLE objecten.gebruiksfunctie_type (
	id int2 NOT NULL,
	naam text NULL,
	omschrijving text NULL,
	CONSTRAINT gebruiksfunctie_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.gebruiksfunctie_type IS 'Opzoeklijst voor gebruiksfunctie van repressief object';

-- Permissions

ALTER TABLE objecten.gebruiksfunctie_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gebruiksfunctie_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.gebruiksfunctie_type TO oiv_read;


-- objecten.gevaarlijkestof_eenheid definition

-- Drop table

-- DROP TABLE objecten.gevaarlijkestof_eenheid;

CREATE TABLE objecten.gevaarlijkestof_eenheid (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	CONSTRAINT gevaarlijke_stof_eenheid_new_naam_key UNIQUE (naam),
	CONSTRAINT gevaarlijke_stof_eenheid_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.gevaarlijkestof_eenheid OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gevaarlijkestof_eenheid TO oiv_admin;
GRANT SELECT ON TABLE objecten.gevaarlijkestof_eenheid TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gevaarlijkestof_eenheid TO oiv_write;


-- objecten.gevaarlijkestof_opslag_type definition

-- Drop table

-- DROP TABLE objecten.gevaarlijkestof_opslag_type;

CREATE TABLE objecten.gevaarlijkestof_opslag_type (
	id int4 NOT NULL,
	naam text NOT NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	size_object int4 NULL,
	CONSTRAINT gevaarlijkestof_opslag_type_naam_key UNIQUE (naam),
	CONSTRAINT gevaarlijkestof_opslag_type_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.gevaarlijkestof_opslag_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gevaarlijkestof_opslag_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.gevaarlijkestof_opslag_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gevaarlijkestof_opslag_type TO oiv_write;


-- objecten.gevaarlijkestof_schade_cirkel_type definition

-- Drop table

-- DROP TABLE objecten.gevaarlijkestof_schade_cirkel_type;

CREATE TABLE objecten.gevaarlijkestof_schade_cirkel_type (
	id int2 NOT NULL,
	naam varchar(100) NULL,
	CONSTRAINT gevaarlijkestof_schade_cirkel_type_new_naam_key UNIQUE (naam),
	CONSTRAINT gevaarlijkestof_schade_cirkel_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.gevaarlijkestof_schade_cirkel_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gevaarlijkestof_schade_cirkel_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.gevaarlijkestof_schade_cirkel_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gevaarlijkestof_schade_cirkel_type TO oiv_write;


-- objecten.gevaarlijkestof_toestand definition

-- Drop table

-- DROP TABLE objecten.gevaarlijkestof_toestand;

CREATE TABLE objecten.gevaarlijkestof_toestand (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	CONSTRAINT gevaarlijke_stof_toestand_new_naam_key UNIQUE (naam),
	CONSTRAINT gevaarlijke_stof_toestand_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.gevaarlijkestof_toestand OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gevaarlijkestof_toestand TO oiv_admin;
GRANT SELECT ON TABLE objecten.gevaarlijkestof_toestand TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gevaarlijkestof_toestand TO oiv_write;


-- objecten.gevaarlijkestof_vnnr definition

-- Drop table

-- DROP TABLE objecten.gevaarlijkestof_vnnr;

CREATE TABLE objecten.gevaarlijkestof_vnnr (
	id serial4 NOT NULL,
	vn_nr varchar(15) NOT NULL,
	gevi_nr varchar(10) NOT NULL,
	eric_kaart varchar(10) NOT NULL,
	CONSTRAINT gevaarlijkestof_vnnr_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.gevaarlijkestof_vnnr IS 'Opzoeklijst voor gevaarlijke stof vn_nr, gevi_nr en eric_kaart';

-- Permissions

ALTER TABLE objecten.gevaarlijkestof_vnnr OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gevaarlijkestof_vnnr TO oiv_admin;
GRANT SELECT ON TABLE objecten.gevaarlijkestof_vnnr TO oiv_read;


-- objecten.gt_pk_metadata_table definition

-- Drop table

-- DROP TABLE objecten.gt_pk_metadata_table;

CREATE TABLE objecten.gt_pk_metadata_table (
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

ALTER TABLE objecten.gt_pk_metadata_table OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gt_pk_metadata_table TO oiv_admin;
GRANT SELECT ON TABLE objecten.gt_pk_metadata_table TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gt_pk_metadata_table TO oiv_write;


-- objecten.historie_aanpassing_type definition

-- Drop table

-- DROP TABLE objecten.historie_aanpassing_type;

CREATE TABLE objecten.historie_aanpassing_type (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	CONSTRAINT historie_aanpassing_type_new_naam_key UNIQUE (naam),
	CONSTRAINT historie_aanpassing_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.historie_aanpassing_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.historie_aanpassing_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.historie_aanpassing_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.historie_aanpassing_type TO oiv_write;


-- objecten.historie_matrix_code definition

-- Drop table

-- DROP TABLE objecten.historie_matrix_code;

CREATE TABLE objecten.historie_matrix_code (
	id int2 NOT NULL,
	matrix_code varchar(4) NOT NULL,
	omschrijving text NOT NULL,
	actualisatie varchar(1) NOT NULL,
	prio_prod int4 NOT NULL,
	CONSTRAINT historie_matrix_code_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.historie_matrix_code IS 'Opzoeklijst voor matrix code';

-- Permissions

ALTER TABLE objecten.historie_matrix_code OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.historie_matrix_code TO oiv_admin;
GRANT SELECT ON TABLE objecten.historie_matrix_code TO oiv_read;


-- objecten.historie_status_type definition

-- Drop table

-- DROP TABLE objecten.historie_status_type;

CREATE TABLE objecten.historie_status_type (
	id int2 NOT NULL,
	naam varchar(50) NULL,
	CONSTRAINT historie_status_type_new_naam_key UNIQUE (naam),
	CONSTRAINT historie_status_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.historie_status_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.historie_status_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.historie_status_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.historie_status_type TO oiv_write;


-- objecten.ingang_type definition

-- Drop table

-- DROP TABLE objecten.ingang_type;

CREATE TABLE objecten.ingang_type (
	id int2 NOT NULL,
	naam text NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	size_object int4 NULL,
	CONSTRAINT ingang_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.ingang_type IS 'Enumeratie van de verschillende soorten ingangen';

-- Permissions

ALTER TABLE objecten.ingang_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.ingang_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.ingang_type TO oiv_read;


-- objecten.label_type definition

-- Drop table

-- DROP TABLE objecten.label_type;

CREATE TABLE objecten.label_type (
	id int2 NOT NULL,
	naam varchar(100) NULL,
	symbol_name text NULL,
	"size" numeric NULL,
	size_object numeric NULL,
	CONSTRAINT label_type_new_naam_key UNIQUE (naam),
	CONSTRAINT label_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.label_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.label_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.label_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.label_type TO oiv_write;


-- objecten.maatregel_type definition

-- Drop table

-- DROP TABLE objecten.maatregel_type;

CREATE TABLE objecten.maatregel_type (
	id int2 NOT NULL,
	naam text NULL,
	omschrijving text NULL,
	CONSTRAINT maatregel_type_pkey PRIMARY KEY (id),
	CONSTRAINT naam_unique UNIQUE (naam)
);

-- Permissions

ALTER TABLE objecten.maatregel_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.maatregel_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.maatregel_type TO oiv_read;


-- objecten.object_type definition

-- Drop table

-- DROP TABLE objecten.object_type;

CREATE TABLE objecten.object_type (
	id int2 NOT NULL,
	naam varchar(100) NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	CONSTRAINT object_type_new_naam_key UNIQUE (naam),
	CONSTRAINT object_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.object_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_type TO oiv_write;


-- objecten.opstelplaats_type definition

-- Drop table

-- DROP TABLE objecten.opstelplaats_type;

CREATE TABLE objecten.opstelplaats_type (
	id int2 NOT NULL,
	naam varchar(100) NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	CONSTRAINT opstelplaats_type_new_naam_key UNIQUE (naam),
	CONSTRAINT opstelplaats_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.opstelplaats_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.opstelplaats_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.opstelplaats_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.opstelplaats_type TO oiv_write;


-- objecten.pictogram_zonder_object_type definition

-- Drop table

-- DROP TABLE objecten.pictogram_zonder_object_type;

CREATE TABLE objecten.pictogram_zonder_object_type (
	id int2 NOT NULL,
	naam text NULL,
	categorie text NULL,
	CONSTRAINT pictogram_zonder_object_type_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.pictogram_zonder_object_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.pictogram_zonder_object_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.pictogram_zonder_object_type TO oiv_read;


-- objecten.points_of_interest_type definition

-- Drop table

-- DROP TABLE objecten.points_of_interest_type;

CREATE TABLE objecten.points_of_interest_type (
	id int2 NOT NULL,
	naam text NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	CONSTRAINT points_of_interest_type_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.points_of_interest_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.points_of_interest_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.points_of_interest_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.points_of_interest_type TO oiv_write;


-- objecten.ruimten_type definition

-- Drop table

-- DROP TABLE objecten.ruimten_type;

CREATE TABLE objecten.ruimten_type (
	naam text NOT NULL,
	id serial4 NOT NULL,
	CONSTRAINT ruimten_type_pkey PRIMARY KEY (id),
	CONSTRAINT uc_naam UNIQUE (naam)
);
COMMENT ON TABLE objecten.ruimten_type IS 'Enumeratie van de verschillende soorten ruimtes in een pand.';

-- Permissions

ALTER TABLE objecten.ruimten_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.ruimten_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.ruimten_type TO oiv_read;


-- objecten.scenario_locatie_type definition

-- Drop table

-- DROP TABLE objecten.scenario_locatie_type;

CREATE TABLE objecten.scenario_locatie_type (
	id int4 NOT NULL,
	naam text NOT NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	size_object int4 NULL,
	CONSTRAINT scenario_locatie_type_naam_key UNIQUE (naam),
	CONSTRAINT scenario_locatie_type_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.scenario_locatie_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.scenario_locatie_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.scenario_locatie_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.scenario_locatie_type TO oiv_write;


-- objecten.scenario_type definition

-- Drop table

-- DROP TABLE objecten.scenario_type;

CREATE TABLE objecten.scenario_type (
	id int2 NOT NULL,
	naam text NULL,
	omschrijving text NULL,
	file_name text NULL,
	CONSTRAINT scenario_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.scenario_type IS 'Enumeratie van de verschillende scenarios';

-- Permissions

ALTER TABLE objecten.scenario_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.scenario_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.scenario_type TO oiv_read;


-- objecten.sectoren_type definition

-- Drop table

-- DROP TABLE objecten.sectoren_type;

CREATE TABLE objecten.sectoren_type (
	id int2 NOT NULL,
	naam varchar(100) NULL,
	CONSTRAINT sectoren_type_new_naam_key UNIQUE (naam),
	CONSTRAINT sectoren_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.sectoren_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.sectoren_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.sectoren_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.sectoren_type TO oiv_write;


-- objecten.sleuteldoel_type definition

-- Drop table

-- DROP TABLE objecten.sleuteldoel_type;

CREATE TABLE objecten.sleuteldoel_type (
	id int2 NOT NULL,
	naam text NULL,
	CONSTRAINT sleuteldoel_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.sleuteldoel_type IS 'Enumeratie van de verschillende doelen van de sleutel in de sleutelkluis';

-- Permissions

ALTER TABLE objecten.sleuteldoel_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.sleuteldoel_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.sleuteldoel_type TO oiv_read;


-- objecten.sleutelkluis_type definition

-- Drop table

-- DROP TABLE objecten.sleutelkluis_type;

CREATE TABLE objecten.sleutelkluis_type (
	id int2 NOT NULL,
	naam text NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	size_object int4 NULL,
	CONSTRAINT sleutelkluis_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.sleutelkluis_type IS 'Enumeratie van de verschillende soorten sleutelkluis';

-- Permissions

ALTER TABLE objecten.sleutelkluis_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.sleutelkluis_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.sleutelkluis_type TO oiv_read;


-- objecten.veiligh_bouwk_type definition

-- Drop table

-- DROP TABLE objecten.veiligh_bouwk_type;

CREATE TABLE objecten.veiligh_bouwk_type (
	id int2 NOT NULL,
	naam varchar(100) NULL,
	CONSTRAINT veiligh_bouwk_type_new_naam_key UNIQUE (naam),
	CONSTRAINT veiligh_bouwk_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.veiligh_bouwk_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.veiligh_bouwk_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.veiligh_bouwk_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.veiligh_bouwk_type TO oiv_write;


-- objecten.veiligh_install_type definition

-- Drop table

-- DROP TABLE objecten.veiligh_install_type;

CREATE TABLE objecten.veiligh_install_type (
	id int2 NOT NULL,
	naam text NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	CONSTRAINT veiligh_install_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.veiligh_install_type IS 'Enumeratie van de verschillende installatietechnische veiligheidsvoorzieningen';

-- Permissions

ALTER TABLE objecten.veiligh_install_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.veiligh_install_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.veiligh_install_type TO oiv_read;


-- objecten.veiligh_ruimtelijk_type definition

-- Drop table

-- DROP TABLE objecten.veiligh_ruimtelijk_type;

CREATE TABLE objecten.veiligh_ruimtelijk_type (
	id int2 NOT NULL,
	naam text NULL,
	categorie text NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	CONSTRAINT veiligh_ruimtelijk_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.veiligh_ruimtelijk_type IS 'Enumeratie van de verschillende ruimtelijke veiligheidsvoorzieningen';

-- Permissions

ALTER TABLE objecten.veiligh_ruimtelijk_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.veiligh_ruimtelijk_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.veiligh_ruimtelijk_type TO oiv_read;


-- objecten.veilighv_org_type definition

-- Drop table

-- DROP TABLE objecten.veilighv_org_type;

CREATE TABLE objecten.veilighv_org_type (
	id int2 NOT NULL,
	naam varchar(100) NULL,
	CONSTRAINT veilighv_org_type_new_naam_key UNIQUE (naam),
	CONSTRAINT veilighv_org_type_new_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE objecten.veilighv_org_type OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.veilighv_org_type TO oiv_admin;
GRANT SELECT ON TABLE objecten.veilighv_org_type TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.veilighv_org_type TO oiv_write;


-- objecten.pictogram_zonder_object definition

-- Drop table

-- DROP TABLE objecten.pictogram_zonder_object;

CREATE TABLE objecten.pictogram_zonder_object (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	voorziening_pictogram_id int2 NOT NULL,
	rotatie int4 NULL,
	"label" text NULL,
	pand_id varchar(16) NOT NULL,
	CONSTRAINT pictogram_zonder_object_pkey PRIMARY KEY (id),
	CONSTRAINT voorziening_zonder_id_fk FOREIGN KEY (voorziening_pictogram_id) REFERENCES objecten.pictogram_zonder_object_type(id)
);
CREATE INDEX voorziening__zonder_geom_gist ON objecten.pictogram_zonder_object USING btree (geom);
CREATE INDEX voorziening_zonder_geom_gist ON objecten.pictogram_zonder_object USING btree (geom);
COMMENT ON TABLE objecten.pictogram_zonder_object IS 'Voorzieningen zonder object';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.pictogram_zonder_object FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.pictogram_zonder_object FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');

-- Permissions

ALTER TABLE objecten.pictogram_zonder_object OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.pictogram_zonder_object TO oiv_admin;
GRANT SELECT ON TABLE objecten.pictogram_zonder_object TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.pictogram_zonder_object TO oiv_write;


-- objecten.aanwezig definition

-- Drop table

-- DROP TABLE objecten.aanwezig;

CREATE TABLE objecten.aanwezig (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	aanwezig_type_id int2 NOT NULL,
	dagen text NULL,
	tijdvakbegin time NULL,
	tijdvakeind time NULL,
	aantal_totaal int2 NULL, -- Aantal aanwezig
	aantal_nietzelf_bewoners int2 NULL, -- Aantal niet aanwezig
	bouwlaag_id int4 NOT NULL,
	aantal_personeel int2 NULL,
	dieren bool NULL,
	bijzonderheid text NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT aanwezig_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.aanwezig IS 'Aanwezige personen';

-- Column comments

COMMENT ON COLUMN objecten.aanwezig.aantal_totaal IS 'Aantal aanwezig';
COMMENT ON COLUMN objecten.aanwezig.aantal_nietzelf_bewoners IS 'Aantal niet aanwezig';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.aanwezig FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.aanwezig FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.aanwezig FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.aanwezig OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.aanwezig TO oiv_admin;
GRANT SELECT ON TABLE objecten.aanwezig TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.aanwezig TO oiv_write;


-- objecten.afw_binnendekking definition

-- Drop table

-- DROP TABLE objecten.afw_binnendekking;

CREATE TABLE objecten.afw_binnendekking (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	rotatie int4 NULL DEFAULT 0,
	"label" varchar(50) NULL,
	handelingsaanwijzing varchar(254) NULL,
	bouwlaag_id int4 NULL,
	object_id int4 NULL,
	soort varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT afw_binnendekking_fk_check CHECK (((bouwlaag_id IS NOT NULL) OR (object_id IS NOT NULL))),
	CONSTRAINT afw_binnendekking_pkey PRIMARY KEY (id)
);
CREATE INDEX afw_binnendekking_geom_gist ON objecten.afw_binnendekking USING gist (geom);
COMMENT ON TABLE objecten.afw_binnendekking IS 'Afwijkende binnendekking';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.afw_binnendekking OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.afw_binnendekking TO oiv_admin;
GRANT SELECT ON TABLE objecten.afw_binnendekking TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.afw_binnendekking TO oiv_write;


-- objecten.bedrijfshulpverlening definition

-- Drop table

-- DROP TABLE objecten.bedrijfshulpverlening;

CREATE TABLE objecten.bedrijfshulpverlening (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	dagen text NULL,
	tijdvakbegin timestamp NULL,
	tijdvakeind timestamp NULL,
	telefoonnummer varchar(11) NULL,
	ademluchtdragend bool NULL,
	object_id int4 NOT NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT bedrijfshulpverlening_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.bedrijfshulpverlening IS 'scenarios';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.bedrijfshulpverlening FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.bedrijfshulpverlening FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.bedrijfshulpverlening FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_deleted');

-- Permissions

ALTER TABLE objecten.bedrijfshulpverlening OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bedrijfshulpverlening TO oiv_admin;
GRANT SELECT ON TABLE objecten.bedrijfshulpverlening TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bedrijfshulpverlening TO oiv_write;


-- objecten.beheersmaatregelen definition

-- Drop table

-- DROP TABLE objecten.beheersmaatregelen;

CREATE TABLE objecten.beheersmaatregelen (
	id serial4 NOT NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	maatregel_type_id int2 NULL,
	dreiging_id int4 NULL,
	inzetfase varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT beheersmaatregelen_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.beheersmaatregelen IS 'Beheersmaatregelen t.b.v. dreiging';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.beheersmaatregelen FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.beheersmaatregelen FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.beheersmaatregelen FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.beheersmaatregelen OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.beheersmaatregelen TO oiv_admin;
GRANT SELECT ON TABLE objecten.beheersmaatregelen TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.beheersmaatregelen TO oiv_write;


-- objecten.bereikbaarheid definition

-- Drop table

-- DROP TABLE objecten.bereikbaarheid;

CREATE TABLE objecten.bereikbaarheid (
	id serial4 NOT NULL,
	geom geometry(multilinestring, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	obstakels varchar(50) NULL,
	wegafzetting varchar(50) NULL,
	object_id int4 NOT NULL,
	fotografie_id int4 NULL,
	"label" varchar(254) NULL,
	soort varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT bereikbaarheid_pkey PRIMARY KEY (id)
);
CREATE INDEX bereikbaarheid_geom_gist ON objecten.bereikbaarheid USING gist (geom);
COMMENT ON TABLE objecten.bereikbaarheid IS 'Bereikbaarheids bijzonderheden per repressief object';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.bereikbaarheid OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bereikbaarheid TO oiv_admin;
GRANT SELECT ON TABLE objecten.bereikbaarheid TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bereikbaarheid TO oiv_write;


-- objecten.bouwlagen definition

-- Drop table

-- DROP TABLE objecten.bouwlagen;

CREATE TABLE objecten.bouwlagen (
	id serial4 NOT NULL,
	geom geometry(multipolygon, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	bouwlaag int4 NOT NULL,
	bouwdeel varchar(25) NULL,
	pand_id varchar(40) NOT NULL,
	datum_deleted timestamptz NULL,
	fotografie_id int4 NULL,
	CONSTRAINT bouwlagen_pkey PRIMARY KEY (id)
);
CREATE INDEX bouwlagen_bouwlaag_idx ON objecten.bouwlagen USING btree (bouwlaag);
CREATE INDEX bouwlagen_geom_gist ON objecten.bouwlagen USING gist (geom);
CREATE INDEX bouwlagen_pand_id_idx ON objecten.bouwlagen USING btree (pand_id);
COMMENT ON TABLE objecten.bouwlagen IS 'Grid voor verdeling en verduidelijking locatie op terrein';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.bouwlagen FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.bouwlagen FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.bouwlagen FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.bouwlagen OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlagen TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlagen TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlagen TO oiv_write;


-- objecten.contactpersoon definition

-- Drop table

-- DROP TABLE objecten.contactpersoon;

CREATE TABLE objecten.contactpersoon (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	dagen text NULL,
	tijdvakbegin timestamp NULL,
	tijdvakeind timestamp NULL,
	telefoonnummer varchar(100) NULL,
	object_id int4 NOT NULL,
	soort varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT contactpersoon_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.contactpersoon IS 'Contactpersonen';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.contactpersoon FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.contactpersoon FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.contactpersoon FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.contactpersoon OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.contactpersoon TO oiv_admin;
GRANT SELECT ON TABLE objecten.contactpersoon TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.contactpersoon TO oiv_write;


-- objecten.dreiging definition

-- Drop table

-- DROP TABLE objecten.dreiging;

CREATE TABLE objecten.dreiging (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	dreiging_type_id int4 NULL,
	rotatie int4 NULL DEFAULT 0,
	"label" varchar(50) NULL,
	bouwlaag_id int4 NULL,
	object_id int4 NULL,
	fotografie_id int4 NULL,
	omschrijving text NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT dreiging_fk_check CHECK (((bouwlaag_id IS NOT NULL) OR (object_id IS NOT NULL))),
	CONSTRAINT dreiging_pkey PRIMARY KEY (id)
);
CREATE INDEX dreiging_geom_gist ON objecten.dreiging USING gist (geom);
COMMENT ON TABLE objecten.dreiging IS 'Dreiging van een gevaar';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.dreiging FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.dreiging FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.dreiging FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.dreiging OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.dreiging TO oiv_admin;
GRANT SELECT ON TABLE objecten.dreiging TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.dreiging TO oiv_write;


-- objecten.gebiedsgerichte_aanpak definition

-- Drop table

-- DROP TABLE objecten.gebiedsgerichte_aanpak;

CREATE TABLE objecten.gebiedsgerichte_aanpak (
	id serial4 NOT NULL,
	geom geometry(multilinestring, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	soort varchar(50) NULL,
	"label" varchar(254) NULL,
	bijzonderheden text NULL,
	object_id int4 NOT NULL,
	fotografie_id int4 NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT gebiedsgerichte_aanpak_pkey PRIMARY KEY (id)
);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.gebiedsgerichte_aanpak OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gebiedsgerichte_aanpak TO oiv_admin;
GRANT SELECT ON TABLE objecten.gebiedsgerichte_aanpak TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gebiedsgerichte_aanpak TO oiv_write;


-- objecten.gebruiksfunctie definition

-- Drop table

-- DROP TABLE objecten.gebruiksfunctie;

CREATE TABLE objecten.gebruiksfunctie (
	id serial4 NOT NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	gebruiksfunctie_type_id int2 NULL,
	object_id int4 NOT NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT gebruiksfunctie_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.gebruiksfunctie IS 'Opzoeklijst voor maatregelen t.b.v. dreiging';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.gebruiksfunctie FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.gebruiksfunctie FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.gebruiksfunctie FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.gebruiksfunctie OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gebruiksfunctie TO oiv_admin;
GRANT SELECT ON TABLE objecten.gebruiksfunctie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gebruiksfunctie TO oiv_write;


-- objecten.gevaarlijkestof definition

-- Drop table

-- DROP TABLE objecten.gevaarlijkestof;

CREATE TABLE objecten.gevaarlijkestof (
	id serial4 NOT NULL,
	opslag_id int4 NOT NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	omschrijving text NULL,
	gevaarlijkestof_vnnr_id int4 NOT NULL, -- Stofidentificatienummer
	locatie text NULL,
	hoeveelheid int4 NOT NULL,
	handelingsaanwijzing text NULL,
	eenheid varchar(50) NULL,
	toestand varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT gevaarlijkestof_pkey PRIMARY KEY (id)
);

-- Column comments

COMMENT ON COLUMN objecten.gevaarlijkestof.gevaarlijkestof_vnnr_id IS 'Stofidentificatienummer';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.gevaarlijkestof FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.gevaarlijkestof FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.gevaarlijkestof FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.gevaarlijkestof OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gevaarlijkestof TO oiv_admin;
GRANT SELECT ON TABLE objecten.gevaarlijkestof TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gevaarlijkestof TO oiv_write;


-- objecten.gevaarlijkestof_opslag definition

-- Drop table

-- DROP TABLE objecten.gevaarlijkestof_opslag;

CREATE TABLE objecten.gevaarlijkestof_opslag (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	locatie text NOT NULL,
	bouwlaag_id int4 NULL,
	object_id int4 NULL,
	fotografie_id int4 NULL,
	rotatie int4 NULL DEFAULT 0,
	datum_deleted timestamptz NULL,
	CONSTRAINT gevaarlijkestof_opslag_pkey PRIMARY KEY (id),
	CONSTRAINT opslag_fk_check CHECK (((bouwlaag_id IS NOT NULL) OR (object_id IS NOT NULL)))
);
CREATE INDEX opslag_geom_gist ON objecten.gevaarlijkestof_opslag USING btree (geom);
COMMENT ON TABLE objecten.gevaarlijkestof_opslag IS 'Lokaties waar scenarios kunnen plaatsvinden';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.gevaarlijkestof_opslag FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.gevaarlijkestof_opslag FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.gevaarlijkestof_opslag FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.gevaarlijkestof_opslag OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gevaarlijkestof_opslag TO oiv_admin;
GRANT SELECT ON TABLE objecten.gevaarlijkestof_opslag TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gevaarlijkestof_opslag TO oiv_write;


-- objecten.gevaarlijkestof_schade_cirkel definition

-- Drop table

-- DROP TABLE objecten.gevaarlijkestof_schade_cirkel;

CREATE TABLE objecten.gevaarlijkestof_schade_cirkel (
	id serial4 NOT NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	straal int4 NOT NULL,
	gevaarlijkestof_id int4 NOT NULL,
	soort varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT gevaarlijkestof_schade_cirkel_pkey PRIMARY KEY (id)
);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.gevaarlijkestof_schade_cirkel FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.gevaarlijkestof_schade_cirkel FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.gevaarlijkestof_schade_cirkel FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.gevaarlijkestof_schade_cirkel OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.gevaarlijkestof_schade_cirkel TO oiv_admin;
GRANT SELECT ON TABLE objecten.gevaarlijkestof_schade_cirkel TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.gevaarlijkestof_schade_cirkel TO oiv_write;


-- objecten.grid definition

-- Drop table

-- DROP TABLE objecten.grid;

CREATE TABLE objecten.grid (
	id serial4 NOT NULL,
	geom geometry(multipolygon, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	y_as_label text NULL,
	x_as_label text NULL,
	afstand int4 NULL,
	object_id int4 NULL,
	vaknummer varchar(10) NULL,
	"scale" int4 NULL,
	papersize varchar(2) NULL,
	orientation varchar(10) NULL,
	"type" varchar(10) NOT NULL,
	uuid text NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT grid_pkey PRIMARY KEY (id)
);
CREATE INDEX grid_geom_gist ON objecten.grid USING gist (geom);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.grid FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.grid FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.grid FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.grid OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.grid TO oiv_admin;
GRANT SELECT ON TABLE objecten.grid TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.grid TO oiv_write;


-- objecten.historie definition

-- Drop table

-- DROP TABLE objecten.historie;

CREATE TABLE objecten.historie (
	id serial4 NOT NULL,
	object_id int4 NOT NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	teamlid_behandeld_id int4 NULL,
	teamlid_afgehandeld_id int4 NULL,
	matrix_code_id int2 NOT NULL,
	aanpassing varchar(50) NULL,
	status varchar(50) NULL,
	typeobject varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT historie_pkey PRIMARY KEY (id)
);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.historie FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.historie FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.historie FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.historie OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.historie TO oiv_admin;
GRANT SELECT ON TABLE objecten.historie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.historie TO oiv_write;


-- objecten.ingang definition

-- Drop table

-- DROP TABLE objecten.ingang;

CREATE TABLE objecten.ingang (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	ingang_type_id int4 NULL,
	rotatie int4 NULL DEFAULT 0,
	"label" varchar(50) NULL,
	belemmering varchar(254) NULL,
	voorzieningen varchar(254) NULL,
	bouwlaag_id int4 NULL,
	object_id int4 NULL,
	fotografie_id int4 NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT ingang_fk_check CHECK (((bouwlaag_id IS NOT NULL) OR (object_id IS NOT NULL))),
	CONSTRAINT ingang_pkey PRIMARY KEY (id)
);
CREATE INDEX ingang_geom_gist ON objecten.ingang USING gist (geom);
COMMENT ON TABLE objecten.ingang IS 'Ingang t.b.v. een pand en dus een bouwlaag';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.ingang FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.ingang FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.ingang FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.ingang OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.ingang TO oiv_admin;
GRANT SELECT ON TABLE objecten.ingang TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.ingang TO oiv_write;


-- objecten.isolijnen definition

-- Drop table

-- DROP TABLE objecten.isolijnen;

CREATE TABLE objecten.isolijnen (
	id serial4 NOT NULL,
	geom geometry(multilinestring, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	hoogte int2 NULL,
	omschrijving text NULL,
	object_id int4 NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT isolijnen_pkey PRIMARY KEY (id)
);
CREATE INDEX isolijnen_geom_gist ON objecten.isolijnen USING gist (geom);
COMMENT ON TABLE objecten.isolijnen IS 'Hoogte en dieptelijnen behorende bij repressief object';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.isolijnen OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.isolijnen TO oiv_admin;
GRANT SELECT ON TABLE objecten.isolijnen TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.isolijnen TO oiv_write;


-- objecten."label" definition

-- Drop table

-- DROP TABLE objecten."label";

CREATE TABLE objecten."label" (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	omschrijving varchar(254) NOT NULL,
	rotatie int4 NULL,
	bouwlaag_id int4 NULL,
	object_id int4 NULL,
	soort varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT label_fk_check CHECK (((bouwlaag_id IS NOT NULL) OR (object_id IS NOT NULL))),
	CONSTRAINT label_pkey PRIMARY KEY (id)
);
CREATE INDEX labels_geom_gist ON objecten.label USING btree (geom);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.label FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.label FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.label FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten."label" OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten."label" TO oiv_admin;
GRANT SELECT ON TABLE objecten."label" TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten."label" TO oiv_write;


-- objecten."object" definition

-- Drop table

-- DROP TABLE objecten."object";

CREATE TABLE objecten."object" (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	basisreg_identifier varchar(254) NOT NULL,
	formelenaam varchar(255) NOT NULL,
	bijzonderheden varchar NULL,
	pers_max int4 NULL,
	pers_nietz_max int4 NULL,
	datum_geldig_tot timestamp NULL,
	datum_geldig_vanaf timestamp NULL,
	bron varchar(3) NOT NULL,
	bron_tabel varchar(25) NOT NULL,
	fotografie_id int4 NULL,
	bodemgesteldheid_type_id int4 NULL,
	min_bouwlaag int4 NULL,
	max_bouwlaag int4 NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT object_pkey PRIMARY KEY (id)
);
CREATE INDEX object_geom_gist ON objecten.object USING btree (geom);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.object FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.object FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.object FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten."object" OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten."object" TO oiv_admin;
GRANT SELECT ON TABLE objecten."object" TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten."object" TO oiv_write;


-- objecten.opstelplaats definition

-- Drop table

-- DROP TABLE objecten.opstelplaats;

CREATE TABLE objecten.opstelplaats (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	rotatie int4 NULL DEFAULT 0,
	object_id int4 NOT NULL,
	fotografie_id int4 NULL,
	"label" varchar(50) NULL,
	soort varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT opstelplaats_pkey PRIMARY KEY (id)
);
CREATE INDEX opstelplaats_geom_gist ON objecten.opstelplaats USING gist (geom);
COMMENT ON TABLE objecten.opstelplaats IS 'Opstelplaatsen t.b.v. brandweervoertuigen';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.opstelplaats OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.opstelplaats TO oiv_admin;
GRANT SELECT ON TABLE objecten.opstelplaats TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.opstelplaats TO oiv_write;


-- objecten.points_of_interest definition

-- Drop table

-- DROP TABLE objecten.points_of_interest;

CREATE TABLE objecten.points_of_interest (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	points_of_interest_type_id int4 NULL,
	"label" text NULL,
	object_id int4 NULL,
	rotatie int4 NULL DEFAULT 0,
	fotografie_id int4 NULL,
	bijzonderheid text NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT points_of_interest_pkey PRIMARY KEY (id)
);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.points_of_interest OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.points_of_interest TO oiv_admin;
GRANT SELECT ON TABLE objecten.points_of_interest TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.points_of_interest TO oiv_write;


-- objecten.ruimten definition

-- Drop table

-- DROP TABLE objecten.ruimten;

CREATE TABLE objecten.ruimten (
	id serial4 NOT NULL,
	geom geometry(multipolygon, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	ruimten_type_id text NULL,
	omschrijving text NULL,
	bouwlaag_id int4 NOT NULL,
	fotografie_id int4 NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT ruimten_pkey PRIMARY KEY (id)
);
CREATE INDEX ruimten_geom_gist ON objecten.ruimten USING gist (geom);
COMMENT ON TABLE objecten.ruimten IS 'Ruimten binnen een bouwlaag.';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.ruimten FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.ruimten FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.ruimten FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.ruimten OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.ruimten TO oiv_admin;
GRANT SELECT ON TABLE objecten.ruimten TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.ruimten TO oiv_write;


-- objecten.scenario definition

-- Drop table

-- DROP TABLE objecten.scenario;

CREATE TABLE objecten.scenario (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	omschrijving text NULL,
	scenario_type_id int4 NULL,
	datum_deleted timestamptz NULL,
	scenario_locatie_id int4 NULL,
	file_name text NULL,
	CONSTRAINT scenario_pkey PRIMARY KEY (id)
);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.scenario FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.scenario FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.scenario FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.scenario OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.scenario TO oiv_admin;
GRANT SELECT ON TABLE objecten.scenario TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.scenario TO oiv_write;


-- objecten.scenario_locatie definition

-- Drop table

-- DROP TABLE objecten.scenario_locatie;

CREATE TABLE objecten.scenario_locatie (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	datum_deleted timestamptz NULL,
	locatie text NULL,
	bouwlaag_id int4 NULL,
	object_id int4 NULL,
	fotografie_id int4 NULL,
	rotatie int4 NULL DEFAULT 0,
	CONSTRAINT scenario_locatie_fk_check CHECK (((bouwlaag_id IS NOT NULL) OR (object_id IS NOT NULL))),
	CONSTRAINT scenario_locatie_pkey PRIMARY KEY (id)
);
CREATE INDEX scenario_locatie_gist ON objecten.scenario_locatie USING btree (geom);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.scenario_locatie OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.scenario_locatie TO oiv_admin;
GRANT SELECT ON TABLE objecten.scenario_locatie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.scenario_locatie TO oiv_write;


-- objecten.sectoren definition

-- Drop table

-- DROP TABLE objecten.sectoren;

CREATE TABLE objecten.sectoren (
	id serial4 NOT NULL,
	geom geometry(multipolygon, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	omschrijving varchar(254) NULL,
	"label" varchar(50) NULL,
	object_id int4 NOT NULL,
	fotografie_id int4 NULL,
	soort varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT sectoren_pkey PRIMARY KEY (id)
);
CREATE INDEX sectoren_geom_gist ON objecten.sectoren USING gist (geom);
COMMENT ON TABLE objecten.sectoren IS 'Bijzondere sectoren per repressief object';

-- Table Triggers

CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.sectoren FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.sectoren FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.sectoren FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.sectoren OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.sectoren TO oiv_admin;
GRANT SELECT ON TABLE objecten.sectoren TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.sectoren TO oiv_write;


-- objecten.sleutelkluis definition

-- Drop table

-- DROP TABLE objecten.sleutelkluis;

CREATE TABLE objecten.sleutelkluis (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	sleutelkluis_type_id int4 NULL,
	rotatie int4 NULL DEFAULT 0,
	"label" varchar(50) NULL,
	aanduiding_locatie varchar(254) NULL,
	sleuteldoel_type_id int4 NULL,
	ingang_id int4 NOT NULL,
	fotografie_id int4 NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT sleutelkluis_pkey PRIMARY KEY (id)
);
CREATE INDEX sleutelkluis_geom_gist ON objecten.sleutelkluis USING gist (geom);
COMMENT ON TABLE objecten.sleutelkluis IS 'Sleutelkluizen t.b.v. ingang een pand en dus een bouwlaag';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.sleutelkluis OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.sleutelkluis TO oiv_admin;
GRANT SELECT ON TABLE objecten.sleutelkluis TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.sleutelkluis TO oiv_write;


-- objecten.terrein definition

-- Drop table

-- DROP TABLE objecten.terrein;

CREATE TABLE objecten.terrein (
	id serial4 NOT NULL,
	geom geometry(multipolygon, 28992) NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	omschrijving text NULL,
	object_id int4 NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT terrein_pkey PRIMARY KEY (id)
);
CREATE INDEX terrein_geom_gist ON objecten.terrein USING gist (geom);

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.terrein FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.terrein FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.terrein FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.terrein OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.terrein TO oiv_admin;
GRANT SELECT ON TABLE objecten.terrein TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.terrein TO oiv_write;


-- objecten.veiligh_bouwk definition

-- Drop table

-- DROP TABLE objecten.veiligh_bouwk;

CREATE TABLE objecten.veiligh_bouwk (
	id serial4 NOT NULL,
	geom geometry(multilinestring, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	bouwlaag_id int4 NOT NULL,
	fotografie_id int4 NULL,
	soort varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT veiligh_bouwk_pkey PRIMARY KEY (id)
);
CREATE INDEX veiligh_bouwk_geom_gist ON objecten.veiligh_bouwk USING gist (geom);
COMMENT ON TABLE objecten.veiligh_bouwk IS 'Bouwkundige veiligheidsvoorzieningen';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.veiligh_bouwk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.veiligh_bouwk TO oiv_admin;
GRANT SELECT ON TABLE objecten.veiligh_bouwk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.veiligh_bouwk TO oiv_write;


-- objecten.veiligh_install definition

-- Drop table

-- DROP TABLE objecten.veiligh_install;

CREATE TABLE objecten.veiligh_install (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	veiligh_install_type_id int4 NULL,
	"label" text NULL,
	bouwlaag_id int4 NOT NULL,
	rotatie int4 NULL DEFAULT 0,
	fotografie_id int4 NULL,
	bijzonderheid text NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT veiligh_install_pkey PRIMARY KEY (id)
);
CREATE INDEX veiligh_install_geom_gist ON objecten.veiligh_install USING gist (geom);
COMMENT ON TABLE objecten.veiligh_install IS 'Installatietechnische veiligheidsvoorzieningen';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.veiligh_install OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.veiligh_install TO oiv_admin;
GRANT SELECT ON TABLE objecten.veiligh_install TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.veiligh_install TO oiv_write;


-- objecten.veiligh_ruimtelijk definition

-- Drop table

-- DROP TABLE objecten.veiligh_ruimtelijk;

CREATE TABLE objecten.veiligh_ruimtelijk (
	id serial4 NOT NULL,
	geom geometry(point, 28992) NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	veiligh_ruimtelijk_type_id int4 NULL,
	"label" text NULL,
	object_id int4 NOT NULL,
	rotatie int4 NULL DEFAULT 0,
	fotografie_id int4 NULL,
	bijzonderheid text NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT veiligh_ruimtelijk_pkey PRIMARY KEY (id)
);
CREATE INDEX veiligh_ruimtelijk_geom_gist ON objecten.veiligh_ruimtelijk USING gist (geom);
COMMENT ON TABLE objecten.veiligh_ruimtelijk IS 'Ruimtelijke veiligheidsvoorzieningen';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.veiligh_ruimtelijk FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.veiligh_ruimtelijk FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.veiligh_ruimtelijk FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.veiligh_ruimtelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.veiligh_ruimtelijk TO oiv_admin;
GRANT SELECT ON TABLE objecten.veiligh_ruimtelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.veiligh_ruimtelijk TO oiv_write;


-- objecten.veilighv_org definition

-- Drop table

-- DROP TABLE objecten.veilighv_org;

CREATE TABLE objecten.veilighv_org (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL DEFAULT now(),
	datum_gewijzigd timestamp NULL,
	omschrijving text NULL,
	object_id int4 NOT NULL,
	soort varchar(50) NULL,
	datum_deleted timestamptz NULL,
	CONSTRAINT veilighv_org_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE objecten.veilighv_org IS 'Organisatorische veiligheidsvoorzieningen';

-- Table Triggers

CREATE TRIGGER trg_set_mutatie BEFORE
UPDATE
    ON
    objecten.veilighv_org FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    objecten.veilighv_org FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE
DELETE
    ON
    objecten.veilighv_org FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

-- Permissions

ALTER TABLE objecten.veilighv_org OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.veilighv_org TO oiv_admin;
GRANT SELECT ON TABLE objecten.veilighv_org TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.veilighv_org TO oiv_write;


-- objecten.aanwezig foreign keys

ALTER TABLE objecten.aanwezig ADD CONSTRAINT aanwezig_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.aanwezig ADD CONSTRAINT aanwezig_groep_id_fk FOREIGN KEY (aanwezig_type_id) REFERENCES objecten.aanwezig_type(id);


-- objecten.afw_binnendekking foreign keys

ALTER TABLE objecten.afw_binnendekking ADD CONSTRAINT afw_binnendekking_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.afw_binnendekking ADD CONSTRAINT afw_binnendekking_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.afw_binnendekking ADD CONSTRAINT soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.afw_binnendekking_type(naam);


-- objecten.bedrijfshulpverlening foreign keys

ALTER TABLE objecten.bedrijfshulpverlening ADD CONSTRAINT bedrijfshulpverlening_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- objecten.beheersmaatregelen foreign keys

ALTER TABLE objecten.beheersmaatregelen ADD CONSTRAINT beheersmaatregel_dreiging_id_fik FOREIGN KEY (dreiging_id) REFERENCES objecten.dreiging(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.beheersmaatregelen ADD CONSTRAINT beheersmaatregelen_inzetfase_type_id_fk FOREIGN KEY (inzetfase) REFERENCES objecten.beheersmaatregelen_inzetfase(naam);
ALTER TABLE objecten.beheersmaatregelen ADD CONSTRAINT maatregel_type_id_fk FOREIGN KEY (maatregel_type_id) REFERENCES objecten.maatregel_type(id);


-- objecten.bereikbaarheid foreign keys

ALTER TABLE objecten.bereikbaarheid ADD CONSTRAINT bereikbaarheid_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.bereikbaarheid ADD CONSTRAINT bereikbaarheid_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.bereikbaarheid ADD CONSTRAINT soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.bereikbaarheid_type(naam);


-- objecten.bouwlagen foreign keys

ALTER TABLE objecten.bouwlagen ADD CONSTRAINT bouwlagen_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);


-- objecten.contactpersoon foreign keys

ALTER TABLE objecten.contactpersoon ADD CONSTRAINT contactpersoon_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.contactpersoon ADD CONSTRAINT contactpersoon_soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.contactpersoon_type(naam);


-- objecten.dreiging foreign keys

ALTER TABLE objecten.dreiging ADD CONSTRAINT dreiging_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.dreiging ADD CONSTRAINT dreiging_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.dreiging ADD CONSTRAINT dreiging_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.dreiging ADD CONSTRAINT dreiging_type_id_fk FOREIGN KEY (dreiging_type_id) REFERENCES objecten.dreiging_type(id);


-- objecten.gebiedsgerichte_aanpak foreign keys

ALTER TABLE objecten.gebiedsgerichte_aanpak ADD CONSTRAINT gebiedsgerichte_aanpak_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.gebiedsgerichte_aanpak ADD CONSTRAINT gebiedsgerichte_aanpak_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.gebiedsgerichte_aanpak ADD CONSTRAINT soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.gebiedsgerichte_aanpak_type(naam);


-- objecten.gebruiksfunctie foreign keys

ALTER TABLE objecten.gebruiksfunctie ADD CONSTRAINT gebruiksfunctie_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.gebruiksfunctie ADD CONSTRAINT gebruiksfunctie_type_id_fk FOREIGN KEY (gebruiksfunctie_type_id) REFERENCES objecten.gebruiksfunctie_type(id);


-- objecten.gevaarlijkestof foreign keys

ALTER TABLE objecten.gevaarlijkestof ADD CONSTRAINT gevaarlijkestof_eenheid_type_id_fk FOREIGN KEY (eenheid) REFERENCES objecten.gevaarlijkestof_eenheid(naam);
ALTER TABLE objecten.gevaarlijkestof ADD CONSTRAINT gevaarlijkestof_opslag_id_fk FOREIGN KEY (opslag_id) REFERENCES objecten.gevaarlijkestof_opslag(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.gevaarlijkestof ADD CONSTRAINT gevaarlijkestof_toestand_type_id_fk FOREIGN KEY (toestand) REFERENCES objecten.gevaarlijkestof_toestand(naam);
ALTER TABLE objecten.gevaarlijkestof ADD CONSTRAINT gevaarlijkestof_vnnr_id_fk FOREIGN KEY (gevaarlijkestof_vnnr_id) REFERENCES objecten.gevaarlijkestof_vnnr(id);


-- objecten.gevaarlijkestof_opslag foreign keys

ALTER TABLE objecten.gevaarlijkestof_opslag ADD CONSTRAINT gevaarlijkestof_opslag_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.gevaarlijkestof_opslag ADD CONSTRAINT opslag_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.gevaarlijkestof_opslag ADD CONSTRAINT opslag_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- objecten.gevaarlijkestof_schade_cirkel foreign keys

ALTER TABLE objecten.gevaarlijkestof_schade_cirkel ADD CONSTRAINT gevaarlijkestof_schade_cirkel_soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.gevaarlijkestof_schade_cirkel_type(naam);
ALTER TABLE objecten.gevaarlijkestof_schade_cirkel ADD CONSTRAINT schade_cirkel_gevaarlijkestof_id_fk FOREIGN KEY (gevaarlijkestof_id) REFERENCES objecten.gevaarlijkestof(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- objecten.grid foreign keys

ALTER TABLE objecten.grid ADD CONSTRAINT grid_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- objecten.historie foreign keys

ALTER TABLE objecten.historie ADD CONSTRAINT aanpassing_id_fk FOREIGN KEY (aanpassing) REFERENCES objecten.historie_aanpassing_type(naam);
ALTER TABLE objecten.historie ADD CONSTRAINT historie_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.historie ADD CONSTRAINT historie_teamlid_afgehandeld_id_fk FOREIGN KEY (teamlid_afgehandeld_id) REFERENCES algemeen.teamlid(id);
ALTER TABLE objecten.historie ADD CONSTRAINT historie_teamlid_behandeld_id_fk FOREIGN KEY (teamlid_behandeld_id) REFERENCES algemeen.teamlid(id);
ALTER TABLE objecten.historie ADD CONSTRAINT matrix_code_id_fk FOREIGN KEY (matrix_code_id) REFERENCES objecten.historie_matrix_code(id);
ALTER TABLE objecten.historie ADD CONSTRAINT status_id_fk FOREIGN KEY (status) REFERENCES objecten.historie_status_type(naam);
ALTER TABLE objecten.historie ADD CONSTRAINT typeobject_id_fk FOREIGN KEY (typeobject) REFERENCES objecten.object_type(naam);


-- objecten.ingang foreign keys

ALTER TABLE objecten.ingang ADD CONSTRAINT ingang_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.ingang ADD CONSTRAINT ingang_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.ingang ADD CONSTRAINT ingang_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.ingang ADD CONSTRAINT ingang_type_id_fk FOREIGN KEY (ingang_type_id) REFERENCES objecten.ingang_type(id);


-- objecten.isolijnen foreign keys

ALTER TABLE objecten.isolijnen ADD CONSTRAINT isolijnen_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- objecten."label" foreign keys

ALTER TABLE objecten."label" ADD CONSTRAINT label_soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.label_type(naam);
ALTER TABLE objecten."label" ADD CONSTRAINT labels_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten."label" ADD CONSTRAINT labels_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- objecten."object" foreign keys

ALTER TABLE objecten."object" ADD CONSTRAINT object_bodemgesteldheid_type_id_fk FOREIGN KEY (bodemgesteldheid_type_id) REFERENCES objecten.bodemgesteldheid_type(id);
ALTER TABLE objecten."object" ADD CONSTRAINT object_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);


-- objecten.opstelplaats foreign keys

ALTER TABLE objecten.opstelplaats ADD CONSTRAINT opstelplaats_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.opstelplaats ADD CONSTRAINT opstelplaats_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.opstelplaats ADD CONSTRAINT opstelplaats_soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.opstelplaats_type(naam);


-- objecten.points_of_interest foreign keys

ALTER TABLE objecten.points_of_interest ADD CONSTRAINT points_of_interest_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.points_of_interest ADD CONSTRAINT points_of_interest_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.points_of_interest ADD CONSTRAINT points_of_interest_type_id_fk FOREIGN KEY (points_of_interest_type_id) REFERENCES objecten.points_of_interest_type(id);


-- objecten.ruimten foreign keys

ALTER TABLE objecten.ruimten ADD CONSTRAINT ruimten_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.ruimten ADD CONSTRAINT ruimten_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.ruimten ADD CONSTRAINT ruimten_type_id_fk FOREIGN KEY (ruimten_type_id) REFERENCES objecten.ruimten_type(naam);


-- objecten.scenario foreign keys

ALTER TABLE objecten.scenario ADD CONSTRAINT scenario_locatie_id_fk FOREIGN KEY (scenario_locatie_id) REFERENCES objecten.scenario_locatie(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.scenario ADD CONSTRAINT scenario_type_id_fk FOREIGN KEY (scenario_type_id) REFERENCES objecten.scenario_type(id);


-- objecten.scenario_locatie foreign keys

ALTER TABLE objecten.scenario_locatie ADD CONSTRAINT scenario_locatie_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.scenario_locatie ADD CONSTRAINT scenario_locatie_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.scenario_locatie ADD CONSTRAINT scenario_locatie_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- objecten.sectoren foreign keys

ALTER TABLE objecten.sectoren ADD CONSTRAINT sectoren_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.sectoren ADD CONSTRAINT sectoren_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.sectoren ADD CONSTRAINT sectoren_soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.sectoren_type(naam);


-- objecten.sleutelkluis foreign keys

ALTER TABLE objecten.sleutelkluis ADD CONSTRAINT sleuteldoel_type_id_fk FOREIGN KEY (sleuteldoel_type_id) REFERENCES objecten.sleuteldoel_type(id);
ALTER TABLE objecten.sleutelkluis ADD CONSTRAINT sleutelkluis_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.sleutelkluis ADD CONSTRAINT sleutelkluis_ingang_id_fk FOREIGN KEY (ingang_id) REFERENCES objecten.ingang(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.sleutelkluis ADD CONSTRAINT sleutelkluis_type_id_fk FOREIGN KEY (sleutelkluis_type_id) REFERENCES objecten.sleutelkluis_type(id);


-- objecten.terrein foreign keys

ALTER TABLE objecten.terrein ADD CONSTRAINT terrein_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- objecten.veiligh_bouwk foreign keys

ALTER TABLE objecten.veiligh_bouwk ADD CONSTRAINT veiligh_bouwk_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.veiligh_bouwk ADD CONSTRAINT veiligh_bouwk_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.veiligh_bouwk ADD CONSTRAINT veiligh_bouwk_soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.veiligh_bouwk_type(naam);


-- objecten.veiligh_install foreign keys

ALTER TABLE objecten.veiligh_install ADD CONSTRAINT veiligh_install_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.veiligh_install ADD CONSTRAINT veiligh_install_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.veiligh_install ADD CONSTRAINT veiligh_install_type_id_fk FOREIGN KEY (veiligh_install_type_id) REFERENCES objecten.veiligh_install_type(id);


-- objecten.veiligh_ruimtelijk foreign keys

ALTER TABLE objecten.veiligh_ruimtelijk ADD CONSTRAINT veiligh_ruimtelijk_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie(id);
ALTER TABLE objecten.veiligh_ruimtelijk ADD CONSTRAINT veiligh_ruimtelijk_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.veiligh_ruimtelijk ADD CONSTRAINT veiligh_ruimtelijk_type_id_fk FOREIGN KEY (veiligh_ruimtelijk_type_id) REFERENCES objecten.veiligh_ruimtelijk_type(id);


-- objecten.veilighv_org foreign keys

ALTER TABLE objecten.veilighv_org ADD CONSTRAINT veilighv_org_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten."object"(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE objecten.veilighv_org ADD CONSTRAINT veilighv_org_soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.veilighv_org_type(naam);


-- objecten.bouwlaag_afw_binnendekking source

CREATE OR REPLACE VIEW objecten.bouwlaag_afw_binnendekking
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.handelingsaanwijzing,
    v.bouwlaag_id,
    b.bouwlaag,
    v.rotatie,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM objecten.afw_binnendekking v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.afw_binnendekking_type st ON v.soort::text = st.naam::text
  WHERE v.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_afw_binnendekking OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_afw_binnendekking TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_afw_binnendekking TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_afw_binnendekking TO oiv_write;


-- objecten.bouwlaag_bouwlagen source

CREATE OR REPLACE VIEW objecten.bouwlaag_bouwlagen
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.bouwlaag,
    b.bouwdeel,
    b.pand_id,
    b.datum_deleted,
    b.fotografie_id
   FROM objecten.bouwlagen b
  WHERE b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_bouwlagen OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_bouwlagen TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_bouwlagen TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_bouwlagen TO oiv_write;


-- objecten.bouwlaag_dreiging source

CREATE OR REPLACE VIEW objecten.bouwlaag_dreiging
AS SELECT v.id,
    v.geom,
    v.dreiging_type_id,
    v.label,
    v.fotografie_id,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM objecten.dreiging v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.dreiging_type st ON v.dreiging_type_id = st.id
  WHERE v.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_dreiging OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_dreiging TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_dreiging TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_dreiging TO oiv_write;


-- objecten.bouwlaag_ingang source

CREATE OR REPLACE VIEW objecten.bouwlaag_ingang
AS SELECT v.id,
    v.geom,
    v.ingang_type_id,
    v.label,
    v.belemmering,
    v.voorzieningen,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    it.symbol_name,
    it.size,
    ''::text AS applicatie
   FROM objecten.ingang v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.ingang_type it ON v.ingang_type_id = it.id
  WHERE v.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_ingang OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_ingang TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_ingang TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_ingang TO oiv_write;


-- objecten.bouwlaag_label source

CREATE OR REPLACE VIEW objecten.bouwlaag_label
AS SELECT l.id,
    l.geom,
    l.soort,
    l.omschrijving,
    l.bouwlaag_id,
    l.object_id,
    b.bouwlaag,
    l.rotatie,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM objecten.label l
     JOIN objecten.bouwlagen b ON l.bouwlaag_id = b.id
     JOIN objecten.label_type st ON l.soort::text = st.naam::text
  WHERE l.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_label OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_label TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_label TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_label TO oiv_write;


-- objecten.bouwlaag_opslag source

CREATE OR REPLACE VIEW objecten.bouwlaag_opslag
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
    b.bouwlaag,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM objecten.gevaarlijkestof_opslag o
     JOIN objecten.bouwlagen b ON o.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE o.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_opslag OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_opslag TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_opslag TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_opslag TO oiv_write;


-- objecten.bouwlaag_ruimten source

CREATE OR REPLACE VIEW objecten.bouwlaag_ruimten
AS SELECT v.id,
    v.geom,
    v.ruimten_type_id,
    v.omschrijving,
    v.fotografie_id,
    v.bouwlaag_id,
    b.bouwlaag,
    ''::text AS applicatie
   FROM objecten.ruimten v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
  WHERE v.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_ruimten OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_ruimten TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_ruimten TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_ruimten TO oiv_write;


-- objecten.bouwlaag_scenario_locatie source

CREATE OR REPLACE VIEW objecten.bouwlaag_scenario_locatie
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
    b.bouwlaag,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM objecten.scenario_locatie o
     JOIN objecten.bouwlagen b ON o.bouwlaag_id = b.id
     JOIN objecten.scenario_locatie_type st ON 'Scenario locatie'::text = st.naam
  WHERE o.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_scenario_locatie OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_scenario_locatie TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_scenario_locatie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_scenario_locatie TO oiv_write;


-- objecten.bouwlaag_sleutelkluis source

CREATE OR REPLACE VIEW objecten.bouwlaag_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.sleutelkluis_type_id,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.fotografie_id,
    v.ingang_id,
    part.bouwlaag,
    v.rotatie,
    it.symbol_name,
    it.size,
    ''::text AS applicatie
   FROM objecten.sleutelkluis v
     JOIN ( SELECT b.bouwlaag,
            ib.id,
            ib.bouwlaag_id
           FROM objecten.ingang ib
             JOIN objecten.bouwlagen b ON ib.bouwlaag_id = b.id) part ON v.ingang_id = part.id
     JOIN objecten.sleutelkluis_type it ON v.sleutelkluis_type_id = it.id
  WHERE v.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_sleutelkluis OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_sleutelkluis TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_sleutelkluis TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_sleutelkluis TO oiv_write;


-- objecten.bouwlaag_veiligh_bouwk source

CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_bouwk
AS SELECT v.id,
    v.geom,
    v.soort,
    v.fotografie_id,
    v.bouwlaag_id,
    b.bouwlaag,
    ''::text AS applicatie
   FROM objecten.veiligh_bouwk v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
  WHERE v.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_veiligh_bouwk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_veiligh_bouwk TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_veiligh_bouwk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_veiligh_bouwk TO oiv_write;


-- objecten.bouwlaag_veiligh_install source

CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_install
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.veiligh_install_type_id,
    v.label,
    v.bijzonderheid,
    v.bouwlaag_id,
    v.rotatie,
    v.fotografie_id,
    b.bouwlaag,
    vt.size,
    vt.symbol_name,
    ''::text AS applicatie
   FROM objecten.veiligh_install v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type vt ON v.veiligh_install_type_id = vt.id
  WHERE v.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.bouwlaag_veiligh_install OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.bouwlaag_veiligh_install TO oiv_admin;
GRANT SELECT ON TABLE objecten.bouwlaag_veiligh_install TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.bouwlaag_veiligh_install TO oiv_write;


-- objecten.object_bereikbaarheid source

CREATE OR REPLACE VIEW objecten.object_bereikbaarheid
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.obstakels,
    l.wegafzetting,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    part.typeobject
   FROM objecten.bereikbaarheid l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_bereikbaarheid OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_bereikbaarheid TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_bereikbaarheid TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_bereikbaarheid TO oiv_write;


-- objecten.object_bgt source

CREATE OR REPLACE VIEW objecten.object_bgt
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.basisreg_identifier,
    b.formelenaam,
    b.bijzonderheden,
    b.pers_max,
    b.pers_nietz_max,
    b.datum_geldig_tot,
    b.datum_geldig_vanaf,
    b.bron,
    b.bron_tabel,
    b.fotografie_id,
    b.bodemgesteldheid_type_id,
    part.typeobject
   FROM objecten.object b
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE b.bron::text = 'BGT'::text AND b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_bgt OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_bgt TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_bgt TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_bgt TO oiv_write;


-- objecten.object_dreiging source

CREATE OR REPLACE VIEW objecten.object_dreiging
AS SELECT v.id,
    v.geom,
    v.dreiging_type_id,
    v.label,
    v.fotografie_id,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    st.symbol_name,
    st.size_object AS size,
    ''::text AS applicatie,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot
   FROM objecten.dreiging v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.dreiging_type st ON v.dreiging_type_id = st.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_dreiging OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_dreiging TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_dreiging TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_dreiging TO oiv_write;


-- objecten.object_gebiedsgerichte_aanpak source

CREATE OR REPLACE VIEW objecten.object_gebiedsgerichte_aanpak
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.bijzonderheden,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot
   FROM objecten.gebiedsgerichte_aanpak l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_gebiedsgerichte_aanpak OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_gebiedsgerichte_aanpak TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_gebiedsgerichte_aanpak TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_gebiedsgerichte_aanpak TO oiv_write;


-- objecten.object_grid source

CREATE OR REPLACE VIEW objecten.object_grid
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.y_as_label,
    b.x_as_label,
    b.object_id,
    b.afstand,
    b.vaknummer,
    b.scale,
    b.papersize,
    b.orientation,
    b.type,
    b.uuid,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM objecten.grid b
     JOIN objecten.object o ON b.object_id = o.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_grid OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_grid TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_grid TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_grid TO oiv_write;


-- objecten.object_ingang source

CREATE OR REPLACE VIEW objecten.object_ingang
AS SELECT v.id,
    v.geom,
    v.ingang_type_id,
    v.label,
    v.belemmering,
    v.voorzieningen,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    it.symbol_name,
    it.size_object AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.ingang v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.ingang_type it ON v.ingang_type_id = it.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_ingang OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_ingang TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_ingang TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_ingang TO oiv_write;


-- objecten.object_isolijnen source

CREATE OR REPLACE VIEW objecten.object_isolijnen
AS SELECT l.id,
    l.geom,
    l.hoogte,
    l.omschrijving,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.isolijnen l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_isolijnen OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_isolijnen TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_isolijnen TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_isolijnen TO oiv_write;


-- objecten.object_label source

CREATE OR REPLACE VIEW objecten.object_label
AS SELECT l.id,
    l.geom,
    l.soort,
    l.omschrijving,
    l.bouwlaag_id,
    l.object_id,
    b.formelenaam,
    l.rotatie,
    st.symbol_name,
    st.size_object AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.label l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN objecten.label_type st ON l.soort::text = st.naam::text
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_label OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_label TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_label TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_label TO oiv_write;


-- objecten.object_objecten source

CREATE OR REPLACE VIEW objecten.object_objecten
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.basisreg_identifier,
    b.formelenaam,
    b.bijzonderheden,
    b.pers_max,
    b.pers_nietz_max,
    b.datum_geldig_tot,
    b.datum_geldig_vanaf,
    b.bron,
    b.bron_tabel,
    b.fotografie_id,
    b.bodemgesteldheid_type_id,
    b.min_bouwlaag,
    b.max_bouwlaag,
    part.typeobject
   FROM objecten.object b
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_objecten OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_objecten TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_objecten TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_objecten TO oiv_write;


-- objecten.object_opslag source

CREATE OR REPLACE VIEW objecten.object_opslag
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    b.formelenaam,
    o.rotatie,
    st.size_object AS size,
    st.symbol_name,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.gevaarlijkestof_opslag o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_opslag OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_opslag TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_opslag TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_opslag TO oiv_write;


-- objecten.object_opstelplaats source

CREATE OR REPLACE VIEW objecten.object_opstelplaats
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    l.rotatie,
    st.symbol_name,
    st.size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.opstelplaats l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN objecten.opstelplaats_type st ON l.soort::text = st.naam::text
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_opstelplaats OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_opstelplaats TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_opstelplaats TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_opstelplaats TO oiv_write;


-- objecten.object_points_of_interest source

CREATE OR REPLACE VIEW objecten.object_points_of_interest
AS SELECT b.id,
    b.geom,
    b.points_of_interest_type_id,
    b.label,
    b.bijzonderheid,
    b.fotografie_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    vt.symbol_name,
    vt.size,
    ''::text AS applicatie,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM objecten.points_of_interest b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.points_of_interest_type vt ON b.points_of_interest_type_id = vt.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_points_of_interest OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_points_of_interest TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_points_of_interest TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_points_of_interest TO oiv_write;


-- objecten.object_scenario_locatie source

CREATE OR REPLACE VIEW objecten.object_scenario_locatie
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
    st.size_object AS size,
    st.symbol_name,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.scenario_locatie o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.scenario_locatie_type st ON 'Scenario locatie'::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_scenario_locatie OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_scenario_locatie TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_scenario_locatie TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_scenario_locatie TO oiv_write;


-- objecten.object_sectoren source

CREATE OR REPLACE VIEW objecten.object_sectoren
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.omschrijving,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.sectoren l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_sectoren OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_sectoren TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_sectoren TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_sectoren TO oiv_write;


-- objecten.object_sleutelkluis source

CREATE OR REPLACE VIEW objecten.object_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.sleutelkluis_type_id,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.fotografie_id,
    v.ingang_id,
    b.formelenaam,
    v.rotatie,
    it.symbol_name,
    it.size_object AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.sleutelkluis v
     JOIN objecten.ingang i ON v.ingang_id = i.id
     JOIN objecten.sleutelkluis_type it ON v.sleutelkluis_type_id = it.id
     JOIN objecten.object b ON i.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_sleutelkluis OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_sleutelkluis TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_sleutelkluis TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_sleutelkluis TO oiv_write;


-- objecten.object_terrein source

CREATE OR REPLACE VIEW objecten.object_terrein
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.object_id,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM objecten.terrein b
     JOIN objecten.object o ON b.object_id = o.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_terrein OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_terrein TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_terrein TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_terrein TO oiv_write;


-- objecten.object_veiligh_ruimtelijk source

CREATE OR REPLACE VIEW objecten.object_veiligh_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.veiligh_ruimtelijk_type_id,
    b.label,
    b.bijzonderheid,
    b.fotografie_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    vt.symbol_name,
    vt.size,
    ''::text AS applicatie,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM objecten.veiligh_ruimtelijk b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.object_veiligh_ruimtelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.object_veiligh_ruimtelijk TO oiv_admin;
GRANT SELECT ON TABLE objecten.object_veiligh_ruimtelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.object_veiligh_ruimtelijk TO oiv_write;


-- objecten.schade_cirkel_calc source

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
             LEFT JOIN objecten.gevaarlijkestof_opslag ops ON gb.opslag_id = ops.id) part ON sc.gevaarlijkestof_id = part.id;

-- Permissions

ALTER TABLE objecten.schade_cirkel_calc OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.schade_cirkel_calc TO oiv_admin;
GRANT SELECT ON TABLE objecten.schade_cirkel_calc TO oiv_read;


-- objecten.status_objectgegevens source

CREATE OR REPLACE VIEW objecten.status_objectgegevens
AS SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    historie.status
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT h.id
           FROM objecten.historie h
          WHERE h.object_id = object.id
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1))
  WHERE object.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.status_objectgegevens OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.status_objectgegevens TO oiv_admin;
GRANT SELECT ON TABLE objecten.status_objectgegevens TO oiv_read;


-- objecten.stavaza_objecten source

CREATE OR REPLACE VIEW objecten.stavaza_objecten
AS SELECT obj.team,
    obj.totaal,
    obj.totaal_in_gebruik,
    obj.totaal_in_concept,
    obj.totaal_in_archief,
    obj.totaal_geen_status,
    obj.totaal_prio_1,
    obj.totaal_prio_2,
    obj.totaal_prio_3,
    obj.totaal_prio_4,
    obj.totaal_zonder_prio,
    obj.prio_1_in_gebruik,
    obj.prio_2_in_gebruik,
    obj.prio_3_in_gebruik,
    obj.prio_4_in_gebruik,
    obj.prio_1_concept,
    obj.prio_2_concept,
    obj.prio_3_concept,
    obj.prio_4_concept,
    obj.team_geom
   FROM ( SELECT o.team,
            count(o.team) AS totaal,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text) AS totaal_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text) AS totaal_in_concept,
            count(o.status) FILTER (WHERE o.status::text = 'archief'::text) AS totaal_in_archief,
            sum(
                CASE
                    WHEN o.status IS NULL THEN 1
                    ELSE 0
                END) AS totaal_geen_status,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 1) AS totaal_prio_1,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 2) AS totaal_prio_2,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 3) AS totaal_prio_3,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 4) AS totaal_prio_4,
            sum(
                CASE
                    WHEN mc.prio_prod IS NULL OR mc.matrix_code::text = '999'::text THEN 1
                    ELSE 0
                END) AS totaal_zonder_prio,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 1) AS prio_1_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 2) AS prio_2_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 3) AS prio_3_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 4) AS prio_4_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 1) AS prio_1_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 2) AS prio_2_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 3) AS prio_3_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 4) AS prio_4_concept,
            o.team_geom
           FROM ( SELECT object.formelenaam,
                    object.basisreg_identifier,
                    object.geom,
                    object.id AS object_id,
                    historie.datum_aangemaakt,
                    historie.aanpassing,
                    historie.status,
                    historie.matrix_code_id,
                    tg.naam AS team,
                    tg.geom AS team_geom
                   FROM objecten.object
                     LEFT JOIN objecten.historie ON historie.id = (( SELECT h.id
                           FROM objecten.historie h
                          WHERE h.object_id = object.id
                          ORDER BY h.datum_aangemaakt DESC
                         LIMIT 1))
                     LEFT JOIN algemeen.team tg ON st_intersects(object.geom, tg.geom)
                  WHERE object.datum_deleted IS NULL
                  ORDER BY historie.status) o
             LEFT JOIN objecten.historie_matrix_code mc ON o.matrix_code_id = mc.id
          GROUP BY o.team, o.team_geom) obj;

-- Permissions

ALTER TABLE objecten.stavaza_objecten OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.stavaza_objecten TO oiv_admin;
GRANT SELECT ON TABLE objecten.stavaza_objecten TO oiv_read;


-- objecten.stavaza_status_gemeente source

CREATE OR REPLACE VIEW objecten.stavaza_status_gemeente
AS SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.status) FILTER (WHERE s.status::text = 'in gebruik'::text) AS totaal_in_gebruik,
    count(s.status) FILTER (WHERE s.status::text = 'concept'::text) AS totaal_in_concept,
    count(s.status) FILTER (WHERE s.status::text = 'archief'::text) AS totaal_in_archief,
    sum(
        CASE
            WHEN s.status IS NULL THEN 1
            ELSE 0
        END) AS totaal_geen_status,
    g.geom
   FROM objecten.status_objectgegevens s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;

-- Permissions

ALTER TABLE objecten.stavaza_status_gemeente OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.stavaza_status_gemeente TO oiv_admin;
GRANT SELECT ON TABLE objecten.stavaza_status_gemeente TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.stavaza_status_gemeente TO oiv_write;


-- objecten.stavaza_update_gemeente source

CREATE OR REPLACE VIEW objecten.stavaza_update_gemeente
AS SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.conditie) FILTER (WHERE s.conditie = 'up-to-date'::text) AS up_to_date,
    count(s.conditie) FILTER (WHERE s.conditie = 'updaten binnen 3 maanden'::text) AS binnen_3_maanden,
    count(s.conditie) FILTER (WHERE s.conditie = 'updaten'::text) AS updaten,
    count(s.conditie) FILTER (WHERE s.conditie = 'nog niet gemaakt'::text) AS nog_maken,
    g.geom
   FROM objecten.stavaza_volgende_update s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;

-- Permissions

ALTER TABLE objecten.stavaza_update_gemeente OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.stavaza_update_gemeente TO oiv_admin;
GRANT SELECT ON TABLE objecten.stavaza_update_gemeente TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.stavaza_update_gemeente TO oiv_write;


-- objecten.stavaza_volgende_update source

CREATE OR REPLACE VIEW objecten.stavaza_volgende_update
AS SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    historie.datum_aangemaakt,
    object.datum_gewijzigd,
    historie.status,
    historie.aanpassing,
    historie_matrix_code.matrix_code,
    historie_matrix_code.actualisatie,
    historie.datum_aangemaakt::date + '1 year'::interval *
        CASE
            WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
            WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
            WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
            WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
            WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
            ELSE NULL::integer
        END::double precision AS volgende_update,
        CASE
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) >= now() THEN 'up-to-date'::text
            WHEN (historie.datum_aangemaakt::date + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) < now() THEN 'updaten'::text
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) IS NULL THEN 'nog niet gemaakt'::text
            ELSE 'updaten binnen 3 maanden'::text
        END AS conditie
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT h.id
           FROM objecten.historie h
          WHERE h.object_id = object.id AND h.aanpassing::text <> 'aanpassing'::text
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN objecten.historie_matrix_code ON historie.matrix_code_id = historie_matrix_code.id
  WHERE object.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.stavaza_volgende_update OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.stavaza_volgende_update TO oiv_admin;
GRANT SELECT ON TABLE objecten.stavaza_volgende_update TO oiv_read;


-- objecten.veiligh_bouwk_types source

CREATE OR REPLACE VIEW objecten.veiligh_bouwk_types
AS SELECT row_number() OVER (ORDER BY e.enumlabel)::integer AS id,
    e.enumlabel::text AS naam
   FROM pg_type t
     JOIN pg_enum e ON t.oid = e.enumtypid
     JOIN pg_namespace n ON n.oid = t.typnamespace
  WHERE t.typname = 'veiligh_bouwk_type'::name;

-- Permissions

ALTER TABLE objecten.veiligh_bouwk_types OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.veiligh_bouwk_types TO oiv_admin;
GRANT SELECT ON TABLE objecten.veiligh_bouwk_types TO oiv_read;


-- objecten.view_afw_binnendekking source

CREATE OR REPLACE VIEW objecten.view_afw_binnendekking
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.handelingsaanwijzing,
    d.bouwlaag_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.symbol_name,
    dt.size
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.afw_binnendekking d ON st_intersects(t.geom, d.geom)
     JOIN objecten.afw_binnendekking_type dt ON d.soort::text = dt.naam::text
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_afw_binnendekking OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_afw_binnendekking TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_afw_binnendekking TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_afw_binnendekking TO oiv_write;


-- objecten.view_bedrijfshulpverlening source

CREATE OR REPLACE VIEW objecten.view_bedrijfshulpverlening
AS SELECT b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.ademluchtdragend,
    b.object_id,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.bedrijfshulpverlening b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_bedrijfshulpverlening OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_bedrijfshulpverlening TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_bedrijfshulpverlening TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_bedrijfshulpverlening TO oiv_write;


-- objecten.view_bereikbaarheid source

CREATE OR REPLACE VIEW objecten.view_bereikbaarheid
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.obstakels,
    b.wegafzetting,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.bereikbaarheid b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_bereikbaarheid OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_bereikbaarheid TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_bereikbaarheid TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_bereikbaarheid TO oiv_write;


-- objecten.view_bouwlagen source

CREATE OR REPLACE VIEW objecten.view_bouwlagen
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.bouwlaag,
    d.bouwdeel,
    d.pand_id,
    o.formelenaam,
    o.id AS object_id,
    o.min_bouwlaag,
    o.max_bouwlaag,
    sub.hoogste_bouwlaag,
    sub.laagste_bouwlaag
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.bouwlagen d ON st_intersects(t.geom, d.geom)
     JOIN ( SELECT bouwlagen.pand_id,
            max(bouwlagen.bouwlaag) AS hoogste_bouwlaag,
            min(bouwlagen.bouwlaag) AS laagste_bouwlaag
           FROM objecten.bouwlagen
          GROUP BY bouwlagen.pand_id) sub ON d.pand_id::text = sub.pand_id::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_bouwlagen OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_bouwlagen TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_bouwlagen TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_bouwlagen TO oiv_write;


-- objecten.view_contactpersoon source

CREATE OR REPLACE VIEW objecten.view_contactpersoon
AS SELECT b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.object_id,
    b.soort,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.contactpersoon b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_contactpersoon OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_contactpersoon TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_contactpersoon TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_contactpersoon TO oiv_write;


-- objecten.view_dreiging_bouwlaag source

CREATE OR REPLACE VIEW objecten.view_dreiging_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.dreiging_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.dreiging d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.dreiging_type dt ON d.dreiging_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_dreiging_bouwlaag OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_dreiging_bouwlaag TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_dreiging_bouwlaag TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_dreiging_bouwlaag TO oiv_write;


-- objecten.view_dreiging_ruimtelijk source

CREATE OR REPLACE VIEW objecten.view_dreiging_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dreiging_type_id,
    b.rotatie,
    b.label,
    b.bouwlaag_id,
    b.object_id,
    b.fotografie_id,
    vt.naam AS soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size_object AS size
   FROM objecten.object o
     JOIN objecten.dreiging b ON o.id = b.object_id
     JOIN objecten.dreiging_type vt ON b.dreiging_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_dreiging_ruimtelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_dreiging_ruimtelijk TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_dreiging_ruimtelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_dreiging_ruimtelijk TO oiv_write;


-- objecten.view_gebiedsgerichte_aanpak source

CREATE OR REPLACE VIEW objecten.view_gebiedsgerichte_aanpak
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.bijzonderheden,
    b.object_id,
    b.fotografie_id,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.gebiedsgerichte_aanpak b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_gebiedsgerichte_aanpak OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_gebiedsgerichte_aanpak TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_gebiedsgerichte_aanpak TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_gebiedsgerichte_aanpak TO oiv_write;


-- objecten.view_gevaarlijkestof_bouwlaag source

CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    st.symbol_name,
    st.size
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_gevaarlijkestof_bouwlaag OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_gevaarlijkestof_bouwlaag TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_gevaarlijkestof_bouwlaag TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_gevaarlijkestof_bouwlaag TO oiv_write;


-- objecten.view_gevaarlijkestof_ruimtelijk source

CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    st.symbol_name,
    st.size_object AS size
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND o.datum_deleted IS NULL AND d.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_gevaarlijkestof_ruimtelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_gevaarlijkestof_ruimtelijk TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_gevaarlijkestof_ruimtelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_gevaarlijkestof_ruimtelijk TO oiv_write;


-- objecten.view_grid source

CREATE OR REPLACE VIEW objecten.view_grid
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.y_as_label,
    b.x_as_label,
    b.object_id,
    b.afstand,
    b.vaknummer,
    b.scale,
    b.papersize,
    b.orientation,
    b.type,
    b.uuid,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.grid b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_grid OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_grid TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_grid TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_grid TO oiv_write;


-- objecten.view_ingang_bouwlaag source

CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.ingang_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.ingang d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.ingang_type dt ON d.ingang_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_ingang_bouwlaag OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_ingang_bouwlaag TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_ingang_bouwlaag TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_ingang_bouwlaag TO oiv_write;


-- objecten.view_ingang_ruimtelijk source

CREATE OR REPLACE VIEW objecten.view_ingang_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.ingang_type_id,
    b.rotatie,
    b.label,
    b.belemmering,
    b.voorzieningen,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.naam AS soort,
    vt.symbol_name,
    vt.size_object AS size
   FROM objecten.object o
     JOIN objecten.ingang b ON o.id = b.object_id
     JOIN objecten.ingang_type vt ON b.ingang_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_ingang_ruimtelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_ingang_ruimtelijk TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_ingang_ruimtelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_ingang_ruimtelijk TO oiv_write;


-- objecten.view_isolijnen source

CREATE OR REPLACE VIEW objecten.view_isolijnen
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.hoogte,
    b.omschrijving,
    b.object_id,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.isolijnen b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_isolijnen OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_isolijnen TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_isolijnen TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_isolijnen TO oiv_write;


-- objecten.view_label_bouwlaag source

CREATE OR REPLACE VIEW objecten.view_label_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.omschrijving,
    d.soort,
    d.rotatie,
    d.bouwlaag_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vt.size
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.label d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.label_type vt ON d.soort::text = vt.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_label_bouwlaag OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_label_bouwlaag TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_label_bouwlaag TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_label_bouwlaag TO oiv_write;


-- objecten.view_label_ruimtelijk source

CREATE OR REPLACE VIEW objecten.view_label_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.rotatie,
    b.bouwlaag_id,
    b.object_id,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.size_object AS size
   FROM objecten.object o
     JOIN objecten.label b ON o.id = b.object_id
     JOIN objecten.label_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_label_ruimtelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_label_ruimtelijk TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_label_ruimtelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_label_ruimtelijk TO oiv_write;


-- objecten.view_objectgegevens source

CREATE OR REPLACE VIEW objecten.view_objectgegevens
AS SELECT o.id,
    o.formelenaam,
    o.geom,
    o.basisreg_identifier,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.bijzonderheden,
    o.pers_max,
    o.pers_nietz_max,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.bron,
    o.bron_tabel,
    o.fotografie_id,
    bg.naam AS bodemgesteldheid,
    o.min_bouwlaag,
    o.max_bouwlaag,
    gf.gebruiksfuncties,
    round(st_x(o.geom)) AS x,
    round(st_y(o.geom)) AS y,
    part.typeobject
   FROM objecten.object o
     LEFT JOIN objecten.bodemgesteldheid_type bg ON o.bodemgesteldheid_type_id = bg.id
     LEFT JOIN ( SELECT DISTINCT g.object_id,
            string_agg(gt.naam, ', '::text) AS gebruiksfuncties
           FROM objecten.gebruiksfunctie g
             JOIN objecten.gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
          GROUP BY g.object_id) gf ON o.id = gf.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime,
            historie.typeobject
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id, historie.typeobject) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_objectgegevens OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_objectgegevens TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_objectgegevens TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_objectgegevens TO oiv_write;


-- objecten.view_opstelplaats source

CREATE OR REPLACE VIEW objecten.view_opstelplaats
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.rotatie,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.object o
     JOIN objecten.opstelplaats b ON o.id = b.object_id
     JOIN objecten.opstelplaats_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_opstelplaats OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_opstelplaats TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_opstelplaats TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_opstelplaats TO oiv_write;


-- objecten.view_pictogram_zonder_object source

CREATE OR REPLACE VIEW objecten.view_pictogram_zonder_object
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.voorziening_pictogram_id,
    v.label,
    v.rotatie,
    p.naam AS pictogram,
    round(st_x(v.geom)) AS x,
    round(st_y(v.geom)) AS y
   FROM objecten.pictogram_zonder_object v
     JOIN objecten.pictogram_zonder_object_type p ON v.voorziening_pictogram_id = p.id;

-- Permissions

ALTER TABLE objecten.view_pictogram_zonder_object OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_pictogram_zonder_object TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_pictogram_zonder_object TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_pictogram_zonder_object TO oiv_write;


-- objecten.view_points_of_interest source

CREATE OR REPLACE VIEW objecten.view_points_of_interest
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.points_of_interest_type_id,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    b.bijzonderheid,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.object o
     JOIN objecten.points_of_interest b ON o.id = b.object_id
     JOIN objecten.points_of_interest_type vt ON b.points_of_interest_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_points_of_interest OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_points_of_interest TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_points_of_interest TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_points_of_interest TO oiv_write;


-- objecten.view_ruimten source

CREATE OR REPLACE VIEW objecten.view_ruimten
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.ruimten_type_id,
    d.omschrijving,
    d.bouwlaag_id,
    d.fotografie_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.ruimten d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_ruimten OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_ruimten TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_ruimten TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_ruimten TO oiv_write;


-- objecten.view_scenario_bouwlaag source

CREATE OR REPLACE VIEW objecten.view_scenario_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.scenario_locatie_id,
    d.omschrijving,
    d.scenario_type_id,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    slt.symbol_name,
    slt.size_object AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.scenario_locatie op ON st_intersects(t.geom, op.geom)
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id
     JOIN objecten.scenario_locatie_type slt ON 'Scenario locatie'::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.scenario_type_id = st.id
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_scenario_bouwlaag OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_scenario_bouwlaag TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_scenario_bouwlaag TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_scenario_bouwlaag TO oiv_write;


-- objecten.view_scenario_ruimtelijk source

CREATE OR REPLACE VIEW objecten.view_scenario_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.scenario_locatie_id,
    d.omschrijving,
    d.scenario_type_id,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    slt.symbol_name,
    slt.size_object AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.scenario_locatie op ON o.id = op.object_id
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id
     JOIN objecten.scenario_locatie_type slt ON 'Scenario locatie'::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.scenario_type_id = st.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND o.datum_deleted IS NULL AND d.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_scenario_ruimtelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_scenario_ruimtelijk TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_scenario_ruimtelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_scenario_ruimtelijk TO oiv_write;


-- objecten.view_schade_cirkel_bouwlaag source

CREATE OR REPLACE VIEW objecten.view_schade_cirkel_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    st_buffer(op.geom, gsc.straal::double precision)::geometry(Polygon,28992) AS geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    gsc.soort
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND gsc.datum_deleted IS NULL AND t.datum_deleted IS NULL AND op.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_schade_cirkel_bouwlaag OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_schade_cirkel_bouwlaag TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_schade_cirkel_bouwlaag TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_schade_cirkel_bouwlaag TO oiv_write;


-- objecten.view_schade_cirkel_ruimtelijk source

CREATE OR REPLACE VIEW objecten.view_schade_cirkel_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    st_buffer(op.geom, gsc.straal::double precision)::geometry(Polygon,28992) AS geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    gsc.soort
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND gsc.datum_deleted IS NULL AND o.datum_deleted IS NULL AND op.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_schade_cirkel_ruimtelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_schade_cirkel_ruimtelijk TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_schade_cirkel_ruimtelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_schade_cirkel_ruimtelijk TO oiv_write;


-- objecten.view_sectoren source

CREATE OR REPLACE VIEW objecten.view_sectoren
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.label,
    b.object_id,
    b.fotografie_id,
    b.soort,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.sectoren b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_sectoren OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_sectoren TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_sectoren TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_sectoren TO oiv_write;


-- objecten.view_sleutelkluis_bouwlaag source

CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.sleutelkluis_type_id,
    d.aanduiding_locatie,
    d.sleuteldoel_type_id,
    d.rotatie,
    d.label,
    d.ingang_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    i.bouwlaag_id,
    dd.naam AS doel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.sleutelkluis d ON st_intersects(t.geom, d.geom)
     JOIN objecten.ingang i ON d.ingang_id = i.id
     JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
     JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     LEFT JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL AND i.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_sleutelkluis_bouwlaag OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_sleutelkluis_bouwlaag TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_sleutelkluis_bouwlaag TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_sleutelkluis_bouwlaag TO oiv_write;


-- objecten.view_sleutelkluis_ruimtelijk source

CREATE OR REPLACE VIEW objecten.view_sleutelkluis_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.sleutelkluis_type_id,
    d.aanduiding_locatie,
    d.sleuteldoel_type_id,
    d.rotatie,
    d.label,
    d.ingang_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    i.object_id,
    dd.naam AS doel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size_object AS size
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.ingang i ON o.id = i.object_id
     JOIN objecten.sleutelkluis d ON i.id = d.ingang_id
     JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     LEFT JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND d.datum_deleted IS NULL AND i.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_sleutelkluis_ruimtelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_sleutelkluis_ruimtelijk TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_sleutelkluis_ruimtelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_sleutelkluis_ruimtelijk TO oiv_write;


-- objecten.view_veiligh_bouwk source

CREATE OR REPLACE VIEW objecten.view_veiligh_bouwk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.bouwlaag_id,
    d.fotografie_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.veiligh_bouwk d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_veiligh_bouwk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_veiligh_bouwk TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_veiligh_bouwk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_veiligh_bouwk TO oiv_write;


-- objecten.view_veiligh_install source

CREATE OR REPLACE VIEW objecten.view_veiligh_install
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.veiligh_install_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    d.bijzonderheid,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.veiligh_install d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type dt ON d.veiligh_install_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_veiligh_install OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_veiligh_install TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_veiligh_install TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_veiligh_install TO oiv_write;


-- objecten.view_veiligh_ruimtelijk source

CREATE OR REPLACE VIEW objecten.view_veiligh_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.veiligh_ruimtelijk_type_id,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    vt.naam AS soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.object o
     JOIN objecten.veiligh_ruimtelijk b ON o.id = b.object_id
     JOIN objecten.veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

-- Permissions

ALTER TABLE objecten.view_veiligh_ruimtelijk OWNER TO oiv_admin;
GRANT ALL ON TABLE objecten.view_veiligh_ruimtelijk TO oiv_admin;
GRANT SELECT ON TABLE objecten.view_veiligh_ruimtelijk TO oiv_read;
GRANT DELETE, INSERT, UPDATE ON TABLE objecten.view_veiligh_ruimtelijk TO oiv_write;


-- objecten.vv_objecten source

CREATE OR REPLACE VIEW objecten.vv_objecten
AS SELECT o.id,
    COALESCE(bwl.bouwlaag, 1) AS bouwlaag,
    row_to_json(( SELECT d.*::record AS d
           FROM ( SELECT concat(o.id, '_bouwlaag_', COALESCE(bwl.bouwlaag, 1)) AS id,
                    o.formelenaam,
                    st_astext(o.geom) AS location,
                    o.bijzonderheden,
                    o.pers_max,
                    o.pers_nietz_max,
                    gf.gebruiksfuncties AS gebruikstype_specifiek,
                    part.typeobject AS symbool,
                    bg.naam AS bodemgesteldheid,
                    bbh.json_list AS lines,
                    lbl.json_list AS labels,
                    vhr.json_list AS symbols,
                    drg.json_list AS danger_symbols,
                    bwl.json_list AS buildings,
                    grd.json_list AS grid_polygons,
                    vrd.json_list AS verdiepingen,
                    rmt.json_list AS custom_polygons) d)) AS json_string
   FROM objecten.object o
     LEFT JOIN objecten.terrein trn ON o.id = trn.object_id
     LEFT JOIN objecten.bodemgesteldheid_type bg ON o.bodemgesteldheid_type_id = bg.id
     LEFT JOIN ( SELECT DISTINCT g.object_id,
            string_agg(gt.naam, ', '::text) AS gebruiksfuncties
           FROM objecten.gebruiksfunctie g
             JOIN objecten.gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
          GROUP BY g.object_id) gf ON o.id = gf.object_id
     LEFT JOIN ( SELECT b.bouwlaag,
            st_union(b.geom) AS geovlak,
            json_agg(row_to_json(( SELECT b_1.*::record AS b
                   FROM ( SELECT b.bouwlaag,
                            b.bouwdeel,
                            st_astext(b.geom) AS polygon) b_1))) AS json_list
           FROM objecten.bouwlagen b
          GROUP BY b.bouwlaag, b.pand_id) bwl ON st_intersects(trn.geom, bwl.geovlak)
     LEFT JOIN ( SELECT b.object_id,
            json_agg(row_to_json(( SELECT DISTINCT b_1.*::record AS b
                   FROM ( SELECT b.bouwlaag,
                                CASE
                                    WHEN b.bouwlaag = 1 THEN true
                                    ELSE false
                                END AS is_hoofdobject,
                            concat(b.object_id, '_bouwlaag_', COALESCE(b.bouwlaag, 1)) AS id) b_1))) AS json_list
           FROM ( SELECT DISTINCT bo.bouwlaag,
                    tren.object_id
                   FROM objecten.bouwlagen bo
                     JOIN objecten.terrein tren ON st_intersects(tren.geom, bo.geom)) b
          GROUP BY b.object_id) vrd ON o.id = vrd.object_id
     LEFT JOIN ( SELECT sub2.object_id,
            sub2.bouwlaag,
            json_agg(sub2.json_list) AS json_list
           FROM ( SELECT COALESCE(sub1.object_id, t.object_id) AS object_id,
                    COALESCE(b.bouwlaag, 1) AS bouwlaag,
                    json_agg(row_to_json(( SELECT b_1.*::record AS b
                           FROM ( SELECT sub1.omschrijving,
                                    sub1.bijzonderheid,
                                    sub1.label,
                                    sub1.soort,
                                    st_astext(sub1.geom) AS line) b_1))) AS json_list
                   FROM ( SELECT vr.geom,
                            vr.obstakels AS omschrijving,
                            vr.wegafzetting AS bijzonderheid,
                            vr.label,
                            vr.soort,
                            vr.object_id,
                            NULL::integer AS bouwlaag_id
                           FROM objecten.bereikbaarheid vr
                        UNION
                         SELECT vr.geom,
                            vr.omschrijving,
                            NULL::character varying AS bijzonderheid,
                            concat(vr.hoogte::text, ' mtr.'::text) AS label,
                            vr.hoogte::text AS hoogte,
                            vr.object_id,
                            NULL::integer AS bouwlaag_id
                           FROM objecten.isolijnen vr
                        UNION
                         SELECT vr.geom,
                            vr.bijzonderheden AS omschrijving,
                            NULL::character varying AS bijzonderheid,
                            vr.label,
                            vr.soort,
                            vr.object_id,
                            NULL::integer AS bouwlaag_id
                           FROM objecten.gebiedsgerichte_aanpak vr
                        UNION
                         SELECT vr.geom,
                            NULL::character varying AS omschrijving,
                            NULL::character varying AS bijzonderheid,
                            NULL::character varying AS label,
                            vr.soort,
                            NULL::integer AS object_id,
                            vr.bouwlaag_id
                           FROM objecten.veiligh_bouwk vr) sub1
                     LEFT JOIN objecten.bouwlagen b ON sub1.bouwlaag_id = b.id
                     LEFT JOIN objecten.terrein t ON st_intersects(t.geom, sub1.geom)
                  GROUP BY sub1.object_id, t.object_id, b.bouwlaag) sub2
          GROUP BY sub2.object_id, sub2.bouwlaag) bbh ON o.id = bbh.object_id AND COALESCE(bwl.bouwlaag, 1) = bbh.bouwlaag
     LEFT JOIN ( SELECT sub2.object_id,
            sub2.bouwlaag,
            json_agg(sub2.json_list) AS json_list
           FROM ( SELECT COALESCE(sub1.object_id, t.object_id) AS object_id,
                    COALESCE(b.bouwlaag, 1) AS bouwlaag,
                    json_agg(row_to_json(( SELECT b_1.*::record AS b
                           FROM ( SELECT sub1.omschrijving,
                                    sub1.label,
                                    sub1.soort,
                                    st_astext(sub1.geom) AS polygon) b_1))) AS json_list
                   FROM ( SELECT vr.geom,
                            vr.omschrijving,
                            vr.label,
                            vr.soort,
                            vr.object_id,
                            NULL::integer AS bouwlaag_id
                           FROM objecten.sectoren vr
                        UNION
                         SELECT vr.geom,
                            vr.omschrijving,
                            NULL::character varying AS label,
                            vr.ruimten_type_id,
                            NULL::integer AS object_id,
                            vr.bouwlaag_id
                           FROM objecten.ruimten vr) sub1
                     LEFT JOIN objecten.bouwlagen b ON sub1.bouwlaag_id = b.id
                     LEFT JOIN objecten.terrein t ON st_intersects(t.geom, sub1.geom)
                  GROUP BY sub1.object_id, t.object_id, b.bouwlaag) sub2
          GROUP BY sub2.object_id, sub2.bouwlaag) rmt ON o.id = rmt.object_id AND COALESCE(bwl.bouwlaag, 1) = rmt.bouwlaag
     LEFT JOIN ( SELECT subquery.object_id,
            subquery.bouwlaag,
            json_agg(subquery.json_list) AS json_list
           FROM ( SELECT COALESCE(l.object_id, t.object_id) AS object_id,
                    COALESCE(b.bouwlaag, 1) AS bouwlaag,
                    json_agg(row_to_json(( SELECT b_1.*::record AS b
                           FROM ( SELECT l.omschrijving AS text,
                                    l.rotatie,
                                    l.soort,
                                    st_astext(l.geom) AS location,
                                    lt.size) b_1))) AS json_list
                   FROM objecten.label l
                     JOIN objecten.label_type lt ON l.soort::text = lt.naam::text
                     LEFT JOIN objecten.bouwlagen b ON l.bouwlaag_id = b.id
                     LEFT JOIN objecten.terrein t ON st_intersects(t.geom, l.geom)
                  GROUP BY l.object_id, t.object_id, b.bouwlaag) subquery
          GROUP BY subquery.object_id, subquery.bouwlaag) lbl ON o.id = lbl.object_id AND COALESCE(bwl.bouwlaag, 1) = lbl.bouwlaag
     LEFT JOIN ( SELECT sub2.object_id,
            sub2.bouwlaag,
            json_agg(sub2.json_list) AS json_list
           FROM ( SELECT COALESCE(sub1.object_id, t.object_id) AS object_id,
                    COALESCE(b.bouwlaag, 1) AS bouwlaag,
                    json_agg(row_to_json(( SELECT b_1.*::record AS b
                           FROM ( SELECT sub1.bijzonderheid,
                                    sub1.rotatie,
                                    sub1.label,
                                    sub1.naam,
                                    sub1.symbol_name AS code,
                                    st_astext(sub1.geom) AS location,
                                    sub1.size) b_1))) AS json_list
                   FROM ( SELECT vr.geom,
                            vr.veiligh_ruimtelijk_type_id,
                            vr.label,
                            NULL::integer AS bouwlaag_id,
                            vr.object_id,
                            vr.rotatie,
                            vr.bijzonderheid,
                            lt.naam,
                            lt.symbol_name,
                            lt.size
                           FROM objecten.veiligh_ruimtelijk vr
                             JOIN objecten.veiligh_ruimtelijk_type lt ON vr.veiligh_ruimtelijk_type_id = lt.id
                        UNION
                         SELECT vr.geom,
                            vr.ingang_type_id,
                            vr.label,
                            vr.bouwlaag_id,
                            vr.object_id,
                            vr.rotatie,
                            vr.voorzieningen,
                            lt.naam,
                            lt.symbol_name,
                            lt.size
                           FROM objecten.ingang vr
                             JOIN objecten.ingang_type lt ON vr.ingang_type_id = lt.id
                        UNION
                         SELECT s.geom,
                            s.sleutelkluis_type_id,
                            s.label,
                            vr.bouwlaag_id,
                            vr.object_id,
                            s.rotatie,
                            sdt.naam,
                            skt.naam,
                            skt.symbol_name,
                            skt.size
                           FROM objecten.sleutelkluis s
                             JOIN objecten.ingang vr ON s.ingang_id = vr.id
                             JOIN objecten.sleutelkluis_type skt ON s.sleutelkluis_type_id = skt.id
                             LEFT JOIN objecten.sleuteldoel_type sdt ON s.sleuteldoel_type_id = sdt.id
                        UNION
                         SELECT op.geom,
                            lt.id,
                            op.label,
                            NULL::integer AS bouwlaag_id,
                            op.object_id,
                            op.rotatie,
                            NULL::text AS bijzonderheid,
                            op.soort,
                            lt.symbol_name,
                            lt.size
                           FROM objecten.opstelplaats op
                             JOIN objecten.opstelplaats_type lt ON op.soort::text = lt.naam::text
                        UNION
                         SELECT op.geom,
                            op.points_of_interest_type_id,
                            op.label,
                            NULL::integer AS bouwlaag_id,
                            op.object_id,
                            op.rotatie,
                            op.bijzonderheid,
                            lt.naam,
                            lt.symbol_name,
                            lt.size
                           FROM objecten.points_of_interest op
                             JOIN objecten.points_of_interest_type lt ON op.points_of_interest_type_id = lt.id
                        UNION
                         SELECT vr.geom,
                            vr.veiligh_install_type_id,
                            vr.label,
                            vr.bouwlaag_id,
                            NULL::integer AS object_id,
                            vr.rotatie,
                            vr.bijzonderheid,
                            lt.naam,
                            lt.symbol_name,
                            lt.size
                           FROM objecten.veiligh_install vr
                             JOIN objecten.veiligh_install_type lt ON vr.veiligh_install_type_id = lt.id) sub1
                     LEFT JOIN objecten.bouwlagen b ON sub1.bouwlaag_id = b.id
                     LEFT JOIN objecten.terrein t ON st_intersects(t.geom, sub1.geom)
                  GROUP BY sub1.object_id, t.object_id, b.bouwlaag) sub2
          GROUP BY sub2.object_id, sub2.bouwlaag) vhr ON o.id = vhr.object_id AND COALESCE(bwl.bouwlaag, 1) = vhr.bouwlaag
     LEFT JOIN ( SELECT subquery.object_id,
            subquery.bouwlaag,
            json_agg(subquery.json_list) AS json_list
           FROM ( SELECT COALESCE(l.object_id, t.object_id) AS object_id,
                    COALESCE(b.bouwlaag, 1) AS bouwlaag,
                    json_agg(row_to_json(( SELECT b_1.*::record AS b
                           FROM ( SELECT l.omschrijving,
                                    l.rotatie,
                                    l.label,
                                    lt.naam,
                                    lt.symbol_name AS code,
                                    st_astext(l.geom) AS location,
                                    lt.size) b_1))) AS json_list
                   FROM objecten.dreiging l
                     JOIN objecten.dreiging_type lt ON l.dreiging_type_id = lt.id
                     LEFT JOIN objecten.bouwlagen b ON l.bouwlaag_id = b.id
                     LEFT JOIN objecten.terrein t ON st_intersects(t.geom, l.geom)
                  GROUP BY l.object_id, t.object_id, b.bouwlaag) subquery
          GROUP BY subquery.object_id, subquery.bouwlaag) drg ON o.id = vhr.object_id
     LEFT JOIN ( SELECT b.object_id,
            json_agg(row_to_json(( SELECT b_1.*::record AS b
                   FROM ( SELECT b.y_as_label,
                            b.x_as_label,
                            b.vaknummer,
                            b.type,
                            st_astext(b.geom) AS polygon) b_1))) AS json_list
           FROM objecten.grid b
          GROUP BY b.object_id) grd ON o.id = grd.object_id
     JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

-- Permissions

ALTER TABLE objecten.vv_objecten OWNER TO webdev;
GRANT ALL ON TABLE objecten.vv_objecten TO webdev;


-- objecten.vv_objecten_list source

CREATE OR REPLACE VIEW objecten.vv_objecten_list
AS SELECT row_to_json(( SELECT x.*::record AS x
           FROM ( SELECT subq.id,
                    st_astext(st_extent(subq.extent)::geometry) AS extent,
                    subq.formelenaam,
                    subq.pand_centroid,
                    subq.symbool,
                    subq.heeft_verdiepingen) x)) AS row_to_json
   FROM ( SELECT concat(o.id, '_bouwlaag_', COALESCE(b.bouwlaag, 1)) AS id,
            st_transform(trn.geom, 4326) AS extent,
            o.formelenaam,
            st_astext(o.geom) AS pand_centroid,
            COALESCE(part.typeobject, ''::character varying) AS symbool,
                CASE
                    WHEN (( SELECT max(bwl.bouwlaag) AS max
                       FROM objecten.bouwlagen bwl
                      WHERE st_intersects(trn.geom, bwl.geom))) <> 1 THEN true
                    ELSE false
                END AS heeft_verdiepingen
           FROM objecten.object o
             JOIN objecten.terrein trn ON o.id = trn.object_id
             LEFT JOIN objecten.bouwlagen b ON st_intersects(trn.geom, b.geom)
             JOIN ( SELECT h.object_id,
                    h.typeobject
                   FROM objecten.historie h
                     JOIN ( SELECT historie.object_id,
                            max(historie.datum_aangemaakt) AS maxdatetime
                           FROM objecten.historie
                          WHERE historie.status::text = 'in gebruik'::text
                          GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
          WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.id, b.bouwlaag, part.typeobject, trn.geom) subq
  GROUP BY subq.id, subq.formelenaam, subq.pand_centroid, subq.symbool, subq.heeft_verdiepingen;

-- Permissions

ALTER TABLE objecten.vv_objecten_list OWNER TO webdev;
GRANT ALL ON TABLE objecten.vv_objecten_list TO webdev;



CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
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
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
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
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
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
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
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
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
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
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
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
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
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
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
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
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
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
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
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

-- Permissions

ALTER FUNCTION objecten.func_scenario_locatie_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_scenario_locatie_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
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
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
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

CREATE OR REPLACE FUNCTION objecten.func_soft_delete_cascade()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
       fk_table TEXT;
       fk_schema TEXT;
       schemaname TEXT := TG_ARGV[0]::TEXT;
       tablename TEXT := TG_ARGV[1]::TEXT;
       identifier TEXT := TG_ARGV[2]::TEXT;
    BEGIN
		FOR fk_table, fk_schema IN
			SELECT 
			       fk_tco.table_schema as fk_table,
			       fk_tco.table_name AS fk_schema
			FROM information_schema.referential_constraints rco
			JOIN information_schema.table_constraints fk_tco ON rco.constraint_name = fk_tco.constraint_name AND rco.constraint_schema = fk_tco.table_schema
			JOIN information_schema.table_constraints pk_tco ON rco.unique_constraint_name = pk_tco.constraint_name AND rco.unique_constraint_schema = pk_tco.table_schema
			WHERE pk_tco.table_name = tablename AND pk_tco.table_schema = schemaname
		LOOP
			EXECUTE format('DELETE FROM %I.%I WHERE $I = $1;', fk_table, fk_schema, identifier)
			USING OLD.id;
		END LOOP;
        RETURN OLD;
    END;
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_soft_delete_cascade() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_soft_delete_cascade() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_veiligh_bouwk_ins() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_bouwk_ins() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
    $function$
;

-- Permissions

ALTER FUNCTION objecten.func_veiligh_ruimtelijk_upd() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.func_veiligh_ruimtelijk_upd() TO oiv_admin;

CREATE OR REPLACE FUNCTION objecten.set_delete_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
      command text := ' SET datum_deleted = now() WHERE id = $1';
    BEGIN
      EXECUTE 'UPDATE "' || TG_TABLE_SCHEMA || '"."' || TG_TABLE_NAME || '" ' || command USING OLD.id;
      RETURN NULL;
    END;
  $function$
;

-- Permissions

ALTER FUNCTION objecten.set_delete_timestamp() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.set_delete_timestamp() TO public;
GRANT ALL ON FUNCTION objecten.set_delete_timestamp() TO oiv_admin;
GRANT ALL ON FUNCTION objecten.set_delete_timestamp() TO oiv_write;

CREATE OR REPLACE FUNCTION objecten.set_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
   NEW := NEW #= hstore(TG_ARGV[0], 'now()');
   RETURN NEW;
END
$function$
;

-- Permissions

ALTER FUNCTION objecten.set_timestamp() OWNER TO oiv_admin;
GRANT ALL ON FUNCTION objecten.set_timestamp() TO public;
GRANT ALL ON FUNCTION objecten.set_timestamp() TO oiv_admin;
GRANT ALL ON FUNCTION objecten.set_timestamp() TO oiv_write;


-- Permissions

GRANT ALL ON SCHEMA objecten TO oiv_admin;
GRANT USAGE ON SCHEMA objecten TO oiv_read;
