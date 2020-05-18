-- VOORDAT JE VERDER GAAT -> LAAD DE LAATSTE BAG TABEL IN DE DATABASE oiv_prod
—- Download het zip bestand dat correspondeert met jouw regio vanaf: https://bitbucket.org/baasgeo/oiv/downloads/
—- Pak het bestand uit
-- Run het importscript dat correspondeert met jouw regio, nl. 8_x_bag_regioafkorting.sql
-- Doe dit niet via de query window, maar in pgadmin via het plugin menu en de psql plugin
-- gebruik het volgende commando vanaf de commandline, vergeet niet het ingepakte bestand eerst uit te pakken.
-- voorbeeld:

-- \copy algemeen.bag_extent FROM 'd:/temp/bag_extent_zw.csv' DELIMITER ',' CSV
-- \copy algemeen.bgt_extent FROM 'd:/temp/bgt_extent_zw.csv' DELIMITER ',' CSV

-- vervang het pad met het pad waar jij jouw sql script hebt staan
-- LET OP: Er mogen geen spaties in de pad verwijzing staan!!
-- in windows denk om de / ipv de \ in het pad
-- Via dit script wordt de INSERT gestart
-- Dit kan ongeveer vijf minuten duren.
