SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE OR REPLACE FUNCTION objecten.set_delete_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
      command text := ' SET self_deleted = now() WHERE id = $1';
    BEGIN
      EXECUTE 'UPDATE "' || TG_TABLE_SCHEMA || '"."' || TG_TABLE_NAME || '" ' || command USING OLD.id;
      RETURN NULL;
    END;
  $function$
;

ALTER TABLE objecten.bouwlagen RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.object RENAME COLUMN datum_deleted TO self_deleted;

ALTER TABLE objecten.aanwezig RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.aanwezig ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.aanwezig FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.afw_binnendekking RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.afw_binnendekking ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.bedrijfshulpverlening RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.bedrijfshulpverlening ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.bedrijfshulpverlening FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.bereikbaarheid RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.bereikbaarheid ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.contactpersoon RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.contactpersoon ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.contactpersoon FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.dreiging RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.dreiging ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.dreiging FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.gebiedsgerichte_aanpak RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.gebiedsgerichte_aanpak ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.gevaarlijkestof_opslag RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.gevaarlijkestof_opslag ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.gevaarlijkestof_opslag FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.gevaarlijkestof RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.gevaarlijkestof ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.gevaarlijkestof FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.gevaarlijkestof_schade_cirkel RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.gevaarlijkestof_schade_cirkel ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.gevaarlijkestof_schade_cirkel FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.grid RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.grid ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.grid FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.historie RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.historie ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.historie FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.ingang RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.ingang ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.ingang FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.isolijnen RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.isolijnen ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.label RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.label ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.label FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.opstelplaats RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.opstelplaats ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.points_of_interest RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.points_of_interest ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.ruimten RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.ruimten ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.ruimten FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.scenario_locatie RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.scenario_locatie ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.scenario RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.scenario ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.scenario FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.sectoren RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.sectoren ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.sectoren FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.sleutelkluis RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.sleutelkluis ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.terrein RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.terrein ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.terrein FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.veiligh_bouwk RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.veiligh_bouwk ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.veiligh_install RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.veiligh_install ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.veiligh_ruimtelijk RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.veiligh_ruimtelijk ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.veiligh_ruimtelijk FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

ALTER TABLE objecten.veilighv_org RENAME COLUMN datum_deleted TO parent_deleted;
ALTER TABLE objecten.veilighv_org ADD COLUMN self_deleted timestamptz default 'infinity';
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.veilighv_org FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();

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
    st.size,
    ''::text AS applicatie
   FROM objecten.afw_binnendekking v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.afw_binnendekking_type st ON v.soort::text = st.naam::text
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW objecten.bouwlaag_bouwlagen
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.bouwlaag,
    b.bouwdeel,
    b.pand_id,
    b.self_deleted AS datum_deleted
   FROM objecten.bouwlagen b
  WHERE b.self_deleted = 'infinity'::timestamp with time zone;

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
    st.size,
    ''::text AS applicatie
   FROM objecten.dreiging v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.dreiging_type st ON v.dreiging_type_id = st.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

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
    it.symbol_name,
    it.size,
    ''::text AS applicatie
   FROM objecten.ingang v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.ingang_type it ON v.ingang_type_id = it.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

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
    st.size,
    ''::text AS applicatie
   FROM objecten.label v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.label_type st ON v.soort::text = st.naam::text
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

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
    st.size,
    ''::text AS applicatie
   FROM objecten.gevaarlijkestof_opslag v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW objecten.bouwlaag_ruimten
AS SELECT v.id,
    v.geom,
    v.ruimten_type_id,
    v.omschrijving,
    v.fotografie_id,
    v.bouwlaag_id,
    b.bouwlaag,
    ''::text AS applicatie
   FROM objecten.ruimten v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone;

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
    st.size,
    ''::text AS applicatie
   FROM objecten.scenario_locatie v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.scenario_locatie_type st ON 'Scenario locatie'::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

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
    it.symbol_name,
    it.size,
    ''::text AS applicatie
   FROM objecten.sleutelkluis v
     JOIN ( SELECT b.bouwlaag,
            ib.id,
            ib.bouwlaag_id
           FROM objecten.ingang ib
             JOIN objecten.bouwlagen b ON ib.bouwlaag_id = b.id) part ON v.ingang_id = part.id
     JOIN objecten.sleutelkluis_type it ON v.sleutelkluis_type_id = it.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_bouwk
AS SELECT v.id,
    v.geom,
    v.soort,
    v.fotografie_id,
    v.bouwlaag_id,
    b.bouwlaag,
    ''::text AS applicatie
   FROM objecten.veiligh_bouwk v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

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
    vt.size,
    vt.symbol_name,
    ''::text AS applicatie
   FROM objecten.veiligh_install v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type vt ON v.veiligh_install_type_id = vt.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;







-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 5;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 353; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = 'v3';
UPDATE algemeen.applicatie SET datum = now();