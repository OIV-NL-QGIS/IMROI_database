SET ROLE oiv_admin;

DROP SCHEMA IF EXISTS objecten CASCADE;

CREATE SCHEMA objecten;
COMMENT ON SCHEMA objecten IS 'OIV objecten';

GRANT USAGE ON SCHEMA objecten TO GROUP oiv_read;

SET search_path = objecten, pg_catalog, public;

--Create types
CREATE TYPE bereikbaarheid_type AS ENUM ('aanrijdroute', 'hekwerk', 'calamiteitenroute', 'vluchtroute publiek', 'wegen eigen terrein', 'oever-kade', 'evenementenroute');
CREATE TYPE contactpersoon_type AS ENUM ('Hoofd BHV','beheerder', 'brugwachter', 'eigenaar', 'gebruiker', 'gemeente', 'havendienst', 'hoogheemraadschap', 
                                          'kantine', 'kustwachtcentrum', 'provincie', 'PWN', 'receptie', 'reddingsbrigade', 'sluiswachter', 'staatsbosbeheer', 'zwemwatertelefoon');
CREATE TYPE opstelplaats_type   AS ENUM ('Tankautospuit','Redvoertuig','Autoladder','WTS','Schuimblusvoertuig', 'UGS', 'Boot te water laat plaats');
CREATE TYPE veilighv_org_type   AS ENUM ('bedrijfsbrandweer', 'onderhoud', 'rampenbestrijdingsplan', 'regulering transitie (verladingen, venstertijden etc)',
                                          'risicocommunicatie', 'sancties', 'supervisie', 'veiligheidsfunctionaris', 'veiligheidsovertredingenregister');
CREATE TYPE veiligh_bouwk_type  AS ENUM ('30 min brandwerende scheiding', '60 min brandwerende scheiding', 'bouwdeelscheiding', 'rookwerendescheiding', '120 min brandwerende scheiding');
CREATE TYPE afw_binnendekking_type AS ENUM('Dekkingsprobleem DMO', 'Dekkingsprobleem TMO');
CREATE TYPE labels_type         AS ENUM ('Algemeen', 'Gevaar', 'Voorzichtig', 'Waarschuwing', 'calamiteitendoorgang', 'publieke ingang');
CREATE TYPE eenheid_type        AS ENUM ('cilinder', 'kg', 'liter', 'm3', 'stuks');
CREATE TYPE toestand_type       AS ENUM ('gas', 'gas / vloeibaar', 'vast', 'vloeibaar', 'vloeibaar / vast');
CREATE TYPE schade_cirkel_type  AS ENUM ('onherstelbare schade en branden', 'zware schade en secundaire branden', 'secundaire branden treden op', 'geen of lichte schade');
CREATE TYPE historie_aanpassing_type AS ENUM ('aanpassing', 'nieuw', 'update');
CREATE TYPE historie_status_type AS ENUM ('concept', 'in gebruik', 'archief');
CREATE TYPE sectoren_type       AS ENUM('persvak', 'podium', 'publieke sector', 'tent', 'parkeerzone');
CREATE TYPE inzetfase_type      AS ENUM('uitrukfase', 'verkenfase', 'inzetfase', 'afbouwfase', 'nazorgfase');

CREATE TABLE bodemgesteldheid_type
(
  id            smallint NOT NULL,
  naam          text,
  omschrijving  text,
  CONSTRAINT bodemgesteldheid_type_pkey PRIMARY KEY (id)
);

CREATE TABLE object
(
  id                  SERIAL PRIMARY KEY    		 NOT NULL,
  geom                GEOMETRY(POINT, 28992),
  datum_aangemaakt    TIMESTAMP WITH TIME ZONE   DEFAULT now(),
  datum_gewijzigd     TIMESTAMP WITH TIME ZONE,
  basisreg_identifier CHARACTER VARYING(254)	   NOT NULL,
  formelenaam         VARCHAR(255) 				       NOT NULL,
  bijzonderheden      VARCHAR,
  pers_max			  INTEGER,
  pers_nietz_max      INTEGER,
  datum_geldig_tot    timestamp without time zone,
  datum_geldig_vanaf  timestamp without time zone,
  bron                character varying(3)       NOT NULL,
  bron_tabel          character varying(25)      NOT NULL,
  fotografie_id       INTEGER,
  bodemgesteldheid_type_id INTEGER,
  CONSTRAINT object_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id),
  CONSTRAINT object_bodemgesteldheid_type_id_fk FOREIGN KEY (bodemgesteldheid_type_id) REFERENCES bodemgesteldheid_type (id)
);

