--Script t.b.v. creeren bag_extent uit de bag database, wordt uitgevoerd door beheer

SET ROLE postgres;

CREATE TABLE algemeen.bag_extent_02 
( 
gid serial primary key,
identificatie character varying(16),
status text,
geovlak geometry(PolygonZ, 28992),
gebruiksdoel text);

--TRUNCATE algemeen.bag_extent_02;

INSERT INTO algemeen.bag_extent_02 (identificatie, status, geovlak, gebruiksdoel)
SELECT p.identificatie, p.pandstatus, p.geovlak, gebr.gebruiksdoel FROM algemeen.veiligheidsregio_watergrens v
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
WHERE v.regiocode = '02';

