SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO sectoren_type (id, naam) VALUES (31, 'Werkingsgebied RBP');
INSERT INTO opstelplaats_type (id, naam, symbol_name, size) VALUES (31, 'Politie', 'politie', 10);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 330; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();