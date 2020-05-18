SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TYPE bereikbaarheid_type ADD VALUE 'evenementenroute';
ALTER TYPE sectoren_type ADD VALUE 'parkeerzone';

INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie, symbol_name) VALUES (207, 'attractie', 'evenement', 'attractie');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie, symbol_name) VALUES (208, 'feesttent', 'evenement', 'feesttent');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie, symbol_name) VALUES (209, 'straattheater', 'evenement', 'straattheater');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie, symbol_name) VALUES (210, 'kleedkamer', 'evenement', 'kleedkamer');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie, symbol_name) VALUES (211, 'vuurwerkafsteekplaats', 'evenement', 'vuurwerkafsteekplaats');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie, symbol_name) VALUES (212, 'restaurant', 'evenement', 'restaurant');
INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie, symbol_name) VALUES (213, 'tijdelijke wegafsluiting', 'evenement', 'tijdelijke_wegafsluiting');

UPDATE veiligh_ruimtelijk_type SET naam = 'Kraam gas', symbol_name = 'kraam_gas' WHERE id = 204;
UPDATE veiligh_ruimtelijk_type SET naam = 'Kraam elektra', symbol_name = 'kraam_elektra' WHERE id = 205;

INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Sectoren', 'parkeerzone', 0.26, '#ff024dc0', 'solid', '#ff027dc0', 'solid', 'bevel', NULL);	
INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Bereikbaarheid', 'evenementenroute_bottom', 0.6, '#ff004f8b', 'solid', NULL, NULL, 'bevel', 'round');
INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Bereikbaarheid', 'evenementenroute_top', 0.6, '#fff6630d', 'dash', NULL, NULL, 'bevel', 'round');
INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Bereikbaarheid', 'wegen eigen terrein_bottom', 6.0, '#ff505050', 'solid', NULL, NULL, 'round', 'flat');
INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Bereikbaarheid', 'wegen eigen terrein_top', 5.75, '#fff8f8f8', 'solid', NULL, NULL, 'round', 'round');
INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Object terrein', 'Object terrein', 0.26, '#ff75649d', 'solid', '#2975649d', 'solid', 'bevel', NULL);
INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Schade cirkel (alleen lezen)', 'onherstelbare schade en branden', 0.5, '#ffd30000', 'dot', '#40d30000', 'solid', 'bevel', NULL);
INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Schade cirkel (alleen lezen)', 'zware schade en secundaire branden', 0.5, '#ffff0101', 'dot', '#40ff0101', 'solid', 'bevel', NULL);
INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Schade cirkel (alleen lezen)', 'secundaire branden treden op', 0.5, '#ffff7f00', 'dot', '#40ff7f00', 'solid', 'bevel', NULL);
INSERT INTO algemeen.styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Schade cirkel (alleen lezen)', 'geen of lichte schade', 0.5, '#fffff302', 'dot', '#80fff302', 'solid', 'bevel', NULL);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 1;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 314; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();