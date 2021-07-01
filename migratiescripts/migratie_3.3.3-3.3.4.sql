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

INSERT INTO objecten.sectoren_type (id, naam) VALUES (41, 'openwater');
INSERT INTO objecten.sectoren_type (id, naam) VALUES (42, 'zwembad');

INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
  VALUES ('Sectoren', 'openwater', 0.6, '#ff0095e6', 'solid', '#ff80bde3', 'solid', 'bevel', 'round');
  
--create style lijn voor blusleiding 
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
  VALUES ('Sectoren', 'zwembad', 1, '#ff0033e6', 'solid', '#ff0072e0', 'solid', 'bevel', 'round');

INSERT INTO objecten.ingang_type (id, naam, symbol_name, size)
    VALUES (701, 'Deur', 'deur', 2);
INSERT INTO objecten.ingang_type (id, naam, symbol_name, size)
    VALUES (702, 'Schuifdeur dubbel', 'schuifdeur_dubbel', 2);
INSERT INTO objecten.ingang_type (id, naam, symbol_name, size)
    VALUES (703, 'Schuifdeur enkel links', 'schuifdeur_enkel_links', 2);
INSERT INTO objecten.ingang_type (id, naam, symbol_name, size)
    VALUES (704, 'Schuifdeur enkel rechts', 'schuifdeur_enkel_rechts', 2);

INSERT INTO objecten.opstelplaats_type (id, naam, symbol_name, size)
    VALUES (9, 'Overig voertuig', 'opstelplaats_overige_voertuigen', 8);

INSERT INTO objecten.veiligh_install_type (id, naam, symbol_name, size)
    VALUES (705, 'Flitslicht', 'flitslicht', 4);
INSERT INTO objecten.veiligh_install_type (id, naam, symbol_name, size)
    VALUES (706, 'Gas detectiepaneel', 'gasdetectiepaneel', 4);
INSERT INTO objecten.veiligh_install_type (id, naam, symbol_name, size)
    VALUES (707, 'Afsluiter SVM', 'afsluiter_svm', 4);
INSERT INTO objecten.veiligh_install_type (id, naam, symbol_name, size)
    VALUES (708, 'Brandweer info-kast', 'brandweerinfokast', 4);

INSERT INTO objecten.veiligh_ruimtelijk_type (id, naam, symbol_name, size)
    VALUES (707, 'Afsluiter SVM', 'afsluiter_svm', 6);
INSERT INTO objecten.veiligh_ruimtelijk_type (id, naam, symbol_name, size)
    VALUES (708, 'Brandweer info-kast', 'brandweerinfokast', 6);

INSERT INTO objecten.dreiging_type (id, naam, symbol_name, size)
    VALUES (709, 'Laadpaal electrisch voertuig', 'laadpaal_elektrisch_voertuig', 6);

INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, verbindingsstijl, eindstijl)
  VALUES ('Bereikbaarheid', 'slagboom_bottom', 0.8, '#ff000000', 'solid', 'bevel', 'round');
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, verbindingsstijl, eindstijl)
  VALUES ('Bereikbaarheid', 'slagboom_middle', 0.6, '#ffffffff', 'solid', 'bevel', 'round');
INSERT INTO algemeen.styles
    (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, verbindingsstijl, eindstijl)
  VALUES ('Bereikbaarheid', 'slagboom_top', 0.6, '#ffff0000', 'dot', 'bevel', 'flat');

INSERT INTO objecten.bereikbaarheid_type (id, naam) VALUES (10, 'slagboom');

INSERT INTO objecten.points_of_interest_type (id, naam, symbol_name, size)
    VALUES (51, 'Doorrijhoogte', 'doorrijhoogte', 6);
INSERT INTO objecten.points_of_interest_type (id, naam, symbol_name, size)
    VALUES (52, 'Sleutelpaal of ringpaal', 'sleutelpaal_of_ringpaal', 6);
INSERT INTO objecten.points_of_interest_type (id, naam, symbol_name, size)
    VALUES (53, 'Poller', 'poller', 6);
INSERT INTO objecten.points_of_interest_type (id, naam, symbol_name, size)
    VALUES (54, 'Windvaan', 'windvaan', 4);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 334; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
