-- FIX voor migratie naar QGis 2.18
-- Alle insert rules moeten worden aangepast
SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

-----Bluswater-----------------------------------
DROP RULE brandkraan_inspectie_upd ON bluswater.brandkraan_inspectie;
CREATE OR REPLACE RULE brandkraan_inspectie_upd AS
    ON UPDATE TO bluswater.brandkraan_inspectie DO INSTEAD  INSERT INTO bluswater.inspectie (brandkraan_nummer, conditie, inspecteur, plaatsaanduiding, plaatsaanduiding_anders, toegankelijkheid, toegankelijkheid_anders, klauw, klauw_diepte, klauw_anders, werking, werking_anders, opmerking, foto)
  VALUES (old.nummer, new.conditie, new.inspecteur, new.plaatsaanduiding, new.plaatsaanduiding_anders, new.toegankelijkheid, new.toegankelijkheid_anders, new.klauw, new.klauw_diepte, new.klauw_anders, new.werking, new.werking_anders, new.opmerking, new.foto)
  RETURNING inspectie.brandkraan_nummer,
    inspectie.id,
    inspectie.brandkraan_nummer,
    ( SELECT brandkraan_huidig_plus.geom
           FROM bluswater.brandkraan_huidig_plus
          WHERE inspectie.brandkraan_nummer::text = brandkraan_huidig_plus.nummer::text) AS geom,
    inspectie.datum_aangemaakt,
    inspectie.datum_gewijzigd,
    inspectie.conditie,
    inspectie.inspecteur,
    inspectie.plaatsaanduiding,
    inspectie.plaatsaanduiding_anders,
    inspectie.toegankelijkheid,
    inspectie.toegankelijkheid_anders,
    inspectie.klauw,
    inspectie.klauw_diepte,
    inspectie.klauw_anders,
    inspectie.werking,
    inspectie.werking_anders,
    inspectie.opmerking,
    inspectie.foto,
    inspectie.uitgezet_bij_pwn,
    inspectie.uitgezet_bij_gemeente,
    inspectie.opmerking_beheerder,
    ( SELECT brandkraan_huidig_plus.inlognaam
           FROM bluswater.brandkraan_huidig_plus
          WHERE inspectie.brandkraan_nummer::text = brandkraan_huidig_plus.nummer::text),
    ( SELECT brandkraan_huidig_plus.gemeentenaam
           FROM bluswater.brandkraan_huidig_plus
          WHERE inspectie.brandkraan_nummer::text = brandkraan_huidig_plus.nummer::text);

