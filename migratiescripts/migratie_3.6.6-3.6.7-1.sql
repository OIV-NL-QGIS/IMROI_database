SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TYPE algemeen.symb_type AS ENUM ('a', 'b', 'c');
CREATE TYPE algemeen.tabbladen AS ENUM ('Algemeen', 'Evenement', 'Gebouw', 'Infrastructuur', 'Natuur', 'Water');
CREATE TYPE algemeen.anchorpoint AS ENUM ('top', 'center', 'bottom');

ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN actief_bouwlaag boolean DEFAULT true;
ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';

ALTER TABLE objecten.dreiging_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.dreiging_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.dreiging_type ADD COLUMN actief_bouwlaag boolean DEFAULT true;
ALTER TABLE objecten.dreiging_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.dreiging_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE objecten.dreiging_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';

ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN actief_bouwlaag boolean DEFAULT true;
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';

ALTER TABLE objecten.ingang_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.ingang_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.ingang_type ADD COLUMN actief_bouwlaag boolean DEFAULT true;
ALTER TABLE objecten.ingang_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.ingang_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE objecten.ingang_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';
UPDATE objecten.ingang_type SET anchorpoint = 'top'
  WHERE naam IN ('Brandweeringang', 'Neveningang', 'Neveningang  gebied terrein', 'Ingang gebied terrein');

ALTER TABLE objecten.object_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.object_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.object_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;

ALTER TABLE objecten.opstelplaats_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.opstelplaats_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.opstelplaats_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.opstelplaats_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE objecten.opstelplaats_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';

ALTER TABLE objecten.points_of_interest_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.points_of_interest_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.points_of_interest_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.points_of_interest_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE objecten.points_of_interest_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';

ALTER TABLE objecten.scenario_locatie_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN actief_bouwlaag boolean DEFAULT true;
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';

ALTER TABLE objecten.sleutelkluis_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN actief_bouwlaag boolean DEFAULT true;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';

ALTER TABLE objecten.veiligh_install_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.veiligh_install_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.veiligh_install_type ADD COLUMN actief_bouwlaag boolean DEFAULT true;
ALTER TABLE objecten.veiligh_install_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.veiligh_install_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE objecten.veiligh_install_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';

ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;

ALTER TABLE bluswater.alternatieve ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE bluswater.alternatieve ADD COLUMN formaat_object algemeen.formaat;
UPDATE bluswater.alternatieve SET formaat_object = 'middel';

ALTER TABLE bluswater.alternatieve_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE bluswater.alternatieve_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE bluswater.alternatieve_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE bluswater.alternatieve_type SET size_object_middel = size;

ALTER TABLE bluswater.alternatieve_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE bluswater.alternatieve_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE bluswater.alternatieve_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE bluswater.alternatieve_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE bluswater.alternatieve_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';

ALTER TABLE objecten.afw_binnendekking DROP CONSTRAINT soort_id_fk;
ALTER TABLE objecten.afw_binnendekking ADD CONSTRAINT afw_binnendekking_type_fk FOREIGN KEY (soort) REFERENCES objecten.afw_binnendekking_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.dreiging DROP CONSTRAINT dreiging_type_id_fk;
ALTER TABLE objecten.dreiging RENAME COLUMN dreiging_type_id TO soort;

DROP VIEW objecten.bouwlaag_dreiging;
DROP VIEW objecten.object_dreiging;
DROP VIEW objecten.view_dreiging_bouwlaag;
DROP VIEW objecten.view_dreiging_ruimtelijk;
DROP VIEW mobiel.symbolen;
DROP VIEW IF EXISTS objecten.mview_dreiging_bouwlaag;
DROP VIEW IF EXISTS objecten.mview_dreiging_ruimtelijk;

ALTER TABLE objecten.dreiging ALTER COLUMN soort TYPE varchar(100);
UPDATE objecten.dreiging SET soort = sub.naam
FROM 
(
	SELECT id::varchar, naam FROM objecten.dreiging_type
) sub
WHERE soort = sub.id;

DELETE FROM objecten.dreiging_type WHERE symbol_name = 'bijt_gevaar';

ALTER TABLE objecten.dreiging_type ADD CONSTRAINT dreiging_type_naam_uc UNIQUE (naam);
ALTER TABLE objecten.dreiging ADD CONSTRAINT dreiging_type_fk FOREIGN KEY (soort) REFERENCES objecten.dreiging_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.ingang DROP CONSTRAINT ingang_type_id_fk;
ALTER TABLE objecten.ingang RENAME COLUMN ingang_type_id TO soort;

DROP VIEW objecten.bouwlaag_ingang;
DROP VIEW objecten.object_ingang;
DROP VIEW objecten.view_ingang_bouwlaag;
DROP VIEW objecten.view_ingang_ruimtelijk;

DROP VIEW IF EXISTS objecten.mview_ingang_bouwlaag;
DROP VIEW IF EXISTS objecten.mview_ingang_ruimtelijk;

ALTER TABLE objecten.ingang ALTER COLUMN soort TYPE varchar(50);
UPDATE objecten.ingang SET soort = sub.naam
FROM 
(
	SELECT id::varchar, naam FROM objecten.ingang_type
) sub
WHERE soort = sub.id;

ALTER TABLE objecten.ingang_type ADD CONSTRAINT ingang_type_naam_uc UNIQUE (naam);
ALTER TABLE objecten.ingang ADD CONSTRAINT ingang_type_fk FOREIGN KEY (soort) REFERENCES objecten.ingang_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.gevaarlijkestof_opslag ADD COLUMN soort varchar(50);
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD CONSTRAINT gevaarlijkestof_opslag_type_naam_uc UNIQUE (naam);
ALTER TABLE objecten.gevaarlijkestof_opslag ADD CONSTRAINT gevaarlijkestof_opslag_type_fk FOREIGN KEY (soort) REFERENCES objecten.gevaarlijkestof_opslag_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.historie DROP CONSTRAINT typeobject_id_fk;
ALTER TABLE objecten.historie ADD CONSTRAINT object_type_fk FOREIGN KEY (typeobject) REFERENCES objecten.object_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.opstelplaats DROP CONSTRAINT opstelplaats_soort_id_fk;
ALTER TABLE objecten.opstelplaats ADD CONSTRAINT opstelplaats_type_id_fk FOREIGN KEY (soort) REFERENCES objecten.opstelplaats_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.points_of_interest DROP CONSTRAINT points_of_interest_type_id_fk;
ALTER TABLE objecten.points_of_interest RENAME COLUMN points_of_interest_type_id TO soort;

DROP VIEW objecten.object_points_of_interest;
DROP VIEW objecten.view_points_of_interest;

DROP VIEW IF EXISTS objecten.mview_points_of_interest;

ALTER TABLE objecten.points_of_interest ALTER COLUMN soort TYPE varchar(50);
UPDATE objecten.points_of_interest SET soort = sub.naam
FROM 
(
	SELECT id::varchar, naam FROM objecten.points_of_interest_type
) sub
WHERE soort = sub.id;

ALTER TABLE objecten.points_of_interest_type ADD CONSTRAINT points_of_interest_type_naam_uc UNIQUE (naam);
ALTER TABLE objecten.points_of_interest ADD CONSTRAINT points_of_interest_type_fk FOREIGN KEY (soort) REFERENCES objecten.points_of_interest_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.sleutelkluis DROP CONSTRAINT sleutelkluis_type_id_fk;
ALTER TABLE objecten.sleutelkluis RENAME COLUMN sleutelkluis_type_id TO soort;

DROP VIEW objecten.bouwlaag_sleutelkluis;
DROP VIEW objecten.object_sleutelkluis;
DROP VIEW objecten.view_sleutelkluis_bouwlaag;
DROP VIEW objecten.view_sleutelkluis_ruimtelijk;

DROP VIEW IF EXISTS objecten.mview_sleutelkluis_bouwlaag;
DROP VIEW IF EXISTS objecten.mview_sleutelkluis_ruimtelijk;

ALTER TABLE objecten.sleutelkluis ALTER COLUMN soort TYPE varchar(50);
UPDATE objecten.sleutelkluis SET soort = sub.naam
FROM 
(
	SELECT id::varchar, naam FROM objecten.sleutelkluis_type
) sub
WHERE soort = sub.id;

ALTER TABLE objecten.sleutelkluis_type ADD CONSTRAINT sleutelkluis_type_naam_uc UNIQUE (naam);
ALTER TABLE objecten.sleutelkluis ADD CONSTRAINT sleutelkluis_type_fk FOREIGN KEY (soort) REFERENCES objecten.sleutelkluis_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.sleutelkluis DROP CONSTRAINT sleuteldoel_type_id_fk;
ALTER TABLE objecten.sleutelkluis RENAME COLUMN sleuteldoel_type_id TO sleuteldoel;

ALTER TABLE objecten.sleutelkluis ALTER COLUMN sleuteldoel TYPE varchar(50);
UPDATE objecten.sleutelkluis SET sleuteldoel = sub.naam
FROM 
(
	SELECT id::varchar, naam FROM objecten.sleuteldoel_type
) sub
WHERE sleuteldoel = sub.id;

ALTER TABLE objecten.sleuteldoel_type ADD CONSTRAINT sleuteldoel_type_naam_uc UNIQUE (naam);
ALTER TABLE objecten.sleutelkluis ADD CONSTRAINT sleuteldoel_type_fk FOREIGN KEY (sleuteldoel) REFERENCES objecten.sleuteldoel_type(naam) ON UPDATE CASCADE;

UPDATE objecten.afw_binnendekking_type SET naam = 'DMO', symbol_name_new='bbh001', symbol_type='c' WHERE symbol_name = 'dekkingsprobleem_dmo';
UPDATE objecten.afw_binnendekking_type SET naam = 'TMO', symbol_name_new='bbh003', symbol_type='c' WHERE symbol_name = 'dekkingsprobleem_tmo';

UPDATE objecten.afw_binnendekking_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE objecten.afw_binnendekking_type DROP COLUMN symbol_name_new;

