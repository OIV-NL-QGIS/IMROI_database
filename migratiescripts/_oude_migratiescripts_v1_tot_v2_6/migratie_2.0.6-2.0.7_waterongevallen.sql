SET ROLE oiv_admin;

--DROP SCHEMA IF EXISTS waterongevallen CASCADE;

--CREATE SCHEMA waterongevallen;
COMMENT ON SCHEMA waterongevallen IS 'OIV waterongevallen';

GRANT USAGE ON SCHEMA waterongevallen TO GROUP oiv_read;

SET search_path = waterongevallen, pg_catalog, public;

-- Creeren van opzoektabellen voor waterongevallen
CREATE TABLE bodemstructuur
(
  id			SMALLINT PRIMARY KEY NOT NULL,
  naam			TEXT,
  omschrijving	TEXT
);
COMMENT ON TABLE bodemstructuur IS 'Opzoeklijst voor bodemstructuur waterongevallen';

CREATE TABLE functie
(
  id			SMALLINT PRIMARY KEY NOT NULL,
  naam			TEXT,
  omschrijving	TEXT
);
COMMENT ON TABLE functie IS 'Opzoeklijst voor functie waterongevallen';
  
CREATE TABLE scheepvaart
(
  id			SMALLINT PRIMARY KEY NOT NULL,
  naam			TEXT,
  omschrijving	TEXT
);
COMMENT ON TABLE scheepvaart IS 'Opzoeklijst voor scheepvaart waterongevallen';

CREATE TABLE stroming
(
  id			SMALLINT PRIMARY KEY NOT NULL,
  naam			TEXT,
  omschrijving	TEXT
);
COMMENT ON TABLE stroming IS 'Opzoeklijst voor stroming waterongevallen';

CREATE TABLE toetreding_water
(
  id			SMALLINT PRIMARY KEY NOT NULL,
  hoogte		TEXT,
  waterin		TEXT,
  wateruit		TEXT,
  nood			TEXT
);
COMMENT ON TABLE toetreding_water IS 'Opzoeklijst voor watertoetreding waterongevallen';

CREATE TABLE kade
(
  id			SMALLINT PRIMARY KEY NOT NULL,
  naam			TEXT,
  omschrijving	TEXT
);
COMMENT ON TABLE kade IS 'Opzoeklijst voor kade waterongevallen';

CREATE TABLE contactp_naam
(
  id			SMALLINT PRIMARY KEY NOT NULL,
  naam			TEXT,
  omschrijving	TEXT
);
COMMENT ON TABLE contactp_naam IS 'Opzoeklijst voor contactpersoon van het water';

CREATE TABLE pictogrammen_lijst
(
  id			SMALLINT PRIMARY KEY NOT NULL,
  naam			TEXT,
  omschrijving	TEXT
);
COMMENT ON TABLE pictogrammen_lijst IS 'Opzoeklijst voor de pictogrammen bij waterongevallen';

CREATE TABLE beheersmaatregelen_lijst
(
  id			SMALLINT PRIMARY KEY NOT NULL,
  risico_gevaar	TEXT,
  aanrijden		TEXT,
  ter_plaatse	TEXT,
  te_water		TEXT,
  nazorg		TEXT,
  omschrijving	TEXT
);
COMMENT ON TABLE beheersmaatregelen_lijst IS 'Opzoeklijst voor de beheersmaatregelen bij waterongevallen';

-- aanmaken van lokatie tabel (de geometrie tabel)
CREATE TABLE lokatiegegevens
(
  id				SERIAL PRIMARY KEY NOT NULL,
  datum_aangemaakt  TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
  lokatienaam		VARCHAR(255),
  straatnaam		VARCHAR(255),
  max_diepte		INTEGER,
  kade_diepte_id	SMALLINT,
  bijzonderheden	TEXT,
  oever_kade_id		SMALLINT,
  functie_id		SMALLINT,
  stroming_id		SMALLINT,
  waterb_gem_id		SMALLINT,
  scheepvaart1_id	SMALLINT,
  scheepvaart2_id	SMALLINT,
  bodemstructuur_id	SMALLINT,
  CONSTRAINT wo_oever_kade_id_fk FOREIGN KEY (oever_kade_id) REFERENCES kade (id),
  CONSTRAINT wo_kade_diepte_id_fk FOREIGN KEY (kade_diepte_id) REFERENCES toetreding_water (id),
  CONSTRAINT wo_functie_id_fk FOREIGN KEY (functie_id) REFERENCES functie (id),
  CONSTRAINT wo_stroming_id_fk FOREIGN KEY (stroming_id) REFERENCES stroming (id),
  CONSTRAINT wo_waterb_gem_id_fk FOREIGN KEY (waterb_gem_id) REFERENCES stroming (id),
  CONSTRAINT wo_scheepvaart1_id_fk FOREIGN KEY (scheepvaart1_id) REFERENCES scheepvaart (id),
  CONSTRAINT wo_scheepvaart2_id_fk FOREIGN KEY (scheepvaart2_id) REFERENCES scheepvaart (id),
  CONSTRAINT wo_bodemstructuur_id_fk FOREIGN KEY (bodemstructuur_id) REFERENCES bodemstructuur (id)
);

