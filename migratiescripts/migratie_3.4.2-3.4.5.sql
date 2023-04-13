SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (10, 'Drukhouder');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (11, 'IBC');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (12, 'Tank-ondergronds');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (13, 'Tank-bovengronds');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (14, 'Silo');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (15, 'PGS-15');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (16, 'Container');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (17, 'Bunker');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (18, 'Installatie');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (19, 'Jerrycan');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (21, 'Vat 60l');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (22, 'Vat 120l');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (23, 'Vat 200l');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (24, 'Kast');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (25, 'Zak');
INSERT INTO gevaarlijkestof_eenheid (id, naam) VALUES (26, 'Palet');


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 5;
UPDATE algemeen.applicatie SET db_versie = 345; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
