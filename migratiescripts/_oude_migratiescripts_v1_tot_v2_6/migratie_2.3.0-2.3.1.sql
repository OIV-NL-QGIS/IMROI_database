SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- Aanpassing t.b.v. eventuele typo in schade_cirkel
ALTER TABLE schade_cikel_soort RENAME TO schade_cirkel_soort;


		  
-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 1;
UPDATE algemeen.applicatie SET db_versie = 16;
UPDATE algemeen.applicatie SET datum = now();