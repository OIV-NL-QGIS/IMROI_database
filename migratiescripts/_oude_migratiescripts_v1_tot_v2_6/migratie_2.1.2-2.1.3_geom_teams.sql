SET ROLE oiv_admin;

ALTER TABLE algemeen.team DROP COLUMN geom;
ALTER TABLE algemeen.team ADD COLUMN geom geometry(MultiPolygon, 28992);

DROP VIEW algemeen.team_geo;
CREATE OR REPLACE VIEW algemeen.team_geo AS
-- Team Noordkop NHN 
SELECT 1 AS id,
    'Noordkop'::text AS team,
	ST_UNION(prt.geom)::geometry(Multipolygon,28992) AS geom FROM
(SELECT ST_CollectionExtract(ST_UNION(ST_INTERSECTION(g.geovlak, v.geom)),3)::geometry(MultiPolygon, 28992) AS geom FROM bagactueel.gemeente g
		INNER JOIN algemeen.veiligheidsregio v ON ST_INTERSECTS(g.geovlak, v.geom)
		WHERE gemeentenaam = 'Hollands Kroon'
	UNION
	SELECT 
		st_multi(st_union(st_intersection(gem.geovlak, v.geom)))::geometry(Multipolygon,28992) AS geom
	FROM ( SELECT g.geovlak
           FROM bagactueel.gemeente g
          WHERE g.gemeentenaam::text = 'Schagen'::text OR g.gemeentenaam::text = 'Texel'::text OR g.gemeentenaam::text = 'Den Helder'::text) gem
    JOIN algemeen.veiligheidsregio_huidig v ON st_intersects(gem.geovlak, v.geom)) prt
UNION
-- Team Regio Alkmaar NHN
 SELECT 2 AS id,
    'Regio Alkmaar'::text AS team,
    st_multi(st_union(st_intersection(gem.geovlak, v.geom)))::geometry(Multipolygon,28992) AS geom
   FROM ( SELECT g.geovlak
           FROM bagactueel.gemeente g
          WHERE g.gemeentenaam::text = 'Castricum'::text OR g.gemeentenaam::text = 'Alkmaar'::text OR g.gemeentenaam::text = 'Heiloo'::text OR g.gemeentenaam::text = 'Bergen (NH.)'::text OR g.gemeentenaam::text = 'Heerhugowaard'::text OR g.gemeentenaam::text = 'Langedijk'::text) gem
     JOIN algemeen.veiligheidsregio_huidig v ON st_intersects(gem.geovlak, v.geom)
UNION
-- Team Westfriesland NHN
 SELECT 3 AS id,
    'Westfriesland'::text AS team,
    st_union(st_intersection(gem.geovlak, v.geom))::geometry(Multipolygon,28992) AS geom
   FROM ( SELECT g.geovlak::geometry(Multipolygon,28992)
           FROM bagactueel.gemeente g
          WHERE g.gemeentenaam::text = 'Enkhuizen'::text OR g.gemeentenaam::text = 'Stede Broec'::text OR g.gemeentenaam::text = 'Drechterland'::text OR g.gemeentenaam::text = 'Hoorn'::text OR g.gemeentenaam::text = 'Medemblik'::text OR g.gemeentenaam::text = 'Opmeer'::text OR g.gemeentenaam::text = 'Koggenland'::text) gem
     JOIN algemeen.veiligheidsregio_huidig v ON st_intersects(gem.geovlak, v.geom)
 UNION
 -- Team Noord VRZW
 SELECT 4 AS id,
    'VRZW Noord'::text AS team,
    st_multi(st_union(st_intersection(gem.geovlak, v.geom))) AS geom
   FROM ( SELECT g.geovlak
           FROM bagactueel.gemeente g
          WHERE g.gemeentenaam::text = 'Wormerland'::text OR g.gemeentenaam::text = 'Beemster'::text OR g.gemeentenaam::text = 'Purmerend'::text) gem
     JOIN algemeen.veiligheidsregio_huidig v ON st_intersects(gem.geovlak, v.geom)
UNION
-- Team West VRZW
 SELECT 5 AS id,
    'VRZW West'::text AS team,
    st_multi(st_union(st_intersection(gem.geovlak, v.geom)))::geometry(Multipolygon,28992) AS geom
   FROM ( SELECT g.geovlak::geometry(Multipolygon,28992)
           FROM bagactueel.gemeente g
          WHERE g.gemeentenaam::text = 'Zaanstad'::text OR g.gemeentenaam::text = 'Oostzaan'::text) gem
     JOIN algemeen.veiligheidsregio_huidig v ON st_intersects(gem.geovlak, v.geom)
UNION
 -- Team Oost VRZW
 SELECT 6 AS id,
    'VRZW Oost'::text AS team,
    st_multi(st_union(st_intersection(gem.geovlak, v.geom))) AS geom
   FROM ( SELECT g.geovlak
           FROM bagactueel.gemeente g
          WHERE g.gemeentenaam::text = 'Edam-Volendam'::text OR g.gemeentenaam::text = 'Landsmeer'::text OR g.gemeentenaam::text = 'Waterland'::text) gem
     JOIN algemeen.veiligheidsregio_huidig v ON st_intersects(gem.geovlak, v.geom)
UNION
-- Team West VRK
 SELECT 7 AS id,
    'VRK'::text AS team,
    st_multi(geom)::geometry(Multipolygon,28992) AS geom
   FROM algemeen.veiligheidsregio
          WHERE statcode = 'VR12';

-- Add Geo to team table
UPDATE algemeen.team SET geom = ST_Multi(t.geom) FROM 
	(SELECT team, geom FROM algemeen.team_geo) t
	WHERE naam = t.team;