UPDATE objecten.dreiging_type SET naam = 'Aanrijding', symbol_name_new='drg001', symbol_type='c' WHERE symbol_name = 'aanrijding';
UPDATE objecten.dreiging_type SET naam = 'Accus en klein chemisch materiaal', symbol_name_new='drg002', symbol_type='c' WHERE symbol_name = 'klein_chemisch';
UPDATE objecten.dreiging_type SET naam = 'Agressie', symbol_name_new='drg003', symbol_type='c' WHERE symbol_name = 'agressie';
UPDATE objecten.dreiging_type SET naam = 'Algemeen gevaar', symbol_name_new='drg004', symbol_type='c' WHERE symbol_name = 'algemeen_gevaar';
UPDATE objecten.dreiging_type SET naam = 'Asbest', symbol_name_new='drg005', symbol_type='c' WHERE symbol_name = 'asbest';
UPDATE objecten.dreiging_type SET naam = 'Beknelling', symbol_name_new='drg006', symbol_type='c' WHERE symbol_name = 'beknelling';
UPDATE objecten.dreiging_type SET naam = 'Beschadiging', symbol_name_new='drg007', symbol_type='c' WHERE symbol_name = 'beschadiging';
UPDATE objecten.dreiging_type SET naam = 'Besmetting', symbol_name_new='drg008', symbol_type='c' WHERE symbol_name = 'besmetting';
UPDATE objecten.dreiging_type SET naam = 'Bijtende stoffen', symbol_name_new='drg009', symbol_type='c' WHERE symbol_name = 'bijtende_stoffen';
UPDATE objecten.dreiging_type SET naam = 'Bijtgevaar', symbol_name_new='drg010', symbol_type='c' WHERE symbol_name = 'bijtgevaar';
UPDATE objecten.dreiging_type SET naam = 'Biologische agentia-infectueus', symbol_name_new='drg011', symbol_type='c' WHERE symbol_name = 'biologische_agentia';
UPDATE objecten.dreiging_type SET naam = 'Brandgevaarlijk', symbol_name_new='drg012', symbol_type='c' WHERE symbol_name = 'ontvlambare_stoffen';
UPDATE objecten.dreiging_type SET naam = 'Desorientatie ', symbol_name_new='drg013', symbol_type='c' WHERE symbol_name = 'desorientatie';
UPDATE objecten.dreiging_type SET naam = 'Drukgolf', symbol_name_new='drg014', symbol_type='c' WHERE symbol_name = 'drukgolf';
UPDATE objecten.dreiging_type SET naam = 'Elektrische spanning', symbol_name_new='drg015', symbol_type='c' WHERE symbol_name = 'elektrische_spanning';
UPDATE objecten.dreiging_type SET naam = 'Elektrisering', symbol_name_new='drg016', symbol_type='c' WHERE symbol_name = 'elektrisering';
UPDATE objecten.dreiging_type SET naam = 'Exotische dieren', symbol_name_new='drg017', symbol_type='c' WHERE symbol_name = 'exotische_dieren';
UPDATE objecten.dreiging_type SET naam = 'Explosie', symbol_name_new='drg018', symbol_type='c' WHERE symbol_name = 'explosie';
UPDATE objecten.dreiging_type SET naam = 'Explosieve atmosfeer', symbol_name_new='drg019', symbol_type='c' WHERE symbol_name = 'explosieve_atmosfeer';
UPDATE objecten.dreiging_type SET naam = 'Explosieve stoffen', symbol_name_new='drg020', symbol_type='c' WHERE symbol_name = 'explosieve_stoffen';
UPDATE objecten.dreiging_type SET naam = 'Gastank', symbol_name_new='drg021', symbol_type='c' WHERE symbol_name = 'N19P18';
UPDATE objecten.dreiging_type SET naam = 'GHS01 Explosief', symbol_name_new='drg023', symbol_type='c' WHERE symbol_name = 'ontplofbare_stoffen_ghs';
UPDATE objecten.dreiging_type SET naam = 'GHS02 Ontvlambaar', symbol_name_new='drg024', symbol_type='c' WHERE symbol_name = 'ontvlambare_stoffen_ghs';
UPDATE objecten.dreiging_type SET naam = 'GHS03 Brand bevorderend (oxiderend)', symbol_name_new='drg025', symbol_type='c' WHERE symbol_name = 'oxiderende_stoffen_ghs';
UPDATE objecten.dreiging_type SET naam = 'GHS04 Houder onder druk', symbol_name_new='drg026', symbol_type='c' WHERE symbol_name = 'gassen_onder_druk_ghs';
UPDATE objecten.dreiging_type SET naam = 'GHS05 Corrosief (Bijtend)', symbol_name_new='drg027', symbol_type='c' WHERE symbol_name = 'corrosieve_stoffen_ghs';
UPDATE objecten.dreiging_type SET naam = 'GHS06 Giftig', symbol_name_new='drg028', symbol_type='c' WHERE symbol_name = 'giftige_stoffen_ghs';
UPDATE objecten.dreiging_type SET naam = 'GHS07 Schadelijk Irriterend allergische huidreactie', symbol_name_new='drg029', symbol_type='c' WHERE symbol_name = 'accuut_gevaar_ghs';
UPDATE objecten.dreiging_type SET naam = 'GHS08 Gezondheidsgevaar op lange termijn', symbol_name_new='drg030', symbol_type='c' WHERE symbol_name = 'gevaar_gezondheid_ghs';
UPDATE objecten.dreiging_type SET naam = 'GHS09 Milieugevaarlijk', symbol_name_new='drg031', symbol_type='c' WHERE symbol_name = 'gevaar_aquatisch_milieu_ghs';
UPDATE objecten.dreiging_type SET naam = 'Giftige stoffen', symbol_name_new='drg032', symbol_type='c' WHERE symbol_name = 'giftige_stoffen';
UPDATE objecten.dreiging_type SET naam = 'Glad oppervlak', symbol_name_new='drg033', symbol_type='c' WHERE symbol_name = 'glad_oppervlak';
UPDATE objecten.dreiging_type SET naam = 'Hangende lasten', symbol_name_new='drg034', symbol_type='c' WHERE symbol_name = 'hangende_lasten';
UPDATE objecten.dreiging_type SET naam = 'Heet oppervlak', symbol_name_new='drg035', symbol_type='c' WHERE symbol_name = 'heet_oppervlak';
UPDATE objecten.dreiging_type SET naam = 'Helling', symbol_name_new='drg036', symbol_type='c' WHERE symbol_name = 'helling';
UPDATE objecten.dreiging_type SET naam = 'Houder onder druk', symbol_name_new='drg038', symbol_type='c' WHERE symbol_name = 'houder_onder_druk';
UPDATE objecten.dreiging_type SET naam = 'Implosie', symbol_name_new='drg039', symbol_type='c' WHERE symbol_name = 'implosie';
UPDATE objecten.dreiging_type SET naam = 'Insluiting', symbol_name_new='drg040', symbol_type='c' WHERE symbol_name = 'insluiting';
UPDATE objecten.dreiging_type SET naam = 'Instorting', symbol_name_new='drg041', symbol_type='c' WHERE symbol_name = 'instorting';
UPDATE objecten.dreiging_type SET naam = 'Kortsluiting', symbol_name_new='drg042', symbol_type='c' WHERE symbol_name = 'kortsluiting';
UPDATE objecten.dreiging_type SET naam = 'Laadpaal EV', symbol_name_new='drg043', symbol_type='c' WHERE symbol_name = 'laadpaal_elektrisch_voertuig';
UPDATE objecten.dreiging_type SET naam = 'Lage temperatuur-bevriezing', symbol_name_new='drg044', symbol_type='c' WHERE symbol_name = 'lage_temperatuur_of_bevriezing';
UPDATE objecten.dreiging_type SET naam = 'Langetermijn gezondheidsschade', symbol_name_new='drg045', symbol_type='c' WHERE symbol_name = 'langetermijn_gezondheidsschade';
UPDATE objecten.dreiging_type SET naam = 'Laserstralen', symbol_name_new='drg046', symbol_type='c' WHERE symbol_name = 'laserstralen';
UPDATE objecten.dreiging_type SET naam = 'Li-ion batterijen', symbol_name_new='drg047', symbol_type='c' WHERE symbol_name = 'lithiumhoudende_batterijen';
UPDATE objecten.dreiging_type SET naam = 'Magnetisch veld', symbol_name_new='drg048', symbol_type='c' WHERE symbol_name = 'magnetisch_veld';
UPDATE objecten.dreiging_type SET naam = 'Niet met water blussen', symbol_name_new='drg049', symbol_type='c' WHERE symbol_name = 'niet_blussen_met_water';
UPDATE objecten.dreiging_type SET naam = 'Niet-ioniserende straling', symbol_name_new='drg050', symbol_type='c' WHERE symbol_name = 'niet_ioniserende_straling';
UPDATE objecten.dreiging_type SET naam = 'Op afstand bestuurde machines', symbol_name_new='drg051', symbol_type='c' WHERE symbol_name = 'op_afstand_bestuurde_machines';
UPDATE objecten.dreiging_type SET naam = 'Oxiderende stoffen', symbol_name_new='drg052', symbol_type='c' WHERE symbol_name = 'oxiderende_stoffen';
UPDATE objecten.dreiging_type SET naam = 'Radioactief materiaal', symbol_name_new='drg053', symbol_type='c' WHERE symbol_name = 'radioactief_materiaal' AND naam = 'Radioactief materiaal';
UPDATE objecten.dreiging_type SET naam = 'Schadelijk voor het milieu', symbol_name_new='drg054', symbol_type='c' WHERE symbol_name = 'schadelijk_voor_milieu';
UPDATE objecten.dreiging_type SET naam = 'Straling', symbol_name_new='drg055', symbol_type='c' WHERE naam = 'Straling';
UPDATE objecten.dreiging_type SET naam = 'Stroming', symbol_name_new='drg056', symbol_type='c' WHERE symbol_name = 'stroming';
UPDATE objecten.dreiging_type SET naam = 'Valgevaar', symbol_name_new='drg057', symbol_type='c' WHERE symbol_name = 'val_gevaar';
UPDATE objecten.dreiging_type SET naam = 'Verdrinking', symbol_name_new='drg058', symbol_type='c' WHERE symbol_name = 'verdrinking';
UPDATE objecten.dreiging_type SET naam = 'Verstikking', symbol_name_new='drg059', symbol_type='c' WHERE symbol_name = 'verstikking';
UPDATE objecten.dreiging_type SET naam = 'Verwonding', symbol_name_new='drg060', symbol_type='c' WHERE symbol_name = 'verwonding';

