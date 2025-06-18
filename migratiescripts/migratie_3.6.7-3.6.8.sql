SET ROLE oiv_admin;

ALTER TABLE objecten.gevaarlijkestof_schade_cirkel ADD CONSTRAINT gevaarlijkestof_id_fk FOREIGN KEY (gevaarlijkestof_id, parent_deleted) REFERENCES objecten.gevaarlijkestof(id, self_deleted) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE objecten.gevaarlijkestof_schade_cirkel DROP CONSTRAINT IF EXISTS  gevaarlijkestof_schade_cirkel_pkey;
ALTER TABLE objecten.gevaarlijkestof_schade_cirkel DROP CONSTRAINT IF EXISTS  schade_cirkel_pkey;
ALTER TABLE objecten.gevaarlijkestof_schade_cirkel ADD CONSTRAINT gevaarlijkestof_schade_cirkel_pkey PRIMARY KEY (id, self_deleted);

CREATE OR REPLACE VIEW objecten."_gevaarlijkestof_schade_cirkel"
AS SELECT *
   FROM objecten.gevaarlijkestof_schade_cirkel g
  WHERE g.self_deleted = 'infinity'::timestamp with time zone;

CREATE RULE gevaarlijkestof_schade_cirkel_ins AS
    ON INSERT TO objecten._gevaarlijkestof_schade_cirkel DO INSTEAD  INSERT INTO objecten.gevaarlijkestof_schade_cirkel (gevaarlijkestof_id, soort, straal)
  VALUES (NEW.gevaarlijkestof_id, NEW.soort, NEW.straal)
  RETURNING *;

CREATE RULE gevaarlijkestof_schade_cirkel_del AS
    ON DELETE TO objecten._gevaarlijkestof_schade_cirkel DO INSTEAD  DELETE FROM objecten.gevaarlijkestof_schade_cirkel
  WHERE (gevaarlijkestof_schade_cirkel.id = old.id);

DROP VIEW IF EXISTS mobiel.labels;

ALTER TABLE objecten.afw_binnendekking_type DROP COLUMN "size";
ALTER TABLE objecten.dreiging_type DROP COLUMN "size";
ALTER TABLE objecten.dreiging_type DROP COLUMN "size_object";
ALTER TABLE objecten.gevaarlijkestof_opslag_type DROP COLUMN "size";
ALTER TABLE objecten.gevaarlijkestof_opslag_type DROP COLUMN "size_object";
ALTER TABLE objecten.ingang_type DROP COLUMN "size";
ALTER TABLE objecten.ingang_type DROP COLUMN "size_object";
ALTER TABLE objecten.label_type DROP COLUMN "size";
ALTER TABLE objecten.label_type DROP COLUMN "size_object";
ALTER TABLE objecten.opstelplaats_type DROP COLUMN "size";
ALTER TABLE objecten.points_of_interest_type DROP COLUMN "size";
ALTER TABLE objecten.scenario_locatie_type DROP COLUMN "size";
ALTER TABLE objecten.scenario_locatie_type DROP COLUMN "size_object";
ALTER TABLE objecten.sleutelkluis_type DROP COLUMN "size";
ALTER TABLE objecten.sleutelkluis_type DROP COLUMN "size_object";
ALTER TABLE objecten.veiligh_install_type DROP COLUMN "size";
ALTER TABLE objecten.veiligh_install_type DROP COLUMN "size_object";

