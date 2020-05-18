-- Opzoektabellen vullen
set role oiv_admin;

SET search_path = objecten, pg_catalog, public;

-- Drop webgis views
DROP VIEW IF EXISTS objecten.webgis_aanwezig;
DROP VIEW IF EXISTS objecten.webgis_gevaarlijkestof;
DROP VIEW IF EXISTS objecten.webgis_historie;
DROP VIEW IF EXISTS objecten.webgis_object;
DROP VIEW IF EXISTS objecten.webgis_opslag;
DROP VIEW IF EXISTS objecten.webgis_scheiding;
DROP VIEW IF EXISTS objecten.webgis_voorziening;

-- Nieuwe velden voor object
ALTER TABLE object
   ADD COLUMN pers_max integer;
ALTER TABLE object
   ADD COLUMN pers_nietz_max integer;

-- Oude velden verwijderen uit object
ALTER TABLE object
   DROP COLUMN straatnaam;
ALTER TABLE object
   DROP COLUMN huisnummer;
ALTER TABLE object
   DROP COLUMN plaats;
   
ALTER TABLE voorziening_pictogram
	ADD COLUMN categorie TEXT;

CREATE TABLE vlakken
(
  id serial NOT NULL,
  object_id integer NOT NULL,
  geom geometry(MultiPolygon,28992),
  datum_aangemaakt TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
  datum_gewijzigd TIMESTAMP WITH TIME ZONE,
  omschrijving TEXT,
  CONSTRAINT vlakken_pkey PRIMARY KEY (id),
  CONSTRAINT vlakken_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE CASCADE
);
COMMENT ON TABLE vlakken IS 'Algemeen vlakken ter verduidelijking van de BAG';

CREATE INDEX vlakken_geom_gist
  ON vlakken
  USING btree
  (geom);
  