INSERT INTO objecten.dreiging_type (id, naam, symbol_name, "size", size_object) VALUES(210, 'GHS XX', 'drg022', 6, 12);

UPDATE objecten.dreiging SET soort = 'Elektrisering' WHERE soort = 'Elektrocutie';
DELETE FROM objecten.dreiging_type WHERE naam = 'Elektrocutie';
UPDATE objecten.dreiging SET soort = 'Lage temperatuur-bevriezing' WHERE soort = 'Onderkoeling';
DELETE FROM objecten.dreiging_type WHERE naam = 'Onderkoeling';
UPDATE objecten.dreiging SET soort = 'Glad oppervlak' WHERE soort = 'Uitglijden';
DELETE FROM objecten.dreiging_type WHERE naam = 'Uitglijden';

UPDATE objecten.dreiging_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE objecten.dreiging_type DROP COLUMN symbol_name_new;

UPDATE objecten.gevaarlijkestof_opslag_type SET naam = 'ADR Kemler -bord', symbol_name_new='gev001', symbol_type='c' WHERE symbol_name = 'opslag_stoffen';
UPDATE objecten.gevaarlijkestof_opslag SET soort = 'ADR Kemler -bord';
UPDATE objecten.gevaarlijkestof_opslag_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE objecten.gevaarlijkestof_opslag_type DROP COLUMN symbol_name_new;

UPDATE objecten.ingang_type SET naam = 'Brandweeringang', symbol_name_new='tgn001', symbol_type='c' WHERE symbol_name = 'brandweeringang';
UPDATE objecten.ingang_type SET naam = 'Brandweerlift', symbol_name_new='tgn002', symbol_type='c' WHERE symbol_name = 'brandweerlift';
UPDATE objecten.ingang_type SET naam = 'Deur L', symbol_name_new='tgn003', symbol_type='c' WHERE symbol_name = 'deur';
UPDATE objecten.ingang_type SET naam = 'Ingang gebied terrein', symbol_name_new='tgn006', symbol_type='c' WHERE symbol_name = 'N19P02';
UPDATE objecten.ingang_type SET naam = 'Lift', symbol_name_new='tgn007', symbol_type='c' WHERE symbol_name = 'lift';
UPDATE objecten.ingang_type SET naam = 'Neveningang  gebied terrein', symbol_name_new='tgn008', symbol_type='c' WHERE symbol_name = 'toegang_spoor';
UPDATE objecten.ingang_type SET naam = 'Neveningang', symbol_name_new='tgn009', symbol_type='c' WHERE symbol_name = 'neveningang';
UPDATE objecten.ingang_type SET naam = 'Schuifdeur dubbel', symbol_name_new='tgn010', symbol_type='c' WHERE symbol_name = 'schuifdeur_dubbel';
UPDATE objecten.ingang_type SET naam = 'Schuifdeur enkel links', symbol_name_new='tgn011', symbol_type='c' WHERE symbol_name = 'schuifdeur_enkel_links';
UPDATE objecten.ingang_type SET naam = 'Schuifdeur enkel rechts', symbol_name_new='tgn012', symbol_type='c' WHERE symbol_name = 'schuifdeur_enkel_rechts';
UPDATE objecten.ingang_type SET naam = 'Trap bordes', symbol_name_new='tgn016', symbol_type='c' WHERE symbol_name = 'trap_bordes';
UPDATE objecten.ingang_type SET naam = 'Trap recht', symbol_name_new='tgn017', symbol_type='c' WHERE symbol_name = 'trap_recht';
UPDATE objecten.ingang_type SET naam = 'Trap rond', symbol_name_new='tgn018', symbol_type='c' WHERE symbol_name = 'trap_rond';

UPDATE objecten.ingang_type SET naam = 'Nooduitgang', symbol_name='vvz049', symbol_type='c' WHERE symbol_name = 'nooduitgang';

INSERT INTO objecten.ingang_type (id, naam, symbol_name, "size", size_object) VALUES(705, 'Deur R', 'tgn004', 3, 6);
INSERT INTO objecten.ingang_type (id, naam, symbol_name, "size", size_object) VALUES(175, 'Generieke trap', 'tgn005', 5, 10);
INSERT INTO objecten.ingang_type (id, naam, symbol_name, "size", size_object) VALUES(176, 'SOS toegang', 'tgn015', 5, 10);

UPDATE objecten.ingang_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE objecten.ingang_type DROP COLUMN symbol_name_new;

UPDATE objecten.ingang SET soort = 'Ingang gebied terrein' WHERE soort = 'Brandweeringang' AND object_id IS NOT NULL;
UPDATE objecten.ingang SET soort = 'Neveningang  gebied terrein' WHERE soort = 'Neveningang' AND object_id IS NOT NULL;
DELETE FROM objecten.ingang_type WHERE naam = 'Inrijpunt';
DELETE FROM objecten.ingang_type WHERE naam = 'Toegang spoor';

UPDATE objecten.historie SET typeobject = 'Evenement' WHERE typeobject = 'Recreatiegebied';
DELETE FROM objecten.object_type WHERE naam = 'Recreatiegebied';

UPDATE objecten.object_type SET naam = 'Evenement C', symbol_name_new='ter003', symbol_type='c' WHERE naam = 'Evenement';
UPDATE objecten.object_type SET naam = 'Gebouw', symbol_name_new='ter004', symbol_type='c' WHERE naam = 'Gebouw';
UPDATE objecten.object_type SET naam = 'Natuur', symbol_name_new='ter006', symbol_type='c' WHERE naam = 'Natuur';
UPDATE objecten.object_type SET naam = 'Water', symbol_name_new='ter007', symbol_type='c' WHERE naam = 'Waterongeval';

INSERT INTO objecten.object_type (id, naam, symbol_name, "size") VALUES(5, 'Evenement B', 'ter002', 0);
INSERT INTO objecten.object_type (id, naam, symbol_name, "size") VALUES(6, 'Evenement A', 'ter001', 0);

UPDATE objecten.object_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE objecten.object_type DROP COLUMN symbol_name_new;

UPDATE objecten.opstelplaats_type SET naam = 'Politie', symbol_name_new='poi031', symbol_type='c' WHERE symbol_name = 'politie';
UPDATE objecten.opstelplaats_type SET naam = 'Autoladder', symbol_name_new='osp001', symbol_type='c' WHERE symbol_name = 'opstelplaats_autoladder';
UPDATE objecten.opstelplaats_type SET naam = 'Boot te water laat plaats', symbol_name_new='osp002', symbol_type='c' WHERE symbol_name = 'boot_te_water_laat_plaats';
UPDATE objecten.opstelplaats_type SET naam = 'COPI', symbol_name_new='osp003', symbol_type='c' WHERE symbol_name = 'copi';
UPDATE objecten.opstelplaats_type SET naam = 'Opstelplaats eerste blusvoertuig', symbol_name_new='osp005', symbol_type='c' WHERE symbol_name = 'opstelplaats_tankautospuit';
UPDATE objecten.opstelplaats_type SET naam = 'Opstelplaats overige blusvoertuigen', symbol_name_new='osp006', symbol_type='c' WHERE symbol_name = 'opstelplaats_overige_voertuigen';
UPDATE objecten.opstelplaats_type SET naam = 'Opstelplaats redvoertuig', symbol_name_new='osp007', symbol_type='c' WHERE symbol_name = 'opstelplaats_redvoertuig';
UPDATE objecten.opstelplaats_type SET naam = 'Opstelplaats WTS', symbol_name_new='osp009', symbol_type='c' WHERE symbol_name = 'opstelplaats_wts';
UPDATE objecten.opstelplaats_type SET naam = 'Schuimblusvoertuig', symbol_name_new='osp010', symbol_type='c' WHERE symbol_name = 'opstelplaats_sb';
UPDATE objecten.opstelplaats_type SET naam = 'UGS', symbol_name_new='osp011', symbol_type='c' WHERE symbol_name = 'ugs';

INSERT INTO objecten.opstelplaats_type (id, naam, symbol_name, "size") VALUES(11, 'Opstapplaats boot', 'ops004', 8);
INSERT INTO objecten.opstelplaats_type (id, naam, symbol_name, "size") VALUES(12, 'Opstelplaats WO', 'ops008', 8);

UPDATE objecten.opstelplaats_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE objecten.opstelplaats_type DROP COLUMN symbol_name_new;

