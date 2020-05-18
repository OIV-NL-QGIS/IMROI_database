SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TABLE grid
(
  id 				SERIAL primary key,
  geom              GEOMETRY(Polygon, 28992),
  datum_aangemaakt  TIMESTAMP WITH TIME ZONE   DEFAULT now(),
  datum_gewijzigd   TIMESTAMP WITH TIME ZONE,
  label_left		TEXT,
  label_top		TEXT,
  afstand INTEGER,  
  object_id			INTEGER,
  CONSTRAINT grid_object_id_fk FOREIGN KEY (object_id) REFERENCES object (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX grid_geom_gist
  ON grid USING GIST(geom);
COMMENT ON TABLE bouwlagen IS 'Grid voor verdeling en verduidelijking locatie op terrein';

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON grid
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON grid
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Grid', 'Grid', 0.26, '#ff000000', 'solid', '#00000000', 'solid', 'bevel', NULL);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 1;
UPDATE algemeen.applicatie SET revisie = 5;
UPDATE algemeen.applicatie SET db_versie = 315; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();