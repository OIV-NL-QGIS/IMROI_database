SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

--create style hulplijn
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, verbindingsstijl, eindstijl)
  VALUES ('Bereikbaarheid', 'hulplijn', 0.15, '#ff000000', 'dot', 'bevel', 'round');
  
--create style lijn voor blusleiding 
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, verbindingsstijl, eindstijl)
  VALUES ('Bereikbaarheid', 'blusleiding', 0.4, '#ff964B00', 'dash', 'bevel', 'round');

--create style lijn voor contouren 
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, verbindingsstijl, eindstijl)
  VALUES ('Bereikbaarheid', 'contouren', 0.4, '#ff555555', 'solid', 'bevel', 'round');

INSERT INTO objecten.bereikbaarheid_type (id, naam) VALUES (8, 'blusleiding');
INSERT INTO objecten.bereikbaarheid_type (id, naam) VALUES (9, 'contouren');
INSERT INTO objecten.bereikbaarheid_type (id, naam) VALUES (90, 'hulplijn');


--create style hulplijn
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, verbindingsstijl, eindstijl)
  VALUES ('Bouwkundige veiligheidsvoorzieningen', 'hulplijn_bouwlaag', 0.15, '#ff000000', 'dot', 'bevel', 'round');
  
--create style lijn voor blusleiding 
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, verbindingsstijl, eindstijl)
  VALUES ('Bouwkundige veiligheidsvoorzieningen', 'blusleiding_bouwlaag', 0.4, '#ff964B00', 'dash', 'bevel', 'round');

--create style lijn voor contouren 
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, verbindingsstijl, eindstijl)
  VALUES ('Bouwkundige veiligheidsvoorzieningen', 'contouren_bouwlaag', 0.4, '#ff555555', 'solid', 'bevel', 'round');

INSERT INTO objecten.veiligh_bouwk_type (id, naam) VALUES (8, 'blusleiding_bouwlaag');
INSERT INTO objecten.veiligh_bouwk_type (id, naam) VALUES (9, 'contouren_bouwlaag');
INSERT INTO objecten.veiligh_bouwk_type (id, naam) VALUES (90, 'hulplijn_bouwlaag');

INSERT INTO objecten.sectoren_type (id, naam) VALUES (31, 'openwater');
INSERT INTO objecten.sectoren_type (id, naam) VALUES (32, 'zwembad');

INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
  VALUES ('Sectoren', 'openwater', 0.6, '#ff0095e6', 'solid', '#ff80bde3', 'solid', 'bevel', 'round');
  
--create style lijn voor blusleiding 
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
  VALUES ('Sectoren', 'zwembad', 1, '#ff0033e6', 'solid', '#ff0072e0', 'solid', 'bevel', 'round');

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 334; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();