UPDATE objecten.points_of_interest_type SET naam = 'Afsluitpaal of poller', symbol_name_new='poi001', symbol_type='c' WHERE symbol_name = 'poller';
UPDATE objecten.points_of_interest_type SET naam = 'ANWB Paddenstoel', symbol_name_new='poi002', symbol_type='c' WHERE symbol_name = 'N19P01';
UPDATE objecten.points_of_interest_type SET naam = 'Bivakplaats Defensie', symbol_name_new='poi005', symbol_type='c' WHERE symbol_name = 'N19P29';
UPDATE objecten.points_of_interest_type SET naam = 'Bungalowpark', symbol_name_new='poi010', symbol_type='c' WHERE symbol_name = 'N19P03';
UPDATE objecten.points_of_interest_type SET naam = 'Camping', symbol_name_new='poi012', symbol_type='c' WHERE symbol_name = 'N19P04';
UPDATE objecten.points_of_interest_type SET naam = 'Doorrijhoogte', symbol_name_new='poi014', symbol_type='c' WHERE symbol_name = 'doorrijhoogte';
UPDATE objecten.points_of_interest_type SET naam = 'Ecoduct', symbol_name_new='poi015', symbol_type='c' WHERE symbol_name = 'N19P12';
UPDATE objecten.points_of_interest_type SET naam = 'Hotel', symbol_name_new='poi019', symbol_type='c' WHERE symbol_name = 'N19P05';
UPDATE objecten.points_of_interest_type SET naam = 'Mountainbike route', symbol_name_new='poi023', symbol_type='c' WHERE symbol_name = 'N19P06';
UPDATE objecten.points_of_interest_type SET naam = 'Object vitale infrastructuur', symbol_name_new='poi024', symbol_type='c' WHERE symbol_name = 'N19P23';
UPDATE objecten.points_of_interest_type SET naam = 'Restaurant', symbol_name_new='poi032', symbol_type='c' WHERE symbol_name = 'N19P07';
UPDATE objecten.points_of_interest_type SET naam = 'Rustplaats', symbol_name_new='poi033', symbol_type='c' WHERE symbol_name = 'N19P08';
UPDATE objecten.points_of_interest_type SET naam = 'Sleutelpaal of ringpaal', symbol_name_new='poi034', symbol_type='c' WHERE symbol_name = 'sleutelpaal_of_ringpaal';
UPDATE objecten.points_of_interest_type SET naam = 'Solitair bouwwerk risicogevend', symbol_name_new='poi035', symbol_type='c' WHERE symbol_name = 'N19P25';
UPDATE objecten.points_of_interest_type SET naam = 'Solitair bouwwerk, risico-ontvangend', symbol_name_new='poi036', symbol_type='c' WHERE symbol_name = 'N19P26';
UPDATE objecten.points_of_interest_type SET naam = 'Solitair bouwwerk', symbol_name_new='poi037', symbol_type='c' WHERE symbol_name = 'N19P24';
UPDATE objecten.points_of_interest_type SET naam = 'Strandpaal, paal', symbol_name_new='poi039', symbol_type='c' WHERE symbol_name = 'N19P16';
UPDATE objecten.points_of_interest_type SET naam = 'Uitzichtpunt', symbol_name_new='poi041', symbol_type='c' WHERE symbol_name = 'N19P15';
UPDATE objecten.points_of_interest_type SET naam = 'Wildrooster', symbol_name_new='poi047', symbol_type='c' WHERE symbol_name = 'N19P10';
UPDATE objecten.points_of_interest_type SET naam = 'Windvaan', symbol_name_new='poi048', symbol_type='c' WHERE symbol_name = 'windvaan';
UPDATE objecten.points_of_interest_type SET naam = 'Zendmast', symbol_name_new='poi049', symbol_type='c' WHERE symbol_name = 'N19P17';
UPDATE objecten.points_of_interest_type SET naam = 'Zittafel', symbol_name_new='poi050', symbol_type='c' WHERE symbol_name = 'N19P09';

INSERT INTO objecten.points_of_interest_type (id, naam, symbol_name, "size") VALUES(60, 'Berijdbaar voor brandweer', 'poi004', 6);
INSERT INTO objecten.points_of_interest_type (id, naam, symbol_name, "size") VALUES(61, 'Omvormer', 'poi025', 6);
INSERT INTO objecten.points_of_interest_type (id, naam, symbol_name, "size") VALUES(62, 'Stuwrichting ventilaties', 'poi040', 6);

UPDATE objecten.points_of_interest_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE objecten.points_of_interest_type DROP COLUMN symbol_name_new;

UPDATE objecten.sleutelkluis_type SET naam = 'Sleutelkluis', symbol_name_new='tgn013', symbol_type='c' WHERE symbol_name = 'sleutelkluis';
UPDATE objecten.sleutelkluis_type SET naam = 'Sleutelkuis Havenbedrijf', symbol_name_new='tgn014', symbol_type='c' WHERE symbol_name = 'sleutelkluis_hbr';

INSERT INTO objecten.sleutelkluis_type (id, naam, symbol_name, "size", size_object) VALUES(2, 'SOS toegang', 'tgn015', 4, 8);

UPDATE objecten.sleutelkluis SET soort = 'Sleutelkluis' WHERE soort = 'sleutelbuis';
DELETE FROM objecten.sleutelkluis_type WHERE naam = 'sleutelbuis';

UPDATE objecten.sleutelkluis_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE objecten.sleutelkluis_type DROP COLUMN symbol_name_new;

UPDATE objecten.veiligh_install_type SET symbol_name_new='poi011', symbol_type='c' WHERE symbol_name = 'calamiteiten_coördinatiecentrum';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz001', symbol_type='c' WHERE symbol_name = 'activering_blussysteem';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz002', symbol_type='c' WHERE symbol_name = 'aed';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz003', symbol_type='c' WHERE symbol_name = 'afsluiter_cv';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz005', symbol_type='c' WHERE symbol_name = 'afsluiter_elektra';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz006', symbol_type='c' WHERE symbol_name = 'afsluiter_gas';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz007', symbol_type='c' WHERE symbol_name = 'afsluiter_luchtbehandeling';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz008', symbol_type='c' WHERE symbol_name = 'afsluiter_neon';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz009', symbol_type='c' WHERE symbol_name = 'afsluiter_omloop';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz010', symbol_type='c' WHERE symbol_name = 'afsluiter_rwa';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz011', symbol_type='c' WHERE symbol_name = 'afsluiter_sprinkler';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz012', symbol_type='c' WHERE symbol_name = 'afsluiter_svm';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz013', symbol_type='c' WHERE symbol_name = 'afsluiter_water';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz014', symbol_type='c' WHERE symbol_name = 'antidote_tegengif';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz017', symbol_type='c' WHERE symbol_name = 'blussysteem_afff';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz018', symbol_type='c' WHERE symbol_name = 'blussysteem_koolstofdioxide';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz019', symbol_type='c' WHERE symbol_name = 'blussysteem_hifog';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz021', symbol_type='c' WHERE symbol_name = 'blussysteem_schuim';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz022', symbol_type='c' WHERE symbol_name = 'blussysteem_water';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz025', symbol_type='c' WHERE symbol_name = 'brandblusser';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz026', symbol_type='c' WHERE symbol_name = 'brandmeldcentrale';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz027', symbol_type='c' WHERE symbol_name = 'brandmeldpaneel';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz028', symbol_type='c' WHERE symbol_name = 'brandslanghaspel';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz029', symbol_type='c' WHERE symbol_name = 'brandweerinfokast';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz037', symbol_type='c' WHERE symbol_name = 'flitslicht';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz038', symbol_type='c' WHERE symbol_name = 'gasdetectiepaneel';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz041', symbol_type='c' WHERE symbol_name = 'meterkast_e_g';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz042', symbol_type='c' WHERE symbol_name = 'meterkast_e_w';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz043', symbol_type='c' WHERE symbol_name = 'meterkast_e_g_w';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz044', symbol_type='c' WHERE symbol_name = 'meterkast_g_w';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz045', symbol_type='c' WHERE symbol_name = 'nevenpaneel';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz047', symbol_type='c' WHERE symbol_name = 'nooddouche';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz048', symbol_type='c' WHERE symbol_name = 'afsluiter_noodstop';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz050', symbol_type='c' WHERE symbol_name = 'ontruimingspaneel';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz051', symbol_type='c' WHERE symbol_name = 'oogdouche';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz052', symbol_type='c' WHERE symbol_name = 'overdruk_ventilatie';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz053', symbol_type='c' WHERE symbol_name = 'rookwarmte_afvoer';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz054', symbol_type='c' WHERE symbol_name = 'schacht_kanaal';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz031', symbol_type='c' WHERE symbol_name = 'stijgleiding_hd_afnamepunt';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz032', symbol_type='c' WHERE symbol_name = 'stijgleiding_hd_vulpunt';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz033', symbol_type='c' WHERE symbol_name = 'stijgleiding_ld_afnamepunt';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz034', symbol_type='c' WHERE symbol_name = 'stijgleiding_ld_vulpunt';
UPDATE objecten.veiligh_install_type SET symbol_name_new='vvz020', symbol_type='c' WHERE symbol_name = 'blussysteem_stikstof';

UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi016', symbol_type='c' WHERE symbol_name = 'feesttent';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi018', symbol_type='c' WHERE symbol_name = 'heli_vmc';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi020', symbol_type='c' WHERE symbol_name = 'kleedkamer';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi021', symbol_type='c' WHERE symbol_name = 'kraam_elektra';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi022', symbol_type='c' WHERE symbol_name = 'kraam_gas';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi027', symbol_type='c' WHERE symbol_name = 'opstapplaats_rpa';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi028', symbol_type='c' WHERE symbol_name = 'N19P28';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi029', symbol_type='c' WHERE symbol_name = 'parkeerplaats';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi030', symbol_type='c' WHERE symbol_name = 'N19P11';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi038', symbol_type='c' WHERE symbol_name = 'straattheater';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi042', symbol_type='c' WHERE symbol_name = 'N19P31';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi043', symbol_type='c' WHERE symbol_name = 'N19P32';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi044', symbol_type='c' WHERE symbol_name = 'vuurwerkafsteekplaats';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi045', symbol_type='c' WHERE symbol_name = 'N19P14';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi046', symbol_type='c' WHERE symbol_name = 'N19P13';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi051', symbol_type='c' WHERE symbol_name = 'N19P27';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz015', symbol_type='c' WHERE symbol_name = 'waterkanon_schuim';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz016', symbol_type='c' WHERE symbol_name = 'waterkanon';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz020', symbol_type='c' WHERE symbol_name = 'blussysteem_stikstof';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz023', symbol_type='c' WHERE symbol_name = 'brandbestrijdings_materiaal';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz024', symbol_type='c' WHERE symbol_name = 'brandbluspomp';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz039', symbol_type='c' WHERE symbol_name = 'generator';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz040', symbol_type='c' WHERE symbol_name = 'kade_aansluiting';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz046', symbol_type='c' WHERE symbol_name = 'installatie_defect';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz056', symbol_type='c' WHERE symbol_name = 'verzamelplaats';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz057', symbol_type='c' WHERE symbol_name = 'reduceer_drukbegrenzer';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi003', symbol_type='c' WHERE symbol_name = 'attractie';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi016', symbol_type='c' WHERE symbol_name = 'feesttent';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi018', symbol_type='c' WHERE symbol_name = 'heli_vmc';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi020', symbol_type='c' WHERE symbol_name = 'kleedkamer';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi021', symbol_type='c' WHERE symbol_name = 'kraam_elektra';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi022', symbol_type='c' WHERE symbol_name = 'kraam_gas';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi027', symbol_type='c' WHERE symbol_name = 'opstapplaats_rpa';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi028', symbol_type='c' WHERE symbol_name = 'N19P28';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi029', symbol_type='c' WHERE symbol_name = 'parkeerplaats';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi030', symbol_type='c' WHERE symbol_name = 'N19P11';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi038', symbol_type='c' WHERE symbol_name = 'straattheater';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi042', symbol_type='c' WHERE symbol_name = 'N19P31';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi043', symbol_type='c' WHERE symbol_name = 'N19P32';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi044', symbol_type='c' WHERE symbol_name = 'vuurwerkafsteekplaats';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi045', symbol_type='c' WHERE symbol_name = 'N19P14';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi046', symbol_type='c' WHERE symbol_name = 'N19P13';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi051', symbol_type='c' WHERE symbol_name = 'N19P27';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz015', symbol_type='c' WHERE symbol_name = 'waterkanon_schuim';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz016', symbol_type='c' WHERE symbol_name = 'waterkanon';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz020', symbol_type='c' WHERE symbol_name = 'blussysteem_stikstof';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz023', symbol_type='c' WHERE symbol_name = 'brandbestrijdings_materiaal';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz024', symbol_type='c' WHERE symbol_name = 'brandbluspomp';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz039', symbol_type='c' WHERE symbol_name = 'generator';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz040', symbol_type='c' WHERE symbol_name = 'kade_aansluiting';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz046', symbol_type='c' WHERE symbol_name = 'installatie_defect';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz056', symbol_type='c' WHERE symbol_name = 'verzamelplaats';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz057', symbol_type='c' WHERE symbol_name = 'reduceer_drukbegrenzer';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz012', symbol_type='c' WHERE symbol_name = 'afsluiter_svm';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz029', symbol_type='c' WHERE symbol_name = 'brandweerinfokast';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz003', symbol_type='c' WHERE symbol_name = 'afsluiter_cv';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz005', symbol_type='c' WHERE symbol_name = 'afsluiter_elektra';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz006', symbol_type='c' WHERE symbol_name = 'afsluiter_gas';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz007', symbol_type='c' WHERE symbol_name = 'afsluiter_luchtbehandeling';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz008', symbol_type='c' WHERE symbol_name = 'afsluiter_neon';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz048', symbol_type='c' WHERE symbol_name = 'afsluiter_noodstop';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz009', symbol_type='c' WHERE symbol_name = 'afsluiter_omloop';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz010', symbol_type='c' WHERE symbol_name = 'afsluiter_rwa';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz011', symbol_type='c' WHERE symbol_name = 'afsluiter_sprinkler';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz013', symbol_type='c' WHERE symbol_name = 'afsluiter_water';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz017', symbol_type='c' WHERE symbol_name = 'blussysteem_afff';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz019', symbol_type='c' WHERE symbol_name = 'blussysteem_hifog';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz018', symbol_type='c' WHERE symbol_name = 'blussysteem_koolstofdioxide';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz021', symbol_type='c' WHERE symbol_name = 'blussysteem_schuim';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz022', symbol_type='c' WHERE symbol_name = 'blussysteem_water';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz002', symbol_type='c' WHERE symbol_name = 'aed';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz001', symbol_type='c' WHERE symbol_name = 'activering_blussysteem';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz025', symbol_type='c' WHERE symbol_name = 'brandblusser';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz028', symbol_type='c' WHERE symbol_name = 'brandslanghaspel';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz051', symbol_type='c' WHERE symbol_name = 'oogdouche';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz047', symbol_type='c' WHERE symbol_name = 'nooddouche';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz054', symbol_type='c' WHERE symbol_name = 'schacht_kanaal';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi011', symbol_type='c' WHERE symbol_name = 'calamiteiten_coördinatiecentrum';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz014', symbol_type='c' WHERE symbol_name = 'antidote_tegengif';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz031', symbol_type='c' WHERE symbol_name = 'stijgleiding_hd_afnamepunt';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz032', symbol_type='c' WHERE symbol_name = 'stijgleiding_hd_vulpunt';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz033', symbol_type='c' WHERE symbol_name = 'stijgleiding_ld_afnamepunt';
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='vvz034', symbol_type='c' WHERE symbol_name = 'stijgleiding_ld_vulpunt';
--Hernoemen van een aantal symbolen, later samenvoegen met de andere met dezelfde symboolnaam, zie hierboven/-onder
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi018', symbol_type='c' WHERE symbol_name = 'N19P30';--Heli landplaats
UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name_new='poi032', symbol_type='c' WHERE symbol_name = 'restaurant';

--Een heel aantal pictogrammen horen mogelijk in een andere tabel thuis
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn001', symbol_type='c' WHERE symbol_name = 'bluswaterriool';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn002', symbol_type='c' WHERE symbol_name = 'bovengrondse_brandkraan';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn003', symbol_type='c' WHERE symbol_name = 'geboorde_put';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn003', symbol_type='c' WHERE symbol_name = 'geboorde_put_voordruk';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn004', symbol_type='c' WHERE symbol_name = 'N19P20';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn006', symbol_type='c' WHERE symbol_name = 'open_water_xxx_zijde';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn007', symbol_type='c' WHERE symbol_name = 'openwater_winput';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn008', symbol_type='c' WHERE symbol_name = 'N19P21';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn009', symbol_type='c' WHERE symbol_name = 'N19P22';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn009', symbol_type='c' WHERE symbol_name = 'N19P19';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn010', symbol_type='c' WHERE naam = 'Waterkelder';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn007', symbol_type='c' WHERE symbol_name = 'open_water';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn015', symbol_type='c' WHERE symbol_name = 'brandkraan_eigen_terrein';
UPDATE bluswater.alternatieve_type SET symbol_name_new='wwn015', symbol_type='c' WHERE symbol_name = 'particuliere_brandkraan';
UPDATE bluswater.alternatieve_type SET symbol_name_new='vvz035', symbol_type='c' WHERE symbol_name = 'stijgleiding_ld_vulpunt';
UPDATE bluswater.alternatieve_type SET symbol_name_new='vvz030', symbol_type='c' WHERE symbol_name = 'stijgleiding_ld_afnamepunt';
UPDATE bluswater.alternatieve_type SET symbol_name_new='vvz009', symbol_type='c' WHERE symbol_name = 'afsluiter_omloop';
UPDATE bluswater.alternatieve_type SET symbol_name_new='osp009', symbol_type='c' WHERE symbol_name = 'opstelplaats_wts';

ALTER TABLE objecten.veiligh_install DROP CONSTRAINT veiligh_install_type_id_fk;
ALTER TABLE objecten.veiligh_install RENAME COLUMN veiligh_install_type_id TO soort;

DROP VIEW objecten.bouwlaag_veiligh_install;
DROP VIEW objecten.view_veiligh_install;
DROP VIEW IF EXISTS objecten.mview_veiligh_install_bouwlaag;

ALTER TABLE objecten.veiligh_install ALTER COLUMN soort TYPE varchar(50);
UPDATE objecten.veiligh_install SET soort = sub.naam
FROM 
(
	SELECT id::varchar, naam FROM objecten.veiligh_install_type
) sub
WHERE soort = sub.id;

ALTER TABLE objecten.veiligh_install_type ADD CONSTRAINT veiligh_install_type_naam_uc UNIQUE (naam);
ALTER TABLE objecten.veiligh_install ADD CONSTRAINT veiligh_install_type_fk FOREIGN KEY (soort) REFERENCES objecten.veiligh_install_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.veiligh_install ADD COLUMN object_id int;
ALTER TABLE objecten.veiligh_install ADD COLUMN formaat_object algemeen.formaat;
ALTER TABLE objecten.veiligh_install ALTER COLUMN bouwlaag_id DROP NOT NULL;

ALTER TABLE objecten.veiligh_install ADD CONSTRAINT veiligh_install_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES objecten.object(id, self_deleted) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE objecten.veiligh_install_type ADD COLUMN size_object_klein numeric(3, 1) DEFAULT 2 NULL;
ALTER TABLE objecten.veiligh_install_type ADD COLUMN size_object_middel numeric(3, 1) DEFAULT 4 NULL;
ALTER TABLE objecten.veiligh_install_type ADD COLUMN size_object_groot numeric(3, 1) DEFAULT 6 NULL;

ALTER TABLE objecten.veiligh_install_type ADD COLUMN size_object int;

ALTER TABLE objecten.veiligh_ruimtelijk DROP CONSTRAINT veiligh_ruimtelijk_type_id_fk;
ALTER TABLE objecten.veiligh_ruimtelijk ADD CONSTRAINT veiligh_ruimtelijk_type_id_fk FOREIGN KEY (veiligh_ruimtelijk_type_id) REFERENCES objecten.veiligh_ruimtelijk_type(id) ON UPDATE CASCADE;

INSERT INTO objecten.veiligh_install_type (id, naam, symbol_name, "size_object", size_object_klein, size_object_middel, size_object_groot, symbol_name_new, symbol_type, actief_ruimtelijk)
SELECT id, naam, symbol_name, "size", size_object_klein, size_object_middel, size_object_groot, symbol_name_new, symbol_type, actief_ruimtelijk FROM objecten.veiligh_ruimtelijk_type
WHERE naam NOT IN (SELECT naam FROM objecten.veiligh_install_type) AND symbol_name_new LIKE 'vvz%';

INSERT INTO objecten.veiligh_install (geom, datum_aangemaakt, datum_gewijzigd, soort, "label", object_id, rotatie, fotografie_id, bijzonderheid, parent_deleted, self_deleted, label_positie, formaat_object)
SELECT geom, datum_aangemaakt, datum_gewijzigd, vt.naam, "label", object_id, rotatie, fotografie_id, bijzonderheid, parent_deleted, self_deleted, label_positie, formaat_object 
FROM objecten.veiligh_ruimtelijk v
INNER JOIN objecten.veiligh_ruimtelijk_type vt ON v.veiligh_ruimtelijk_type_id = vt.id
WHERE vt.symbol_name_new LIKE 'vvz%';

