SET ROLE oiv_admin;

CREATE TYPE algemeen.labelposition AS ENUM (
	'boven - links',
	'boven - midden',
	'boven - rechts',
	'midden - links',
	'midden',
	'midden - rechts',
	'onder - links',
	'onder - midden',
	'onder - rechts'
);

CREATE TYPE algemeen.formaat AS ENUM ('klein', 'middel', 'groot');

ALTER TABLE objecten.gevaarlijkestof_opslag ADD COLUMN label varchar(50);
ALTER TABLE objecten.scenario_locatie ADD COLUMN label varchar(50);

ALTER TABLE objecten.afw_binnendekking ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE objecten.dreiging ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE objecten.gevaarlijkestof_opslag ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE objecten.ingang ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE objecten.opstelplaats ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE objecten.points_of_interest ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE objecten.scenario_locatie ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE objecten.sleutelkluis ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden'
ALTER TABLE objecten.veiligh_install ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE objecten.veiligh_ruimtelijk ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';

ALTER TABLE mobiel.werkvoorraad_punt ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';
ALTER TABLE info_of_interest.points_of_interest ADD COLUMN label_positie algemeen.labelposition DEFAULT 'onder - midden';

UPDATE objecten.afw_binnendekking SET label_positie = 'onder - midden';
UPDATE objecten.dreiging SET label_positie = 'onder - midden';
UPDATE objecten.gevaarlijkestof_opslag SET label_positie = 'onder - midden';
UPDATE objecten.ingang SET label_positie = 'onder - midden';
UPDATE objecten.opstelplaats SET label_positie = 'onder - midden';
UPDATE objecten.points_of_interest SET label_positie = 'onder - midden';
UPDATE objecten.scenario_locatie SET label_positie = 'onder - midden';
UPDATE objecten.veiligh_install SET label_positie = 'onder - midden';
UPDATE objecten.afw_binnendekking SET label_positie = 'onder - midden';
UPDATE objecten.veiligh_ruimtelijk SET label_positie = 'onder - midden';

UPDATE mobiel.werkvoorraad_punt SET label_positie = 'onder - midden';
UPDATE info_of_interest.points_of_interest SET label_positie = 'onder - midden';

ALTER TABLE objecten.afw_binnendekking ADD COLUMN formaat_bouwlaag algemeen.formaat;
UPDATE objecten.afw_binnendekking SET formaat_bouwlaag = 'middel';

ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN size_bouwlaag_klein decimal(3,1) DEFAULT 2;
ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN size_bouwlaag_middel decimal(3,1) DEFAULT 4;
ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN size_bouwlaag_groot decimal(3,1) DEFAULT 6;

UPDATE objecten.afw_binnendekking_type SET size_bouwlaag_middel = size;

ALTER TABLE objecten.dreiging ADD COLUMN formaat_bouwlaag algemeen.formaat;
UPDATE objecten.dreiging SET formaat_bouwlaag = 'middel';
ALTER TABLE objecten.dreiging ADD COLUMN formaat_object algemeen.formaat;
UPDATE objecten.dreiging SET formaat_object = 'middel';

ALTER TABLE objecten.dreiging_type ADD COLUMN size_bouwlaag_klein decimal(3,1) DEFAULT 2;
ALTER TABLE objecten.dreiging_type ADD COLUMN size_bouwlaag_middel decimal(3,1) DEFAULT 4;
ALTER TABLE objecten.dreiging_type ADD COLUMN size_bouwlaag_groot decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.dreiging_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.dreiging_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE objecten.dreiging_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE objecten.dreiging_type SET size_bouwlaag_middel = size;
UPDATE objecten.dreiging_type SET size_object_middel = size_object;

ALTER TABLE objecten.gevaarlijkestof_opslag ADD COLUMN formaat_bouwlaag algemeen.formaat;
UPDATE objecten.gevaarlijkestof_opslag SET formaat_bouwlaag = 'middel';
ALTER TABLE objecten.gevaarlijkestof_opslag ADD COLUMN formaat_object algemeen.formaat;
UPDATE objecten.gevaarlijkestof_opslag SET formaat_object = 'middel';

ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN size_bouwlaag_klein decimal(3,1) DEFAULT 2;
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN size_bouwlaag_middel decimal(3,1) DEFAULT 4;
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN size_bouwlaag_groot decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE objecten.gevaarlijkestof_opslag_type SET size_bouwlaag_middel = size;
UPDATE objecten.gevaarlijkestof_opslag_type SET size_object_middel = size_object;

ALTER TABLE objecten.ingang ADD COLUMN formaat_bouwlaag algemeen.formaat;
UPDATE objecten.ingang SET formaat_bouwlaag = 'middel';
ALTER TABLE objecten.ingang ADD COLUMN formaat_object algemeen.formaat;
UPDATE objecten.ingang SET formaat_object = 'middel';

ALTER TABLE objecten.ingang_type ADD COLUMN size_bouwlaag_klein decimal(3,1) DEFAULT 2;
ALTER TABLE objecten.ingang_type ADD COLUMN size_bouwlaag_middel decimal(3,1) DEFAULT 4;
ALTER TABLE objecten.ingang_type ADD COLUMN size_bouwlaag_groot decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.ingang_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.ingang_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE objecten.ingang_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE objecten.ingang_type SET size_bouwlaag_middel = size;
UPDATE objecten.ingang_type SET size_object_middel = size_object;

ALTER TABLE objecten."label" ADD COLUMN formaat_bouwlaag algemeen.formaat;
UPDATE objecten."label" SET formaat_bouwlaag = 'middel';
ALTER TABLE objecten."label" ADD COLUMN formaat_object algemeen.formaat;
UPDATE objecten."label" SET formaat_object = 'middel';

ALTER TABLE objecten.label_type ADD COLUMN size_bouwlaag_klein decimal(3,1) DEFAULT 2;
ALTER TABLE objecten.label_type ADD COLUMN size_bouwlaag_middel decimal(3,1) DEFAULT 4;
ALTER TABLE objecten.label_type ADD COLUMN size_bouwlaag_groot decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.label_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.label_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE objecten.label_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE objecten.label_type SET size_bouwlaag_middel = size;
UPDATE objecten.label_type SET size_object_middel = size_object;

ALTER TABLE objecten.opstelplaats ADD COLUMN formaat_object algemeen.formaat;
UPDATE objecten.opstelplaats SET formaat_object = 'middel';

ALTER TABLE objecten.opstelplaats_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.opstelplaats_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE objecten.opstelplaats_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE objecten.opstelplaats_type SET size_object_middel = size;

ALTER TABLE objecten.points_of_interest ADD COLUMN formaat_object algemeen.formaat;
UPDATE objecten.points_of_interest SET formaat_object = 'middel';

ALTER TABLE objecten.points_of_interest_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.points_of_interest_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE objecten.points_of_interest_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE objecten.points_of_interest_type SET size_object_middel = size;

ALTER TABLE objecten.scenario_locatie ADD COLUMN formaat_bouwlaag algemeen.formaat;
UPDATE objecten.scenario_locatie SET formaat_bouwlaag = 'middel';
ALTER TABLE objecten.scenario_locatie ADD COLUMN formaat_object algemeen.formaat;
UPDATE objecten.scenario_locatie SET formaat_object = 'middel';

ALTER TABLE objecten.scenario_locatie_type ADD COLUMN size_bouwlaag_klein decimal(3,1) DEFAULT 2;
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN size_bouwlaag_middel decimal(3,1) DEFAULT 4;
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN size_bouwlaag_groot decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE objecten.scenario_locatie_type SET size_bouwlaag_middel = size;
UPDATE objecten.scenario_locatie_type SET size_object_middel = size_object;

ALTER TABLE objecten.sleutelkluis ADD COLUMN formaat_bouwlaag algemeen.formaat;
UPDATE objecten.sleutelkluis SET formaat_bouwlaag = 'middel';
ALTER TABLE objecten.sleutelkluis ADD COLUMN formaat_object algemeen.formaat;
UPDATE objecten.sleutelkluis SET formaat_object = 'middel';

