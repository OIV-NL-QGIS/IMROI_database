SET ROLE oiv_admin;

ALTER TABLE objecten.historie DROP CONSTRAINT IF EXISTS  historie_pkey;
ALTER TABLE objecten.historie ADD CONSTRAINT historie_pkey PRIMARY KEY (id, self_deleted);

CREATE OR REPLACE VIEW objecten."_historie"
AS SELECT *
   FROM objecten.historie g
  WHERE g.self_deleted = 'infinity'::timestamp with time zone;

CREATE RULE historie_ins AS
    ON INSERT TO objecten._historie DO INSTEAD  INSERT INTO objecten.historie (object_id, teamlid_behandeld_id, teamlid_afgehandeld_id, matrix_code_id, aanpassing, status, typeobject)
  VALUES (NEW.object_id, NEW.teamlid_behandeld_id, NEW.teamlid_afgehandeld_id, NEW.matrix_code_id, NEW.aanpassing, NEW.status, NEW.typeobject)
  RETURNING *;

CREATE RULE historie_del AS
    ON DELETE TO objecten._historie DO INSTEAD  DELETE FROM objecten.historie
  WHERE (historie.id = old.id);

ALTER TABLE objecten.afw_binnendekking_type DROP CONSTRAINT afw_binnendekking_type_volgnummer_uc;
ALTER TABLE objecten.bereikbaarheid_type DROP CONSTRAINT bereikbaarheid_type_volgnummer_uc;
ALTER TABLE objecten.dreiging_type DROP CONSTRAINT dreiging_type_volgnummer_uc;
ALTER TABLE objecten.gebiedsgerichte_aanpak_type DROP CONSTRAINT gebiedsgerichte_aanpak_type_volgnummer_uc;
ALTER TABLE objecten.gevaarlijkestof_opslag_type DROP CONSTRAINT gevaarlijkestof_opslag_type_volgnummer_uc;
ALTER TABLE objecten.ingang_type DROP CONSTRAINT ingang_type_volgnummer_uc;
ALTER TABLE objecten.isolijnen_type DROP CONSTRAINT isolijnen_type_volgnummer_uc;
ALTER TABLE objecten.label_type DROP CONSTRAINT label_type_volgnummer_uc;
ALTER TABLE objecten.opstelplaats_type DROP CONSTRAINT opstelplaats_type_volgnummer_uc;
ALTER TABLE objecten.points_of_interest_type DROP CONSTRAINT points_of_interest_type_volgnummer_uc;
ALTER TABLE objecten.ruimten_type DROP CONSTRAINT ruimten_type_volgnummer_uc;
ALTER TABLE objecten.scenario_locatie_type DROP CONSTRAINT scenario_locatie_type_volgnummer_uc;
ALTER TABLE objecten.sectoren_type DROP CONSTRAINT sectoren_type_volgnummer_uc;
ALTER TABLE objecten.sleutelkluis_type DROP CONSTRAINT sleutelkluis_type_volgnummer_uc;
ALTER TABLE objecten.veiligh_bouwk_type DROP CONSTRAINT veiligh_bouwk_type_volgnummer_uc;
ALTER TABLE objecten.veiligh_install_type DROP CONSTRAINT veiligh_install_type_volgnummer_uc;

UPDATE objecten.dreiging_type SET symbol_type = 'a';
ALTER TABLE objecten.dreiging_type ALTER COLUMN symbol_type SET DEFAULT 'a';

ALTER TABLE info_of_interest.points_of_interest_type ADD COLUMN symbol_name_new varchar(15);
ALTER TABLE info_of_interest.points_of_interest_type ADD COLUMN symbol_type algemeen.symb_type DEFAULT 'c';
ALTER TABLE info_of_interest.points_of_interest_type ADD COLUMN actief_ruimtelijk boolean DEFAULT true;
ALTER TABLE info_of_interest.points_of_interest_type ADD COLUMN snap boolean DEFAULT false;
ALTER TABLE info_of_interest.points_of_interest_type ADD COLUMN anchorpoint algemeen.anchorpoint DEFAULT 'center';

ALTER TABLE info_of_interest.points_of_interest ADD COLUMN formaat_object algemeen.formaat;
UPDATE info_of_interest.points_of_interest SET formaat_object = 'middel';