DELETE FROM objecten.veiligh_ruimtelijk
WHERE id IN (SELECT v.id FROM objecten.veiligh_ruimtelijk v INNER JOIN objecten.veiligh_ruimtelijk_type vt ON v.veiligh_ruimtelijk_type_id = vt.id WHERE vt.symbol_name_new LIKE 'vvz%');

UPDATE objecten.veiligh_ruimtelijk SET veiligh_ruimtelijk_type_id = 1009 WHERE veiligh_ruimtelijk_type_id = 2006;
UPDATE objecten.veiligh_ruimtelijk_type SET naam = 'Restaurant' WHERE naam = 'restaurant';
DELETE FROM objecten.veiligh_ruimtelijk_type WHERE id = 2006;

INSERT INTO objecten.points_of_interest_type (id, naam, symbol_name, "size", size_object_klein, size_object_middel, size_object_groot, symbol_type, actief_ruimtelijk)
SELECT id, naam, symbol_name_new, "size", size_object_klein, size_object_middel, size_object_groot, symbol_type, actief_ruimtelijk FROM objecten.veiligh_ruimtelijk_type
WHERE naam NOT IN (SELECT naam FROM objecten.points_of_interest_type) AND symbol_name_new LIKE 'poi%';

INSERT INTO objecten.points_of_interest (geom, datum_aangemaakt, datum_gewijzigd, soort, "label", object_id, rotatie, fotografie_id, bijzonderheid, parent_deleted, self_deleted, label_positie, formaat_object)
SELECT geom, datum_aangemaakt, datum_gewijzigd, vt.naam, "label", object_id, rotatie, fotografie_id, bijzonderheid, parent_deleted, self_deleted, label_positie, formaat_object 
FROM objecten.veiligh_ruimtelijk v
INNER JOIN objecten.veiligh_ruimtelijk_type vt ON v.veiligh_ruimtelijk_type_id = vt.id
WHERE vt.symbol_name_new LIKE 'poi%';

DELETE FROM objecten.veiligh_ruimtelijk
WHERE id IN (SELECT v.id FROM objecten.veiligh_ruimtelijk v INNER JOIN objecten.veiligh_ruimtelijk_type vt ON v.veiligh_ruimtelijk_type_id = vt.id WHERE vt.symbol_name_new LIKE 'poi%');

UPDATE objecten.points_of_interest_type SET naam = 'Attractie' WHERE symbol_name = 'poi003';
UPDATE objecten.points_of_interest_type SET naam = 'Feesttent' WHERE symbol_name = 'feesttent';
UPDATE objecten.points_of_interest_type SET naam = 'Heli landingsplaats' WHERE symbol_name = 'poi016';
UPDATE objecten.points_of_interest_type SET naam = 'Kleedkamer' WHERE symbol_name = 'poi020';
UPDATE objecten.points_of_interest_type SET naam = 'Kraam elektra' WHERE symbol_name = 'poi021';
UPDATE objecten.points_of_interest_type SET naam = 'Kraam gas' WHERE symbol_name = 'poi022';
UPDATE objecten.points_of_interest_type SET naam = 'Opstapplaats RPA' WHERE symbol_name = 'poi027';
UPDATE objecten.points_of_interest_type SET naam = 'Overdrachtsplaats ambulance-vervoer' WHERE symbol_name = 'poi028';
UPDATE objecten.points_of_interest_type SET naam = 'Parkeerplaats' WHERE symbol_name = 'poi029';
UPDATE objecten.points_of_interest_type SET naam = 'Passeerplaats' WHERE symbol_name = 'poi030';
UPDATE objecten.points_of_interest_type SET naam = 'Straattheater' WHERE symbol_name = 'poi038';
UPDATE objecten.points_of_interest_type SET naam = 'Verboden voor heli’s om te landen' WHERE symbol_name = 'poi042';
UPDATE objecten.points_of_interest_type SET naam = 'Vuurhaard' WHERE symbol_name = 'poi043';
UPDATE objecten.points_of_interest_type SET naam = 'Vuurwerkafsteekplaats' WHERE symbol_name = 'poi044';
UPDATE objecten.points_of_interest_type SET naam = 'Wegafsluiting passeerbaar' WHERE symbol_name = 'poi045';
UPDATE objecten.points_of_interest_type SET naam = 'Wegafsluiting' WHERE symbol_name = 'poi046';
UPDATE objecten.points_of_interest_type SET naam = 'Zwaartepunt' WHERE symbol_name = 'poi051';

UPDATE objecten.veiligh_install_type SET naam = 'Activering blussysteem' WHERE symbol_name_new = 'vvz001';
UPDATE objecten.veiligh_install_type SET naam = 'AED' WHERE symbol_name_new = 'vvz002';
UPDATE objecten.veiligh_install_type SET naam = 'Afsluiter CV' WHERE symbol_name_new = 'vvz003';
UPDATE objecten.veiligh_install_type SET naam = 'Afsluiter elektra' WHERE symbol_name_new = 'vvz005';
UPDATE objecten.veiligh_install_type SET naam = 'Afsluiter gas' WHERE symbol_name_new = 'vvz006';
UPDATE objecten.veiligh_install_type SET naam = 'Afsluiter luchtbehandeling' WHERE symbol_name_new = 'vvz007';
UPDATE objecten.veiligh_install_type SET naam = 'Afsluiter neon' WHERE symbol_name_new = 'vvz008';
UPDATE objecten.veiligh_install_type SET naam = 'Afsluiter omloop' WHERE symbol_name_new = 'vvz009';
UPDATE objecten.veiligh_install_type SET naam = 'Afsluiter rwa' WHERE symbol_name_new = 'vvz010';
UPDATE objecten.veiligh_install_type SET naam = 'Afsluiter sprinkler' WHERE symbol_name_new = 'vvz011';
UPDATE objecten.veiligh_install_type SET naam = 'Afsluiter SVM' WHERE symbol_name_new = 'vvz012';
UPDATE objecten.veiligh_install_type SET naam = 'Afsluiter water' WHERE symbol_name_new = 'vvz013';
UPDATE objecten.veiligh_install_type SET naam = 'Antidote tegengif' WHERE symbol_name_new = 'vvz014';
UPDATE objecten.veiligh_install_type SET naam = 'Blusmonitor S (schuim)' WHERE symbol_name_new = 'vvz015';
UPDATE objecten.veiligh_install_type SET naam = 'Blusmonitor W water (waterkanon)' WHERE symbol_name_new = 'vvz016';
UPDATE objecten.veiligh_install_type SET naam = 'Blussysteem AFFF' WHERE symbol_name_new = 'vvz017';
UPDATE objecten.veiligh_install_type SET naam = 'Blussysteem CO2 (koolstofdioxide)' WHERE symbol_name_new = 'vvz018';
UPDATE objecten.veiligh_install_type SET naam = 'Blussysteem Hi-Fog (watermist)' WHERE symbol_name_new = 'vvz019';
UPDATE objecten.veiligh_install_type SET naam = 'Blussysteem N2 (stikstof)' WHERE symbol_name_new = 'vvz020';
UPDATE objecten.veiligh_install_type SET naam = 'Blussysteem S (schuim)' WHERE symbol_name_new = 'vvz021';
UPDATE objecten.veiligh_install_type SET naam = 'Blussysteem W (water)' WHERE symbol_name_new = 'vvz022';
UPDATE objecten.veiligh_install_type SET naam = 'Brandbestrijdingsmateriaal' WHERE symbol_name_new = 'vvz023';
UPDATE objecten.veiligh_install_type SET naam = 'Brandbluspomp' WHERE symbol_name_new = 'vvz024';
UPDATE objecten.veiligh_install_type SET naam = 'Brandblusser' WHERE symbol_name_new = 'vvz025';
UPDATE objecten.veiligh_install_type SET naam = 'Brandmeldinstallatie (BMC)' WHERE symbol_name_new = 'vvz026';
UPDATE objecten.veiligh_install_type SET naam = 'Brandmeldpaneel (BMP)' WHERE symbol_name_new = 'vvz027';
UPDATE objecten.veiligh_install_type SET naam = 'Brandslanghaspel' WHERE symbol_name_new = 'vvz028';
UPDATE objecten.veiligh_install_type SET naam = 'Brandweer info-kast' WHERE symbol_name_new = 'vvz029';
UPDATE objecten.veiligh_install_type SET naam = 'Buisleiding HD afnamepunt' WHERE symbol_name_new = 'vvz031';
UPDATE objecten.veiligh_install_type SET naam = 'Buisleiding HD vulpunt' WHERE symbol_name_new = 'vvz032';
UPDATE objecten.veiligh_install_type SET naam = 'Buisleiding LD afnamepunt' WHERE symbol_name_new = 'vvz033';
UPDATE objecten.veiligh_install_type SET naam = 'Buisleiding LD vulpunt' WHERE symbol_name_new = 'vvz034';
UPDATE objecten.veiligh_install_type SET naam = 'Eerste hulp' WHERE symbol_name_new = 'vvz036';
UPDATE objecten.veiligh_install_type SET naam = 'Flitslicht' WHERE symbol_name_new = 'vvz037';
UPDATE objecten.veiligh_install_type SET naam = 'Gas detectiepaneel' WHERE symbol_name_new = 'vvz038';
UPDATE objecten.veiligh_install_type SET naam = 'Generator' WHERE symbol_name_new = 'vvz039';
UPDATE objecten.veiligh_install_type SET naam = 'Kadeaansluiting blusboot' WHERE symbol_name_new = 'vvz040';
UPDATE objecten.veiligh_install_type SET naam = 'Meterkast elektra en gas' WHERE symbol_name_new = 'vvz041';
UPDATE objecten.veiligh_install_type SET naam = 'Meterkast elektra en water' WHERE symbol_name_new = 'vvz042';
UPDATE objecten.veiligh_install_type SET naam = 'Meterkast elektra, gas en water' WHERE symbol_name_new = 'vvz043';
UPDATE objecten.veiligh_install_type SET naam = 'Meterkast gas en water' WHERE symbol_name_new = 'vvz044';
UPDATE objecten.veiligh_install_type SET naam = 'Nevenpaneel (NP)' WHERE symbol_name_new = 'vvz045';
UPDATE objecten.veiligh_install_type SET naam = 'Niet bruikbaar' WHERE symbol_name_new = 'vvz046';
UPDATE objecten.veiligh_install_type SET naam = 'Nooddouche' WHERE symbol_name_new = 'vvz047';
UPDATE objecten.veiligh_install_type SET naam = 'Noodstop' WHERE symbol_name_new = 'vvz048';
UPDATE objecten.veiligh_install_type SET naam = 'Ontruimingspaneel' WHERE symbol_name_new = 'vvz050';
UPDATE objecten.veiligh_install_type SET naam = 'Oogdouche' WHERE symbol_name_new = 'vvz051';
UPDATE objecten.veiligh_install_type SET naam = 'Overdruk ventilatie' WHERE symbol_name_new = 'vvz052';
UPDATE objecten.veiligh_install_type SET naam = 'Rookwarmteafvoer RWA' WHERE symbol_name_new = 'vvz053';
UPDATE objecten.veiligh_install_type SET naam = 'Schacht of kanaal' WHERE symbol_name_new = 'vvz054';
UPDATE objecten.veiligh_install_type SET naam = 'Verzamelplaats' WHERE symbol_name_new = 'vvz056';
UPDATE objecten.veiligh_install_type SET naam = 'Water-reduceer (drukbegrenzer)' WHERE symbol_name_new = 'vvz057';

