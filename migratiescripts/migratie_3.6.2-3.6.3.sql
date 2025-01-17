SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

UPDATE objecten.bereikbaarheid_type SET style_ids='75,76,77' WHERE naam='slagboom';

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 362; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();