ALTER TABLE info_of_interest.points_of_interest_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE info_of_interest.points_of_interest_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE info_of_interest.points_of_interest_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;
ALTER TABLE info_of_interest.labels_of_interest_type ADD COLUMN size_object_klein numeric(3, 1) DEFAULT 6 NULL;
ALTER TABLE info_of_interest.labels_of_interest_type ADD COLUMN size_object_middel numeric(3, 1) DEFAULT 8 NULL;
ALTER TABLE info_of_interest.labels_of_interest_type ADD COLUMN size_object_groot numeric(3, 1) DEFAULT 10 NULL;
ALTER TABLE info_of_interest.labels_of_interest_type ADD COLUMN snap bool DEFAULT false NULL;

UPDATE info_of_interest.points_of_interest_type SET size_object_middel = size;
UPDATE info_of_interest.labels_of_interest_type SET size_object_middel = size;

ALTER TABLE info_of_interest.labels_of_interest ADD formaat_object algemeen.formaat DEFAULT 'middel';
ALTER TABLE info_of_interest.labels_of_interest ADD opmerking text NULL;

ALTER TABLE info_of_interest.lines_of_interest RENAME bijzonderheid TO opmerking;

ALTER TABLE info_of_interest.points_of_interest DROP CONSTRAINT points_of_interest_type_id_fk;
ALTER TABLE info_of_interest.points_of_interest RENAME COLUMN points_of_interest_type_id TO soort;

ALTER TABLE info_of_interest.points_of_interest ALTER COLUMN soort TYPE varchar(50);
UPDATE info_of_interest.points_of_interest SET soort = sub.naam
FROM 
(
	SELECT id::varchar, naam FROM info_of_interest.points_of_interest_type
) sub
WHERE soort = sub.id;

ALTER TABLE info_of_interest.points_of_interest_type ADD tabbladen json DEFAULT '{"Algemeen": 1}'::json;
ALTER TABLE info_of_interest.labels_of_interest_type ADD tabbladen json DEFAULT '{"Algemeen": 1}'::json;
ALTER TABLE info_of_interest.lines_of_interest_type ADD tabbladen json DEFAULT '{"Algemeen": 1}'::json;

ALTER TABLE info_of_interest.points_of_interest_type ADD volgnummer int;
ALTER TABLE info_of_interest.labels_of_interest_type ADD volgnummer int;
ALTER TABLE info_of_interest.lines_of_interest_type ADD volgnummer int;

ALTER TABLE info_of_interest.labels_of_interest_type ADD actief_ruimtelijk BOOLEAN DEFAULT true;
ALTER TABLE info_of_interest.lines_of_interest_type ADD actief_ruimtelijk BOOLEAN DEFAULT true;

ALTER TABLE info_of_interest.points_of_interest RENAME datum_deleted TO self_deleted;
UPDATE info_of_interest.points_of_interest SET self_deleted = 'infinity' WHERE self_deleted IS NULL;
ALTER TABLE info_of_interest.points_of_interest ALTER self_deleted SET DEFAULT 'infinity'::timestamp with time zone;
ALTER TABLE info_of_interest.labels_of_interest RENAME datum_deleted TO self_deleted;
UPDATE info_of_interest.labels_of_interest SET self_deleted = 'infinity' WHERE self_deleted IS NULL;
ALTER TABLE info_of_interest.lines_of_interest RENAME datum_deleted TO self_deleted;
UPDATE info_of_interest.lines_of_interest SET self_deleted = 'infinity' WHERE self_deleted IS NULL;

ALTER TABLE info_of_interest.points_of_interest ALTER self_deleted SET DEFAULT 'infinity'::timestamp with time zone;
ALTER TABLE info_of_interest.labels_of_interest ALTER self_deleted SET DEFAULT 'infinity'::timestamp with time zone;
ALTER TABLE info_of_interest.lines_of_interest ALTER self_deleted SET DEFAULT 'infinity'::timestamp with time zone;

WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM info_of_interest.labels_of_interest_type)
	UPDATE info_of_interest.labels_of_interest_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = labels_of_interest_type.naam);
WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM info_of_interest.lines_of_interest_type)
	UPDATE info_of_interest.lines_of_interest_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = lines_of_interest_type.naam);

ALTER TABLE info_of_interest.points_of_interest_type ADD CONSTRAINT points_of_interest_type_naam_uc UNIQUE (naam);
ALTER TABLE info_of_interest.points_of_interest ADD CONSTRAINT points_of_interest_type_fk FOREIGN KEY (soort) REFERENCES info_of_interest.points_of_interest_type(naam) ON UPDATE CASCADE;

