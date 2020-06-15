SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO veiligh_install_type (id, naam, symbol_name, size) VALUES (1019, 'Schacht of kanaal', 'schacht_kanaal', 4);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 1;
UPDATE algemeen.applicatie SET revisie = 9;
UPDATE algemeen.applicatie SET db_versie = 319; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