ALTER TABLE objecten.sleutelkluis_type ADD COLUMN size_bouwlaag_klein decimal(3,1) DEFAULT 2;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN size_bouwlaag_middel decimal(3,1) DEFAULT 4;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN size_bouwlaag_groot decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE objecten.sleutelkluis_type SET size_bouwlaag_middel = size;
UPDATE objecten.sleutelkluis_type SET size_object_middel = size_object;

ALTER TABLE objecten.veiligh_install ADD COLUMN formaat_bouwlaag algemeen.formaat;
UPDATE objecten.veiligh_install SET formaat_bouwlaag = 'middel';

ALTER TABLE objecten.veiligh_install_type ADD COLUMN size_bouwlaag_klein decimal(3,1) DEFAULT 2;
ALTER TABLE objecten.veiligh_install_type ADD COLUMN size_bouwlaag_middel decimal(3,1) DEFAULT 4;
ALTER TABLE objecten.veiligh_install_type ADD COLUMN size_bouwlaag_groot decimal(3,1) DEFAULT 6;

UPDATE objecten.veiligh_install_type SET size_bouwlaag_middel = size;

ALTER TABLE objecten.veiligh_ruimtelijk ADD COLUMN formaat_object algemeen.formaat;
UPDATE objecten.veiligh_ruimtelijk SET formaat_object = 'middel';

ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN size_object_klein decimal(3,1) DEFAULT 6;
ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN size_object_middel decimal(3,1) DEFAULT 8;
ALTER TABLE objecten.veiligh_ruimtelijk_type ADD COLUMN size_object_groot decimal(3,1) DEFAULT 10;

UPDATE objecten.veiligh_ruimtelijk_type SET size_object_middel = size;

ALTER TABLE mobiel.werkvoorraad_punt ADD COLUMN formaat algemeen.formaat;

DROP VIEW IF EXISTS objecten.bouwlaag_afw_binnendekking;
CREATE OR REPLACE VIEW objecten.bouwlaag_afw_binnendekking
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.handelingsaanwijzing,
    v.bouwlaag_id,
    b.bouwlaag,
    v.rotatie,
    st.symbol_name,
    CASE
	    WHEN v.formaat_bouwlaag = 'klein' THEN st.size_bouwlaag_klein
	    WHEN v.formaat_bouwlaag = 'middel' THEN st.size_bouwlaag_middel
	    WHEN v.formaat_bouwlaag = 'groot' THEN st.size_bouwlaag_groot
	END AS size,
    ''::text AS applicatie,
    v.label_positie,
	v.formaat_bouwlaag
   FROM objecten.afw_binnendekking v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.afw_binnendekking_type st ON v.soort::text = st.naam::text
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER afw_binnendekking_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_del();
CREATE TRIGGER afw_binnendekking_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_ins();
CREATE TRIGGER afw_binnendekking_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_upd();

DROP VIEW IF EXISTS objecten.bouwlaag_dreiging;
CREATE OR REPLACE VIEW objecten.bouwlaag_dreiging
AS SELECT v.id,
    v.geom,
    v.dreiging_type_id,
    v.label,
    v.fotografie_id,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    st.symbol_name,
    CASE
	    WHEN v.formaat_bouwlaag = 'klein' THEN st.size_bouwlaag_klein
	    WHEN v.formaat_bouwlaag = 'middel' THEN st.size_bouwlaag_middel
	    WHEN v.formaat_bouwlaag = 'groot' THEN st.size_bouwlaag_groot
	END AS size,
    ''::text AS applicatie,
    v.label_positie,
	v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.dreiging v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.dreiging_type st ON v.dreiging_type_id = st.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_dreiging_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_del('bouwlaag');
CREATE TRIGGER bouwlaag_dreiging_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_ins('bouwlaag');
CREATE TRIGGER bouwlaag_dreiging_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_upd('bouwlaag');

DROP VIEW IF EXISTS objecten.bouwlaag_ingang;
CREATE OR REPLACE VIEW objecten.bouwlaag_ingang
AS SELECT v.id,
    v.geom,
    v.ingang_type_id,
    v.label,
    v.belemmering,
    v.voorzieningen,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    st.symbol_name,
    CASE
	    WHEN v.formaat_bouwlaag = 'klein' THEN st.size_bouwlaag_klein
	    WHEN v.formaat_bouwlaag = 'middel' THEN st.size_bouwlaag_middel
	    WHEN v.formaat_bouwlaag = 'groot' THEN st.size_bouwlaag_groot
	END AS size,
    ''::text AS applicatie,
    v.label_positie,
	v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.ingang v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.ingang_type st ON v.ingang_type_id = st.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_ingang_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_del('bouwlaag');
CREATE TRIGGER bouwlaag_ingang_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_ins('bouwlaag');
CREATE TRIGGER bouwlaag_ingang_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_upd('bouwlaag');

DROP VIEW IF EXISTS objecten.bouwlaag_opslag;
CREATE OR REPLACE VIEW objecten.bouwlaag_opslag
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.locatie,
    v.bouwlaag_id,
    v.object_id,
    v.fotografie_id,
    v.rotatie,
    b.bouwlaag,
    st.symbol_name,
    CASE
	    WHEN v.formaat_bouwlaag = 'klein' THEN st.size_bouwlaag_klein
	    WHEN v.formaat_bouwlaag = 'middel' THEN st.size_bouwlaag_middel
	    WHEN v.formaat_bouwlaag = 'groot' THEN st.size_bouwlaag_groot
	END AS size,
    ''::text AS applicatie,
    v.self_deleted,
    v.label,
    v.label_positie,
	v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.gevaarlijkestof_opslag v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_opslag_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_ins('bouwlaag');
CREATE TRIGGER bouwlaag_opslag_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_del('bouwlaag');
CREATE TRIGGER bouwlaag_opslag_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_upd('bouwlaag');

DROP VIEW IF EXISTS objecten.bouwlaag_scenario_locatie;
CREATE OR REPLACE VIEW objecten.bouwlaag_scenario_locatie
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.locatie,
    v.bouwlaag_id,
    v.object_id,
    v.fotografie_id,
    v.rotatie,
    b.bouwlaag,
    st.symbol_name,
    CASE
	    WHEN v.formaat_bouwlaag = 'klein' THEN st.size_bouwlaag_klein
	    WHEN v.formaat_bouwlaag = 'middel' THEN st.size_bouwlaag_middel
	    WHEN v.formaat_bouwlaag = 'groot' THEN st.size_bouwlaag_groot
	END AS size,
    ''::text AS applicatie,
    v.label,
    v.label_positie,
	v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.scenario_locatie v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.scenario_locatie_type st ON 'Scenario locatie'::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_scenario_locatie_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_ins('bouwlaag');
CREATE TRIGGER bouwlaag_scenario_locatie_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_del('bouwlaag');
CREATE TRIGGER bouwlaag_scenario_locatie_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_upd('bouwlaag');

DROP VIEW IF EXISTS objecten.bouwlaag_sleutelkluis;
CREATE OR REPLACE VIEW objecten.bouwlaag_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.sleutelkluis_type_id,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.fotografie_id,
    v.ingang_id,
    part.bouwlaag,
    v.rotatie,
    st.symbol_name,
    CASE
	    WHEN v.formaat_bouwlaag = 'klein' THEN st.size_bouwlaag_klein
	    WHEN v.formaat_bouwlaag = 'middel' THEN st.size_bouwlaag_middel
	    WHEN v.formaat_bouwlaag = 'groot' THEN st.size_bouwlaag_groot
	END AS size,
    ''::text AS applicatie,
    part.bouwlaag_id,
    v.label_positie,
	v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.sleutelkluis v
     JOIN ( SELECT b.bouwlaag,
            ib.id,
            ib.bouwlaag_id
           FROM objecten.ingang ib
             JOIN objecten.bouwlagen b ON ib.bouwlaag_id = b.id) part ON v.ingang_id = part.id
     JOIN objecten.sleutelkluis_type st ON v.sleutelkluis_type_id = st.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_sleutelkluis_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_del('bouwlaag');
