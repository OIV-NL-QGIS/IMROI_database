DO $$
DECLARE
--Vervang de regio code '22' door jouw regiocode, altijd bestaande uit 2 cijfers. Dus Friesland is bijvoorbeeld '02'.
  regio varchar := '22';

BEGIN
	--Vervang rol 'postgres' naam door een rol waarmee je tabellen aan mag maken in je database
	SET ROLE postgres;
	--Vervang 'search_path = latest' door 'search_path = bag_schema_naam', waar bag_schema_naam de schemanaam is is jouw database
	SET search_path = latest, pg_catalog, public;

	DROP TABLE IF EXISTS bgt.bag_extent ;
	CREATE TABLE bgt.bag_extent
	( 
		gid 			serial primary key,
		identificatie 	text,
		status 			text,
		geovlak 		geometry(MultiPolygon, 28992),
		gebruiksdoel 	text,
		bron 			character varying(10),
		bron_tbl 		character varying(254)
	);

	INSERT INTO bgt.bag_extent (identificatie, status, geovlak, gebruiksdoel, bron, bron_tbl)
	SELECT p.identificatie, p.pandstatus, ST_Multi(ST_Force2D(p.geovlak))::geometry(MultiPolygon, 28992), gebr.gebruiksdoel, 'BAG', 'Pand' FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN bagactueel.pandactueel p ON ST_INTERSECTS(p.geovlak, v.geom)
		LEFT JOIN (
			SELECT gerelateerdpand, string_agg(gebruiksdoelverblijfsobject::text, ', ') AS gebruiksdoel FROM
				(SELECT vop.gerelateerdpand, vog.gebruiksdoelverblijfsobject 
					FROM bagactueel.verblijfsobjectpand vop
				LEFT JOIN bagactueel.verblijfsobjectgebruiksdoel vog ON vop.identificatie = vog.identificatie
				GROUP BY vop.gerelateerdpand, vog.gebruiksdoelverblijfsobject
				) part
			GROUP BY gerelateerdpand
			) gebr ON p.identificatie = gebr.gerelateerdpand
	WHERE v.code = regio;

	INSERT INTO bgt.bag_extent (identificatie, status, geovlak, gebruiksdoel, bron, bron_tbl)
	SELECT o.gml_id, o."bgt-status", ST_Multi(ST_CurveToLine(o.geom))::geometry(MultiPolygon,28992), 'overigbouwwerk', 'BGT', 'Overigbouwwerk' FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN bgt.overigbouwwerk o ON ST_3DINTERSECTS(v.geom, o.geom)
	WHERE v.code = '12';

	INSERT INTO bgt.bag_extent (identificatie, status, geovlak, gebruiksdoel, bron, bron_tbl)
	SELECT o.gml_id, o."bgt-status", ST_Multi(ST_CurveToLine(o.geom))::geometry(MultiPolygon,28992), 'tunneldeel', 'BGT', 'Tunneldeel' FROM algemeen.veiligheidsregio_watergrens v
		LEFT JOIN bgt.tunneldeel o ON ST_3DINTERSECTS(v.geom, o.geom)
	WHERE v.code = '12';

	INSERT INTO algemeen.bag_extent (identificatie, status, geovlak, gebruiksdoel, bron, bron_tbl)
	SELECT l.identificatie, l.ligplaatsstatus::TEXT, ST_Multi(ST_Force2D(l.geovlak))::geometry(MultiPolygon, 28992), 'ligplaats', 'BAG', 'Ligplaats' FROM algemeen.veiligheidsregio_watergrens v 
		LEFT JOIN bagactueel.ligplaatsactueel l ON ST_INTERSECTS(v.geom, l.geovlak)
	WHERE v.code = regio;

	INSERT INTO algemeen.bag_extent (identificatie, status, geovlak, gebruiksdoel, bron, bron_tbl)
	SELECT l.identificatie, l.standplaatsstatus::TEXT, ST_Multi(ST_Force2D(l.geovlak))::geometry(MultiPolygon, 28992), 'standplaats', 'BAG', 'Standplaats' FROM algemeen.veiligheidsregio_watergrens v 
		LEFT JOIN bagactueel.standplaatsactueel l ON ST_INTERSECTS(v.geom, l.geovlak)
	WHERE v.code = regio;
END 
$$;