UPDATE info_of_interest.points_of_interest_type SET naam='Asbest', symbol_name_new = 'drg005', symbol_type = 'a' WHERE symbol_name = 'asbest';
UPDATE info_of_interest.points_of_interest_type SET naam='DMO', symbol_name_new = 'bbh001' WHERE symbol_name = 'dekkingsprobleem_dmo';
UPDATE info_of_interest.points_of_interest_type SET naam='TMO', symbol_name_new = 'bbh003' WHERE symbol_name = 'dekkingsprobleem_tmo';
UPDATE info_of_interest.points_of_interest_type SET naam='Doorrijhoogte', symbol_name_new = 'poi014' WHERE symbol_name = 'doorrijhoogte';
UPDATE info_of_interest.points_of_interest_type SET naam='Afsluitpaal of poller', symbol_name_new = 'poi001' WHERE symbol_name = 'poller';
UPDATE info_of_interest.points_of_interest_type SET naam='Rietenkap', symbol_name_new = 'cdb001' WHERE symbol_name = 'rietenkap';
UPDATE info_of_interest.points_of_interest_type SET naam='Sleutelkluis', symbol_name_new = 'tgn013' WHERE symbol_name = 'sleutelkluis';
UPDATE info_of_interest.points_of_interest_type SET naam='Sleutelpaal of ringpaal', symbol_name_new = 'poi034' WHERE symbol_name = 'sleutelpaal_of_ringpaal';
UPDATE info_of_interest.points_of_interest_type SET naam='Buisleiding LD afnamepunt', symbol_name_new = 'vvz033' WHERE symbol_name = 'stijgleiding_ld_afnamepunt';
UPDATE info_of_interest.points_of_interest_type SET naam='Buisleiding HD afnamepunt', symbol_name_new = 'vvz031' WHERE symbol_name = 'stijgleiding_hd_afnamepunt';
UPDATE info_of_interest.points_of_interest_type SET naam='Buisleiding HD vulpunt', symbol_name_new = 'vvz032' WHERE symbol_name = 'stijgleiding_hd_vulpunt';
UPDATE info_of_interest.points_of_interest_type SET naam='Buisleiding LD vulpunt', symbol_name_new = 'vvz034' WHERE symbol_name = 'stijgleiding_ld_vulpunt';
UPDATE info_of_interest.points_of_interest_type SET naam='Blusmonitor W water (waterkanon)', symbol_name_new = 'vvz016' WHERE symbol_name = 'waterkanon';
UPDATE info_of_interest.points_of_interest_type SET naam='Windvaan', symbol_name_new = 'poi048' WHERE symbol_name = 'windvaan';

UPDATE info_of_interest.points_of_interest SET geom = 
	ST_Transform(ST_Project(ST_Transform(geom, 4326)::GEOGRAPHY, 0.7, RADIANS(106))::GEOMETRY, 28992)
	WHERE soort = 'Doorrijhoogte';

UPDATE info_of_interest.points_of_interest SET geom = 
	ST_Transform(ST_Project(ST_Transform(geom, 4326)::GEOGRAPHY, 1.0, RADIANS(135))::GEOMETRY, 28992)
	WHERE soort = 'Sleutelpaal of ringpaal';

UPDATE info_of_interest.points_of_interest_type SET symbol_name = symbol_name_new WHERE symbol_name_new IS NOT NULL;
ALTER TABLE info_of_interest.points_of_interest_type DROP COLUMN symbol_name_new;

ALTER TABLE info_of_interest.points_of_interest RENAME COLUMN bijzonderheid TO opmerking;

CREATE OR REPLACE FUNCTION info_of_interest.func_points_of_interest_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
    BEGIN
        INSERT INTO info_of_interest.points_of_interest (geom, soort, label, opmerking, rotatie, fotografie_id, label_positie, formaat_object)
        VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
                COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION info_of_interest.func_points_of_interest_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
    BEGIN
        UPDATE info_of_interest.points_of_interest SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, opmerking = new.opmerking, 
				label = new.label, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_object=new.formaat_object
        WHERE (points_of_interest.id = new.id);
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION info_of_interest.func_points_of_interest_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
    BEGIN
        DELETE FROM info_of_interest.points_of_interest WHERE (points_of_interest.id = old.id);
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE VIEW info_of_interest.vw_points_of_interest
AS SELECT b.id,
    b.geom,
    b.soort,
    b.label,
    b.opmerking,
    b.fotografie_id,
    b.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    b.label_positie,
    b.formaat_object
   FROM info_of_interest.points_of_interest b
   INNER JOIN info_of_interest.points_of_interest_type st ON b.soort = st.naam
   WHERE b.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER points_of_interest_ins INSTEAD OF
