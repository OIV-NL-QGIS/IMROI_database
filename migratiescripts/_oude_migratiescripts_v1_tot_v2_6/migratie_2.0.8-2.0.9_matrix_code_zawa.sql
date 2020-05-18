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
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (1,'1','Gebouwen met onderste verdiepingsvloer meer dan 5 meter onder maaiveld','B',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (2,'2','Zorgclusterwoning voor 24-uurs zorg in een woongebouw','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (3,'3','Groepszorgwoning voor 24-uurs zorg','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (4,'04a','Kinderdagverblijf en peuterspeelzaal - 25 tm 100 kinderen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (5,'04b','Kinderdagverblijf en peuterspeelzaal - meer dan 100 kinderen','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (6,'05a','Theater, schouwburg, bioscoop, aula, museum of bibliotheek - 500-999 personen  ','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (7,'05b','Theater, schouwburg, bioscoop, aula, museum of bibliotheek - 1000 personen of meer','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (8,'06a','Buurthuis, ontmoetingscentrum, wijkcentrum of gebedshuis - 500-999 personen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (9,'06b','Buurthuis, ontmoetingscentrum, wijkcentrum of gebedshuis - 1000 personen of meer','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (10,'07a','Tentoonstellingsgebouwen, kantine, eetzaal, cafés, discotheken of restaurants 500-999 personen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (11,'07b','Tentoonstellingsgebouwen, kantine, eetzaal, cafés, discotheken of restaurants 1000 personen of meer','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (12,'8','Objecten met grote economische waarde < 500 mensen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (13,'9','Celgebouwen met 24-uursbezetting','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (14,'10','Met bedgebied bv. ziekenhuis, verpleegtehuis','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (15,'11a','Fabrieken met 500-999 personen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (16,'11b','Fabrieken met 1000 personen of meer','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (17,'12a','Kantoren met 500-999 personen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (18,'12b','Kantoren met 1000 personen of meer','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (19,'13a','Hotel, pension, nachtverblijf met 10 - 49 personen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (20,'13b','Hotel, pension, nachtverblijf meer 50 personen of meer','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (21,'14a','Dagverblijf gehandicapten met 10-50 personen','B',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (22,'14b','Dagverblijf gehandicapten met meer dan 50 personen','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (23,'15','School leerlingen 4-12 jaar meer dan 350 personen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (24,'16','School leerlingen >12 jaar meer dan 1000 personen','B',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (25,'17a','Gymzaal, studio (bv ballet), sporthal, stadion of zwembad ','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (26,'17b','Gymzaal, studio (bv ballet), sporthal, stadion of zwembad - meer dan 5000 personen','B',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (27,'18a','Winkelgebouwen 500-1000 personen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (28,'18b','Winkelgebouwen met meer dan 1000 personen','B',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (29,'19a','Gebouwen met 500-1000 personen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (30,'19b','Gebouwen met meer dan 1000 personen','B',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (31,'20','Tunnels langer dan 200 meter','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (32,'21','Loods, veem en/of opslagplaats >2.500 m2','C',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (33,'22','Garage inrichtingen (opslag, stalling) >1.000 m2','C',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (34,'23','Kampeerterrein en/of jachthaven met verminderde bereikbaarheid','C',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (35,'24a','Objecten gevaarlijke stoffen, zie Matrix ‘Gevaarlijke stoffen’, pag 7','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (36,'24b','Objecten gevaarlijke stoffen, zie Matrix ‘Gevaarlijke stoffen’, pag 7','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (37,'24c','Objecten gevaarlijke stoffen, zie Matrix ‘Gevaarlijke stoffen’, pag 7','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (38,'25','Hoogspanning stations 150 kV en 380 kV','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (39,'26','Transformatorstations, met niet in een gesloten gebouw ondergebrachte transformatoren, met een maximaal gelijktijdig in te schakelen elektrisch vermogen van 200 MVA of meer','B',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (40,'27','Het omzetten van thermische energie in elektrische energie','B',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (41,'28','Gasstations (odorisatie stations)','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (42,'29','Laboratoria, dierverblijven, opslagruimten of waar kassen aanwezig zijn, die zijn bestemd voor: de genetische modificatie van organismen','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (43,'30','Brandmeldinstallaties met doormelding brandweer vanuit wetgeving geëist.','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (44,'31','Object met brandweersleutelsysteem','C',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (45,'32','Gasblussing vanaf 500m2 vloeroppervlakte','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (46,'33','Schuimblusinstallatie vanaf 2500 m2 vloeroppervlakte','A',1);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (47,'34','Opvangregeling / bijzondere afspraken met BHV (waar en door wie wordt de eerste TS opgevangen of verder geleid) ','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (48,'35','Afwijkende bluswatervoorziening bv droge blusleiding','C',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (49,'36','Bijzondere inzetprocedures voor object, speciale gevaren','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (50,'37','Ruimtes die slechts na overleg met bedrijfsdeskundige betreden mogen worden','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (51,'38','Rangeerterrein, emplacement','C',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (52,'39','Gebouw met hoge infrastructurele waarde: computer- en telefooncentrale, knooppunten datatransport, vluchtleiding apparatuur, meldkamer, commandopost','B',2);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (53,'40','Als de diepte van het water meer dan 1,5 meter is','C',3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (54,'41','Bij groot water, water waarbij de inzetdiepte groter is dan 50 meter','C',3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (55,'42','Bij stroming of kans op stroming','C',3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (56,'43','Recreatievaart of gebieden waar veel waterrecreatie plaats vindt','C',3);
INSERT INTO matrix_code (id, matrix_code,omschrijving,actualisatie,prio_prod) VALUES (57,'44','Bij sluizen','C',3);

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