CREATE TRIGGER bouwlaag_sleutelkluis_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_ins('bouwlaag');
CREATE TRIGGER bouwlaag_sleutelkluis_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_upd('bouwlaag');

DROP VIEW IF EXISTS objecten.bouwlaag_veiligh_install;
CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_install
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.veiligh_install_type_id,
    v.label,
    v.bijzonderheid,
    v.bouwlaag_id,
    v.rotatie,
    v.fotografie_id,
    b.bouwlaag,
    CASE
	    WHEN v.formaat_bouwlaag = 'klein' THEN st.size_bouwlaag_klein
	    WHEN v.formaat_bouwlaag = 'middel' THEN st.size_bouwlaag_middel
	    WHEN v.formaat_bouwlaag = 'groot' THEN st.size_bouwlaag_groot
	END AS size,
    st.symbol_name,
    ''::text AS applicatie,
    v.label_positie,
	v.formaat_bouwlaag
   FROM objecten.veiligh_install v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type st ON v.veiligh_install_type_id = st.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER veiligh_install_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_del();
CREATE TRIGGER veiligh_install_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_ins();
CREATE TRIGGER veiligh_install_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_upd();

DROP VIEW IF EXISTS objecten.object_dreiging;
CREATE OR REPLACE VIEW objecten.object_dreiging
AS SELECT v.id,
    v.geom,
    v.dreiging_type_id,
    v.label,
    v.fotografie_id,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    st.symbol_name,
    CASE
	    WHEN v.formaat_object = 'klein' THEN st.size_object_klein
	    WHEN v.formaat_object = 'middel' THEN st.size_object_middel
	    WHEN v.formaat_object = 'groot' THEN st.size_object_groot
	END AS size,
    ''::text AS applicatie,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    v.label_positie,
	v.formaat_object,
    v.formaat_bouwlaag
   FROM objecten.dreiging v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.dreiging_type st ON v.dreiging_type_id = st.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_dreiging_del INSTEAD OF
DELETE
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_del('object');
CREATE TRIGGER object_dreiging_ins INSTEAD OF
INSERT
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_ins('object');
CREATE TRIGGER object_dreiging_upd INSTEAD OF
UPDATE
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_upd('object');

DROP VIEW IF EXISTS objecten.object_ingang;
CREATE OR REPLACE VIEW objecten.object_ingang
AS SELECT v.id,
    v.geom,
    v.ingang_type_id,
    v.label,
    v.belemmering,
    v.voorzieningen,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    st.symbol_name,
    CASE
	    WHEN v.formaat_object = 'klein' THEN st.size_object_klein
	    WHEN v.formaat_object = 'middel' THEN st.size_object_middel
	    WHEN v.formaat_object = 'groot' THEN st.size_object_groot
	END AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    v.label_positie,
	v.formaat_object,
    v.formaat_bouwlaag
   FROM objecten.ingang v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.ingang_type st ON v.ingang_type_id = st.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_ingang_del INSTEAD OF
DELETE
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_del('object');
CREATE TRIGGER object_ingang_ins INSTEAD OF
INSERT
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_ins('object');
CREATE TRIGGER object_ingang_upd INSTEAD OF
UPDATE
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_upd('object');

DROP VIEW IF EXISTS objecten.object_opslag;
CREATE OR REPLACE VIEW objecten.object_opslag
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    b.formelenaam,
    o.rotatie,
    CASE
	    WHEN o.formaat_object = 'klein' THEN st.size_object_klein
	    WHEN o.formaat_object = 'middel' THEN st.size_object_middel
	    WHEN o.formaat_object = 'groot' THEN st.size_object_groot
	END AS size,
    st.symbol_name,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
	o.label,
	o.label_positie,
	o.formaat_object,
    o.formaat_bouwlaag
   FROM objecten.gevaarlijkestof_opslag o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.parent_deleted = 'infinity'::timestamp with time zone AND o.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_opslag_ins INSTEAD OF
INSERT
    ON
    objecten.object_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_ins('object');
CREATE TRIGGER object_opslag_del INSTEAD OF
DELETE
    ON
    objecten.object_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_del('object');
CREATE TRIGGER object_opslag_upd INSTEAD OF
UPDATE
    ON
    objecten.object_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_upd('object');

DROP VIEW IF EXISTS objecten.object_opstelplaats;
CREATE OR REPLACE VIEW objecten.object_opstelplaats
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.fotografie_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    st.symbol_name,
    CASE
	    WHEN v.formaat_object = 'klein' THEN st.size_object_klein
	    WHEN v.formaat_object = 'middel' THEN st.size_object_middel
	    WHEN v.formaat_object = 'groot' THEN st.size_object_groot
	END AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
	v.label_positie,
	v.formaat_object
   FROM objecten.opstelplaats v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.opstelplaats_type st ON v.soort::text = st.naam::text
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER opstelplaats_del INSTEAD OF
DELETE
    ON
    objecten.object_opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.func_opstelplaats_del();
CREATE TRIGGER opstelplaats_ins INSTEAD OF
INSERT
    ON
    objecten.object_opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.func_opstelplaats_ins();
CREATE TRIGGER opstelplaats_upd INSTEAD OF
UPDATE
    ON
    objecten.object_opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.func_opstelplaats_upd();

DROP VIEW IF EXISTS objecten.object_points_of_interest;
CREATE OR REPLACE VIEW objecten.object_points_of_interest
AS SELECT b.id,
    b.geom,
    b.points_of_interest_type_id,
    b.label,
    b.bijzonderheid,
    b.fotografie_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    st.symbol_name,
    CASE
	    WHEN b.formaat_object = 'klein' THEN st.size_object_klein
	    WHEN b.formaat_object = 'middel' THEN st.size_object_middel
	    WHEN b.formaat_object = 'groot' THEN st.size_object_groot
	END AS size,
    ''::text AS applicatie,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject,
	b.label_positie,
	b.formaat_object
   FROM objecten.points_of_interest b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.points_of_interest_type st ON b.points_of_interest_type_id = st.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER points_of_interest_del INSTEAD OF
DELETE
    ON
    objecten.object_points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.func_points_of_interest_del();
CREATE TRIGGER points_of_interest_ins INSTEAD OF
INSERT
    ON
    objecten.object_points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.func_points_of_interest_ins();
CREATE TRIGGER points_of_interest_upd INSTEAD OF
UPDATE
    ON
    objecten.object_points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.func_points_of_interest_upd();

DROP VIEW objecten.object_scenario_locatie;
CREATE OR REPLACE VIEW objecten.object_scenario_locatie
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
    CASE
	    WHEN o.formaat_object = 'klein' THEN st.size_object_klein
	    WHEN o.formaat_object = 'middel' THEN st.size_object_middel
	    WHEN o.formaat_object = 'groot' THEN st.size_object_groot
	END AS size,
    st.symbol_name,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
	o.label,
	o.label_positie,
	o.formaat_object,
    o.formaat_bouwlaag
   FROM objecten.scenario_locatie o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.scenario_locatie_type st ON 'Scenario locatie'::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.parent_deleted = 'infinity'::timestamp with time zone AND o.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_scenario_locatie_ins INSTEAD OF
INSERT
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_ins('object');
CREATE TRIGGER object_scenario_locatie_del INSTEAD OF
DELETE
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_del('object');
CREATE TRIGGER object_scenario_locatie_upd INSTEAD OF
UPDATE
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_upd('object');