UPDATE objecten.veiligh_install_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE objecten.veiligh_install_type DROP COLUMN symbol_name_new;

UPDATE objecten.veiligh_install_type SET size_object = sub."size", size_object_middel = sub."size"
FROM 
(
  SELECT id, "size" FROM objecten.veiligh_ruimtelijk_type
) sub
WHERE veiligh_install_type.id = sub.id;

UPDATE objecten.veiligh_install_type SET "size_object" = 6 WHERE "size_object" IS NULL;

INSERT INTO objecten.veiligh_install_type (id, naam, symbol_name, "size_object", size_object_klein, size_object_middel, size_object_groot, symbol_type, actief_ruimtelijk)
SELECT id+7000, naam, symbol_name, "size", size_object_klein, size_object_middel, size_object_groot, symbol_type, actief_ruimtelijk FROM objecten.veiligh_ruimtelijk_type
WHERE symbol_name_new IS NULL;

INSERT INTO objecten.veiligh_install (geom, datum_aangemaakt, datum_gewijzigd, soort, "label", object_id, rotatie, fotografie_id, bijzonderheid, parent_deleted, self_deleted, label_positie, formaat_object)
SELECT geom, datum_aangemaakt, datum_gewijzigd, vt.naam, "label", object_id, rotatie, fotografie_id, bijzonderheid, parent_deleted, self_deleted, label_positie, formaat_object 
FROM objecten.veiligh_ruimtelijk v
INNER JOIN objecten.veiligh_ruimtelijk_type vt ON v.veiligh_ruimtelijk_type_id = vt.id
WHERE vt.symbol_name_new IS NULL;

UPDATE objecten.veiligh_install_type SET "size" = 4 WHERE "size" IS NULL;

INSERT INTO objecten.veiligh_install_type (id, naam, symbol_name, "size", size_object) VALUES(1100, 'Afsluiter diversen', 'vvz004', 4, 6);
INSERT INTO objecten.veiligh_install_type (id, naam, symbol_name, "size", size_object) VALUES(1101, 'Sprinklermeldinstallatie (SMC)', 'vvz055', 4, 6);
INSERT INTO objecten.veiligh_install_type (id, naam, symbol_name, "size", size_object) VALUES(1102, 'Buisleiding afnamepunt', 'vvz030', 4, 6);
INSERT INTO objecten.veiligh_install_type (id, naam, symbol_name, "size", size_object) VALUES(1103, 'Buisleiding vulpunt', 'vvz035', 4, 6);

INSERT INTO objecten.points_of_interest (geom, datum_aangemaakt, datum_gewijzigd, soort, "label", object_id, rotatie, fotografie_id, bijzonderheid, parent_deleted, self_deleted, label_positie, formaat_object)
SELECT geom, datum_aangemaakt, datum_gewijzigd, vt.naam, "label", object_id, rotatie, fotografie_id, bijzonderheid, parent_deleted, self_deleted, label_positie, formaat_object 
FROM objecten.veiligh_install v
INNER JOIN objecten.veiligh_install_type vt ON v.soort = vt.naam
WHERE vt.symbol_name = 'poi011';

ALTER TABLE objecten.veiligh_install DISABLE TRIGGER trg_set_delete;
DELETE FROM objecten.veiligh_install WHERE soort = 'Calamiteiten coördinatiecentrum';
ALTER TABLE objecten.veiligh_install ENABLE TRIGGER trg_set_delete;
DELETE FROM objecten.veiligh_install_type WHERE naam = 'Calamiteiten coördinatiecentrum';

UPDATE objecten.veiligh_install_type SET naam = 'Niet bruikbaar', symbol_name='vvz046', symbol_type='c' WHERE symbol_name = 'installatie_defect';

UPDATE bluswater.alternatieve_type SET naam = 'Niet bruikbaar', symbol_name_new='vvz046', symbol_type='c' WHERE symbol_name = 'bluswater_defect';

UPDATE bluswater.alternatieve_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE bluswater.alternatieve_type DROP COLUMN symbol_name_new;

ALTER TABLE bluswater.alternatieve_type ALTER COLUMN naam TYPE varchar(50);
UPDATE bluswater.alternatieve_type SET naam = 'Bluswaterriool' WHERE symbol_name = 'wwn001';
UPDATE bluswater.alternatieve_type SET naam = 'Bovengrondse brandkraan' WHERE symbol_name = 'wwn002';
UPDATE bluswater.alternatieve_type SET naam = 'Geboorde putten - dicht' WHERE symbol_name = 'wwn003';
UPDATE bluswater.alternatieve_type SET naam = 'Geboorde putten - open' WHERE symbol_name = 'wwn004';
UPDATE bluswater.alternatieve_type SET naam = 'Open water xxx zijde' WHERE symbol_name = 'wwn006';
UPDATE bluswater.alternatieve_type SET naam = 'Open water' WHERE symbol_name = 'wwn007';
UPDATE bluswater.alternatieve_type SET naam = 'Opvoerpomp of bronpomp' WHERE symbol_name = 'wwn008';
UPDATE bluswater.alternatieve_type SET naam = 'Water innamepunt (WIP)' WHERE symbol_name = 'wwn009';
UPDATE bluswater.alternatieve_type SET naam = 'Waterkelder - buffer' WHERE symbol_name = 'wwn010';
UPDATE bluswater.alternatieve_type SET naam = 'Ondergrondse brandkraan (particulier)' WHERE symbol_name = 'wwn015';

UPDATE bluswater.alternatieve_type SET naam = 'Opvoerpomp of bronpomp', symbol_name = 'wwn008' WHERE id = 1;
UPDATE bluswater.alternatieve SET type_id = 23, opmerking = CONCAT(opmerking, CHR(13), CHR(10), 'geboorde put met voordruk') WHERE type_id = 1;
DELETE FROM bluswater.alternatieve_type WHERE id = 1;

UPDATE bluswater.alternatieve SET type_id = 10, opmerking = CONCAT(opmerking, CHR(13), CHR(10), 'openwater winput') WHERE type_id = 7;
DELETE FROM bluswater.alternatieve_type WHERE id = 7;

UPDATE bluswater.alternatieve SET type_id = 24 WHERE type_id = 21;
DELETE FROM bluswater.alternatieve_type WHERE id = 21;

UPDATE bluswater.alternatieve SET type_id = 9 WHERE type_id = 14;
DELETE FROM bluswater.alternatieve_type WHERE id = 14;

ALTER TABLE bluswater.alternatieve DROP CONSTRAINT altern_type_id_fk;
ALTER TABLE bluswater.alternatieve RENAME COLUMN type_id TO soort;
ALTER TABLE bluswater.alternatieve ALTER COLUMN soort TYPE varchar(50);

UPDATE bluswater.alternatieve SET soort = sub.naam
FROM 
(
	SELECT id::varchar, naam FROM bluswater.alternatieve_type
) sub
WHERE soort = sub.id;

ALTER TABLE bluswater.alternatieve_type ADD CONSTRAINT alternatieve_type_naam_uc UNIQUE (naam);
ALTER TABLE bluswater.alternatieve ADD CONSTRAINT alternatieve_type_fk FOREIGN KEY (soort) REFERENCES bluswater.alternatieve_type(naam) ON UPDATE CASCADE;

INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, size) VALUES (30, 'Bluswaterriool (particulier)','wwn011', 6);
INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, size) VALUES (31, 'Bovengrondse brandkraan (particulier)','wwn012', 6);
INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, size) VALUES (32, 'Geboorde putten - dicht (particulier)','wwn013', 6);
INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, size) VALUES (33, 'Geboorde putten - open (particulier)','wwn014', 6);
INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, size) VALUES (34, 'Open water xxx zijde (particulier)','wwn016', 6);
INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, size) VALUES (35, 'Open water (particulier)','wwn017', 6);
INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, size) VALUES (36, 'Opvoerpomp of bronpomp (particulier)','wwn018', 6);
INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, size) VALUES (37, 'Water innamepunt (WIP) (particulier)','wwn019', 6);
INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, size) VALUES (38, 'Waterkelder - buffer (particulier)','wwn020', 6);

ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.bereikbaarheid_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.dreiging_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.gebiedsgerichte_aanpak_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.ingang_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.isolijnen_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.label_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.opstelplaats_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.points_of_interest_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.ruimten_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.sectoren_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.veiligh_bouwk_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.veiligh_install_type ADD COLUMN tabbladen json;
ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN tabbladen json;
ALTER TABLE bluswater.alternatieve_type ADD COLUMN tabbladen json;