CREATE INDEX object_geom_gist
  ON object (geom);

CREATE INDEX object_geovlak_gist
  ON object USING GIST(geovlak);

CREATE TABLE bouwlagen
(
	id 				SERIAL PRIMARY KEY 						 NOT NULL,
	geom	 		GEOMETRY(MULTIPOLYGON, 28992),
	datum_aangemaakt  TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
	bouwlaag 		INTEGER 								 NOT NULL,
	bouwdeel 		CHARACTER VARYING(25),
	pand_id 		character varying(16) NOT NULL
);

CREATE INDEX bouwlagen_geom_gist
  ON bouwlagen USING GIST(geom);
COMMENT ON TABLE bouwlagen IS 'Vlakken laag om bouwlagen in te tekenen';

CREATE TABLE bereikbaarheid
(
  id                     SERIAL PRIMARY KEY NOT NULL,
  geom                   geometry(MultiLineString,28992),
  datum_aangemaakt       TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd        TIMESTAMP WITH TIME ZONE,
  obstakels              CHARACTER VARYING(50),
  wegafzetting           CHARACTER VARYING(50),
  soort                  bereikbaarheid_type,
  object_id              INTEGER NOT NULL,
  fotografie_id          INTEGER,
  label                  CHARACTER VARYING(254),
  CONSTRAINT bereikbaarheid_object_id_fk FOREIGN KEY (object_id)     REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT bereikbaarheid_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX bereikbaarheid_geom_gist
  ON bereikbaarheid USING GIST(geom);
COMMENT ON TABLE bereikbaarheid IS 'Bereikbaarheids bijzonderheden per repressief object';

CREATE TABLE contactpersoon
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  soort                     contactpersoon_type,
  dagen                     TEXT,
  tijdvakbegin              TIMESTAMP WITHOUT TIME ZONE,
  tijdvakeind               TIMESTAMP WITHOUT TIME ZONE,
  telefoonnummer             CHARACTER VARYING(11),
  object_id             INTEGER         NOT NULL,
  CONSTRAINT contactpersoon_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE contactpersoon IS 'Contactpersonen';

CREATE TABLE bedrijfshulpverlening
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  dagen                     TEXT,
  tijdvakbegin              TIMESTAMP,
  tijdvakeind               TIMESTAMP,
  telefoonnummer            CHARACTER VARYING(11),
  ademluchtdragend          BOOLEAN,
  object_id                 INTEGER         NOT NULL,
  CONSTRAINT bedrijfshulpverlening_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE bedrijfshulpverlening IS 'Bedrijfshulpverlening';

CREATE TABLE scenario_type
(
  id            SMALLINT PRIMARY KEY NOT NULL,
  naam          TEXT,
  omschrijving  TEXT
);
COMMENT ON TABLE scenario_type IS 'Enumeratie van de verschillende scenarios';
REVOKE ALL ON TABLE scenario_type FROM GROUP oiv_write;

CREATE TABLE scenario
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  omschrijving              TEXT,
  scenario_type_id          INTEGER,
  object_id             INTEGER         NOT NULL,
  CONSTRAINT scenario_type_id_fk FOREIGN KEY (scenario_type_id) REFERENCES scenario_type (id),
  CONSTRAINT scenario_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE bedrijfshulpverlening IS 'scenarios';

CREATE TABLE opstelplaats
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  soort                     opstelplaats_type,
  rotatie                   INTEGER DEFAULT 0,  
  object_id                 INTEGER NOT NULL,
  fotografie_id             INTEGER,
  label                     CHARACTER VARYING(50),
  CONSTRAINT opstelplaats_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT opstelplaats_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE opstelplaats IS 'Opstelplaatsen t.b.v. brandweervoertuigen';
  
CREATE INDEX opstelplaats_geom_gist
  ON opstelplaats USING GIST(geom);

CREATE TABLE veilighv_org
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  soort                     veilighv_org_type,
  omschrijving              TEXT,
  object_id                 INTEGER NOT NULL,
  CONSTRAINT veilighv_org_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE veilighv_org IS 'Organisatorische veiligheidsvoorzieningen';

CREATE TABLE veiligh_ruimtelijk_type
(
  id        SMALLINT PRIMARY KEY NOT NULL,
  naam      TEXT,
  categorie TEXT,
  symbol_name TEXT
);
COMMENT ON TABLE veiligh_ruimtelijk_type IS 'Enumeratie van de verschillende ruimtelijke veiligheidsvoorzieningen';
REVOKE ALL ON TABLE veiligh_ruimtelijk_type FROM GROUP oiv_write;

CREATE TABLE veiligh_ruimtelijk
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  veiligh_ruimtelijk_type_id   INTEGER,
  label                     TEXT,
  object_id                 INTEGER         NOT NULL,
  rotatie                   INTEGER DEFAULT 0,
  fotografie_id             INTEGER,
  CONSTRAINT veiligh_ruimtelijk_type_id_fk FOREIGN KEY (veiligh_ruimtelijk_type_id) REFERENCES veiligh_ruimtelijk_type (id),
  CONSTRAINT veiligh_ruimtelijk_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT veiligh_ruimtelijk_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE veiligh_ruimtelijk IS 'Ruimtelijke veiligheidsvoorzieningen';

CREATE INDEX veiligh_ruimtelijk_geom_gist
  ON veiligh_ruimtelijk USING GIST(geom);

CREATE TABLE veiligh_install_type
(
  id        SMALLINT PRIMARY KEY NOT NULL,
  naam      TEXT,
  symbol_name TEXT,
  size INTEGER
);
COMMENT ON TABLE veiligh_install_type IS 'Enumeratie van de verschillende installatietechnische veiligheidsvoorzieningen';
REVOKE ALL ON TABLE veiligh_install_type FROM GROUP oiv_write;

CREATE TABLE veiligh_install
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  veiligh_install_type_id   INTEGER,
  label                     TEXT,
  bouwlaag_id               INTEGER         NOT NULL,
  rotatie                   INTEGER DEFAULT 0,
  fotografie_id             INTEGER,
  CONSTRAINT veiligh_install_type_id_fk FOREIGN KEY (veiligh_install_type_id) REFERENCES veiligh_install_type (id),
  CONSTRAINT veiligh_install_bouwlaag_id_fk  FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT veiligh_install_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE veiligh_install IS 'Installatietechnische veiligheidsvoorzieningen';

CREATE INDEX veiligh_install_geom_gist
  ON veiligh_install USING GIST(geom);

CREATE TABLE veiligh_bouwk
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(MultiLineString, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  soort                     veiligh_bouwk_type,
  bouwlaag_id               INTEGER         NOT NULL,
  fotografie_id             INTEGER,
  CONSTRAINT veiligh_bouwk_bouwlaag_id_fk  FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT veiligh_bouwk_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE veiligh_bouwk IS 'Bouwkundige veiligheidsvoorzieningen';

CREATE INDEX veiligh_bouwk_geom_gist
  ON veiligh_bouwk USING GIST(geom);

CREATE TABLE ruimten_type
(
  id        SERIAL
  naam      TEXT,
  CONSTRAINT ruimten_type_pk PRIMARY KEY (id),
  CONSTRAINT UC_naam UNIQUE (naam)
);
COMMENT ON TABLE ruimten_type IS 'Enumeratie van de verschillende soorten ruimtes in een pand.';
REVOKE ALL ON TABLE ruimten_type FROM GROUP oiv_write;

CREATE TABLE ruimten
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(MultiPolygon,28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  ruimten_type_id           TEXT,
  omschrijving              TEXT,
  bouwlaag_id               INTEGER         NOT NULL,
  fotografie_id             INTEGER,
  CONSTRAINT ruimten_type_id_fk FOREIGN KEY (ruimten_type_id) REFERENCES ruimten_type (naam),
  CONSTRAINT ruimten_bouwlaag_id_fk  FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT ruimten_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE ruimten IS 'Ruimten binnen een bouwlaag.';

CREATE INDEX ruimten_geom_gist
  ON ruimten USING GIST(geom);

CREATE TABLE ingang_type
(
  id            SMALLINT PRIMARY KEY NOT NULL,
  naam          TEXT,
  symbol_name   TEXT,
  size          INTEGER
);
COMMENT ON TABLE ingang_type IS 'Enumeratie van de verschillende soorten ingangen';
REVOKE ALL ON TABLE ingang_type FROM GROUP oiv_write;

CREATE TABLE ingang
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  ingang_type_id            INTEGER,
  rotatie                   INTEGER DEFAULT 0,
  label                     VARCHAR(50),
  belemmering               VARCHAR(254),
  voorzieningen             VARCHAR(254),  
  bouwlaag_id               INTEGER,
  object_id                 INTEGER,
  fotografie_id             INTEGER,
  CONSTRAINT ingang_type_id_fk    FOREIGN KEY (ingang_type_id) REFERENCES ingang_type (id),
  CONSTRAINT ingang_id_fk       FOREIGN KEY (bouwlaag_id)  REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT ingang_object_id_fk    FOREIGN KEY (object_id)    REFERENCES object (id)    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT ingang_fk_check    CHECK     (bouwlaag_id IS NOT NULL OR object_id IS NOT NULL),
  CONSTRAINT ingang_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE ingang IS 'Ingang t.b.v. een pand en dus een bouwlaag';

CREATE INDEX ingang_geom_gist
  ON ingang USING GIST(geom);

CREATE TABLE dreiging_type
(
  id            SMALLINT PRIMARY KEY NOT NULL,
  naam          TEXT,
  symbol_name   TEXT,
  size          INTEGER
);
COMMENT ON TABLE dreiging_type IS 'Enumeratie van de verschillende soorten dreigingen';
REVOKE ALL ON TABLE dreiging_type FROM GROUP oiv_write;

CREATE TABLE dreiging
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  dreiging_type_id          INTEGER,
  rotatie                   INTEGER DEFAULT 0,
  label                     VARCHAR(50),
  bouwlaag_id               INTEGER,
  object_id                 INTEGER,
  fotografie_id             INTEGER,
  CONSTRAINT dreiging_type_id_fk     FOREIGN KEY (dreiging_type_id)  REFERENCES dreiging_type (id),
  CONSTRAINT dreiging_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id)   REFERENCES bouwlagen (id)   ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT dreiging_object_id_fk   FOREIGN KEY (object_id)     REFERENCES object (id)    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT dreiging_fk_check       CHECK       (bouwlaag_id IS NOT NULL OR object_id IS NOT NULL),
  CONSTRAINT dreiging_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE dreiging IS 'Dreiging van een gevaar';

CREATE INDEX dreiging_geom_gist
  ON dreiging USING GIST(geom);

CREATE TABLE sleutelkluis_type
(
  id            SMALLINT PRIMARY KEY NOT NULL,
  naam          TEXT,
  symbol_name   TEXT,
  size          TEXT
);
COMMENT ON TABLE sleutelkluis_type IS 'Enumeratie van de verschillende soorten sleutelkluis';
REVOKE ALL ON TABLE sleutelkluis_type FROM GROUP oiv_write;

CREATE TABLE sleuteldoel_type
(
  id            SMALLINT PRIMARY KEY NOT NULL,
  naam          TEXT
);
COMMENT ON TABLE sleuteldoel_type IS 'Enumeratie van de verschillende doelen van de sleutel in de sleutelkluis';
REVOKE ALL ON TABLE sleuteldoel_type FROM GROUP oiv_write;

CREATE TABLE sleutelkluis
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  sleutelkluis_type_id      INTEGER,
  rotatie                   INTEGER DEFAULT 0,
  label                     VARCHAR(50),
  aanduiding_locatie        VARCHAR(254),
  sleuteldoel_type_id       INTEGER,  
  ingang_id                 INTEGER         NOT NULL,
  fotografie_id             INTEGER,
  CONSTRAINT sleutelkluis_type_id_fk FOREIGN KEY (sleutelkluis_type_id) REFERENCES sleutelkluis_type (id),
  CONSTRAINT sleuteldoel_type_id_fk  FOREIGN KEY (sleuteldoel_type_id)  REFERENCES sleuteldoel_type (id),
  CONSTRAINT sleutelkluis_ingang_id_fk FOREIGN KEY (ingang_id) REFERENCES ingang (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT sleutelkluis_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
COMMENT ON TABLE sleutelkluis IS 'Sleutelkluizen t.b.v. ingang een pand en dus een bouwlaag';

CREATE INDEX sleutelkluis_geom_gist
  ON sleutelkluis USING GIST(geom);

CREATE TABLE afw_binnendekking
(
  id                        SERIAL PRIMARY KEY      NOT NULL,
  geom                      GEOMETRY(Point, 28992),
  datum_aangemaakt          TIMESTAMP DEFAULT now(),
  datum_gewijzigd           TIMESTAMP,
  soort           afw_binnendekking_type NOT NULL,
  rotatie                   INTEGER DEFAULT 0,
  label                     VARCHAR(50),
  handelingsaanwijzing      VARCHAR(254),
  bouwlaag_id               INTEGER,
  object_id         INTEGER,
  CONSTRAINT afw_binnendekking_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT afw_binnendekking_object_id_fk   FOREIGN KEY (object_id)   REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT afw_binnendekking_fk_check     CHECK       (bouwlaag_id IS NOT NULL OR object_id IS NOT NULL)
);
COMMENT ON TABLE afw_binnendekking IS 'Afwijkende binnendekking';

CREATE INDEX afw_binnendekking_geom_gist
  ON afw_binnendekking USING GIST(geom);

CREATE TABLE aanwezig_type
(
  id           SMALLINT PRIMARY KEY      	NOT NULL,
  naam         TEXT,
  omschrijving TEXT
);
COMMENT ON TABLE aanwezig_type IS 'Opzoeklijst voor groep type aanwezige personen';

CREATE TABLE aanwezig
(
  id                SERIAL PRIMARY KEY      NOT NULL,
  datum_aangemaakt  TIMESTAMP DEFAULT now(),
  datum_gewijzigd   TIMESTAMP,
  aanwezig_type_id  SMALLINT				NOT NULL,
  dagen             TEXT,
  tijdvakbegin      TIME,
  tijdvakeind       TIME,
  aantal_totaal     SMALLINT,
  aantal_nietzelf_bewoners SMALLINT,
  bouwlaag_id 		  INTEGER 				NOT NULL,
  aantal_personeel  SMALLINT,
  dieren            BOOLEAN,
  CONSTRAINT aanwezig_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT aanwezig_groep_id_fk FOREIGN KEY (aanwezig_type_id) REFERENCES aanwezig_type (id)
);
COMMENT ON TABLE aanwezig IS 'Aanwezige personen';
COMMENT ON COLUMN aanwezig.aantal_totaal IS 'Aantal aanwezig';
COMMENT ON COLUMN aanwezig.aantal_nietzelf_bewoners IS 'Aantal niet aanwezig';

CREATE TABLE gevaarlijkestof_opslag
(
  id               SERIAL PRIMARY KEY       NOT NULL,
  geom             GEOMETRY(POINT, 28992),
  datum_aangemaakt TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd  TIMESTAMP WITH TIME ZONE,
  locatie          TEXT										NOT NULL,
  bouwlaag_id 	   INTEGER 								,
  object_id        INTEGER,
  fotografie_id    INTEGER,
  rotatie          INTEGER DEFAULT 0,
  CONSTRAINT opslag_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT opslag_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT opslag_fk_check CHECK  (bouwlaag_id IS NOT NULL OR object_id IS NOT NULL),
  CONSTRAINT gevaarlijkestof_opslag_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE INDEX opslag_geom_gist
  ON gevaarlijkestof_opslag (geom);
COMMENT ON TABLE gevaarlijkestof_opslag IS 'Lokaties waar stoffen worden opgeslagen';

CREATE TABLE gevaarlijkestof_vnnr
(
	id 				SERIAL 		NOT NULL,
	vn_nr 			VARCHAR(15) NOT NULL,
	gevi_nr 		VARCHAR(10) NOT NULL,
	eric_kaart 		VARCHAR(10) NOT NULL,
	CONSTRAINT gevaarlijkestof_vnnr_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE gevaarlijkestof_vnnr IS 'Opzoeklijst voor gevaarlijke stof vn_nr, gevi_nr en eric_kaart';
	
CREATE TABLE gevaarlijkestof
(
  id                          SERIAL PRIMARY KEY                     NOT NULL,
  opslag_id                   INTEGER                                NOT NULL,
  datum_aangemaakt            TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd             TIMESTAMP WITH TIME ZONE,
  omschrijving                TEXT,
  gevaarlijkestof_vnnr_id     INTEGER								NOT NULL,
  locatie                     TEXT,
  hoeveelheid                 INTEGER								NOT NULL,
  eenheid                     eenheid_type								NOT NULL,
  toestand                    toestand_type							NOT NULL,
  handelingsaanwijzing        TEXT,
  CONSTRAINT gevaarlijkestof_opslag_id_fk FOREIGN KEY (opslag_id) REFERENCES gevaarlijkestof_opslag (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT gevaarlijkestof_vnnr_id_fk FOREIGN KEY (gevaarlijkestof_vnnr_id) REFERENCES gevaarlijkestof_vnnr (id)
);
COMMENT ON COLUMN gevaarlijkestof.gevaarlijkestof_vnnr_id IS 'Stofidentificatienummer';

-- Aanmaken opzoektabel historie_matrix_code
CREATE TABLE historie_matrix_code
(
	id				SMALLINT PRIMARY KEY	      NOT NULL,
	matrix_code		CHARACTER VARYING(4)  	NOT NULL,
	omschrijving	TEXT					          NOT NULL,
	actualisatie	CHARACTER VARYING(1)	  NOT NULL,
	prio_prod 		INTEGER					        NOT NULL
);
COMMENT ON TABLE historie_matrix_code IS 'Opzoeklijst voor matrix code';

CREATE TABLE historie
(
  id                     SERIAL PRIMARY KEY                     NOT NULL,
  object_id              INTEGER                                NOT NULL,
  datum_aangemaakt       TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd        TIMESTAMP WITH TIME ZONE,
  teamlid_behandeld_id   INTEGER,
  teamlid_afgehandeld_id INTEGER,
  matrix_code_id		     SMALLINT								NOT NULL,
  status                 historie_status_type   NOT NULL,
  aanpassing              historie_aanpassing_type NOT NULL,
  CONSTRAINT historie_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT historie_teamlid_behandeld_id_fk FOREIGN KEY (teamlid_behandeld_id) REFERENCES algemeen.teamlid,
  CONSTRAINT historie_teamlid_afgehandeld_id_fk FOREIGN KEY (teamlid_afgehandeld_id) REFERENCES algemeen.teamlid,
  CONSTRAINT matrix_code_id_fk FOREIGN KEY (matrix_code_id) REFERENCES historie_matrix_code (id)
);

CREATE TABLE label
(
  id 					      SERIAL PRIMARY KEY 				NOT NULL,
  geom 					    GEOMETRY(Point,28992),
  datum_aangemaakt 	TIMESTAMP WITH TIME ZONE  DEFAULT now(),
  datum_gewijzigd 	TIMESTAMP WITH TIME ZONE,
  omschrijving 			CHARACTER VARYING(254)		NOT NULL,
  soort 			      labels_type           		NOT NULL,
  rotatie 				  INTEGER,
  bouwlaag_id 			INTEGER,
  object_id         INTEGER,
  CONSTRAINT labels_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES bouwlagen (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT labels_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT label_fk_check    CHECK       (bouwlaag_id IS NOT NULL OR object_id IS NOT NULL)
);

CREATE INDEX labels_geom_gist
  ON label
  USING btree
  (geom);
 
--Opzoeklijst pictogrammen zonder koppeling object
CREATE TABLE pictogram_zonder_object_type 
(
  id SMALLINT PRIMARY KEY NOT NULL,
  naam TEXT,
  categorie TEXT
);

-- Create pictogrammenlaag zonder object
CREATE TABLE pictogram_zonder_object
(
  id                   SERIAL PRIMARY KEY 						NOT NULL,
  geom                 GEOMETRY(POINT, 28992),
  datum_aangemaakt     TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd      TIMESTAMP WITH TIME ZONE,
  voorziening_pictogram_id SMALLINT 							NOT NULL,
  rotatie              INTEGER,
  label                TEXT,
  pand_id              CHARACTER VARYING(16)   					NOT NULL,
  CONSTRAINT voorziening_zonder_id_fk FOREIGN KEY (voorziening_pictogram_id) REFERENCES pictogram_zonder_object_type (id)
);
CREATE INDEX voorziening_zonder_geom_gist
  ON pictogram_zonder_object (geom);
COMMENT ON TABLE pictogram_zonder_object IS 'Voorzieningen zonder object';

CREATE INDEX voorziening__zonder_geom_gist
  ON pictogram_zonder_object
  USING btree
  (geom);

CREATE TABLE gevaarlijkestof_schade_cirkel 
(
	id 						     SERIAL PRIMARY KEY, 
	datum_aangemaakt 	 TIMESTAMP WITH TIME ZONE DEFAULT now(),
	datum_gewijzigd 	 TIMESTAMP WITH TIME ZONE, 
	straal 					   INTEGER NOT NULL, 
	soort        			 schade_cirkel_type NOT NULL, 
  gevaarlijkestof_id INTEGER NOT NULL,
  CONSTRAINT schade_cirkel_gevaarlijkestof_id_fk FOREIGN KEY (gevaarlijkestof_id) REFERENCES gevaarlijkestof (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE objecten.gt_pk_metadata_table
(
  table_schema character varying(32) NOT NULL,
  table_name character varying(32) NOT NULL,
  pk_column character varying(32) NOT NULL,
  pk_column_idx integer,
  pk_policy character varying(32),
  pk_sequence character varying(64),
  CONSTRAINT gt_pk_metadata_table_table_schema_table_name_pk_column_key UNIQUE (table_schema, table_name, pk_column),
  CONSTRAINT gt_pk_metadata_table_pk_policy_check CHECK (pk_policy::text = ANY (ARRAY['sequence'::character varying::text, 'assigned'::character varying::text, 'autogenerated'::character varying::text]))
);

CREATE TABLE sectoren
(
  id                     SERIAL PRIMARY KEY NOT NULL,
  geom                   geometry(MultiPolygon,28992),
  datum_aangemaakt       TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd        TIMESTAMP WITH TIME ZONE,
  soort                  sectoren_type,
  omschrijving           CHARACTER VARYING(254),
  label                  CHARACTER VARYING(50),
  object_id              INTEGER NOT NULL,
  fotografie_id          INTEGER,
  CONSTRAINT sectoren_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT sectoren_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX sectoren_geom_gist
  ON sectoren
  USING gist
  (geom);

COMMENT ON TABLE sectoren IS 'Bijzondere sectoren per repressief object';

CREATE TABLE gebruiksfunctie_type (
  id SMALLINT,
  naam TEXT,
  omschrijving TEXT,
  CONSTRAINT gebruiksfunctie_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE gebruiksfunctie_type IS 'Opzoeklijst voor gebruiksfunctie van repressief object';

CREATE TABLE gebruiksfunctie (
  id                      SERIAL NOT NULL,
  datum_aangemaakt        TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd         TIMESTAMP WITH TIME ZONE,
  gebruiksfunctie_type_id SMALLINT,
  object_id               INTEGER NOT NULL,
  CONSTRAINT gebruiksfunctie_pkey PRIMARY KEY (id),
  CONSTRAINT gebruiksfunctie_type_id_fk FOREIGN KEY (gebruiksfunctie_type_id) REFERENCES gebruiksfunctie_type (id),
  CONSTRAINT gebruiksfunctie_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE gebruiksfunctie IS 'Extra gebruiksfunctie van repressief object naast bgt/bag gebruiksdoel';

CREATE TABLE maatregel_type (
  id SMALLINT,
  naam TEXT,
  omschrijving TEXT,
  CONSTRAINT maatregel_type_pkey PRIMARY KEY (id),
  CONSTRAINT naam_unique UNIQUE (naam)
);
COMMENT ON TABLE gebruiksfunctie IS 'Opzoeklijst voor maatregelen t.b.v. dreiging';


CREATE TABLE beheersmaatregelen
( 
  id                      SERIAL PRIMARY KEY,
  datum_aangemaakt        TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd         TIMESTAMP WITH TIME ZONE,
  inzetfase               inzetfase_type,
  maatregel_type_id       SMALLINT,
  dreiging_id             INTEGER,
  CONSTRAINT beheersmaatregel_dreiging_id_fik FOREIGN KEY (dreiging_id) REFERENCES dreiging (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT maatregel_type_id_fk FOREIGN KEY (maatregel_type_id) REFERENCES maatregel_type (id)
);
COMMENT ON TABLE beheersmaatregelen IS 'Beheersmaatregelen t.b.v. dreiging';

CREATE TABLE isolijnen
( 
  id                      SERIAL PRIMARY KEY,
  geom                    geometry(MultiLineString, 28992),
  datum_aangemaakt        TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd         TIMESTAMP WITH TIME ZONE,
  hoogte                  SMALLINT,
  omschrijving            TEXT,
  object_id               INTEGER,
  CONSTRAINT isolijnen_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE isolijnen IS 'Hoogte en dieptelijnen behorende bij repressief object';

CREATE INDEX isolijnen_geom_gist
  ON isolijnen
  USING gist
  (geom);

CREATE TABLE terrein
(
  id        SERIAL PRIMARY KEY NOT NULL,
  geom      GEOMETRY(MULTIPOLYGON, 28992),
  datum_aangemaakt  TIMESTAMP WITH TIME ZONE DEFAULT now(),
    datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
  omschrijving  TEXT,
  object_id     INTEGER,
  CONSTRAINT terrein_object_id_fk  FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE bouwlagen IS 'Terreinen behorende bij een repressief object';

CREATE INDEX terrein_geom_gist
  ON terrein 
USING GIST(geom);

CREATE TABLE grid
(
  id        SERIAL primary key,
  geom              geometry(MultiPolygon, 28992),
  datum_aangemaakt  TIMESTAMP WITH TIME ZONE   DEFAULT now(),
  datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
  y_as_label   TEXT,
  x_as_label   TEXT,
  afstand INTEGER,  
  object_id     INTEGER,
  vaknummer CHARACTER VARYING(10),
  CONSTRAINT grid_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE bouwlagen IS 'Grid voor verdeling en verduidelijking locatie op terrein';

CREATE INDEX grid_geom_gist
  ON grid
USING GIST(geom);

-- Restricties voor opzoektabellen
REVOKE ALL ON TABLE aanwezig_type FROM GROUP oiv_write;
REVOKE ALL ON TABLE gevaarlijkestof_vnnr FROM GROUP oiv_write;
REVOKE ALL ON TABLE historie_matrix_code FROM GROUP oiv_write; 
REVOKE ALL ON TABLE pictogram_zonder_object_type FROM GROUP oiv_write;
REVOKE ALL ON TABLE gebruiksfunctie_type FROM GROUP oiv_write;
REVOKE ALL ON TABLE maatregel_type FROM GROUP oiv_write;