CREATE TABLE label_type
(
  id smallint NOT NULL,
  type_label varchar(15),
  CONSTRAINT labels_type_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE label_type IS 'Opzoeklijst voor type label';

CREATE TABLE object_labels
(
  id serial NOT NULL,
  object_id integer NOT NULL,
  geom geometry(Point,28992),
  datum_aangemaakt timestamp with time zone DEFAULT now(),
  datum_gewijzigd timestamp with time zone,
  omschrijving TEXT,
  type_label integer NOT NULL,
  rotatie integer NOT NULL,
  CONSTRAINT labels_pkey PRIMARY KEY (id),
  CONSTRAINT labels_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT labels_type_id_fk FOREIGN KEY (type_label) REFERENCES label_type (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX labels_geom_gist
  ON object_labels
  USING btree
  (geom);

-- Restricties voor opzoektabellen
REVOKE ALL ON TABLE label_type FROM GROUP oiv_write;

-- Nieuwe opzoek waarden
INSERT INTO label_type (id, type_label) VALUES (1, 'Algemeen'), (2, 'Gevaar'), (3, 'Voorzichtig'),	(4, 'Waarschuwing');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON vlakken
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON object_labels
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

-- Opzoek view
CREATE OR REPLACE VIEW view_voorziening_pictogram AS 
 SELECT v.id,
    concat(v.categorie, ' - ', v.naam) AS categorie
   FROM voorziening_pictogram v
  ORDER BY (concat(v.categorie, ' - ', v.naam));

-- Opzoek waarden bijwerken
UPDATE voorziening_pictogram SET categorie = 'Toetreding' WHERE id =35;
UPDATE voorziening_pictogram SET categorie = 'Voorziening' WHERE id =149;
UPDATE voorziening_pictogram SET categorie = 'Voorziening' WHERE id =154;
UPDATE voorziening_pictogram SET categorie = 'Voorziening' WHERE id =152;
UPDATE voorziening_pictogram SET categorie = 'Voorziening' WHERE id =151;
UPDATE voorziening_pictogram SET categorie = 'Voorziening' WHERE id =150;
UPDATE voorziening_pictogram SET categorie = 'Voorziening' WHERE id =147;
UPDATE voorziening_pictogram SET categorie = 'Toetreding', naam = 'Trap bordes' WHERE id =153;
UPDATE voorziening_pictogram SET categorie = 'Toetreding' WHERE id =173;
UPDATE voorziening_pictogram SET categorie = 'Toetreding' WHERE id =174;
UPDATE voorziening_pictogram SET categorie = 'Communicatie' WHERE id =18;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =7;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =8;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =11;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =9;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =12;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =14;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =13;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =15;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =16;
UPDATE voorziening_pictogram SET categorie = 'Blussysteem' WHERE id =23;
UPDATE voorziening_pictogram SET categorie = 'Blussysteem' WHERE id =25;
UPDATE voorziening_pictogram SET categorie = 'Blussysteem' WHERE id =26;
UPDATE voorziening_pictogram SET categorie = 'Blussysteem' WHERE id =171;
UPDATE voorziening_pictogram SET categorie = 'Blussysteem' WHERE id =172;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =22;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =38;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =43;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =42;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =45;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =48;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =49;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =145;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =17;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =146;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =166;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =168;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =167;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =169;
UPDATE voorziening_pictogram SET categorie = 'Gevaar' WHERE id =170;
UPDATE voorziening_pictogram SET categorie = 'Communicatie' WHERE id =20;
UPDATE voorziening_pictogram SET categorie = 'BMC' WHERE id =30;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =156;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =157;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =159;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =158;
UPDATE voorziening_pictogram SET categorie = 'Afsluiter' WHERE id =164;
UPDATE voorziening_pictogram SET categorie = 'BMC' WHERE id =163;
UPDATE voorziening_pictogram SET categorie = 'BMC' WHERE id =162;
UPDATE voorziening_pictogram SET categorie = 'BMC' WHERE id =161;
UPDATE voorziening_pictogram SET categorie = 'Toetreding' WHERE id =160;
UPDATE voorziening_pictogram SET categorie = 'Toetreding' WHERE id =165;
UPDATE voorziening_pictogram SET categorie = 'Toetreding' WHERE id =32;
UPDATE voorziening_pictogram SET categorie = 'Toetreding' WHERE id =148;
UPDATE voorziening_pictogram SET categorie = 'Toetreding' WHERE id =47;
UPDATE voorziening_pictogram SET categorie = 'Toetreding' WHERE id =50;
INSERT INTO voorziening_pictogram VALUES (175, 'GEVI bord', 'Gevaar');
INSERT INTO voorziening_pictogram VALUES (173, 'Trap rond', 'Toetreding');
INSERT INTO voorziening_pictogram VALUES (174, 'Trap recht', 'Toetreding');
INSERT INTO voorziening_pictogram VALUES (171, 'Blussysteem Hi-Fog', 'Blussysteem');
INSERT INTO voorziening_pictogram VALUES (172, 'Blussysteem AFFF', 'Blussysteem');
INSERT INTO voorziening_pictogram VALUES (166, 'Ontvlambare stoffen', 'Gevaar');
INSERT INTO voorziening_pictogram VALUES (168, 'Bijtende stoffen', 'Gevaar');
INSERT INTO voorziening_pictogram VALUES (167, 'Giftige stoffen', 'Gevaar');
INSERT INTO voorziening_pictogram VALUES (169, 'Oxiderende stoffen', 'Gevaar');
INSERT INTO voorziening_pictogram VALUES (170, 'Explosieve stoffen', 'Gevaar');
INSERT INTO voorziening_pictogram VALUES (164, 'Afsluiter luchtbehandeling', 'Afsluiter');
INSERT INTO voorziening_pictogram VALUES (163, 'Ontruimingspaneel', 'BMC');
INSERT INTO voorziening_pictogram VALUES (162, 'Brandmeldcentrale', 'BMC');
INSERT INTO voorziening_pictogram VALUES (161, 'Nevenbrandweerpaneel', 'BMC');
INSERT INTO voorziening_pictogram VALUES (160, 'Verzamelplaats', 'Toetreding');
INSERT INTO voorziening_pictogram VALUES (165, 'Lift', 'Toetreding');

-- Views voor web weergave, bijvoorbeeld geoserver
CREATE OR REPLACE VIEW webgis_scheiding AS
  SELECT
    scheiding.*,
    scheiding_type.naam
  FROM scheiding
    LEFT JOIN scheiding_type ON scheiding_type.id = scheiding_type_id;

CREATE OR REPLACE VIEW webgis_object AS
  SELECT
    object.*,
    object_gebruiktype.naam     gebruiktype,
    object_bouwconstructie.naam bouwconstructie,
    team.naam                   team
  FROM object
    LEFT JOIN object_gebruiktype ON object_gebruiktype.id = object_gebruiktype_id
    LEFT JOIN object_bouwconstructie ON object_bouwconstructie.id = object_bouwconstructie_id
    LEFT JOIN algemeen.team ON team.id = team_id;

CREATE OR REPLACE VIEW webgis_voorziening AS
  SELECT
    voorziening.*,
    voorziening_pictogram.naam pictogram
  FROM voorziening
    LEFT JOIN voorziening_pictogram ON voorziening_pictogram.id = voorziening_pictogram_id;

CREATE OR REPLACE VIEW webgis_opslag AS
  SELECT
    opslag.*,
    count(gevaarlijkestof) gevaarlijkestof_aantal
  FROM opslag
    LEFT JOIN gevaarlijkestof ON gevaarlijkestof.opslag_id = opslag.id
  GROUP BY opslag.id;

CREATE OR REPLACE VIEW webgis_gevaarlijkestof AS
  SELECT
    gevaarlijkestof.*,
    gevaarlijkestof_eenheid.naam  eenheid,
    gevaarlijkestof_gevi.nummer   gevi,
    gevaarlijkestof_toestand.naam toestand
  FROM gevaarlijkestof
    LEFT JOIN gevaarlijkestof_eenheid ON gevaarlijkestof_eenheid.id = gevaarlijkestof_eenheid_id
    LEFT JOIN gevaarlijkestof_gevi ON gevaarlijkestof_gevi.id = gevaarlijkestof_gevi_id
    LEFT JOIN gevaarlijkestof_toestand ON gevaarlijkestof_toestand.id = gevaarlijkestof_toestand_id;

CREATE OR REPLACE VIEW webgis_aanwezig AS
  SELECT
    aanwezig.*,
    aanwezig_groep.naam groep
  FROM aanwezig
    LEFT JOIN aanwezig_groep ON aanwezig_groep.id = aanwezig_groep_id;

CREATE OR REPLACE VIEW webgis_historie AS
  SELECT
    historie.*,
    historie_aanpassing.naam aanpassing,
    historie_status.naam     status,
    teamlid_behandeld.naam   teamlid_behandeld,
    teamlid_afgehandeld.naam teamlid_afgehandeld
  FROM historie
    LEFT JOIN historie_aanpassing ON historie_aanpassing.id = historie_aanpassing_id
    LEFT JOIN historie_status ON historie_status.id = historie_status_id
    LEFT JOIN algemeen.teamlid teamlid_behandeld ON teamlid_behandeld.id = teamlid_behandeld_id
    LEFT JOIN algemeen.teamlid teamlid_afgehandeld ON teamlid_afgehandeld.id = teamlid_afgehandeld_id;

UPDATE algemeen.applicatie SET sub = 2;