DROP VIEW IF EXISTS objecten.object_sleutelkluis;
CREATE OR REPLACE VIEW objecten.object_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.sleutelkluis_type_id,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.fotografie_id,
    v.ingang_id,
    b.formelenaam,
    v.rotatie,
    st.symbol_name,
    CASE
	    WHEN v.formaat_object = 'klein' THEN st.size_object_klein
	    WHEN v.formaat_object = 'middel' THEN st.size_object_middel
	    WHEN v.formaat_object = 'groot' THEN st.size_object_groot
	END AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
	v.label_positie,
	v.formaat_object,
    v.formaat_bouwlaag,
    i.object_id
   FROM objecten.sleutelkluis v
     JOIN objecten.ingang i ON v.ingang_id = i.id
     JOIN objecten.sleutelkluis_type st ON v.sleutelkluis_type_id = st.id
     JOIN objecten.object b ON i.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_sleutelkluis_del INSTEAD OF
DELETE
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_del('object');
CREATE TRIGGER object_sleutelkluis_ins INSTEAD OF
INSERT
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_ins('object');
CREATE TRIGGER object_sleutelkluis_upd INSTEAD OF
UPDATE
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_upd('object');

DROP VIEW IF EXISTS objecten.bouwlaag_label;
CREATE OR REPLACE VIEW objecten.bouwlaag_label
AS SELECT v.id,
    v.geom,
    v.soort,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    st.symbol_name,
    CASE
	    WHEN v.formaat_bouwlaag = 'klein' THEN st.size_bouwlaag_klein
	    WHEN v.formaat_bouwlaag = 'middel' THEN st.size_bouwlaag_middel
	    WHEN v.formaat_bouwlaag = 'groot' THEN st.size_bouwlaag_groot
	END AS size,
    ''::text AS applicatie,
	v.formaat_object,
    v.formaat_bouwlaag
   FROM objecten.label v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.label_type st ON v.soort::text = st.naam::text
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER bouwlaag_label_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_del('bouwlaag');
CREATE TRIGGER bouwlaag_label_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_ins('bouwlaag');
CREATE TRIGGER bouwlaag_label_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_upd('bouwlaag');

DROP VIEW IF EXISTS objecten.object_veiligh_ruimtelijk;
CREATE OR REPLACE VIEW objecten.object_veiligh_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.veiligh_ruimtelijk_type_id,
    b.label,
    b.bijzonderheid,
    b.fotografie_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    st.symbol_name,
    CASE
	    WHEN b.formaat_object = 'klein' THEN st.size_object_klein
	    WHEN b.formaat_object = 'middel' THEN st.size_object_middel
	    WHEN b.formaat_object = 'groot' THEN st.size_object_groot
	END AS size,
    ''::text AS applicatie,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject,
	b.label_positie,
	b.formaat_object
   FROM objecten.veiligh_ruimtelijk b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.veiligh_ruimtelijk_type st ON b.veiligh_ruimtelijk_type_id = st.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER veiligh_ruimtelijk_del INSTEAD OF
DELETE
    ON
    objecten.object_veiligh_ruimtelijk FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_ruimtelijk_del();
CREATE TRIGGER veiligh_ruimtelijk_ins INSTEAD OF
INSERT
    ON
    objecten.object_veiligh_ruimtelijk FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_ruimtelijk_ins();
CREATE TRIGGER veiligh_ruimtelijk_upd INSTEAD OF
UPDATE
    ON
    objecten.object_veiligh_ruimtelijk FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_ruimtelijk_upd();

DROP VIEW objecten.object_label;
CREATE OR REPLACE VIEW objecten.object_label
AS SELECT l.id,
    l.geom,
    l.soort,
    l.omschrijving,
    l.bouwlaag_id,
    l.object_id,
    b.formelenaam,
    l.rotatie,
    st.symbol_name,
    CASE
	    WHEN l.formaat_object = 'klein' THEN st.size_object_klein
	    WHEN l.formaat_object = 'middel' THEN st.size_object_middel
	    WHEN l.formaat_object = 'groot' THEN st.size_object_groot
	END AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
	l.formaat_object,
    l.formaat_bouwlaag
   FROM objecten.label l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN objecten.label_type st ON l.soort::text = st.naam::text
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

