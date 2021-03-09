SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name = 'reduceer_drukbegrenzer' WHERE symbol_name = 'reduceer_drukbegerenzer';
UPDATE dreiging_type SET symbol_name = 'algemeen_gevaar' WHERE id = 129;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 330; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();