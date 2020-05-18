SET role oiv_admin;
SET search_path = algemeen, pg_catalog, public;

DROP TABLE bag_extent CASCADE;

CREATE TABLE bag_extent
(
  gid serial NOT NULL,
  identificatie text,
  status text,
  geovlak geometry(MultiPolygon,28992),
  gebruiksdoel text,
  bron character varying(10),
  bron_tbl character varying(254) NOT NULL,
  CONSTRAINT bag_extent_pkey PRIMARY KEY (gid)
);

CREATE INDEX sidx_bag_extent_geom
  ON bag_extent
  USING gist
  (geovlak);

CREATE TABLE bgt_extent
(
  gid serial NOT NULL,
  identificatie character varying,
  geovlak geometry(CurvePolygon,28992),
  lokaalid character varying,
  bron_tbl character varying(254),
  bron character varying(10),
  CONSTRAINT bgg_extent_pkey PRIMARY KEY (gid)
);
COMMENT ON COLUMN bgt_extent.identificatie IS 'gml_id vanuit BGT';

CREATE INDEX sidx_bgt_extent_geom
  ON bgt_extent
  USING gist
  (geovlak);

UPDATE algemeen.applicatie SET sub = 9;
UPDATE algemeen.applicatie SET revisie = 93;
UPDATE algemeen.applicatie SET db_versie = 993; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();