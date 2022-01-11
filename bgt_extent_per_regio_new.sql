DO $$
DECLARE
--Vervang de regio code '22' door jouw regiocode, altijd bestaande uit 2 cijfers. Dus Friesland is bijvoorbeeld '02'.
  regio varchar := '12';

BEGIN
	--Vervang rol 'postgres' naam door een rol waarmee je tabellen aan mag maken in je database
	SET ROLE postgres;
	--Vervang 'search_path = latest' door 'search_path = bag_schema_naam', waar bag_schema_naam de schemanaam is is jouw database
	SET search_path = bgt, pg_catalog, public;

	DROP TABLE IF EXISTS bgt.bgt_extent ;
	CREATE TABLE bgt.bgt_extent
	(
		gid 			serial,
		identificatie 	character varying,
		geovlak 		geometry(CurvePolygon,28992),
		lokaalid 		character varying,
		bgt_bron_tbl 	character varying(254),
		bron 			character varying(10),
		CONSTRAINT 		bgt_extent_pkey PRIMARY KEY (gid)
	);

	INSERT INTO bgt.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, ST_ForceCurve((ST_DUMP(ST_CURVETOLINE(b.geom))).geom), lokaalid, 'begroeidterreindeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN bgt.begroeidterreindeel b ON ST_INTERSECTS(v.geom, b.geom)
		WHERE v.code = '12';

	INSERT INTO bgt.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, b.geom, "lokaalID", 'onbegroeidterreindeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN onbegroeidterreindeel b ON ST_INTERSECTS(v.geom, b.geom)
		WHERE v.code = '12';

	INSERT INTO bgt.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, b.geom, lokaalid, 'overbruggingsdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN overbruggingsdeel b ON ST_INTERSECTS(v.geom, b.geom)
		WHERE v.code = regio;

	INSERT INTO bgt.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, ST_ForceCurve((ST_DUMP(ST_CURVETOLINE(b.geom))).geom), lokaalid, 'ondersteunendwegdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN ondersteunendwegdeel b ON ST_INTERSECTS(v.geom, ST_CURVETOLINE(ST_ForceCurve(b.geom)))
		WHERE v.code = '12';

	INSERT INTO bgt.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, b.geom, lokaalid, 'ondersteunendwaterdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN ondersteunendwaterdeel b ON ST_INTERSECTS(v.geom, b.geom)
		WHERE v.code = regio;

	INSERT INTO bgt.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, b.geom, lokaalid, 'waterdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN waterdeel b ON ST_INTERSECTS(v.geom, b.geom)
		WHERE v.code = regio;

	INSERT INTO bgt.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, c.geom, lokaalid, 'wegdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN (SELECT b.*, ST_CurveToLine(b.geom) geovlak FROM wegdeel b WHERE ST_IsValid(b.geom)=true) c ON ST_INTERSECTS(v.geom, c.geom)
		WHERE v.code = '12';

	INSERT INTO bgt.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, ST_ForceCurve((ST_DUMP(ST_CURVETOLINE(b.geom))).geom), lokaalid, 'kunstwerkdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN bgt.kunstwerkdeel b ON ST_INTERSECTS(v.geom, ST_CURVETOLINE(ST_ForceCurve(b.geom)))
		WHERE v.code = '12';

	INSERT INTO bgt.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, b.geom, lokaalid, 'ongeclassificeerdobject'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN ongeclassificeerdobject b ON ST_INTERSECTS(v.geom, b.geom)
		WHERE v.code = regio;
END 
$$;