--Extra analyse lagen t.b.v. bluswater beheer, analyse bag pand niet bereikt binnen 100m straal
SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO veiligh_install_type (id, naam) VALUES (1001, 'Activering blussysteem');
INSERT INTO veiligh_install_type (id, naam) VALUES (1002, 'Brandblusser');
INSERT INTO veiligh_install_type (id, naam) VALUES (1003, 'Brandslanghaspel');
INSERT INTO veiligh_install_type (id, naam) VALUES (1004, 'Oogdouche');
INSERT INTO veiligh_install_type (id, naam) VALUES (1005, 'Nooddouche');
INSERT INTO veiligh_install_type (id, naam) VALUES (1006, 'Overdruk ventilatie');
INSERT INTO veiligh_install_type (id, naam) VALUES (1013, 'Blussysteem stikstof');
INSERT INTO veiligh_install_type (id, naam) VALUES (1021, 'Antidote of tegengif');
INSERT INTO veiligh_install_type (id, naam) VALUES (201,  'aed');
INSERT INTO veiligh_install_type (id, naam) VALUES (9999, 'Installatie defect');
INSERT INTO veiligh_install_type (id, naam) VALUES (1022, 'Calamiteiten coördinatiecentrum');

INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1006, 'Oilboom_opstel');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1007, 'Oilboom_afzet');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1008, 'Schermenponton');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1009, 'Heli landplaats');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1010, 'Opstapplaats RPA');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1001, 'Activering blussysteem');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1013, 'Blussysteem stikstof');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1014, 'Brandbluspomp');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1015, 'Waterkanon SVM');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1016, 'Voedingspunt SVM');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1017, 'Kade aansluiting');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1002, 'Brandblusser');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1003, 'Brandslanghaspel');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1004, 'Oogdouche');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1005, 'Nooddouche');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1018, 'Brandbestrijdingsmateriaal');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1019, 'Schacht of kanaal');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1020, 'Reduceer of drukbegerenzer');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1021, 'Antidote of tegengif');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (9999, 'Installatie defect');
INSERT INTO veiligh_ruimtelijk_type (id, naam) VALUES (1022, 'Calamiteiten coördinatiecentrum');

ALTER TYPE opstelplaats_type ADD VALUE 'UGS';

ALTER TYPE bereikbaarheid_type ADD VALUE 'wegen eigen terrein';

INSERT INTO ingang_type          (id, naam) VALUES (1011, 'Nooduitgang');
INSERT INTO ingang_type          (id, naam) VALUES (1012, 'Toegang spoor');
INSERT INTO ingang_type          (id, naam) VALUES (1013, 'Gedeelde neveningang');

INSERT INTO sleutelkluis_type    (id, naam) VALUES (10, 'Sleutelkuis Havenbedrijf');

INSERT INTO dreiging_type (id, naam) VALUES (201, 'Ontvlambare stoffen - GHS');
INSERT INTO dreiging_type (id, naam) VALUES (202, 'Oxiderende stoffen - GHS');
INSERT INTO dreiging_type (id, naam) VALUES (203, 'Ontplofbare stoffen - GHS');
INSERT INTO dreiging_type (id, naam) VALUES (204, 'Corrosieve stoffen - GHS');
INSERT INTO dreiging_type (id, naam) VALUES (205, 'Giftige stoffen - GHS');
INSERT INTO dreiging_type (id, naam) VALUES (206, 'Accuut gevaar - GHS');
INSERT INTO dreiging_type (id, naam) VALUES (207, 'Gassen onder druk - GHS');
INSERT INTO dreiging_type (id, naam) VALUES (208, 'Gevaar voor milieu - GHS');
INSERT INTO dreiging_type (id, naam) VALUES (209, 'Gevaar gezondheid - GHS');
INSERT INTO dreiging_type (id, naam) VALUES (115, 'Valgevaar');
INSERT INTO dreiging_type (id, naam) VALUES (116, 'Bijtgevaar');
INSERT INTO dreiging_type (id, naam) VALUES (117, 'Klein chemisch');
INSERT INTO dreiging_type (id, naam) VALUES (118, 'Explosieve atmosfeer');
INSERT INTO dreiging_type (id, naam) VALUES (119, 'Lithiumhoudende batterijen');
INSERT INTO dreiging_type (id, naam) VALUES (120, 'Exotische dieren');
INSERT INTO dreiging_type (id, naam) VALUES (121, 'Schadelijk voor milieu');
INSERT INTO dreiging_type (id, naam) VALUES (122, 'Glad oppervlak');
INSERT INTO dreiging_type (id, naam) VALUES (123, 'Hangende lasten');
INSERT INTO dreiging_type (id, naam) VALUES (124, 'Heet oppervlak');
INSERT INTO dreiging_type (id, naam) VALUES (125, 'Houder onder druk');
INSERT INTO dreiging_type (id, naam) VALUES (126, 'Op afstand bestuurde machines');
INSERT INTO dreiging_type (id, naam) VALUES (127, 'Helling');
INSERT INTO dreiging_type (id, naam) VALUES (128, 'Langetermijn gezondheidsschade');

INSERT INTO bluswater.alternatieve_type (id, naam) VALUES (12, 'Open water xxx zijde');
INSERT INTO bluswater.alternatieve_type (id, naam) VALUES (13, 'Open water onbereikbaar');
INSERT INTO bluswater.alternatieve_type (id, naam) VALUES (14, 'Brandkraan eigen terrein');
INSERT INTO bluswater.alternatieve_type (id, naam) VALUES (9999,  'Voorziening defect');

CREATE OR REPLACE VIEW veiligh_bouwk_types AS
select 
row_number() OVER (ORDER BY e.enumlabel)::integer AS id, e.enumlabel::text as naam
from pg_type t 
   join pg_enum e on t.oid = e.enumtypid  
   join pg_catalog.pg_namespace n ON n.oid = t.typnamespace
where t.typname = 'veiligh_bouwk_type';

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 10;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 2103; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();