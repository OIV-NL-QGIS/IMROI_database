SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TABLE gebiedsgerichte_aanpak_type
(
  id smallint NOT NULL,
  naam character varying(50),
  CONSTRAINT gebiedsgerichte_aanpak_type_pkey PRIMARY KEY (id),
  CONSTRAINT naam_uk UNIQUE (naam)
);

CREATE TABLE gebiedsgerichte_aanpak
(
  id serial NOT NULL,
  geom geometry(MultiLineString,28992),
  datum_aangemaakt timestamp with time zone DEFAULT now(),
  datum_gewijzigd timestamp with time zone,
  soort character varying(50),
  label character varying(254),  
  bijzonderheden text,
  object_id integer NOT NULL,
  fotografie_id integer,
  CONSTRAINT gebiedsgerichte_aanpak_pkey PRIMARY KEY (id),
  CONSTRAINT gebiedsgerichte_aanpak_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT gebiedsgerichte_aanpak_object_id_fk FOREIGN KEY (object_id)
      REFERENCES objecten.object (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT soort_id_fk FOREIGN KEY (soort)
      REFERENCES objecten.gebiedsgerichte_aanpak_type (naam) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON gebiedsgerichte_aanpak
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON gebiedsgerichte_aanpak
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON points_of_interest
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON points_of_interest
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

INSERT INTO gebiedsgerichte_aanpak_type (id, naam) VALUES
	 (1, 'Beheer bos: 100%')
	,(2, 'Beheer bos: 60%')
	,(3, 'Beheer bos: 30%')
	,(4, 'Beheer bos: 0%')
	,(5, 'Beheer heide: 100%')
	,(6, 'Beheer heide: niet gereed')
	,(7, 'Beheer heide: subcompartiment')
	,(8, 'Stoplijn in heide/gras')
	,(9, 'Stoplijn door voorbranden')
	,(10, 'Bos: compartiment gereed')
	,(11, 'Bos: subcompartiment of 60% gereed')
	,(12, 'Bos: compartimentsgrens in aanleg')
	,(13, 'Heide: gereed');

INSERT INTO sectoren_type (id, naam) VALUES
	 (21, 'Ecologisch kwetsbaar terrein')
	,(22, 'Drassig terrein, niet berijdbaar')
	,(23, 'Gevaarlijk terrein, nooit te betreden');

INSERT INTO bereikbaarheid_type (id, naam) VALUES
	 (21, 'Afrastering (algemeen)')
	,(22, 'Afrastering defensie/risico-objecten')
	,(23, 'Afrastering munitie');

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 6;
UPDATE algemeen.applicatie SET db_versie = 326; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();