CREATE TRIGGER object_label_del INSTEAD OF
DELETE
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_del('object');
CREATE TRIGGER object_label_ins INSTEAD OF
INSERT
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_ins('object');
CREATE TRIGGER object_label_upd INSTEAD OF
UPDATE
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_upd('object');

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.afw_binnendekking (geom, soort, label, rotatie, handelingsaanwijzing, bouwlaag_id, label_positie, formaat_bouwlaag)
            VALUES (new.geom, new.soort, new.label, new.rotatie, new.handelingsaanwijzing, new.bouwlaag_id, new.label_positie, new.formaat_bouwlaag);
        ELSE
            size := (SELECT at."size" FROM objecten.afw_binnendekking_type at WHERE naam = new.soort);
            symbol_name := (SELECT at.symbol_name FROM objecten.afw_binnendekking_type at WHERE naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.handelingsaanwijzing) d));
            bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
    
            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted, label, label_positie, formaat_bouwlaag)
            VALUES (new.geom, jsonstring, 'INSERT', 'afw_binnendekking', NULL, bouwlaagid, NEW.rotatie, size, symbol_name, new.bouwlaag, false, new.label, new.label_positie, new.formaat_bouwlaag);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.afw_binnendekking SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, handelingsaanwijzing = new.handelingsaanwijzing, 
					bouwlaag_id = new.bouwlaag_id, label_positie= new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag
            WHERE (afw_binnendekking.id = new.id);
        ELSE
            size := (SELECT at."size" FROM objecten.afw_binnendekking_type at WHERE naam = new.soort);
            symbol_name := (SELECT at.symbol_name FROM objecten.afw_binnendekking_type at WHERE naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.handelingsaanwijzing) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted, label, label_positie, formaat_bouwlaag)
            VALUES (new.geom, jsonstring, 'UPDATE', 'afw_binnendekking', old.id, new.bouwlaag_id, NEW.rotatie, size, symbol_name, new.bouwlaag, false, label, new.label_positie, new.formaat_bouwlaag);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'afw_binnendekking', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.afw_binnendekking WHERE (afw_binnendekking.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.handelingsaanwijzing) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted, label, label_positie, formaat_bouwlaag)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'afw_binnendekking', OLD.id, OLD.bouwlaag_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.bouwlaag, false, old.label, old.label_positie, old.formaat_bouwlaag);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.dreiging (geom, dreiging_type_id, label, rotatie, bouwlaag_id, object_id, fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.dreiging_type_id, new.label, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id, new.label_positie, new.formaat_bouwlaag, new.formaat_object);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'INSERT', 'dreiging', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, omschrijving = new.omschrijving, rotatie = new.rotatie, label = new.label, 
						bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie,
						formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (dreiging.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
                size := (SELECT dt."size" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            ELSE
                size := (SELECT dt."size_object" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'UPDATE', 'dreiging', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'dreiging', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.dreiging WHERE (dreiging.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.omschrijving) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'dreiging', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, 
						old.fotografie_id, false, old.label, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_ingang_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.ingang (geom, ingang_type_id, label, rotatie, belemmering, voorzieningen, bouwlaag_id, object_id, fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.ingang_type_id, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.bouwlaag_id, new.object_id, new.fotografie_id, new.label_positie, new.formaat_bouwlaag, new.formaat_object);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.belemmering, new.voorzieningen) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'INSERT', 'ingang', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_ingang_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, 
                    bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (ingang.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.belemmering, new.voorzieningen) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT dt."size_object" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag)
            VALUES (new.geom, jsonstring, 'UPDATE', 'ingang', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'ingang', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_ingang_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.ingang WHERE (ingang.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.belemmering, old.voorzieningen) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'ingang', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, 
						old.fotografie_id, false, old.label, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN 
            UPDATE objecten.sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, sleuteldoel_type_id = new.sleuteldoel_type_id, 
                    ingang_id = new.ingang_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (sleutelkluis.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT st."size_object" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'UPDATE', 'sleutelkluis', old.id, new.ingang_id, NEW.rotatie, size, symbol_name, bouwlaag,
						new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'sleutelkluis', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        ingangid integer;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, 
												fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.sleutelkluis_type_id, new.label, new.rotatie, new.aanduiding_locatie, new.sleuteldoel_type_id, new.ingang_id, 
						new.fotografie_id, new.label_positie, new.formaat_bouwlaag, new.formaat_object);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                ingangid := (SELECT i.ingang_id FROM (SELECT i.id AS ingang_id, b.geom <-> new.geom AS dist FROM objecten.ingang i
                                INNER JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) i);
                bouwlaag = new.bouwlaag;
            ELSEIF bouwlaag_object = 'object'::text THEN
                size := (SELECT st."size_object" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                ingangid := (SELECT b.ingang_id FROM (SELECT b.id AS ingang_id, b.geom <-> new.geom AS dist FROM objecten.ingang b ORDER BY dist LIMIT 1) b);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, row_to_json(NEW.*), 'INSERT', 'sleutelkluis', NULL, ingangid, NEW.rotatie, size, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.sleutelkluis WHERE (sleutelkluis.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.aanduiding_locatie, old.sleuteldoel_type_id) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'sleutelkluis', OLD.id, OLD.ingang_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, 
						OLD.fotografie_id, false, old.label, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_opslag_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.gevaarlijkestof_opslag (geom, locatie, bouwlaag_id, object_id, fotografie_id, rotatie, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.locatie, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT st."size_object" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'INSERT', 'gevaarlijkestof_opslag', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_opslag_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, 
					fotografie_id = new.fotografie_id, label = new.label, label_positie = new.label_positie, formaat_bouwlaag= new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (gevaarlijkestof_opslag.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
                size := (SELECT st."size" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            ELSE
                size := (SELECT st."size_object" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'UPDATE', 'gevaarlijkestof_opslag', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, size, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'gevaarlijkestof_opslag', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_opslag_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.gevaarlijkestof_opslag WHERE (gevaarlijkestof_opslag.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'gevaarlijkestof_opslag', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, 
						old.fotografie_id, false, old.label, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.opstelplaats (geom, soort, label, rotatie, object_id, fotografie_id, label_positie, formaat_object)
            VALUES (new.geom, new.soort, new.label, new.rotatie, new.object_id, new.fotografie_id, new.label_positie, new.formaat_object);
        ELSE
            size := (SELECT ot."size" FROM objecten.opstelplaats_type ot WHERE ot.naam = new.soort);
            symbol_name := (SELECT ot.symbol_name FROM objecten.opstelplaats_type ot WHERE ot.naam = new.soort);
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (new.geom, 'INSERT', 'opstelplaats', NULL, objectid, NEW.rotatie, size, symbol_name, new.fotografie_id, false, new.label, new.label_positie, new.formaat_object);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.opstelplaats SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, object_id = new.object_id, 
												fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_object=new.formaat_object
            WHERE (opstelplaats.id = new.id);
        ELSE
            size := (SELECT ot."size" FROM objecten.opstelplaats_type ot WHERE ot.naam = new.soort);
            symbol_name := (SELECT ot.symbol_name FROM objecten.opstelplaats_type ot WHERE ot.naam = new.soort);

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (new.geom, 'UPDATE', 'opstelplaats', old.id, new.object_id, NEW.rotatie, size, symbol_name, new.fotografie_id, false, new.label, new.label_positie, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'opstelplaats');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.opstelplaats WHERE (opstelplaats.id = old.id);
        ELSE
            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (OLD.geom, 'DELETE', 'opstelplaats', OLD.id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, old.fotografie_id, false, old.label, old.label_positie, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.points_of_interest (geom, points_of_interest_type_id, label, bijzonderheid, rotatie, object_id, fotografie_id, label_positie, formaat_object)
            VALUES (new.geom, new.points_of_interest_type_id, new.label, new.bijzonderheid, new.rotatie, new.object_id, new.fotografie_id, new.label_positie, new.formaat_object);
        ELSE
            size := (SELECT vt."size" FROM objecten.points_of_interest_type vt WHERE vt.id = new.points_of_interest_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.points_of_interest_type vt WHERE vt.id = new.points_of_interest_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.bijzonderheid) d));
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (new.geom, jsonstring, 'INSERT', 'points_of_interest', NULL, objectid, NEW.rotatie, size, symbol_name, new.fotografie_id, false, new.label, new.label_positie, new.formaat_object);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
                UPDATE objecten.points_of_interest SET geom = new.geom, points_of_interest_type_id = new.points_of_interest_type_id, rotatie = new.rotatie, bijzonderheid = new.bijzonderheid, 
						label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_object=new.formaat_object
                WHERE (points_of_interest.id = new.id);
        ELSE
            size := (SELECT vt."size" FROM objecten.points_of_interest_type vt WHERE vt.id = new.points_of_interest_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.points_of_interest_type vt WHERE vt.id = new.points_of_interest_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.bijzonderheid) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (new.geom, jsonstring, 'UPDATE', 'points_of_interest', old.id, new.object_id, NEW.rotatie, size, symbol_name, new.fotografie_id, false, new.label, new.label_positie, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'points_of_interest');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.points_of_interest WHERE (points_of_interest.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.bijzonderheid) d)); 

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'points_of_interest', OLD.id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.fotografie_id, false, old.label, old.label_positie, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.scenario_locatie (geom, locatie, bouwlaag_id, object_id, fotografie_id, rotatie, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.locatie, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT st."size_object" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'INSERT', 'scenario_locatie', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, 
													new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.scenario_locatie SET geom = new.geom, locatie = new.locatie, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id,
								label = new.label, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (scenario_locatie.id = new.id);
        ELSE
            
            symbol_name := (SELECT st.symbol_name FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT st."size_object" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'UPDATE', 'scenario_locatie', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, size, symbol_name, bouwlaag, 
													new.fotografie_id, false, new.label, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'scenario_locatie', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.scenario_locatie WHERE (scenario_locatie.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'scenario_locatie', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, 
													old.fotografie_id, false, old.label, old.label_positie, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.veiligh_install (geom, veiligh_install_type_id, label, bijzonderheid, rotatie, bouwlaag_id, fotografie_id, label_positie, formaat_bouwlaag)
            VALUES (new.geom, new.veiligh_install_type_id, new.label, new.bijzonderheid, new.rotatie, new.bouwlaag_id, new.fotografie_id, new.label_positie, new.formaat_bouwlaag);
        ELSE
            size := (SELECT vt."size" FROM objecten.veiligh_install_type vt WHERE vt.id = new.veiligh_install_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.veiligh_install_type vt WHERE vt.id = new.veiligh_install_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.bijzonderheid) d));
            bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
            
            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted, fotografie_id, label, label_positie, formaat_bouwlaag)
            VALUES (new.geom, jsonstring, 'INSERT', 'veiligh_install', NULL, bouwlaagid, NEW.rotatie, size, symbol_name, new.bouwlaag, false, new.fotografie_id, new.label, new.label_positie, new.formaat_bouwlaag);
        
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.veiligh_install SET geom = new.geom, veiligh_install_type_id = new.veiligh_install_type_id, bouwlaag_id = new.bouwlaag_id, label = new.label, rotatie = new.rotatie, 
					fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag
            WHERE (veiligh_install.id = new.id);
        ELSE
            size := (SELECT vt."size" FROM objecten.veiligh_install_type vt WHERE vt.id = new.veiligh_install_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.veiligh_install_type vt WHERE vt.id = new.veiligh_install_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.bijzonderheid) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, accepted, bouwlaag, fotografie_id, label, label_positie, formaat_bouwlaag)
            VALUES (new.geom, jsonstring, 'UPDATE', 'veiligh_install', old.id, new.bouwlaag_id, NEW.rotatie, size, symbol_name, false, new.bouwlaag, new.fotografie_id, new.label, new.label_positie, new.formaat_bouwlaag);
            
            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'veiligh_install', new.bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN  
            DELETE FROM objecten.veiligh_install WHERE (veiligh_install.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.bijzonderheid) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, accepted, fotografie_id, label, label_positie, formaat_bouwlaag)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'veiligh_install', OLD.id, OLD.bouwlaag_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.bouwlaag, false, OLD.fotografie_id, old.label, old.label_positie, old.formaat_bouwlaag);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_ruimtelijk_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        objectid integer;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.veiligh_ruimtelijk (geom, veiligh_ruimtelijk_type_id, label, rotatie, object_id, fotografie_id, label_positie, formaat_object)
            VALUES (new.geom, new.veiligh_ruimtelijk_type_id, new.label, new.rotatie, new.object_id, new.fotografie_id, new.label_positie, new.formaat_object);
        ELSE
            size := (SELECT vt."size" FROM objecten.veiligh_ruimtelijk_type vt WHERE vt.id = new.veiligh_ruimtelijk_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.veiligh_ruimtelijk_type vt WHERE vt.id = new.veiligh_ruimtelijk_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.bijzonderheid) d));        
            objectid := (SELECT b.object_id FROM (SELECT b.id AS object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (new.geom, jsonstring, 'INSERT', 'veiligh_ruimtelijk', NULL, objectid, NEW.rotatie, size, symbol_name, new.fotografie_id, false, new.label, new.label_positie, new.formaat_object);
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_ruimtelijk_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.veiligh_ruimtelijk SET geom = new.geom, veiligh_ruimtelijk_type_id = new.veiligh_ruimtelijk_type_id, rotatie = new.rotatie, label = new.label, object_id = new.object_id
            , fotografie_id = new.fotografie_id, bijzonderheid = NEW.bijzonderheid, label_positie = new.label_positie, formaat_object=new.formaat_object
            WHERE (veiligh_ruimtelijk.id = new.id);
        ELSE
            size := (SELECT vt."size" FROM objecten.veiligh_ruimtelijk_type vt WHERE vt.id = new.veiligh_ruimtelijk_type_id);
            symbol_name := (SELECT vt.symbol_name FROM objecten.veiligh_ruimtelijk_type vt WHERE vt.id = new.veiligh_ruimtelijk_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.bijzonderheid) d));

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (new.geom, row_to_json(NEW.*), 'UPDATE', 'veiligh_ruimtelijk', old.id, new.object_id, NEW.rotatie, size, symbol_name, new.fotografie_id, false, new.label, new.label_positie, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'veiligh_ruimtelijk');
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_ruimtelijk_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.veiligh_ruimtelijk WHERE (veiligh_ruimtelijk.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.bijzonderheid) d));        

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, object_id, rotatie, SIZE, symbol_name, fotografie_id, accepted, label, label_positie, formaat_object)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'veiligh_ruimtelijk', OLD.id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, OLD.fotografie_id, false, old.label, old.label_positie, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_label_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            INSERT INTO objecten.label (geom, soort, omschrijving, rotatie, bouwlaag_id, object_id, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id, new.object_id, new.formaat_bouwlaag, new.formaat_object);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.label_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.label_type dt WHERE dt.naam = new.soort);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.label_type dt WHERE dt.naam = new.soort);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_label (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, rotatie, SIZE, symbol_name, bouwlaag, accepted, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'INSERT', 'label', NULL, bouwlaagid, objectid, NEW.omschrijving, NEW.rotatie, size, symbol_name, bouwlaag, false, new.formaat_bouwlaag, new.formaat_object);

        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_label_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id,
                    formaat_bouwlaag =new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (label.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.label_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
                size := (SELECT dt."size" FROM objecten.label_type dt WHERE dt.naam = new.soort);
            ELSE
                size := (SELECT dt."size_object" FROM objecten.label_type dt WHERE dt.naam = new.soort);
            END IF;

            INSERT INTO mobiel.werkvoorraad_label (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, rotatie, SIZE, symbol_name, bouwlaag, accepted, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, jsonstring, 'UPDATE', 'label', OLD.id, NEW.bouwlaag_id, NEW.object_id, NEW.omschrijving, NEW.rotatie, size, symbol_name, bouwlaag, false, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'label', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE FUNCTION objecten.func_label_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
	      mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (OLD.applicatie = 'OIV') OR (mobielAan = False) THEN 
            DELETE FROM objecten.label WHERE (label.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.omschrijving) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_label (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, rotatie, SIZE, symbol_name, bouwlaag, accepted, formaat_bouwlaag, formaat_object)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'label', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.omschrijving, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, false, old.formaat_bouwlaag, old.formaat_object);
        END IF;
        RETURN OLD;
    END;
    $function$
;

DROP VIEW IF EXISTS mobiel.symbolen;
CREATE OR REPLACE VIEW mobiel.symbolen
AS SELECT concat(sub.brontabel, '_', sub.id::character varying) AS id,
    sub.geom,
    sub.waarden_new,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.rotatie,
    sub.size,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.binnen_buiten,
    sub.id AS orig_id,
    sub.datum_aangemaakt,
    sub.datum_gewijzigd,
    sub.label,
    sub.label_positie,
    sub.formaat
   FROM ( SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.bijzonderheid) d)) AS waarden_new,
            ''::character varying AS operatie,
            'veiligh_install'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END AS size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag AS formaat
           FROM objecten.veiligh_install v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.veiligh_install_type vt ON v.veiligh_install_type_id = vt.id
          WHERE v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('veiligh_install', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.bijzonderheid) d)) AS waarden_new,
            ''::character varying AS operatie,
            'veiligh_ruimtelijk'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.veiligh_ruimtelijk v
             JOIN objecten.veiligh_ruimtelijk_type vt ON v.veiligh_ruimtelijk_type_id = vt.id
          WHERE v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('veiligh_ruimtelijk', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.omschrijving) d)) AS waarden_new,
            ''::character varying AS operatie,
            'dreiging'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag
           FROM objecten.dreiging v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.dreiging_type vt ON v.dreiging_type_id = vt.id
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('dreiging', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.omschrijving) d)) AS waarden_new,
            ''::character varying AS operatie,
            'dreiging'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.dreiging v
             JOIN objecten.dreiging_type vt ON v.dreiging_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('dreiging', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.handelingsaanwijzing) d)) AS waarden_new,
            ''::character varying AS operatie,
            'afw_binnendekking'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag
           FROM objecten.afw_binnendekking v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.afw_binnendekking_type vt ON v.soort::text = vt.naam::text AND CONCAT('afw_binnendekking', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
          WHERE v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.belemmering,
                            v.voorzieningen) d)) AS waarden_new,
            ''::character varying AS operatie,
            'ingang'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag
           FROM objecten.ingang v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.ingang_type vt ON v.ingang_type_id = vt.id
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('ingang', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.belemmering,
                            v.voorzieningen) d)) AS waarden_new,
            ''::character varying AS operatie,
            'ingang'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.ingang v
             JOIN objecten.ingang_type vt ON v.ingang_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('ingang', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            NULL::json AS waarden_new,
            ''::character varying AS operatie,
            'opstelplaats'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.opstelplaats v
             JOIN objecten.opstelplaats_type vt ON v.soort::text = vt.naam::text
          WHERE v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('opstelplaats', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.aanduiding_locatie) d)) AS waarden_new,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            i.bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
                WHEN v.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
                WHEN v.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
            END,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag
           FROM objecten.sleutelkluis v
             JOIN objecten.ingang i ON v.ingang_id = i.id
             JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE i.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('sleutelkluis', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.aanduiding_locatie) d)) AS waarden_new,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            i.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.sleutelkluis v
             JOIN objecten.ingang i ON v.ingang_id = i.id
             JOIN objecten.sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id
          WHERE i.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('sleutelkluis', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT v.id,
            v.geom,
            row_to_json(( SELECT d.*::record AS d
                   FROM ( SELECT v.bijzonderheid) d)) AS waarden_new,
            ''::character varying AS operatie,
            'points_of_interest'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
            CASE
                WHEN v.formaat_object = 'klein' THEN vt.size_object_klein
                WHEN v.formaat_object = 'middel' THEN vt.size_object_middel
                WHEN v.formaat_object = 'groot' THEN vt.size_object_groot
            END,
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS binnen_buiten,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object
           FROM objecten.points_of_interest v
             JOIN objecten.points_of_interest_type vt ON v.points_of_interest_type_id = vt.id
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone AND CONCAT('points_of_interest', v.id) NOT IN (SELECT CONCAT(brontabel, bron_id) FROM mobiel.werkvoorraad_punt WHERE operatie = 'DELETE')
        UNION ALL
         SELECT werkvoorraad_punt.id,
            werkvoorraad_punt.geom,
            werkvoorraad_punt.waarden_new,
            werkvoorraad_punt.operatie,
            werkvoorraad_punt.brontabel,
            werkvoorraad_punt.bron_id,
            werkvoorraad_punt.object_id,
            werkvoorraad_punt.bouwlaag_id,
            werkvoorraad_punt.rotatie,
            werkvoorraad_punt.size,
            werkvoorraad_punt.symbol_name,
            werkvoorraad_punt.bouwlaag,
            ''::text AS binnen_buiten,
            'werkvoorraad'::text AS bron,
            werkvoorraad_punt.datum_aangemaakt,
            werkvoorraad_punt.datum_gewijzigd,
            werkvoorraad_punt.label,
            werkvoorraad_punt.label_positie,
            werkvoorraad_punt.formaat
           FROM mobiel.werkvoorraad_punt) sub;

