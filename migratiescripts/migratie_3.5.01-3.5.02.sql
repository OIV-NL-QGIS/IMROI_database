SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO objecten.ruimten_type (id, naam) VALUES (42, 'zwembad binnen');

--create style
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
  VALUES ('Ruimten', 'zwembad binnen', 0.1, '#ff0033e6', 'solid', '#ff0072e0', 'solid', 'bevel', 'round');

CREATE TABLE bluswater.foto (
	id serial4 NOT NULL,
	geom public.geometry(point, 28992) NOT NULL,
	datum_aangemaakt timestamptz NULL DEFAULT now(),
	datum_gewijzigd timestamptz NULL,
	periode varchar,
	gebruiker varchar,
	"schema" varchar,
	tabel varchar,
	brandkraan_id varchar,
	foto text NOT NULL,
	rd_x numeric NULL,
	rd_y numeric NULL,
	naam varchar(255) NULL,
	bijzonderheden text NULL,
	plusinfo text NULL,
	CONSTRAINT fotografie_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_fotografie_geom ON bluswater.foto USING gist (geom);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 5;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 321; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
