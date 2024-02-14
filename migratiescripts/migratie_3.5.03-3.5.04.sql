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










-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 5;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 353; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = 'v3';
UPDATE algemeen.applicatie SET datum = now();