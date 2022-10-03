DO $$
DECLARE
--Vervang de regio code '22' door jouw regiocode, altijd bestaande uit 2 cijfers. Dus Friesland is bijvoorbeeld '02'.
  regio varchar := '22';

BEGIN
	--Vervang rol 'postgres' naam door een rol waarmee je tabellen aan mag maken in je database
	SET ROLE postgres;
	--Vervang 'search_path = latest' door 'search_path = bag_schema_naam', waar bag_schema_naam de schemanaam is is jouw database
	SET search_path = latest, pg_catalog, public;

	DROP TABLE IF EXISTS algemeen.bgt_extent ;
	CREATE TABLE algemeen.bgt_extent
	(
		gid 			serial,
		identificatie 	character varying,
		geovlak 		geometry(CurvePolygon,28992),
		lokaalid 		character varying,
		bgt_bron_tbl 	character varying(254),
		bron 			character varying(10),
		CONSTRAINT 		bgt_extent_pkey PRIMARY KEY (gid)
	);

	INSERT INTO algemeen.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, geometrie_vlak, lokaalid, 'begroeidterreindeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN begroeidterreindeelactueel b ON ST_INTERSECTS(v.geom, b.geometrie_vlak)
		WHERE v.code = regio;

	INSERT INTO algemeen.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, geometrie_vlak, lokaalid, 'onbegroeidterreindeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN onbegroeidterreindeelactueel b ON ST_INTERSECTS(v.geom, b.geometrie_vlak)
		WHERE v.code = regio;

	INSERT INTO algemeen.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, geometrie_vlak, lokaalid, 'overbruggingsdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN overbruggingsdeelactueel b ON ST_INTERSECTS(v.geom, b.geometrie_vlak)
		WHERE v.code = regio;

	INSERT INTO algemeen.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, geometrie_vlak, lokaalid, 'ondersteunendwegdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN ondersteunendwegdeelactueel b ON ST_INTERSECTS(v.geom, b.geometrie_vlak)
		WHERE v.code = regio;

	INSERT INTO algemeen.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, geometrie_vlak, lokaalid, 'ondersteunendwaterdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN ondersteunendwaterdeelactueel b ON ST_INTERSECTS(v.geom, b.geometrie_vlak)
		WHERE v.code = regio;

	INSERT INTO algemeen.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, geometrie_vlak, lokaalid, 'waterdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN waterdeelactueel b ON ST_INTERSECTS(v.geom, b.geometrie_vlak)
		WHERE v.code = regio;

	INSERT INTO algemeen.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, geometrie_vlak, lokaalid, 'wegdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN (SELECT *, ST_CurveToLine(geometrie_vlak) geom FROM wegdeelactueel b WHERE ST_IsValid(b.geometrie_vlak)=true) b ON ST_INTERSECTS(v.geom, b.geom)
		WHERE v.code = regio;

	INSERT INTO algemeen.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, geometrie_vlak, lokaalid, 'kunstwerkdeel'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN kunstwerkdeelactueel b ON ST_INTERSECTS(v.geom, b.geometrie_vlak)
		WHERE v.code = regio;
		
	INSERT INTO algemeen.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, geometrie_vlak, lokaalid, 'scheiding'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN scheidingactueel b ON ST_INTERSECTS(v.geom, b.geometrie_vlak)
		WHERE v.code = regio;

	INSERT INTO algemeen.bgt_extent (identificatie, geovlak, lokaalid, bgt_bron_tbl, bron)
	SELECT gml_id, geometrie_vlak, lokaalid, 'ongeclassificeerdobject'::CHARACTER VARYING(254) AS bgt_bron_tbl, 'BGT'
		FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN ongeclassificeerdobjectactueel b ON ST_INTERSECTS(v.geom, b.geometrie_vlak)
		WHERE v.code = regio;
END 
$$;