UPDATE objecten.afw_binnendekking_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.bereikbaarheid_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.dreiging_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.gebiedsgerichte_aanpak_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.gevaarlijkestof_opslag_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.ingang_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.isolijnen_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.label_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.opstelplaats_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.points_of_interest_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.ruimten_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.scenario_locatie_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.sectoren_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.sleutelkluis_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.veiligh_bouwk_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.veiligh_install_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE objecten.veiligh_ruimtelijk_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';
UPDATE bluswater.alternatieve_type SET tabbladen = '{"Algemeen":1, "Evenement":0, "Gebouw":0, "Infrastructuur":0, "Natuur":0, "Water":0}';

ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.bereikbaarheid_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.dreiging_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.gebiedsgerichte_aanpak_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.ingang_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.isolijnen_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.label_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.opstelplaats_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.points_of_interest_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.ruimten_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.sectoren_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.veiligh_bouwk_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.veiligh_install_type ADD COLUMN volgnummer int;
ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN volgnummer int;

ALTER TABLE objecten.gebiedsgerichte_aanpak_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.isolijnen_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.label_type ADD COLUMN actief_bouwlaag boolean DEFAULT true;
ALTER TABLE objecten.label_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.ruimten_type ADD COLUMN actief_bouwlaag boolean DEFAULT true;
ALTER TABLE objecten.sectoren_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.veiligh_bouwk_type ADD COLUMN actief_bouwlaag boolean DEFAULT true;
ALTER TABLE objecten.bereikbaarheid_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE objecten.label_type ADD COLUMN snap boolean DEFAULT false;

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.afw_binnendekking_type)
	UPDATE objecten.afw_binnendekking_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = afw_binnendekking_type.naam);
ALTER TABLE objecten.afw_binnendekking_type ADD CONSTRAINT afw_binnendekking_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.bereikbaarheid_type)
	UPDATE objecten.bereikbaarheid_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = bereikbaarheid_type.naam);
ALTER TABLE objecten.bereikbaarheid_type ADD CONSTRAINT bereikbaarheid_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.dreiging_type)
	UPDATE objecten.dreiging_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = dreiging_type.naam);
ALTER TABLE objecten.dreiging_type ADD CONSTRAINT dreiging_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.gebiedsgerichte_aanpak_type)
	UPDATE objecten.gebiedsgerichte_aanpak_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = gebiedsgerichte_aanpak_type.naam);
ALTER TABLE objecten.gebiedsgerichte_aanpak_type ADD CONSTRAINT gebiedsgerichte_aanpak_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.gevaarlijkestof_opslag_type)
	UPDATE objecten.gevaarlijkestof_opslag_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = gevaarlijkestof_opslag_type.naam);
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD CONSTRAINT gevaarlijkestof_opslag_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.ingang_type)
	UPDATE objecten.ingang_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = ingang_type.naam);
ALTER TABLE objecten.ingang_type ADD CONSTRAINT ingang_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.isolijnen_type)
	UPDATE objecten.isolijnen_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = isolijnen_type.naam);
ALTER TABLE objecten.isolijnen_type ADD CONSTRAINT isolijnen_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.label_type)
	UPDATE objecten.label_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = label_type.naam);
ALTER TABLE objecten.label_type ADD CONSTRAINT label_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.opstelplaats_type)
	UPDATE objecten.opstelplaats_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = opstelplaats_type.naam);
ALTER TABLE objecten.opstelplaats_type ADD CONSTRAINT opstelplaats_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.points_of_interest_type)
	UPDATE objecten.points_of_interest_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = points_of_interest_type.naam);
ALTER TABLE objecten.points_of_interest_type ADD CONSTRAINT points_of_interest_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.ruimten_type)
	UPDATE objecten.ruimten_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = ruimten_type.naam);
ALTER TABLE objecten.ruimten_type ADD CONSTRAINT ruimten_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.scenario_locatie_type)
	UPDATE objecten.scenario_locatie_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = scenario_locatie_type.naam);
ALTER TABLE objecten.scenario_locatie_type ADD CONSTRAINT scenario_locatie_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.sectoren_type)
	UPDATE objecten.sectoren_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = sectoren_type.naam);
ALTER TABLE objecten.sectoren_type ADD CONSTRAINT sectoren_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.sleutelkluis_type)
	UPDATE objecten.sleutelkluis_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = sleutelkluis_type.naam);
ALTER TABLE objecten.sleutelkluis_type ADD CONSTRAINT sleutelkluis_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.veiligh_bouwk_type)
	UPDATE objecten.veiligh_bouwk_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = veiligh_bouwk_type.naam);
ALTER TABLE objecten.veiligh_bouwk_type ADD CONSTRAINT veiligh_bouwk_type_volgnummer_uc UNIQUE (volgnummer);

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM objecten.veiligh_install_type)
	UPDATE objecten.veiligh_install_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = veiligh_install_type.naam);
ALTER TABLE objecten.veiligh_install_type ADD CONSTRAINT veiligh_install_type_volgnummer_uc UNIQUE (volgnummer);

ALTER TABLE objecten."label" DROP CONSTRAINT label_soort_id_fk;
ALTER TABLE objecten."label" ADD CONSTRAINT label_soort_fk FOREIGN KEY (soort) REFERENCES objecten.label_type(naam) ON UPDATE CASCADE;

UPDATE objecten.label_type SET symbol_name = 'calamiteiten_coordinatiecentrum', naam = 'Calamiteiten coördinatiecentrum' WHERE naam = 'CCR';

ALTER TABLE objecten.veiligh_bouwk DROP CONSTRAINT veiligh_bouwk_soort_id_fk;
ALTER TABLE objecten.veiligh_bouwk ADD CONSTRAINT veiligh_bouwk_soort_id_fk FOREIGN KEY (soort) REFERENCES objecten.veiligh_bouwk_type(naam) ON UPDATE CASCADE;

UPDATE objecten.veiligh_bouwk_type SET naam = 'blusleiding' WHERE naam = 'blusleiding_bouwlaag';
UPDATE objecten.veiligh_bouwk_type SET naam = 'contouren' WHERE naam = 'contouren_bouwlaag';
UPDATE objecten.veiligh_bouwk_type SET naam = 'hulplijn' WHERE naam = 'hulplijn_bouwlaag';
UPDATE objecten.veiligh_bouwk_type SET naam = 'slagboom' WHERE naam = 'slagboom_bouwlaag';

ALTER TABLE objecten.ruimten DROP CONSTRAINT ruimten_type_id_fk;
ALTER TABLE objecten.ruimten ADD CONSTRAINT ruimten_soort_fk FOREIGN KEY (ruimten_type_id) REFERENCES objecten.ruimten_type(naam) ON UPDATE CASCADE;

UPDATE objecten.ruimten_type SET naam = 'zwembad' WHERE naam = 'zwembad binnen';

DROP VIEW objecten.bouwlaag_ruimten;
DROP VIEW objecten.view_ruimten;

ALTER TABLE objecten.ruimten RENAME COLUMN ruimten_type_id TO soort;

UPDATE objecten.dreiging SET soort = 'Brandgevaarlijk' WHERE soort = 'Brand';
DELETE FROM objecten.dreiging_type WHERE naam = 'Brand';

ALTER TABLE objecten.bereikbaarheid DROP CONSTRAINT soort_id_fk;
ALTER TABLE objecten.bereikbaarheid ADD CONSTRAINT bereikbaarheid_soort_fk FOREIGN KEY (soort) REFERENCES objecten.bereikbaarheid_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.gebiedsgerichte_aanpak DROP CONSTRAINT soort_id_fk;
ALTER TABLE objecten.gebiedsgerichte_aanpak ADD CONSTRAINT gebiedsgerichte_aanpak_soort_fk FOREIGN KEY (soort) REFERENCES objecten.gebiedsgerichte_aanpak_type(naam) ON UPDATE CASCADE;

ALTER TABLE objecten.sectoren DROP CONSTRAINT sectoren_soort_id_fk;
ALTER TABLE objecten.sectoren ADD CONSTRAINT sectoren_soort_fk FOREIGN KEY (soort) REFERENCES objecten.sectoren_type(naam) ON UPDATE CASCADE;

UPDATE objecten.opstelplaats SET soort = 'Foambooster' WHERE soort = 'Foambooster 2';
DELETE FROM objecten.opstelplaats_type WHERE naam = 'Foambooster 2';
UPDATE objecten.opstelplaats_type SET symbol_name = 'foambooster' WHERE naam = 'Foambooster';
UPDATE objecten.opstelplaats_type SET symbol_name = 'dompelpomp_unit' WHERE naam = 'Dompelpomp unit';
UPDATE objecten.opstelplaats_type SET symbol_name = 'schuim_trailer' WHERE naam = 'Schuim trailer';

UPDATE objecten.opstelplaats_type SET symbol_name = 'osp004' WHERE naam = 'Opstapplaats boot';
UPDATE objecten.opstelplaats_type SET symbol_name = 'osp008' WHERE naam = 'Opstelplaats WO';

UPDATE objecten.bereikbaarheid_type SET naam = REPLACE(naam, '/', ' of ');
UPDATE objecten.gebiedsgerichte_aanpak_type SET naam = REPLACE(naam, ':', '');
UPDATE objecten.gebiedsgerichte_aanpak_type SET naam = REPLACE(naam, '/', ' of ');

UPDATE bluswater.alternatieve SET soort = 'Open water xxx zijde' WHERE soort = 'Open water onbereikbaar';
DELETE FROM bluswater.alternatieve_type WHERE naam = 'Open water onbereikbaar';

UPDATE algemeen.styles SET soortnaam = REPLACE(soortnaam, '/', ' of ');
UPDATE algemeen.styles SET soortnaam = REPLACE(soortnaam, ':', '');
UPDATE algemeen.styles SET soortnaam = REPLACE(soortnaam, '/', ' of ');
UPDATE algemeen.styles SET soortnaam = REPLACE(soortnaam, ',', '');

ALTER TABLE objecten.scenario_locatie ADD COLUMN soort varchar(50);
ALTER TABLE objecten.scenario_locatie_type ADD CONSTRAINT scenario_locatie_type_naam_uc UNIQUE (naam);
ALTER TABLE objecten.scenario_locatie ADD CONSTRAINT scenario_locatie_type_fk FOREIGN KEY (soort) REFERENCES objecten.scenario_locatie_type(naam) ON UPDATE CASCADE;
UPDATE objecten.scenario_locatie SET soort = 'Scenario locatie';

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 367; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