ALTER TABLE objecten.afw_binnendekking ALTER COLUMN formaat_bouwlaag SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.dreiging ALTER COLUMN formaat_bouwlaag SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.dreiging ALTER COLUMN formaat_object SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.gevaarlijkestof_opslag ALTER COLUMN formaat_bouwlaag SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.gevaarlijkestof_opslag ALTER COLUMN formaat_object SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.ingang ALTER COLUMN formaat_bouwlaag SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.ingang ALTER COLUMN formaat_object SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.opstelplaats ALTER COLUMN formaat_object SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.points_of_interest ALTER COLUMN formaat_object SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.scenario_locatie ALTER COLUMN formaat_bouwlaag SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.scenario_locatie ALTER COLUMN formaat_object SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.sleutelkluis ALTER COLUMN formaat_bouwlaag SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.sleutelkluis ALTER COLUMN formaat_object SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.veiligh_install ALTER COLUMN formaat_bouwlaag SET DEFAULT 'middel'::algemeen.formaat;
ALTER TABLE objecten.veiligh_install ALTER COLUMN formaat_object SET DEFAULT 'middel'::algemeen.formaat;

ALTER TABLE objecten.ingang DROP COLUMN belemmering;
ALTER TABLE objecten.ingang DROP COLUMN voorzieningen;

--Verplaatsen van oude symbolen niet helemaal in het midden
UPDATE objecten.points_of_interest SET geom = 
	ST_Transform(ST_Project(ST_Transform(geom, 4326)::GEOGRAPHY, 0.7, RADIANS(106))::GEOMETRY, 28992)
	WHERE soort = 'Doorrijhoogte';

UPDATE objecten.points_of_interest SET geom = 
	ST_Transform(ST_Project(ST_Transform(geom, 4326)::GEOGRAPHY, 1.0, RADIANS(135))::GEOMETRY, 28992)
	WHERE soort = 'Sleutelpaal of ringpaal';

UPDATE objecten.ingang SET geom = 
	ST_Transform(ST_Project(ST_Transform(geom, 4326)::GEOGRAPHY, 0.15, RADIANS(0))::GEOMETRY, 28992)
	WHERE soort = 'Trap bordes';

UPDATE objecten.ingang SET geom = 
	ST_Transform(ST_Project(ST_Transform(geom, 4326)::GEOGRAPHY, 0.4, RADIANS(25))::GEOMETRY, 28992)
	WHERE soort = 'Trap recht';

  UPDATE objecten.veiligh_install SET geom = 
	ST_Transform(ST_Project(ST_Transform(geom, 4326)::GEOGRAPHY, 1.1, RADIANS(120))::GEOMETRY, 28992)
	WHERE soort = 'Afsluiter SVM';

UPDATE objecten.veiligh_install SET geom = 
	ST_Transform(ST_Project(ST_Transform(geom, 4326)::GEOGRAPHY, 0.4, RADIANS(49))::GEOMETRY, 28992)
	WHERE soort = 'Gas detectiepaneel';

--Draaien van oude symbolen omdat de nieuwe een andere positie hebben
UPDATE objecten.ingang SET rotatie = rotatie + 90 WHERE soort IN ('Brandweerlift', 'Lift');

--Verplaatsing van de ankerpunten van de ingangen
UPDATE objecten.ingang SET geom = ST_Transform(ST_Project(ST_Transform(sub.geom, 4326)::GEOGRAPHY, 0.5*sub.deltaX, RADIANS(sub.rotatie))::GEOMETRY, 28992)
FROM 
(
	SELECT i.id, geom,
    CASE
	    WHEN i.formaat_bouwlaag = 'klein' THEN -st.size_bouwlaag_klein
	    WHEN i.formaat_bouwlaag = 'middel' THEN -st.size_bouwlaag_middel
	    WHEN i.formaat_bouwlaag = 'groot' THEN -st.size_bouwlaag_groot
	    WHEN i.formaat_object = 'klein' THEN -st.size_object_klein
	    WHEN i.formaat_object = 'middel' THEN -st.size_object_middel
	    WHEN i.formaat_object = 'groot' THEN -st.size_object_groot
	END AS deltaX,
	rotatie
	FROM objecten.ingang i
	INNER JOIN objecten.ingang_type st ON i.soort = st.naam
) sub WHERE soort IN ('Brandweeringang', 'Neveningang', 'Ingang gebied terrein', 'Nooduitgang') AND ingang.id = sub.id;


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 8;
UPDATE algemeen.applicatie SET db_versie = 368; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();