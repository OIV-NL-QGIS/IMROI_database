SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE object DROP COLUMN IF EXISTS oms_nummer;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 1;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 310; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();