-----Objecten-----------------------------------
-- Bouwlagen
DROP RULE bouwlaag_ins ON bouwlaag_1;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_1 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (1, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
DROP RULE bouwlaag_ins ON bouwlaag_2;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_2 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (2, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
DROP RULE bouwlaag_ins ON bouwlaag_3;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_3 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (3, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);

DROP RULE bouwlaag_ins ON bouwlaag_4;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_4 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (4, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
DROP RULE bouwlaag_ins ON bouwlaag_5;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_5 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (5, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
DROP RULE bouwlaag_ins ON bouwlaag_6;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_6 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (6, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
DROP RULE bouwlaag_ins ON bouwlaag_7;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_7 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (7, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
DROP RULE bouwlaag_ins ON bouwlaag_8;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_8 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (8, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);

DROP RULE bouwlaag_ins ON bouwlaag_9;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_9 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (9, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
DROP RULE bouwlaag_ins ON bouwlaag_10;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_10 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (10, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
DROP RULE bouwlaag_ins ON bouwlaag_min1;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_min1 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (-1, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
DROP RULE bouwlaag_ins ON bouwlaag_min2;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_min2 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (-2, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
DROP RULE bouwlaag_ins ON bouwlaag_min3;
CREATE OR REPLACE RULE bouwlaag_ins AS 
	ON INSERT TO bouwlaag_min3 DO INSTEAD INSERT INTO bouwlagen (bouwlaag, object_id, bouwdeel, geom) 
	VALUES (-3, new.object_id, new.bouwdeel, new.geom)
	RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, bouwlaag, bouwdeel, object_id, (SELECT formelenaam FROM object WHERE object_id = object.id);
	
-- Voorzieningen
DROP RULE voorziening_ins ON bouwlaag_1_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_1_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;
				
DROP RULE voorziening_ins ON bouwlaag_2_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_2_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;

DROP RULE voorziening_ins ON bouwlaag_3_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_3_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;

DROP RULE voorziening_ins ON bouwlaag_4_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_4_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;

DROP RULE voorziening_ins ON bouwlaag_5_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_5_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;

DROP RULE voorziening_ins ON bouwlaag_6_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_6_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;

DROP RULE voorziening_ins ON bouwlaag_7_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_7_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;

DROP RULE voorziening_ins ON bouwlaag_8_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_8_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;

DROP RULE voorziening_ins ON bouwlaag_9_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_9_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;

DROP RULE voorziening_ins ON bouwlaag_10_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_10_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;	

DROP RULE voorziening_ins ON bouwlaag_min1_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_min1_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;	

DROP RULE voorziening_ins ON bouwlaag_min2_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_min2_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;	

DROP RULE voorziening_ins ON bouwlaag_min3_voorz;
CREATE OR REPLACE RULE voorziening_ins AS
    ON INSERT TO bouwlaag_min3_voorz DO INSTEAD  INSERT INTO voorziening (geom, voorziening_pictogram_id, rotatie, label, bouwlaag_id)
  VALUES (new.geom, new.voorziening_pictogram_id, new.rotatie, new.label, new.bouwlaag_id)
  RETURNING voorziening.id, voorziening.geom, voorziening.datum_aangemaakt, voorziening.datum_gewijzigd, 
				voorziening.voorziening_pictogram_id, voorziening.rotatie, voorziening.label, voorziening.bouwlaag_id;
				
-- Labels
DROP RULE label_ins ON bouwlaag_1_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_1_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;

DROP RULE label_ins ON bouwlaag_2_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_2_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_3_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_3_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_4_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_4_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_5_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_5_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_6_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_6_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_7_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_7_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_8_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_8_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_9_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_9_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_1_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_1_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_10_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_10_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_1_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_1_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_min1_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_min1_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;				

DROP RULE label_ins ON bouwlaag_min2_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_min2_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;	

DROP RULE label_ins ON bouwlaag_min3_label;
CREATE OR REPLACE RULE label_ins AS 
	ON INSERT TO bouwlaag_min3_label DO INSTEAD INSERT INTO object_labels (geom, type_label, omschrijving, rotatie, bouwlaag_id)
	VALUES (new.geom, new.type_label, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, type_label, rotatie, bouwlaag_id;

-- Opslag
DROP RULE opslag_ins ON bouwlaag_1_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_1_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;  
  
DROP RULE opslag_ins ON bouwlaag_2_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_2_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_3_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_3_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_4_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_4_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_5_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_5_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_6_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_6_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_7_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_7_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_8_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_8_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_9_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_9_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_10_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_10_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_min1_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_min1_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_min2_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_min2_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

DROP RULE opslag_ins ON bouwlaag_min3_opslag;
CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_min3_opslag DO INSTEAD  INSERT INTO opslag (geom, locatie, bouwlaag_id)
  VALUES (new.geom, new.locatie, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, locatie, bouwlaag_id;

-- Scheidingen
DROP RULE scheiding_ins ON bouwlaag_1_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_1_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id; 

DROP RULE scheiding_ins ON bouwlaag_2_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_2_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_3_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_3_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_4_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_4_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_5_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_5_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_6_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_6_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_7_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_7_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_8_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_8_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_9_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_9_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_10_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_10_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_min1_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_min1_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_min2_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_min2_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;

DROP RULE scheiding_ins ON bouwlaag_min3_scheiding;
CREATE OR REPLACE RULE scheiding_ins AS
    ON INSERT TO bouwlaag_min3_scheiding DO INSTEAD  INSERT INTO scheiding (geom, scheiding_type_id, bouwlaag_id)
  VALUES (new.geom, new.scheiding_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id, bouwlaag_id;
 
 -- Vlakken
DROP RULE vlakken_ins ON bouwlaag_1_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_1_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;
  
DROP RULE vlakken_ins ON bouwlaag_2_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_2_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_3_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_3_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_4_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_4_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_5_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_5_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_6_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_6_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_7_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_7_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_8_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_8_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_9_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_9_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_10_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_10_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_min1_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_min1_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_min2_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_min2_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;

DROP RULE vlakken_ins ON bouwlaag_min3_vlakken;
CREATE OR REPLACE RULE vlakken_ins AS
    ON INSERT TO objecten.bouwlaag_min3_vlakken DO INSTEAD  INSERT INTO objecten.vlakken (geom, vlakken_type_id, bouwlaag_id)
  VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id)
  RETURNING id, geom, datum_aangemaakt, datum_gewijzigd, omschrijving, vlakken_type_id, bouwlaag_id;  

				