SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TYPE algemeen.symb_type AS ENUM ('a', 'b', 'c');

CREATE TYPE algemeen.symb_type AS ENUM ('a', 'b', 'c');

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



-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 363; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
