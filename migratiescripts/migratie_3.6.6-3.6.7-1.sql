SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

--TODO: naam aanpassingen vanuit Excel
-- 		categorie toevoegen
--		volgnummer toevoegen
--		symbolen toevoegen aan database
--		views aanpassen

--		bespreken niet gemapte symbolen
--		bespreken dubbele symbolen

CREATE TYPE algemeen.symb_type AS ENUM ('a', 'b', 'c');
CREATE TYPE algemeen.tabbladen AS ENUM ('Algemeen', 'Evenement', 'Gebouw', 'Infrastructuur', 'Natuur', 'Water');

ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE objecten.dreiging_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.dreiging_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.dreiging_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE objecten.ingang_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.ingang_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.ingang_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE objecten.object_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.object_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.object_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE objecten.opstelplaats_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.opstelplaats_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.opstelplaats_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE objecten.points_of_interest_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.points_of_interest_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.points_of_interest_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE objecten.scenario_locatie_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE objecten.sleutelkluis_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE objecten.veiligh_install_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.veiligh_install_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.veiligh_install_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN actief boolean DEFAULT true;

ALTER TABLE bluswater.alternatieve ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE bluswater.alternatieve ADD COLUMN formaat_object algemeen.formaat;
UPDATE bluswater.alternatieve SET formaat_object = 'middel';

ALTER TABLE bluswater.alternatieve_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE bluswater.alternatieve_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE bluswater.alternatieve_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE bluswater.alternatieve_type SET size_object_middel = size;

ALTER TABLE bluswater.alternatieve_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE bluswater.alternatieve_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE bluswater.alternatieve_type ADD COLUMN actief boolean DEFAULT true;

UPDATE objecten.points_of_interest SET geom = 
	ST_Transform(ST_Project(ST_Transform(geom, 4326)::GEOGRAPHY, 0.7, RADIANS(106))::GEOMETRY, 28992);
UPDATE objecten.points_of_interest SET geom = 
	ST_Transform(ST_Project(ST_Transform(geom, 4326)::GEOGRAPHY, 1, RADIANS(135))::GEOMETRY, 28992);

UPDATE objecten.ingang SET geom = 
	ST_Transform(ST_Project(ST_Transform(sub.geom, 4326)::GEOGRAPHY, sub.deltaX, RADIANS(sub.rotatie))::GEOMETRY, 28992)
FROM 
(
	SELECT i.id, geom,
    CASE
	    WHEN i.formaat_bouwlaag = 'klein' THEN -0.5*st.size_bouwlaag_klein
	    WHEN i.formaat_bouwlaag = 'middel' THEN -0.5*st.size_bouwlaag_middel
	    WHEN i.formaat_bouwlaag = 'groot' THEN -0.5*st.size_bouwlaag_groot
	    WHEN i.formaat_object = 'klein' THEN -0.5*st.size_object_klein
	    WHEN i.formaat_object = 'middel' THEN -0.5*st.size_object_middel
	    WHEN i.formaat_object = 'groot' THEN -0.5*st.size_object_groot
	END AS deltaX,
	coalesce(rotatie,0) as rotatie
	FROM objecten.ingang i
	INNER JOIN objecten.ingang_type st ON i.ingang_type_id = st.id
	WHERE ingang_type_id IN (32, 47, 301, 1011)
) sub WHERE ingang.id = sub.id;

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
INSERT INTO objecten.ingang_type (id, naam, symbol_name, "size", size_object) VALUES(175, 'SOS toegang', 'tgn015', 5, 10);

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

UPDATE objecten.sleutelkluis_type SET symbol_name_new='tgn013', symbol_type='c' WHERE symbol_name = 'sleutelkluis';
UPDATE objecten.sleutelkluis_type SET symbol_name_new='tgn014', symbol_type='c' WHERE symbol_name = 'sleutelkluis_hbr';
--Hernoemen van een aantal symbolen, later samenvoegen met de andere met dezelfde symboolnaam, zie hierboven/-onder
UPDATE objecten.sleutelkluis_type SET symbol_name_new='tgn013', symbol_type='c' WHERE symbol_name = 'sleutelkluis';

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

ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.bereikbaarheid_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.dreiging_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.gebiedsgerichte_aanpak_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.ingang_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.isolijnen_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.label_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.opstelplaats_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.points_of_interest_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.ruimten_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.sectoren_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.veiligh_bouwk_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.veiligh_install_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];
ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN tabbladen algemeen.tabbladen[] DEFAULT ARRAY['Algemeen']::algemeen.tabbladen[];






-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 367; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
