-- Opzoektabellen vullen
SET role oiv_admin;
SET search_path = bluswater, pg_catalog, public;

-- INSERT type alternatieve bluswatervoorzieningen
INSERT INTO alternatieve_type VALUES (1, 'Geboorde Put met voordruk', 'geboorde_put_voordruk', 6);
INSERT INTO alternatieve_type VALUES (2, 'Geboorde Put', 'geboorde_put', 6);
INSERT INTO alternatieve_type VALUES (3, 'Waterkelder', 'openwater_winput', t6);
INSERT INTO alternatieve_type VALUES (4, 'Blusleiding afnamepunt', 'stijgleiding_ld_afnamepunt', 6);
INSERT INTO alternatieve_type VALUES (5, 'Blusleiding vulpunt', 'stijgleiding_ld_vulpunt', 6);
INSERT INTO alternatieve_type VALUES (6, 'Bluswaterriool', 'bluswaterriool', 6);
INSERT INTO alternatieve_type VALUES (7, 'Openwater winput', 'openwater_winput', 6);
INSERT INTO alternatieve_type VALUES (8, 'Afsluiter omloop', 'afsluiter_omloop', 6);
INSERT INTO alternatieve_type VALUES (9, 'Particuliere brandkraan', 'particuliere_brandkraan', 6);
INSERT INTO alternatieve_type VALUES (10, 'Open water', 'open_water', 6);
INSERT INTO alternatieve_type VALUES (11, 'Opstelplaats WTS', 'opstelplaats_wts', 6);
INSERT INTO alternatieve_type VALUES (12, 'Open water xxx zijde', 'open_water_xxx_zijde', 6);
INSERT INTO alternatieve_type VALUES (13, 'Open water onbereikbaar', '', 6);
INSERT INTO alternatieve_type VALUES (14, 'Brandkraan eigen terrein', 'brandkraan_eigen_terrein', 6);
INSERT INTO alternatieve_type VALUES (15, 'Bovengrondse brandkraan', 'bovengrondse_brandkraan', 6);
INSERT INTO alternatieve_type VALUES (9999,  'Voorziening defect', 'bluswater_defect', 6);
INSERT INTO alternatieve_type VALUES (21, 'Waterinnampunt,open water', 'N19P19', 6);
INSERT INTO alternatieve_type VALUES (22, 'Geboorde put', 'N19P20', 6);
INSERT INTO alternatieve_type VALUES (23, 'Opvoerpomp of bronpomp', 'N19P21', 6);
INSERT INTO alternatieve_type VALUES (24, 'Water innampunt (WIP)', 'N19P22', 6);