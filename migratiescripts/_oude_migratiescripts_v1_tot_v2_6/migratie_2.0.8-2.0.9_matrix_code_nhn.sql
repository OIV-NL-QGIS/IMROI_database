SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- Aanmaken opzoektabel matrix_code
CREATE TABLE matrix_code
(
	id				SMALLINT PRIMARY KEY	NOT NULL,
	matrix_code		CHARACTER VARYING(4)  	NOT NULL,
	omschrijving	TEXT					NOT NULL,
	actualisatie	CHARACTER VARYING(1)	NOT NULL,
	prio_prod 		INTEGER					NOT NULL
);
COMMENT ON TABLE matrix_code IS 'Opzoeklijst voor matrix code';

-- INSERT matrix codes in opzoektabel
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (1, '1', 'Gebouwen hoger dan  70 m', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (2, '2', 'Gebouwen met onderste verdiepingsvloer lager dan 5 meter onder maaiveld', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (3, '3', 'Grootste brandcompartiment groter dan 2.500m2', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (4, '04a', 'Tehuizen meer dan 100 bewoners', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (5, '04b', 'Tehuizen meer dan 500 bewoners', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (6, '5', 'Monumentaal object', 'D', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (7, '06b', 'Woongebouwen met inpandige gangen hoger dan 70m bovenste verdiepingsvloer of inzetdiepte langer dan 30 meter', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (8, '06c', 'Woongebouwen met inpandige gangen hoger dan 70m bovenste verdiepingsvloer, of inzetdiepte langer dan 60 meter', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (9, '08b', 'Woningen niet-zelfredzame bewoners, 10 of meer personen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (10, '08c', 'Woningen niet-zelfredzame bewoners, 50 of meer personen', 'A', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (11, '09a', 'Bejaardenoorden meer dan 100 bejaarden', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (12, '09b', 'Bejaardenoorden meer dan 500 bejaarden', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (13, '11b', 'Kinderdagverblijf ( 0-4 jaar) met 25 tot 100 kinderen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (14, '11c', 'Kinderdagverblijf ( 0-4 jaar) met meer dan 100 kinderen', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (15, '12', 'Peuterspeelzaal (2-4 jaar) met meer dan 25 kinderen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (16, '13b', 'Theater, schouwburg, bioscoop en/of aula 50 tot 1000 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (17, '13c', 'Theater, schouwburg, bioscoop en/of aula tot 10.000 personen', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (18, '13d', 'Theater, schouwburg, bioscoop en/of aula met meer dan 10.000 personen', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (19, '14b', 'Museum en/of Bibliotheek 50 tot 1000 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (20, '14c', 'Museum en/of Bibliotheek tot 10.000 personen', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (21, '14d', 'Museum en/of Bibliotheek met meer dan 10.000 personen', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (22, '15b', 'Buurthuis, Ontm. Centrum en of Wijkcentrum 50 tot 1000 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (23, '15c', 'Buurthuis, Ontm. Centrum en of Wijkcentrum met meer dan 1000 personen', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (24, '16b', 'Gebedshuis 50 tot 1000 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (25, '16c', 'Gebedshuis met meer dan 1000 personen', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (26, '17b', 'Tentoonstellingsgebouwen 50 tot 1000 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (27, '17c', 'Tentoonstellingsgebouwen tot 10.000 personen', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (28, '17d', 'Tentoonstellingsgebouwen met meer dan 10.000 personen', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (29, '18b', 'Kantine en/of Eetzaal met meer dan 500 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (30, '19b', 'Cafés, Discotheken en/of Restaurants 50 tot 1000 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (31, '19c', 'Cafés, Discotheken en/of Restaurants tot 10.000 personen', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (32, '19d', 'Cafés, Discotheken en/of Restaurants met meer dan 10.000 personen', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (33, '21a', 'celgebouwen < 10 gedetineerden', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (34, '21b', 'celgebouwen 10 - 50 gedetineerden', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (35, '21c', 'celgebouwen 50 - 500 gedetineerden', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (36, '23', '10 tot 100 bedden', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (37, '24', '100 tot 250 bedden', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (38, '25', 'Meer dan 250 bedden', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (39, '26', 'Fabrieken 100-250 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (40, '27', 'Fabrieken 250-500 personen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (41, '28', 'Fabrieken >500 personen', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (42, '30', 'Kantoren tussen de 250 - 500 personen', 'B', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (43, '31', 'Kantoren met meer dan 500 personen', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (44, '32', 'Hotel, Pension, Nachtverblijf en/of Kamerverhuur met 10 - 100 personen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (45, '33', 'Hotel, Pension, Nachtverblijf en/of Kamerverhuur met meer dan 100 personen', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (46, '34', 'Hotel, Pension, Nachtverblijf en/of Kamerverhuur met meer dan 500  personen ', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (47, '36', 'Dagverblijf met meer dan 10 gehandicapte kinderen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (48, '37b', 'Onderwijsinstellingen leerlingen 4-12 jaar en meer dan 100 leerlingen ???', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (49, '39', 'Onderwijsinstellingen leerlingen >12 jaar en meer dan 1000 personen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (50, '41', 'Onderwijsinstellingen leerlingen meer dan 10 gehandicapte leerlingen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (51, '42b', 'Gymzaal, Studio, Sporthal, Stadion en/of Zwembad 500 tot 1000 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (52, '42c', 'Gymzaal, Studio, Sporthal, Stadion en/of Zwembad tot 10.000 personen  ????', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (53, '42d', 'Gymzaal, Studio, Sporthal, Stadion en/of Zwembad meer dan 10.000 pers.', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (54, '43b', 'Winkelgebouwen 100 tot 1000 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (55, '43c', 'Winkelgebouwen tot 5.000 personen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (56, '43d', 'Winkelgebouwen met meer dan 5.000 pers.', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (57, '44b', 'Gebouwen met gebruiksfunctie 500 tot 1000 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (58, '44c', 'Gebouwen met gebruiksfunctie tot 10.000 personen', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (59, '44d', 'Gebouwen met gebruiksfunctie met meer dan 10.000 pers.', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (60, '46', 'Tunnels langer dan 200 meter', 'C', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (61, '47b', 'Loods, Veem en/of Opslagplaats >2.500 m2', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (62, '48b', 'Garage inrichtingen (opslag/stalling) > 2.500 m2', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (63, '49', 'Benzinestation zonder LPG installatie', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (64, '50', 'Benzinestation met LPG installatie', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (65, '51', 'Kampeerterrein / jachthaven > 20 kampeerplaatsen / ligplaatsen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (66, '52', 'Evenementen (aandachtsevenement)', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (67, '53', 'Evenementen (risico-evenement)', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (68, '54', 'Tijdelijke Bouwsels', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (69, '55', 'Overige gevaarlijke stoffen >10 ton', 'C', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (70, '56', 'Overige gevaarlijke stoffen >50 ton', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (71, '57', 'Overige gevaarlijke stoffen >100 ton', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (72, '58', 'Radioactieve stoffen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (73, '59', 'Ammoniak > 500 kg', 'C', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (74, '60', 'Ammoniak > 1500 kg', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (75, '61', 'Ammoniak > 5 ton', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (76, '62', 'Object gecompartimenteerd en groter dan 2.500 m2 vloeroppervlakte', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (77, '63', 'Bulkopslag en compartimenten groter dan 2.500 m2 vloeroppervlakte', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (78, '64', 'Het omzetten van windenergie in mechanische, elektrische of thermische energie', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (79, '65', 'Het omzetten van hydrostatische energie in elektrische of thermische energie', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (80, '66', 'Het omzetten van elektrische energie in stralingsenergie', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (81, '67', 'Het omzetten van thermische energie in elektrische energie', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (82, '68', 'Het omzetten van Biomassa in energie', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (83, '69', 'Transformatorstations, met niet in een gesloten gebouw ondergebrachte transformatoren, met een maximaal gelijktijdig in te schakelen elektrisch vermogen van 200 MVA of meer', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (84, '70', 'Laboratoria, dierverblijven, opslagruimten of waar kassen aanwezig zijn, die zijn bestemd voor: de genetische modificatie van organismen of', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (85, '71', 'Objecten welk het voor onderwijs, onderzoek, ontwikkeling of niet-industriële doeleinden vermeerderen, opslaan, toepassen, voorhanden hebben, vervoeren, zich ontdoen of vernietigen van genetisch gemodificeerde organismen in hoeveelheden van niet meer dan tien liter cultuurvloeistof per eenheid of in hoeveelheden die om andere redenen zijn te beschouwen als kleinschalig;', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (86, '72', 'Dierverblijven, opslagruimten, kassen of installaties voor productieprocessen aanwezig zijn, die zijn bestemd voor het niet-kleinschalig vermeerderen, opslaan, toepassen, voorhanden hebben, vervoeren, zich ontdoen of vernietigen van genetisch gemodificeerde organismen', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (87, '73', 'Brandmeldinstallaties met doormelding brandweer vanuit wetgeving geëist.', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (88, '74', 'Brandbestrijdingsinstallaties indien door de brandweer bediend.', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (89, '75', 'Gasblussing tot en met 500 m2 vloeroppervlakte', 'C', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (90, '76', 'Gasblussing vanaf 500 m2 vloeroppervlakte', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (91, '77', 'Schuimblusinstallatie tot en met 2.500 m2 vloeroppervlakte', 'C', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (92, '78', 'Schuimblusinstallatie vanaf 2.500 m2 vloeroppervlakte', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (93, '79', 'Opvangregeling / bijzondere afspraken met BHV (waar en door wie wordt de eerste TS opgevangen of verder geleid)', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (94, '80', 'Aanrijroute, als die afwijkt van de normale route of als de route onbekend zou kunnen zijn; brandweer toegang anders dan hoofdingang.', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (95, '81', 'De plaats en aanwezigheid van de BMI dan wel het brandmeldpaneel', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (96, '82', 'De aanwezigheid van een BHV-organisatie /  bedrijfsnoodplan', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (97, '83', 'Afwijkende bluswatervoorziening', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (98, '84', 'Bijzondere inzetprocedures voor betreffende object', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (99, '85', 'Brandpreventieve voorzieningen als RWA e.d.', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (100, '86', 'Speciale gevaren / gevaarlijke stoffen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (101, '87', 'Ruimtes die slechts na overleg betreden moeten worden', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (102, '88', 'brandkranen ', 'A', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (103, '89', 'secundaire waterwinning', 'B', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (104, '90', 'tertiaire waterwinning / opstelplaats WTS', 'C', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (105, '91', 'asbest daken indien bekend', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (106, '92', 'rieten daken', 'B', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (107, '93', 'blusleidingen', 'B', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (108, '94', 'stijgleidingen', 'B', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (109, '95', 'object met sleutelkluis zonder andere voorzieningen', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (110, '96', 'uitgangsstelling', 'B', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (111, '97', 'Rangeerterrein, emplacement', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (112, '98', 'vliegveld', 'B', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (113, '99', 'Knooppunten wegen en rails', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (114, '100', 'Kunstwerken in verkeerswegen en rails langer dan 200 m', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (115, '101', 'Hoogspanningsstations 10 kV', 'D', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (116, '102', 'hoogspannings stations > 50KVA', 'D', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (117, '103', 'Hoogspanningstations 150 kV en 380 kV', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (118, '104', 'Gasstations (odorisatie stations)', 'C', 1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (119, '105', 'Sluizencomplex', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (120, '107', 'Complexe gebouwen, > 5 bouwlagen, > 500 personen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (121, '108', 'Gebouw met hoge infrastructurele waarde: computer- en telefooncentrale, knooppunten datatransport, vluchtleidingsapparatuur, meldkamer, commandopost', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (122, '109', 'cultuurerfgoed zonder publieksfunctie', 'D', 4);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (123, '111', 'Attractieparken meer dan 1000 personen', 'C', 3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (124, '112', 'Attractieparken meer dan 10.000 personen', 'B', 2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (125, '113', 'Attractieparken meer dan 15.000 personen', 'A', 1);


-- Opzoekwaarde toevoegen aan historie
ALTER TABLE historie ADD COLUMN matrix_code_id INTEGER;

UPDATE historie 
SET matrix_code_id = mc.id
FROM (SELECT id, matrix_code FROM matrix_code) As mc
WHERE historie.code = mc.matrix_code;

-- Objecten zonder matrix code tijdelijk een conversie naar 999
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (999,'999','Geen matrix code','X',999);

UPDATE historie SET matrix_code_id = 999 WHERE code IS NULL;

ALTER TABLE historie ADD CONSTRAINT matrix_code_id_fk FOREIGN KEY (matrix_code_id) REFERENCES matrix_code (id);
ALTER TABLE historie DROP COLUMN code;
