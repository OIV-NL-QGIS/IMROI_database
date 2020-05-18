
-- run dit script na migratie_2.0.1-2.0.3.sql
-- Dit is een fix voor het opslaan van Polygon in Multiploygon bij de laag "vlakken".
SET role oiv_admin;

SET search_path = objecten, pg_catalog, public;

-- create view vlakken, icm formelenaam object van alle objecten die de status hebben "in gebruik"
DROP VIEW IF EXISTS view_vlakken;

ALTER TABLE objecten.vlakken
    ALTER COLUMN geom TYPE geometry(MultiPolygon,28992) USING ST_Multi(geom);
	
CREATE OR REPLACE VIEW view_vlakken AS
SELECT v.id, v.geom, v.datum_aangemaakt, v.datum_gewijzigd, v.omschrijving, o.formelenaam FROM vlakken v
INNER JOIN (SELECT formelenaam, object.id FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o ON v.object_id = o.id;
		
UPDATE algemeen.applicatie SET db_versie = 3;