-- De tabel lokatiegegevens kan worden gekoppeld aan meerdere lokaties
CREATE TABLE lokatie
(
  id				SERIAL PRIMARY KEY NOT NULL,
  wo_gegevens_id	SMALLINT NOT NULL,
  geom				GEOMETRY(POINT, 28992),
  datum_aangemaakt  TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
  CONSTRAINT lokatie_wo_gegevens_id_fk FOREIGN KEY (wo_gegevens_id) REFERENCES lokatiegegevens (id) ON DELETE CASCADE
);
CREATE INDEX lokatie_geom_gist
  ON lokatie (geom);

-- Tabel beheersmaatregelen worden gekoppeld aan een pictogram welke gekoppeld is aan lokatiegegevens
CREATE TABLE beheersmaatregelen
(
  id				SERIAL PRIMARY KEY NOT NULL,
  wo_lokatie_id		SMALLINT NOT NULL,
  geom				GEOMETRY(POINT, 28992),
  datum_aangemaakt  TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
  risico_gev_id		SMALLINT NOT NULL,
  CONSTRAINT beheer_wo_lokatie_id_fk FOREIGN KEY (wo_lokatie_id) REFERENCES lokatie (id) ON DELETE CASCADE,
  CONSTRAINT beheersmaatregelen_lijst_id_fk FOREIGN KEY (risico_gev_id) REFERENCES beheersmaatregelen_lijst (id)
);
CREATE INDEX beheersm_geom_gist
  ON beheersmaatregelen (geom);
COMMENT ON TABLE beheersmaatregelen IS 'Beheersmaatregelen ten behoeve van de risicos en gevaren';
  
CREATE TABLE contactpersonen
(
  id				SERIAL PRIMARY KEY NOT NULL,
  wo_gegevens_id	SMALLINT NOT NULL,
  datum_aangemaakt  TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
  contactpers_id	SMALLINT NOT NULL,
  tel_nr			VARCHAR(11),
  CONSTRAINT contactp_wo_gegevens_id_fk FOREIGN KEY (wo_gegevens_id) REFERENCES lokatiegegevens (id) ON DELETE CASCADE,
  CONSTRAINT contactpers_id_fk FOREIGN KEY (contactpers_id) REFERENCES contactp_naam (id)
);

CREATE TABLE pictogrammen
(
  id				SERIAL PRIMARY KEY NOT NULL,
  wo_lokatie_id		SMALLINT NOT NULL,
  geom				GEOMETRY(POINT, 28992),
  datum_aangemaakt  TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
  pictogrammen_id	SMALLINT NOT NULL,
  opmerking			VARCHAR(255),
  CONSTRAINT pictogrammen_wo_lokatie_id_fk FOREIGN KEY (wo_lokatie_id) REFERENCES lokatie (id) ON DELETE CASCADE,
  CONSTRAINT pictogrammen_id_fk FOREIGN KEY (pictogrammen_id) REFERENCES pictogrammen_lijst (id)
); 
CREATE INDEX pictogrammen_geom_gist
  ON pictogrammen (geom);

CREATE TABLE historie_status
(
  id   SMALLINT PRIMARY KEY NOT NULL,
  naam TEXT
);

CREATE TABLE historie_aanpassing
(
  id   SMALLINT PRIMARY KEY NOT NULL,
  naam TEXT
);

