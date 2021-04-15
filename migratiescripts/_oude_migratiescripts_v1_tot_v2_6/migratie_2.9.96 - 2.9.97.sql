SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TYPE bereikbaarheid_type ADD VALUE 'calamiteitenroute';
ALTER TYPE bereikbaarheid_type ADD VALUE 'vluchtroute publiek';

ALTER TYPE labels_type ADD VALUE 'calamiteitendoorgang';
ALTER TYPE labels_type ADD VALUE 'publieke ingang';

CREATE TYPE sectoren_type AS ENUM('persvak', 'podium', 'publieke sector', 'tent');

CREATE TABLE sectoren
(
  id                     SERIAL PRIMARY KEY NOT NULL,
  geom                   geometry(MultiPolygon,28992),
  datum_aangemaakt       TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd        TIMESTAMP WITH TIME ZONE,
  soort	              	 sectoren_type,
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

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON sectoren
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON sectoren
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

COMMENT ON TABLE sectoren IS 'Bijzondere sectoren per repressief object';

INSERT INTO objecten.veiligh_ruimtelijk_type (id, naam, categorie) VALUES (201, 'aed', 'evenement');
INSERT INTO objecten.veiligh_ruimtelijk_type (id, naam, categorie) VALUES (202, 'ehbo', 'evenement');
INSERT INTO objecten.veiligh_ruimtelijk_type (id, naam, categorie) VALUES (203, 'generator', 'evenement');
INSERT INTO objecten.veiligh_ruimtelijk_type (id, naam, categorie) VALUES (204, 'braadkraam gas', 'evenement');
INSERT INTO objecten.veiligh_ruimtelijk_type (id, naam, categorie) VALUES (205, 'braadkraam electra', 'evenement');
INSERT INTO objecten.veiligh_ruimtelijk_type (id, naam, categorie) VALUES (206, 'parkeerplaats', 'evenement');

UPDATE algemeen.applicatie SET sub = 9;
UPDATE algemeen.applicatie SET revisie = 97;
UPDATE algemeen.applicatie SET db_versie = 997; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();