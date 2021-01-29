-- Opzoektabellen vullen
SET role oiv_admin;
SET search_path = bluswater, pg_catalog, public;

-- INSERT type alternatieve bluswatervoorzieningen
INSERT INTO alternatieve_type (id, naam) VALUES (1, 'Geboorde Put met voordruk');
INSERT INTO alternatieve_type (id, naam) VALUES (2, 'Geboorde Put');
INSERT INTO alternatieve_type (id, naam) VALUES (3, 'Waterkelder');
INSERT INTO alternatieve_type (id, naam) VALUES (4, 'Blusleiding afnamepunt');
INSERT INTO alternatieve_type (id, naam) VALUES (5, 'Blusleiding vulpunt');
INSERT INTO alternatieve_type (id, naam) VALUES (6, 'Bluswaterriool');
INSERT INTO alternatieve_type (id, naam) VALUES (7, 'Openwater winput');
INSERT INTO alternatieve_type (id, naam) VALUES (8, 'Afsluiter omloop');
INSERT INTO alternatieve_type (id, naam) VALUES (9, 'Particuliere brandkraan');
INSERT INTO alternatieve_type (id, naam) VALUES (10, 'Open water');
INSERT INTO alternatieve_type (id, naam) VALUES (11, 'Opstelplaats WTS');
INSERT INTO alternatieve_type (id, naam) VALUES (12, 'Open water xxx zijde');
INSERT INTO alternatieve_type (id, naam) VALUES (13, 'Open water onbereikbaar');
INSERT INTO alternatieve_type (id, naam) VALUES (14, 'Brandkraan eigen terrein');
INSERT INTO alternatieve_type (id, naam) VALUES (15, 'Bovengrondse brandkraan');
INSERT INTO alternatieve_type (id, naam) VALUES (9999,  'Voorziening defect');