CREATE TABLE historie
(
  id                     SERIAL PRIMARY KEY                     NOT NULL,
  wo_gegevens_id         SMALLINT                               NOT NULL,
  datum_aangemaakt       TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  datum_gewijzigd        TIMESTAMP WITH TIME ZONE,
  teamlid_behandeld_id   SMALLINT,
  historie_status_id     SMALLINT,
  historie_aanpassing_id SMALLINT,
  opmerking				 TEXT,
  CONSTRAINT historie_wo_gegevens_id_fk FOREIGN KEY (wo_gegevens_id) REFERENCES lokatiegegevens (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT historie_teamlid_behandeld_id_fk FOREIGN KEY (teamlid_behandeld_id) REFERENCES algemeen.teamlid (id),
  CONSTRAINT historie_historie_status_id_fk FOREIGN KEY (historie_status_id) REFERENCES historie_status (id),
  CONSTRAINT historie_aanpassing_id_fk FOREIGN KEY (historie_aanpassing_id) REFERENCES historie_aanpassing (id)
);

CREATE TABLE label_type
(
  id 					SMALLINT PRIMARY KEY NOT NULL,
  type_label 			VARCHAR(15)
);
COMMENT ON TABLE label_type IS 'Opzoeklijst voor type label';

CREATE TABLE labels_wo
(
  id 					SERIAL NOT NULL,
  wo_lokatie_id 		integer NOT NULL,
  geom 					geometry(Point,28992),
  datum_aangemaakt 		timestamp with time zone DEFAULT now(),
  datum_gewijzigd 		timestamp with time zone,
  omschrijving 			TEXT,
  type_label 			integer NOT NULL,
  rotatie 				integer,
  CONSTRAINT labels_pkey PRIMARY KEY (id),
  CONSTRAINT labels_wo_lokatie_id_fk FOREIGN KEY (wo_lokatie_id) REFERENCES lokatie (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT labels_type_id_fk FOREIGN KEY (type_label) REFERENCES label_type (id)
);

CREATE INDEX labels_geom_gist
  ON labels_wo
  USING btree
  (geom);

CREATE TABLE dieptes
(
  id 					SMALLINT PRIMARY KEY NOT NULL,
  naam		 			VARCHAR(15)
);
COMMENT ON TABLE dieptes IS 'Opzoeklijst voor dieptes bij dieptelijnen';

CREATE TABLE dieptelijnen
(
  id 					SERIAL NOT NULL,
  geom 					geometry(MultiLinestring,28992),
  datum_aangemaakt 		timestamp with time zone DEFAULT now(),
  datum_gewijzigd 		timestamp with time zone,
  diepte_id				integer NOT NULL,
  omschrijving 			TEXT,
  CONSTRAINT dieptelijnen_pkey PRIMARY KEY (id),
  CONSTRAINT dieptes_id_fk FOREIGN KEY (diepte_id) REFERENCES dieptes (id)
);

CREATE INDEX dieptelijnen_geom_gist
  ON dieptelijnen
  USING gist
  (geom);

CREATE TABLE dieptevlakken
(
  id 					SERIAL NOT NULL,
  geom 					geometry(MultiPolygon,28992),
  datum_aangemaakt 		timestamp with time zone DEFAULT now(),
  datum_gewijzigd 		timestamp with time zone,
  diepte_id				integer NOT NULL,
  omschrijving 			TEXT,
  CONSTRAINT dieptevlakken_pkey PRIMARY KEY (id),
  CONSTRAINT dieptes_id_fk FOREIGN KEY (diepte_id) REFERENCES dieptes (id)
);

CREATE INDEX dieptevlakken_geom_gist
  ON dieptevlakken
  USING gist
  (geom);
  
-- Restricties voor opzoektabellen
REVOKE ALL ON TABLE bodemstructuur FROM GROUP oiv_write;
REVOKE ALL ON TABLE scheepvaart FROM GROUP oiv_write;
REVOKE ALL ON TABLE functie FROM GROUP oiv_write;
REVOKE ALL ON TABLE stroming FROM GROUP oiv_write;
REVOKE ALL ON TABLE pictogrammen_lijst FROM GROUP oiv_write;
REVOKE ALL ON TABLE contactp_naam FROM GROUP oiv_write;
REVOKE ALL ON TABLE kade FROM GROUP oiv_write;
REVOKE ALL ON TABLE toetreding_water FROM GROUP oiv_write;
REVOKE ALL ON TABLE beheersmaatregelen_lijst FROM GROUP oiv_write;
REVOKE ALL ON TABLE historie_status FROM GROUP oiv_write;
REVOKE ALL ON TABLE historie_aanpassing FROM GROUP oiv_write;
REVOKE ALL ON TABLE label_type FROM GROUP oiv_write;
REVOKE ALL ON TABLE dieptes FROM GROUP oiv_write;

-- Opzoektabellen vullen
SET role oiv_admin;
SET search_path = waterongevallen, pg_catalog, public;

INSERT INTO waterongevallen.historie_aanpassing (id, naam) VALUES (1, 'aanpassing');
INSERT INTO waterongevallen.historie_aanpassing (id, naam) VALUES (2, 'nieuw');
INSERT INTO waterongevallen.historie_aanpassing (id, naam) VALUES (3, 'update');

INSERT INTO waterongevallen.historie_status (id, naam) VALUES (1, 'concept');
INSERT INTO waterongevallen.historie_status (id, naam) VALUES (2, 'in gebruik');
INSERT INTO waterongevallen.historie_status (id, naam) VALUES (3, 'archief');

INSERT INTO waterongevallen.label_type (id, type_label) VALUES (1, 'Algemeen'), (2, 'Gevaar'), (3, 'Voorzichtig'),	(4, 'Waarschuwing');

INSERT INTO waterongevallen.bodemstructuur (id, naam) VALUES (1, 'n.n.b.');
INSERT INTO waterongevallen.bodemstructuur (id, naam) VALUES (2, 'klei');
INSERT INTO waterongevallen.bodemstructuur (id, naam) VALUES (3, 'slib');
INSERT INTO waterongevallen.bodemstructuur (id, naam) VALUES (4, 'zand');

INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (1, 'n.b.');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (2, 'beheerder');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (3, 'brugwachter');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (4, 'eigenaar');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (5, 'gebruiker');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (6, 'gemeente');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (7, 'havendienst');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (8, 'hoogheemraadschap');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (9, 'kantine');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (10, 'kustwachtcentrum');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (11, 'provincie');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (12, 'PWN');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (13, 'receptie');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (14, 'reddingsbrigade');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (15, 'sluiswachter');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (16, 'staatsbosbeheer');
INSERT INTO waterongevallen.contactp_naam (id, naam) VALUES (17, 'zwemwatertelefoon');

INSERT INTO waterongevallen.functie (id, naam) VALUES (1, 'brug');
INSERT INTO waterongevallen.functie (id, naam) VALUES (2, 'gemaal');
INSERT INTO waterongevallen.functie (id, naam) VALUES (3, 'gracht');
INSERT INTO waterongevallen.functie (id, naam) VALUES (4, 'haven');
INSERT INTO waterongevallen.functie (id, naam) VALUES (5, 'kanaal');
INSERT INTO waterongevallen.functie (id, naam) VALUES (6, 'naviduct');
INSERT INTO waterongevallen.functie (id, naam) VALUES (7, 'pont');
INSERT INTO waterongevallen.functie (id, naam) VALUES (8, 'recreatieplas');
INSERT INTO waterongevallen.functie (id, naam) VALUES (9, 'ringvaart');
INSERT INTO waterongevallen.functie (id, naam) VALUES (10, 'sloot');
INSERT INTO waterongevallen.functie (id, naam) VALUES (11, 'sluis');
INSERT INTO waterongevallen.functie (id, naam) VALUES (12, 'vlotbrug');
INSERT INTO waterongevallen.functie (id, naam) VALUES (13, 'waterberging');
INSERT INTO waterongevallen.functie (id, naam) VALUES (14, 'waterwinstation');

INSERT INTO waterongevallen.kade (id, naam) VALUES (1, 'hoge wal (> 1 mtr)');
INSERT INTO waterongevallen.kade (id, naam) VALUES (2, 'lage wal (< 1 mtr)');
INSERT INTO waterongevallen.kade (id, naam) VALUES (3, 'steigers');

INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (1, '1');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (2, '2');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (3, '3');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (4, '4');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (5, '5');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (6, '6');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (7, '7');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (8, '8');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (9, '9');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (10, '10');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (11, '11');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (12, '12');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (13, '13');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (14, '14');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (15, '15');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (16, '>15');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (17, 'Gevaar');
INSERT INTO waterongevallen.pictogrammen_lijst (id, naam) VALUES (19, 'Boot te water laat plaats');

INSERT INTO waterongevallen.scheepvaart (id, naam) VALUES (1, 'n.v.t.');
INSERT INTO waterongevallen.scheepvaart (id, naam) VALUES (2, 'beroepsvaart');
INSERT INTO waterongevallen.scheepvaart (id, naam) VALUES (3, 'pleziervaart');

INSERT INTO waterongevallen.stroming (id, naam) VALUES (1, 'n.v.t.');
INSERT INTO waterongevallen.stroming (id, naam) VALUES (2, '< 0,5 m/s');
INSERT INTO waterongevallen.stroming (id, naam) VALUES (3, '> 0,5 m/s');

INSERT INTO waterongevallen.toetreding_water (id, hoogte, waterin, wateruit, nood) VALUES (1, 'lengte i.v.m. stenen/riet', 'ladder', 'ladder', 'redvoertuig of oranje bak');
INSERT INTO waterongevallen.toetreding_water (id, hoogte, waterin, wateruit, nood) VALUES (2, '"hoogte kade tot 1 mtr, diepte + kade < 5 mtr"', 'handreiking', 'ladder', 'rednet');
INSERT INTO waterongevallen.toetreding_water (id, hoogte, waterin, wateruit, nood) VALUES (3, '"hoogte kade tot 3 mtr, diepte + kade < 5 mtr"', 'ladder', 'ladder', 'rednet');
INSERT INTO waterongevallen.toetreding_water (id, hoogte, waterin, wateruit, nood) VALUES (4, '"hoogte kade tot 5 mtr, diepte + kade > 5 mtr"', 'redvoertuig', 'redvoertuig', 'redvoertuig');

INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (1, 'Afgesloten binnenwater', 'Boot alarmeren (brandweer)', '', '', '');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (2, '"Brug, sluis, uit/inlaat, pomp, gemaal"', '', 'Pompen dien uitgeschakeld te zijn', '', '');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (3, 'Dieper dan 9 meter', '', '', 'Dieptemeter bewaken/gebruiken', 'Arbodienst in kennis stellen');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (4, 'Dieper dan 15 meter', 'Alarmeren DDG', '"Inzetgebied, 15 meter diepte lijn bepalen"', '"Dieptemeter bewaken/gebruiken, Fysiek voorkomen dieper dan bv knoop in seinlijn"', 'Arbodienst in kennis stellen');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (5, 'Duiken bij scheepvaart verkeer (procedure)', '"Waterbeheerder / Havendienst, Alarmeren boot"', '"Duikvlag, Fysiek personen op de uitkijk, Boot fysiek duikgebied laten blokkeren"', '"Duiker blijft binnen cirkel van 50 meter van de vlag"', '');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (6, 'Duiken onder schepen (procedure)', '"Waterbeheerder / Havendienst"', '"Motor / schroef uit, contactsleutels innemen"', 'Niet opkomen tussen boot en wal of twee schepen', '');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (7, 'Gaten in de bodem van een 1 meter diep', '', '', '"Uittrimmen, zwevend boven bodem"', '');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (8, 'Kunstwerken (procedure)', '"Beheerder alarmeren"', '"Schut en spui deuren gesloten en geborgd"', '', '');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (9, 'Obstakels op bodem', '', '"DP-1 gebruiksklaar"', '"Seinlijn strak houden, Tactiek, aan walkant beginnen"', '');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (10, 'Stroming (procedure)', '"Alarmen Boot, e.v.t. tweede, Opschalen Middel-Incident"', '"Zoek gebied vast stellen, stromingssnelheid, Boot stroomafwaarts met zuurstofkoffer"', '"Verzwaren?"', '');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (11, 'Vaargeul', '"Dwarsdoorsnede bekijken"', '"DP-1 gebruiksklaar"', '"Tactiek aanpassen, voorkom jojo-en, Seinlijn kan vast raken"', '');
INSERT INTO waterongevallen.beheersmaatregelen_lijst (id, risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg) VALUES (12, 'Zout of brak water', '"Duiker verzwaren  max. 1 kg"', '', '', '');

INSERT INTO waterongevallen.dieptes (id, naam) VALUES (1, '3 meter');
INSERT INTO waterongevallen.dieptes (id, naam) VALUES (2, '9 meter');
INSERT INTO waterongevallen.dieptes (id, naam) VALUES (3, '15 meter');
-- Update versie
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 6;