INSERT
    ON
    info_of_interest.vw_points_of_interest FOR EACH ROW EXECUTE FUNCTION info_of_interest.func_points_of_interest_ins();
CREATE TRIGGER points_of_interest_upd INSTEAD OF
UPDATE
    ON
    info_of_interest.vw_points_of_interest FOR EACH ROW EXECUTE FUNCTION info_of_interest.func_points_of_interest_upd();
CREATE TRIGGER points_of_interest_del INSTEAD OF
DELETE
    ON
    info_of_interest.vw_points_of_interest FOR EACH ROW EXECUTE FUNCTION info_of_interest.func_points_of_interest_del();

CREATE OR REPLACE FUNCTION info_of_interest.func_label_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        DELETE FROM info_of_interest.labels_of_interest WHERE (labels_of_interest.id = old.id);
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION info_of_interest.func_label_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        INSERT INTO info_of_interest.labels_of_interest (geom, soort, omschrijving, rotatie, opmerking, formaat_object)
        VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.opmerking, COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION info_of_interest.func_label_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        UPDATE info_of_interest.labels_of_interest SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie,
                formaat_object = new.formaat_object, opmerking = new.opmerking
        WHERE (labels_of_interest.id = new.id);
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE VIEW info_of_interest.vw_labels_of_interest
AS SELECT l.id,
    l.geom,
    l.soort,
    l.omschrijving,
    l.rotatie,
    st.symbol_name,
        CASE
            WHEN l.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN l.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN l.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    l.formaat_object,
    l.opmerking
   FROM info_of_interest.labels_of_interest l
     JOIN info_of_interest.labels_of_interest_type st ON l.soort::text = st.naam::text
  WHERE l.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER vw_labels_of_interest_del INSTEAD OF
DELETE
    ON
    info_of_interest.vw_labels_of_interest FOR EACH ROW EXECUTE FUNCTION info_of_interest.func_label_del('object');
CREATE TRIGGER vw_labels_of_interest_ins INSTEAD OF
INSERT
    ON
    info_of_interest.vw_labels_of_interest FOR EACH ROW EXECUTE FUNCTION info_of_interest.func_label_ins('object');
CREATE TRIGGER vw_labels_of_interest_upd INSTEAD OF
UPDATE
    ON
    info_of_interest.vw_labels_of_interest FOR EACH ROW EXECUTE FUNCTION info_of_interest.func_label_upd('object');

CREATE OR REPLACE FUNCTION info_of_interest.func_lines_of_interest_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        DELETE FROM info_of_interest.lines_of_interest WHERE (lines_of_interest.id = old.id);
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION info_of_interest.func_lines_of_interest_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        INSERT INTO info_of_interest.lines_of_interest (geom, soort, label, opmerking)
        VALUES (new.geom, new.soort, new.label, new.opmerking);
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION info_of_interest.func_lines_of_interest_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN
        UPDATE info_of_interest.lines_of_interest SET geom = new.geom, soort = new.soort, label = new.label, opmerking = new.opmerking
        WHERE (lines_of_interest.id = new.id);
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE VIEW info_of_interest.vw_lines_of_interest
AS SELECT b.id,
    b.geom,
    b.soort,
    b.label,
    b.opmerking
   FROM info_of_interest.lines_of_interest b
  WHERE b.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER lines_of_interest_ins INSTEAD OF
INSERT
    ON
    info_of_interest.vw_lines_of_interest FOR EACH ROW EXECUTE FUNCTION info_of_interest.func_lines_of_interest_ins();
CREATE TRIGGER lines_of_interest_upd INSTEAD OF
UPDATE
    ON
    info_of_interest.vw_lines_of_interest FOR EACH ROW EXECUTE FUNCTION info_of_interest.func_lines_of_interest_upd();
CREATE TRIGGER lines_of_interest_del INSTEAD OF
DELETE
    ON
    info_of_interest.vw_lines_of_interest FOR EACH ROW EXECUTE FUNCTION info_of_interest.func_lines_of_interest_del();

ALTER TABLE bluswater.alternatieve_type ADD volgnummer int;
WITH cte AS (SELECT naam, ROW_NUMBER() OVER(order by naam) AS rn FROM bluswater.alternatieve_type)
	UPDATE bluswater.alternatieve_type SET volgnummer = (SELECT rn FROM cte WHERE cte.naam = alternatieve_type.naam);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 9;
UPDATE algemeen.applicatie SET db_versie = 369; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();