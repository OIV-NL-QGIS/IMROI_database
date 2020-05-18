SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

--toevoegen gebruiksfunctie aan repressief object en vullen vanuit wo
CREATE TABLE gebruiksfunctie_type (
  id SMALLINT,
  naam TEXT,
  omschrijving TEXT,
  CONSTRAINT gebruiksfunctie_type_pkey PRIMARY KEY (id)
);

REVOKE ALL ON TABLE gebruiksfunctie_type FROM GROUP oiv_write;

COMMENT ON TABLE gebruiksfunctie_type IS 'Opzoeklijst voor gebruiksfunctie van repressief object';

CREATE TABLE gebruiksfunctie (
  id SERIAL NOT NULL,
  datum_aangemaakt timestamp with time zone DEFAULT now(),
  datum_gewijzigd timestamp with time zone,
  gebruiksfunctie_type_id SMALLINT,
  object_id integer NOT NULL,
  CONSTRAINT gebruiksfunctie_pkey PRIMARY KEY (id),
  CONSTRAINT gebruiksfunctie_type_id_fk FOREIGN KEY (gebruiksfunctie_type_id)
      REFERENCES objecten.gebruiksfunctie_type (id),
  CONSTRAINT gebruiksfunctie_object_id_fk FOREIGN KEY (object_id)
      REFERENCES objecten.object (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

COMMENT ON TABLE gebruiksfunctie IS 'Extra gebruiksfunctie van repressief object naast bgt/bag gebruiksdoel';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON gebruiksfunctie
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON gebruiksfunctie
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

INSERT INTO gebruiksfunctie_type
SELECT * FROM waterongevallen.functie;

INSERT INTO gebruiksfunctie (gebruiksfunctie_type_id, object_id)
SELECT
  c.functie_id,
  cid.id
FROM waterongevallen.lokatiegegevens c
INNER JOIN 
 (SELECT wi.*, w.gegevens_id FROM waterongevallen.wo_id_conversie wi
	INNER JOIN waterongevallen.wo_lokatiegegevens w ON wi.wo_lokatie_id = w.id) cid ON c.id = cid.gegevens_id;

--scheepvaart toevoegen aan gebruiksfunctie
INSERT INTO gebruiksfunctie_type (id, naam) VALUES (15, 'beroepsvaart');
INSERT INTO gebruiksfunctie_type (id, naam) VALUES (16, 'pleziervaart');

INSERT INTO gebruiksfunctie (gebruiksfunctie_type_id, object_id)
SELECT
  CASE
   WHEN c.scheepvaart1_id = 2 THEN 15
   WHEN c.scheepvaart1_id = 3 THEN 16
  END,
  cid.id
FROM waterongevallen.lokatiegegevens c
INNER JOIN 
 (SELECT wi.*, w.gegevens_id FROM waterongevallen.wo_id_conversie wi
	INNER JOIN waterongevallen.wo_lokatiegegevens w ON wi.wo_lokatie_id = w.id) cid ON c.id = cid.gegevens_id;

INSERT INTO gebruiksfunctie (gebruiksfunctie_type_id, object_id)
SELECT
  CASE
   WHEN c.scheepvaart2_id = 2 THEN 15
   WHEN c.scheepvaart2_id = 3 THEN 16
  END,
  cid.id
FROM waterongevallen.lokatiegegevens c
INNER JOIN 
 (SELECT wi.*, w.gegevens_id FROM waterongevallen.wo_id_conversie wi
	INNER JOIN waterongevallen.wo_lokatiegegevens w ON wi.wo_lokatie_id = w.id) cid ON c.id = cid.gegevens_id;

ALTER TABLE waterongevallen.lokatiegegevens DROP CONSTRAINT wo_scheepvaart1_id_fk;
ALTER TABLE waterongevallen.lokatiegegevens DROP CONSTRAINT wo_scheepvaart2_id_fk;
ALTER TABLE waterongevallen.lokatiegegevens DROP CONSTRAINT wo_oever_kade_id_fk;
ALTER TABLE waterongevallen.lokatiegegevens DROP CONSTRAINT wo_stroming_id_fk;
ALTER TABLE waterongevallen.lokatiegegevens DROP CONSTRAINT wo_waterb_gem_id_fk;
ALTER TABLE waterongevallen.lokatiegegevens DROP CONSTRAINT wo_bodemstructuur_id_fk;
ALTER TABLE waterongevallen.lokatiegegevens DROP CONSTRAINT wo_functie_id_fk;

DROP TABLE waterongevallen.scheepvaart;
DROP TABLE waterongevallen.functie;
DROP TABLE waterongevallen.kade;
DROP TABLE waterongevallen.stroming;
DROP TABLE waterongevallen.bodemstructuur;

--toevoegen van kade als lijn aan bereikbaarheid
ALTER TYPE bereikbaarheid_type ADD VALUE 'oever-kade';

--beheersmaatregelen naar 1-n tabel gekoppeld aan dreiging
CREATE TABLE maatregel_type (
  id SMALLINT,
  naam TEXT,
  omschrijving TEXT,
  CONSTRAINT maatregel_type_pkey PRIMARY KEY (id) 
);

REVOKE ALL ON TABLE maatregel_type FROM GROUP oiv_write;

ALTER TABLE maatregel_type ADD CONSTRAINT naam_unique UNIQUE (naam);

INSERT INTO maatregel_type (id, naam)
SELECT DISTINCT row_number() OVER (ORDER BY maatregel) AS id, maatregel FROM
(
  SELECT DISTINCT REPLACE(aanrijden, '"', '') AS maatregel FROM waterongevallen.beheersmaatregelen_lijst WHERE aanrijden != ''
UNION
  SELECT DISTINCT REPLACE(ter_plaatse, '"', '') AS maatregel FROM waterongevallen.beheersmaatregelen_lijst WHERE ter_plaatse != ''
UNION
  SELECT DISTINCT REPLACE(te_water, '"', '') AS maatregel FROM waterongevallen.beheersmaatregelen_lijst WHERE te_water != ''
UNION
  SELECT DISTINCT REPLACE(nazorg, '"', '') AS maatregel FROM waterongevallen.beheersmaatregelen_lijst WHERE nazorg != ''
) p;

CREATE TABLE waterongevallen.dreiging AS
SELECT b.id, wo_lokatie_id, geom, datum_aangemaakt, datum_gewijzigd, bl.risico_gevaar AS dreiging_type, bl.id AS beh_lijst_id_oud
FROM waterongevallen.beheersmaatregelen b
INNER JOIN waterongevallen.beheersmaatregelen_lijst bl ON b.risico_gev_id = bl.id;

CREATE TYPE inzetfase_type AS ENUM('uitrukfase', 'verkenfase', 'inzetfase', 'afbouwfase', 'nazorgfase');

ALTER TABLE dreiging ADD COLUMN beheersmaatregel_id INTEGER;

INSERT INTO dreiging (geom, datum_aangemaakt, datum_gewijzigd, dreiging_type_id, object_id, beheersmaatregel_id)
SELECT d.geom, d.datum_aangemaakt, d.datum_gewijzigd, 129, c.id AS object_id, d.id
FROM waterongevallen.dreiging d
INNER JOIN waterongevallen.wo_id_conversie c ON d.wo_lokatie_id = c.wo_lokatie_id;

ALTER TABLE waterongevallen.wo_id_conversie ADD COLUMN dreiging_id_new SMALLINT;
UPDATE waterongevallen.wo_id_conversie c SET dreiging_id_new = p.id
FROM
(SELECT d.id, d.object_id FROM dreiging d INNER JOIN waterongevallen.beheersmaatregelen b ON d.beheersmaatregel_id = b.id) p
WHERE c.id = p.object_id;

CREATE TABLE beheersmaatregelen
( id SERIAL PRIMARY KEY,
  datum_aangemaakt timestamp with time zone DEFAULT now(),
  datum_gewijzigd timestamp with time zone,
  inzetfase objecten.inzetfase_type,
  maatregel_type_id SMALLINT,
  dreiging_id INTEGER,
  CONSTRAINT beheersmaatregel_dreiging_id_fik FOREIGN KEY (dreiging_id)
      REFERENCES objecten.dreiging (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT maatregel_type_id_fk FOREIGN KEY (maatregel_type_id)
      REFERENCES objecten.maatregel_type (id)
);

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON beheersmaatregelen
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON beheersmaatregelen
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

ALTER TABLE dreiging DROP COLUMN beheersmaatregel_id;

INSERT INTO beheersmaatregelen (datum_aangemaakt, datum_gewijzigd, inzetfase, maatregel_type_id, dreiging_id)
  SELECT datum_aangemaakt, datum_gewijzigd, 'uitrukfase'::objecten.inzetfase_type, m.id, c.dreiging_id_new 
  FROM waterongevallen.beheersmaatregelen b
  INNER JOIN waterongevallen.beheersmaatregelen_lijst bl ON b.risico_gev_id = bl.id
  INNER JOIN maatregel_type m ON bl.aanrijden = m.naam
  INNER JOIN waterongevallen.wo_id_conversie c ON b.wo_lokatie_id = c.wo_lokatie_id;

INSERT INTO beheersmaatregelen (datum_aangemaakt, datum_gewijzigd, inzetfase, maatregel_type_id, dreiging_id)
  SELECT datum_aangemaakt, datum_gewijzigd, 'verkenfase'::objecten.inzetfase_type, m.id, c.dreiging_id_new
  FROM waterongevallen.beheersmaatregelen b
  INNER JOIN waterongevallen.beheersmaatregelen_lijst bl ON b.risico_gev_id = bl.id
  INNER JOIN maatregel_type m ON bl.ter_plaatse = m.naam
  INNER JOIN waterongevallen.wo_id_conversie c ON b.wo_lokatie_id = c.wo_lokatie_id;

INSERT INTO beheersmaatregelen (datum_aangemaakt, datum_gewijzigd, inzetfase, maatregel_type_id, dreiging_id)
  SELECT datum_aangemaakt, datum_gewijzigd, 'inzetfase'::objecten.inzetfase_type, m.id, c.dreiging_id_new 
  FROM waterongevallen.beheersmaatregelen b
  INNER JOIN waterongevallen.beheersmaatregelen_lijst bl ON b.risico_gev_id = bl.id
  INNER JOIN maatregel_type m ON bl.te_water = m.naam
  INNER JOIN waterongevallen.wo_id_conversie c ON b.wo_lokatie_id = c.wo_lokatie_id;

INSERT INTO beheersmaatregelen (datum_aangemaakt, datum_gewijzigd, inzetfase, maatregel_type_id, dreiging_id)
  SELECT datum_aangemaakt, datum_gewijzigd, 'nazorgfase'::objecten.inzetfase_type, m.id, c.dreiging_id_new 
  FROM waterongevallen.beheersmaatregelen b
  INNER JOIN waterongevallen.beheersmaatregelen_lijst bl ON b.risico_gev_id = bl.id
  INNER JOIN maatregel_type m ON bl.nazorg = m.naam
  INNER JOIN waterongevallen.wo_id_conversie c ON b.wo_lokatie_id = c.wo_lokatie_id;

CREATE TABLE waterongevallen_backup.wo_beheersmaatregelen AS
SELECT b.*, bl.risico_gevaar, aanrijden, ter_plaatse, te_water, nazorg, omschrijving FROM waterongevallen.beheersmaatregelen b
INNER JOIN waterongevallen.beheersmaatregelen_lijst bl ON b.risico_gev_id = bl.id;

DROP TABLE waterongevallen.beheersmaatregelen;
DROP TABLE waterongevallen.beheersmaatregelen_lijst;
DROP TABLE waterongevallen.dreiging;

INSERT INTO dreiging_type (id, naam) VALUES (130, 'Stroming');

CREATE TABLE isolijnen
( id SERIAL,
  geom geometry(LineString,28992),
  datum_aangemaakt timestamp with time zone DEFAULT now(),
  datum_gewijzigd timestamp with time zone,
  hoogte SMALLINT,
  omschrijving TEXT,
  object_id INTEGER,
  CONSTRAINT isolijnen_object_id_fk FOREIGN KEY (object_id)
      REFERENCES object (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT isolijnen_pkey PRIMARY KEY (id)
);

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON isolijnen
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON isolijnen
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE INDEX isolijnen_geom_gist
  ON isolijnen
  USING gist
  (geom);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 0;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 304; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
  