CREATE RULE symbolen_ins AS
    ON INSERT TO mobiel.symbolen DO INSTEAD  INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, size, symbol_name,
                bouwlaag, accepted, bouwlaag_object, label, label_positie, formaat)
  VALUES (new.geom, new.waarden_new, 'INSERT'::character varying, new.brontabel, new.bron_id, new.bouwlaag_id, new.object_id, new.rotatie, new.size, new.symbol_name,
                new.bouwlaag, false, new.binnen_buiten, new.label, new.label_positie, new.formaat);

CREATE OR REPLACE FUNCTION mobiel.funct_symbol_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, 
				object_id, rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object, label, label_positie, formaat)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, new.bron_id, NEW.bouwlaag_id, 
  				NEW.object_id, new.rotatie, new.size, new.symbol_name, new.bouwlaag, FALSE, NEW.binnen_buiten, NEW.label, new.label_positie, new.formaat);
  		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), new.bron_id, new.brontabel, new.bouwlaag, new.bouwlaag_id, new.object_id);
			END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_punt
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=OLD.operatie, brontabel=NEW.brontabel, bron_id=old.bron_id, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, rotatie=NEW.rotatie, "size"=NEW.size, symbol_name=NEW.symbol_name,
				bouwlaag=NEW.bouwlaag, bouwlaag_object=NEW.binnen_buiten, label=NEW.label, label_positie=new.label_positie, formaat=new.formaat
			WHERE werkvoorraad_punt.id = OLD.orig_id;

			IF NOT ST_Equals(new.geom, old.geom) AND NEW.bron_id IS NOT NULL THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag, OLD.bouwlaag_id, OLD.object_id);
			END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel.funct_symbol_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id,
				  object_id, rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object, label, label_positie, formaat)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.bron_id, old.bouwlaag_id,
  				OLD.object_id, old.rotatie, old.size, old.symbol_name, old.bouwlaag, FALSE, OLD.binnen_buiten, OLD.label, old.label_positie, old.formaat);
	    ELSE
			  DELETE FROM mobiel.werkvoorraad_punt WHERE (id = OLD.orig_id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel.funct_label_update()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF NEW.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_label (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, omschrijving, 
				rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object)
  			VALUES (new.geom, new.waarden_new, 'UPDATE', new.brontabel, new.bron_id, new.bouwlaag_id, NEW.object_id, new.omschrijving, 
  				new.rotatie, new.size, new.symbol_name, new.bouwlaag, FALSE, new.binnen_buiten);
  		
			IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), new.bron_id, new.brontabel, new.bouwlaag, new.bouwlaag_id, NEW.object_id);
            END IF;
	    ELSE
			UPDATE mobiel.werkvoorraad_label
			SET geom=NEW.geom, waarden_new=NEW.waarden_new, operatie=old.operatie, brontabel=old.brontabel, bron_id=old.bron_id, omschrijving=new.omschrijving, 
				object_id=NEW.object_id, bouwlaag_id=NEW.bouwlaag_id, rotatie=NEW.rotatie, "size"=NEW.size, symbol_name=NEW.symbol_name, bouwlaag=NEW.bouwlaag, bouwlaag_object=NEW.binnen_buiten
			WHERE werkvoorraad_label.id = OLD.orig_id;
		
			IF NOT ST_Equals(new.geom, old.geom) AND NEW.bron_id IS NOT NULL THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag, bouwlaag_id, object_id) 
                    VALUES (ST_MakeLine(ST_Centroid(old.geom), ST_Centroid(new.geom)), old.bron_id, new.brontabel, new.bouwlaag, OLD.bouwlaag_id, OLD.object_id);
            END IF;
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel.funct_label_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_label (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id,
				object_id, rotatie, size, symbol_name, bouwlaag, accepted, bouwlaag_object, omschrijving)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.bron_id, old.bouwlaag_id,
  				OLD.object_id, old.rotatie, old.size, old.symbol_name, old.bouwlaag, FALSE, old_binnen_buiten, OLD.omschrijving);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_label WHERE (id = OLD.orig_id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel.funct_lijn_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_lijn (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, accepted, bouwlaag_object)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.bron_id, old.bouwlaag_id, old.symbol_name, old.bouwlaag, FALSE, OLD.binnen_buiten);
	    ELSE
			DELETE FROM mobiel.werkvoorraad_lijn WHERE (id = OLD.orig_id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel.funct_vlak_delete()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    BEGIN 
	    IF OLD.bron = 'oiv' THEN
			INSERT INTO mobiel.werkvoorraad_vlak (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, symbol_name, bouwlaag, accepted, bouwlaag_object)
  			VALUES (old.geom, old.waarden_new, 'DELETE', old.brontabel, old.bron_id, old.bouwlaag_id, old.symbol_name, old.bouwlaag, FALSE, OLD.binnen_buiten);	
	    ELSE
			DELETE FROM mobiel.werkvoorraad_vlak WHERE (id = OLD.orig_id);
	    END IF;
	    RETURN NULL;
    END;
$function$
;

DROP VIEW objecten.view_afw_binnendekking;
CREATE OR REPLACE VIEW objecten.view_afw_binnendekking
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.handelingsaanwijzing,
    d.bouwlaag_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vt.symbol_name,
    CASE
        WHEN d.formaat_bouwlaag = 'klein' THEN vt.size_bouwlaag_klein
        WHEN d.formaat_bouwlaag = 'middel' THEN vt.size_bouwlaag_middel
        WHEN d.formaat_bouwlaag = 'groot' THEN vt.size_bouwlaag_groot
    END as size,
    o.share,
	d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.afw_binnendekking d ON st_intersects(t.geom, d.geom)
     JOIN objecten.afw_binnendekking_type vt ON d.soort::text = vt.naam::text
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_dreiging_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_dreiging_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.dreiging_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.naam AS soort,
    dt.symbol_name,
    CASE
        WHEN d.formaat_bouwlaag = 'klein' THEN dt.size_bouwlaag_klein
        WHEN d.formaat_bouwlaag = 'middel' THEN dt.size_bouwlaag_middel
        WHEN d.formaat_bouwlaag = 'groot' THEN dt.size_bouwlaag_groot
    END as size,
    o.share,
	d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.dreiging d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.dreiging_type dt ON d.dreiging_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_dreiging_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_dreiging_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dreiging_type_id,
    b.rotatie,
    b.label,
    b.bouwlaag_id,
    b.object_id,
    b.fotografie_id,
    vt.naam AS soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    CASE
        WHEN b.formaat_object = 'klein' THEN vt.size_object_klein
        WHEN b.formaat_object = 'middel' THEN vt.size_object_middel
        WHEN b.formaat_object = 'groot' THEN vt.size_object_groot
    END as size,
    o.share,
	b.label_positie
   FROM objecten.object o
     JOIN objecten.dreiging b ON o.id = b.object_id
     JOIN objecten.dreiging_type vt ON b.dreiging_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_gevaarlijkestof_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    st.symbol_name,
    CASE
        WHEN op.formaat_bouwlaag = 'klein' THEN st.size_bouwlaag_klein
        WHEN op.formaat_bouwlaag = 'middel' THEN st.size_bouwlaag_middel
        WHEN op.formaat_bouwlaag = 'groot' THEN st.size_bouwlaag_groot
    END as size,
    o.share,
	op.label,
	op.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_gevaarlijkestof_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    st.symbol_name,
    CASE
        WHEN op.formaat_object = 'klein' THEN st.size_object_klein
        WHEN op.formaat_object = 'middel' THEN st.size_object_middel
        WHEN op.formaat_object = 'groot' THEN st.size_object_groot
    END as size,
    o.share,
	op.label,
	op.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_ingang_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.ingang_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.naam AS soort,
    dt.symbol_name,
    CASE
        WHEN d.formaat_bouwlaag = 'klein' THEN dt.size_bouwlaag_klein
        WHEN d.formaat_bouwlaag = 'middel' THEN dt.size_bouwlaag_middel
        WHEN d.formaat_bouwlaag = 'groot' THEN dt.size_bouwlaag_groot
    END as size,
    o.share,
	d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.ingang d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.ingang_type dt ON d.ingang_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_ingang_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_ingang_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.ingang_type_id,
    b.rotatie,
    b.label,
    b.belemmering,
    b.voorzieningen,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.naam AS soort,
    vt.symbol_name,
    CASE
        WHEN b.formaat_object = 'klein' THEN vt.size_object_klein
        WHEN b.formaat_object = 'middel' THEN vt.size_object_middel
        WHEN b.formaat_object = 'groot' THEN vt.size_object_groot
    END as size,
    o.share,
	b.label_positie
   FROM objecten.object o
     JOIN objecten.ingang b ON o.id = b.object_id
     JOIN objecten.ingang_type vt ON b.ingang_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_opstelplaats;
CREATE OR REPLACE VIEW objecten.view_opstelplaats
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.rotatie,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    CASE
        WHEN b.formaat_object = 'klein' THEN vt.size_object_klein
        WHEN b.formaat_object = 'middel' THEN vt.size_object_middel
        WHEN b.formaat_object = 'groot' THEN vt.size_object_groot
    END as size,
    o.share,
	b.label_positie
   FROM objecten.object o
     JOIN objecten.opstelplaats b ON o.id = b.object_id
     JOIN objecten.opstelplaats_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_points_of_interest;
CREATE OR REPLACE VIEW objecten.view_points_of_interest
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    vt.naam AS soort,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    b.bijzonderheid,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    CASE
        WHEN b.formaat_object = 'klein' THEN vt.size_object_klein
        WHEN b.formaat_object = 'middel' THEN vt.size_object_middel
        WHEN b.formaat_object = 'groot' THEN vt.size_object_groot
    END as size,
    o.share,
	b.label_positie
   FROM objecten.object o
     JOIN objecten.points_of_interest b ON o.id = b.object_id
     JOIN objecten.points_of_interest_type vt ON b.points_of_interest_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_scenario_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_scenario_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.scenario_locatie_id,
    d.omschrijving,
    d.scenario_type_id,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    slt.symbol_name,
    CASE
        WHEN op.formaat_bouwlaag = 'klein' THEN slt.size_bouwlaag_klein
        WHEN op.formaat_bouwlaag = 'middel' THEN slt.size_bouwlaag_middel
        WHEN op.formaat_bouwlaag = 'groot' THEN slt.size_bouwlaag_groot
    END as size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url,
    o.share,
	op.label,
	op.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.scenario_locatie op ON st_intersects(t.geom, op.geom)
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id
     JOIN objecten.scenario_locatie_type slt ON 'Scenario locatie'::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.scenario_type_id = st.id
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_scenario_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_scenario_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.scenario_locatie_id,
    d.omschrijving,
    d.scenario_type_id,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    slt.symbol_name,
    CASE
        WHEN op.formaat_object = 'klein' THEN slt.size_object_klein
        WHEN op.formaat_object = 'middel' THEN slt.size_object_middel
        WHEN op.formaat_object = 'groot' THEN slt.size_object_groot
    END as size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url,
    o.share,
	op.label,
	op.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.scenario_locatie op ON o.id = op.object_id
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id
     JOIN objecten.scenario_locatie_type slt ON 'Scenario locatie'::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.scenario_type_id = st.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_sleutelkluis_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.sleutelkluis_type_id,
    d.aanduiding_locatie,
    d.sleuteldoel_type_id,
    d.rotatie,
    d.label,
    d.ingang_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    i.bouwlaag_id,
    dd.naam AS doel,
    dt.naam AS soort,
    dt.symbol_name,
    CASE
        WHEN d.formaat_bouwlaag = 'klein' THEN dt.size_bouwlaag_klein
        WHEN d.formaat_bouwlaag = 'middel' THEN dt.size_bouwlaag_middel
        WHEN d.formaat_bouwlaag = 'groot' THEN dt.size_bouwlaag_groot
    END as size,
    o.share,
	d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.sleutelkluis d ON st_intersects(t.geom, d.geom)
     JOIN objecten.ingang i ON d.ingang_id = i.id
     JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
     JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     LEFT JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_sleutelkluis_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.sleutelkluis_type_id,
    d.aanduiding_locatie,
    d.sleuteldoel_type_id,
    d.rotatie,
    d.label,
    d.ingang_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    i.object_id,
    dd.naam AS doel,
    dt.naam AS soort,
    dt.symbol_name,
    CASE
        WHEN d.formaat_object = 'klein' THEN dt.size_object_klein
        WHEN d.formaat_object = 'middel' THEN dt.size_object_middel
        WHEN d.formaat_object = 'groot' THEN dt.size_object_groot
    END as size,
    o.share,
	d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.ingang i ON o.id = i.object_id
     JOIN objecten.sleutelkluis d ON i.id = d.ingang_id
     JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     LEFT JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_veiligh_install;
CREATE OR REPLACE VIEW objecten.view_veiligh_install
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.veiligh_install_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    d.bijzonderheid,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.naam AS soort,
    dt.symbol_name,
    CASE
        WHEN d.formaat_bouwlaag = 'klein' THEN dt.size_bouwlaag_klein
        WHEN d.formaat_bouwlaag = 'middel' THEN dt.size_bouwlaag_middel
        WHEN d.formaat_bouwlaag = 'groot' THEN dt.size_bouwlaag_groot
    END as size,
    o.share,
	d.label_positie
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.veiligh_install d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type dt ON d.veiligh_install_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW objecten.view_veiligh_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_veiligh_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.veiligh_ruimtelijk_type_id,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    vt.naam AS soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    CASE
        WHEN b.formaat_object = 'klein' THEN vt.size_object_klein
        WHEN b.formaat_object = 'middel' THEN vt.size_object_middel
        WHEN b.formaat_object = 'groot' THEN vt.size_object_groot
    END as size,
    o.share,
	b.label_positie
   FROM objecten.object o
     JOIN objecten.veiligh_ruimtelijk b ON o.id = b.object_id
     JOIN objecten.veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 5;
UPDATE algemeen.applicatie SET db_versie = 365; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();