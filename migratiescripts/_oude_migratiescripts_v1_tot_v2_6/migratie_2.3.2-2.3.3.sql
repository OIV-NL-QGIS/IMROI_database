SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- Opschonen bestaande bag views
DROP VIEW IF EXISTS bag_gebruikstype CASCADE;

-- CREATE bag extent t.b.v. BAG panden in qgis project
DROP TABLE IF EXISTS algemeen.bag_extent;
CREATE TABLE algemeen.bag_extent
(
  gid integer,
  identificatie text,
  pandstatus text,
  geovlak geometry(PolygonZ,28992)
);

CREATE INDEX sidx_bag_extent_geom
  ON algemeen.bag_extent
  USING gist
  (geovlak);

-- Run hierna het migratiescript dat correspondeert met jouw regio, nl. 8_x_bag_regioafkorting.sql vanuit de aanmaakscripts
-- Doe dit niet via de query window, maar in pgadmin via het plugin menu en de plsql plugin
-- gebruik het volgende commando vanaf de commandline
-- voorbeeld:
-- \i C:/Users/oiv/Documents/bag_extent/migratie_2.3.2-2.3.3_regioafkorting.sql
-- vervang het pad met het pad waar jij jouw sql sctipt hebt staan
-- LET OP: Er mogen geen spaties in de pad verwijzing staan!!
-- in windows denk om de / ipv de \ in het pad
-- Via dit script wordt de INSERT gestart

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 17;
UPDATE algemeen.applicatie SET datum = now();
