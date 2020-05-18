--set thin
SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- verwijderen overbodige kolommen
ALTER TABLE vlakken DROP COLUMN omschrijving CASCADE;
ALTER TABLE opslag DROP COLUMN omschrijving CASCADE;
ALTER TABLE objecten.object ALTER COLUMN bhvaanwezig DROP NOT NULL;
DROP VIEW IF EXISTS view_gevaarlijkestof CASCADE;

--Re-create view vlakken en opslag
-- Create view vlakken bouwlaag 1
CREATE OR REPLACE VIEW bouwlaag_1_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 1;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_1_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_1_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_1_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag min3
CREATE OR REPLACE VIEW bouwlaag_min3_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = -3;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_min3_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_min3_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_min3_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag min2
CREATE OR REPLACE VIEW bouwlaag_min2_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = -2;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_min2_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_min2_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_min2_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag min1
CREATE OR REPLACE VIEW bouwlaag_min1_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = -1;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_min1_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_min1_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_min1_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag 2
CREATE OR REPLACE VIEW bouwlaag_2_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 2;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_2_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_2_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_2_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag 3
CREATE OR REPLACE VIEW bouwlaag_3_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 3;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_3_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_3_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_3_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag 4
CREATE OR REPLACE VIEW bouwlaag_4_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 4;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_4_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_4_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_4_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag 5
CREATE OR REPLACE VIEW bouwlaag_5_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 5;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_5_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_5_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_5_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag 6
CREATE OR REPLACE VIEW bouwlaag_6_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 6;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_6_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_6_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_6_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag 7
CREATE OR REPLACE VIEW bouwlaag_7_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 7;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_7_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_7_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_7_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag 8
CREATE OR REPLACE VIEW bouwlaag_8_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 8;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_8_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_8_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_8_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag 9
CREATE OR REPLACE VIEW bouwlaag_9_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 9;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_9_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_9_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_9_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view vlakken bouwlaag 10
CREATE OR REPLACE VIEW bouwlaag_10_vlakken AS SELECT v.* FROM vlakken v INNER JOIN bouwlagen b ON v.bouwlaag_id = b.id WHERE b.bouwlaag = 10;
CREATE OR REPLACE RULE vlakken_ins AS 
	ON INSERT TO bouwlaag_10_vlakken DO INSTEAD INSERT INTO vlakken (geom, vlakken_type_id, bouwlaag_id)
	VALUES (new.geom, new.vlakken_type_id, new.bouwlaag_id);
CREATE OR REPLACE RULE vlakken_upd AS ON UPDATE TO bouwlaag_10_vlakken DO INSTEAD UPDATE vlakken SET geom = new.geom, vlakken_type_id = new.vlakken_type_id, 
				 bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE vlakken_del AS ON DELETE TO bouwlaag_10_vlakken DO INSTEAD DELETE FROM vlakken WHERE id = old.id;

-- Create view opslag bouwlaag 1
CREATE OR REPLACE VIEW bouwlaag_1_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 1;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_1_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_1_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_1_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag min3
CREATE OR REPLACE VIEW bouwlaag_min3_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = -3;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_min3_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_min3_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_min3_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag min2
CREATE OR REPLACE VIEW bouwlaag_min2_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = -2;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_min2_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_min2_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_min2_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag min1
CREATE OR REPLACE VIEW bouwlaag_min1_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = -1;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_min1_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_min1_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_min1_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;
	
-- Create view opslag bouwlaag 2
CREATE OR REPLACE VIEW bouwlaag_2_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 2;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_2_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_2_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_2_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag 3
CREATE OR REPLACE VIEW bouwlaag_3_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 3;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_3_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_3_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_3_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag 4
CREATE OR REPLACE VIEW bouwlaag_4_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 4;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_4_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_4_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_4_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag 5
CREATE OR REPLACE VIEW bouwlaag_5_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 5;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_5_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_5_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_5_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag 6
CREATE OR REPLACE VIEW bouwlaag_6_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 6;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_6_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_6_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_6_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag 7
CREATE OR REPLACE VIEW bouwlaag_7_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 7;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_7_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_7_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_7_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag 8
CREATE OR REPLACE VIEW bouwlaag_8_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 8;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_8_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_8_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_8_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag 9
CREATE OR REPLACE VIEW bouwlaag_9_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 9;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_9_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_9_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_9_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- Create view opslag bouwlaag 10
CREATE OR REPLACE VIEW bouwlaag_10_opslag AS SELECT o.* FROM opslag o INNER JOIN bouwlagen b ON o.bouwlaag_id = b.id WHERE b.bouwlaag = 10;
CREATE OR REPLACE RULE opslag_ins AS 
	ON INSERT TO bouwlaag_10_opslag DO INSTEAD INSERT INTO opslag (geom, locatie, bouwlaag_id)
	VALUES (new.geom, new.locatie, new.bouwlaag_id);
CREATE OR REPLACE RULE opslag_upd AS ON UPDATE TO bouwlaag_10_opslag DO INSTEAD UPDATE opslag SET geom = new.geom, 
				locatie = new.locatie, bouwlaag_id = new.bouwlaag_id WHERE id = new.id;								
CREATE OR REPLACE RULE opslag_del AS ON DELETE TO bouwlaag_10_opslag DO INSTEAD DELETE FROM opslag WHERE id = old.id;

-- view van gevaarlijkestoffen locatie met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_gevaarlijkestof AS 
SELECT b.formelenaam, b.bouwlaag, b.bouwdeel, gvs.id, gvs.locatie AS gvslocatie, gvs.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, eenh.naam AS eenheid, toest.naam AS toestand,
							ops.geom, ops.locatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y FROM gevaarlijkestof gvs
LEFT JOIN gevaarlijkestof_eenheid eenh ON gvs.gevaarlijkestof_eenheid_id = eenh.id
LEFT JOIN gevaarlijkestof_toestand toest ON gvs.gevaarlijkestof_toestand_id = toest.id
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN opslag ops ON gvs.opslag_id = ops.id
INNER JOIN (SELECT o.*, bouwlagen.id AS bouwlaag_id, bouwlagen.bouwlaag, bouwlagen.bouwdeel FROM (SELECT formelenaam, object.id, geom FROM objecten.object
		LEFT JOIN objecten.historie ON objecten.historie.id = 
		((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
		ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o INNER JOIN bouwlagen ON o.id = bouwlagen.object_id) b ON ops.bouwlaag_id = b.bouwlaag_id;
        
-- create view bouwlagen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_bouwlagen AS
SELECT bl.id, bl.geom, bl.datum_aangemaakt, bl.datum_gewijzigd, bl.bouwlaag, bl.bouwdeel, b.formelenaam, bl.object_id FROM bouwlagen bl
INNER JOIN (SELECT o.* FROM (SELECT formelenaam, object.id FROM objecten.object
			LEFT JOIN objecten.historie ON objecten.historie.id = 
			((SELECT id FROM objecten.historie WHERE objecten.historie.object_id = objecten.object.id 
			ORDER BY objecten.historie.datum_aangemaakt DESC LIMIT 1))
			WHERE historie_status_id = 2) o	INNER JOIN bouwlagen ON o.id = bouwlagen.object_id) b ON bl.object_id = b.id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 13;
UPDATE algemeen.applicatie SET datum = now();