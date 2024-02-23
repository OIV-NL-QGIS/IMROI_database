SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE aanwezig DROP CONSTRAINT aanwezig_bouwlaag_id_fk;
ALTER TABLE afw_binnendekking DROP CONSTRAINT afw_binnendekking_object_id_fk;
ALTER TABLE afw_binnendekking DROP CONSTRAINT afw_binnendekking_bouwlaag_id_fk;
ALTER TABLE bedrijfshulpverlening DROP CONSTRAINT bedrijfshulpverlening_object_id_fk;
ALTER TABLE beheersmaatregelen DROP CONSTRAINT beheersmaatregel_dreiging_id_fik;
ALTER TABLE bereikbaarheid DROP CONSTRAINT bereikbaarheid_object_id_fk;
ALTER TABLE contactpersoon DROP CONSTRAINT contactpersoon_object_id_fk;
ALTER TABLE dreiging DROP CONSTRAINT dreiging_object_id_fk;
ALTER TABLE dreiging DROP CONSTRAINT dreiging_bouwlaag_id_fk;
ALTER TABLE gebiedsgerichte_aanpak DROP CONSTRAINT gebiedsgerichte_aanpak_object_id_fk;
ALTER TABLE gebruiksfunctie DROP CONSTRAINT gebruiksfunctie_object_id_fk;
ALTER TABLE gevaarlijkestof_schade_cirkel DROP CONSTRAINT schade_cirkel_gevaarlijkestof_id_fk;
ALTER TABLE gevaarlijkestof DROP CONSTRAINT gevaarlijkestof_opslag_id_fk;
ALTER TABLE gevaarlijkestof_opslag DROP CONSTRAINT opslag_object_id_fk;
ALTER TABLE gevaarlijkestof_opslag DROP CONSTRAINT opslag_bouwlaag_id_fk;
ALTER TABLE grid DROP CONSTRAINT grid_object_id_fk;
ALTER TABLE historie DROP CONSTRAINT historie_object_id_fk;
ALTER TABLE sleutelkluis DROP CONSTRAINT sleutelkluis_ingang_id_fk;
ALTER TABLE ingang DROP CONSTRAINT ingang_object_id_fk;
ALTER TABLE ingang DROP CONSTRAINT ingang_id_fk;
ALTER TABLE isolijnen DROP CONSTRAINT isolijnen_object_id_fk;
ALTER TABLE label DROP CONSTRAINT labels_object_id_fk;
ALTER TABLE label DROP CONSTRAINT labels_bouwlaag_id_fk;
ALTER TABLE opstelplaats DROP CONSTRAINT opstelplaats_object_id_fk;
ALTER TABLE points_of_interest DROP CONSTRAINT points_of_interest_object_id_fk;
ALTER TABLE ruimten DROP CONSTRAINT ruimten_bouwlaag_id_fk;
ALTER TABLE scenario DROP CONSTRAINT scenario_locatie_id_fk;
ALTER TABLE scenario_locatie DROP CONSTRAINT scenario_locatie_bouwlaag_id_fk;
ALTER TABLE scenario_locatie DROP CONSTRAINT scenario_locatie_object_id_fk;
ALTER TABLE sectoren DROP CONSTRAINT sectoren_object_id_fk;
ALTER TABLE terrein DROP CONSTRAINT terrein_object_id_fk;
ALTER TABLE veiligh_bouwk DROP CONSTRAINT veiligh_bouwk_bouwlaag_id_fk;
ALTER TABLE veiligh_install DROP CONSTRAINT veiligh_install_bouwlaag_id_fk;
ALTER TABLE veiligh_ruimtelijk DROP CONSTRAINT veiligh_ruimtelijk_object_id_fk;
ALTER TABLE veilighv_org DROP CONSTRAINT veilighv_org_object_id_fk;

UPDATE object SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE object ALTER COLUMN datum_deleted SET DEFAULT 'infinity';
ALTER TABLE OBJECT DROP CONSTRAINT object_pkey;
ALTER TABLE object ADD PRIMARY KEY (id, datum_deleted);

UPDATE bouwlagen SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE bouwlagen ALTER COLUMN datum_deleted SET DEFAULT 'infinity';
ALTER TABLE bouwlagen DROP CONSTRAINT bouwlagen_pkey;
ALTER TABLE bouwlagen ADD PRIMARY KEY (id, datum_deleted);

UPDATE aanwezig SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE aanwezig ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE afw_binnendekking SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE afw_binnendekking ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE bedrijfshulpverlening SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE bedrijfshulpverlening ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE beheersmaatregelen SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE beheersmaatregelen ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE bereikbaarheid SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE bereikbaarheid ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE contactpersoon SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE contactpersoon ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE dreiging SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE dreiging ALTER COLUMN datum_deleted SET DEFAULT 'infinity';
ALTER TABLE dreiging DROP CONSTRAINT dreiging_pkey;
ALTER TABLE dreiging ADD PRIMARY KEY (id, datum_deleted);

UPDATE gebiedsgerichte_aanpak SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE gebiedsgerichte_aanpak ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE gebruiksfunctie SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE gebruiksfunctie ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE gevaarlijkestof SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE gevaarlijkestof ALTER COLUMN datum_deleted SET DEFAULT 'infinity';
ALTER TABLE gevaarlijkestof DROP CONSTRAINT gevaarlijkestof_pkey;
ALTER TABLE gevaarlijkestof ADD PRIMARY KEY (id, datum_deleted);

UPDATE gevaarlijkestof_opslag SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE gevaarlijkestof_opslag ALTER COLUMN datum_deleted SET DEFAULT 'infinity';
ALTER TABLE gevaarlijkestof_opslag DROP CONSTRAINT IF EXISTS gevaarlijkestof_opslag_pkey;
ALTER TABLE gevaarlijkestof_opslag DROP CONSTRAINT IF EXISTS opslag_pkey;
ALTER TABLE gevaarlijkestof_opslag ADD PRIMARY KEY (id, datum_deleted);

UPDATE grid SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE grid ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE historie SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE historie ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE ingang SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE ingang ALTER COLUMN datum_deleted SET DEFAULT 'infinity';
ALTER TABLE ingang DROP CONSTRAINT ingang_pkey;
ALTER TABLE ingang ADD PRIMARY KEY (id, datum_deleted);

UPDATE isolijnen SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE isolijnen ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE label SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE label ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE opstelplaats SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE opstelplaats ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE points_of_interest SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE points_of_interest ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE ruimten SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE ruimten ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE scenario SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE scenario ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE scenario_locatie SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE scenario_locatie ALTER COLUMN datum_deleted SET DEFAULT 'infinity';
ALTER TABLE scenario_locatie DROP CONSTRAINT scenario_locatie_pkey;
ALTER TABLE scenario_locatie ADD PRIMARY KEY (id, datum_deleted);

UPDATE sectoren SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE sectoren ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE sleutelkluis SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE sleutelkluis ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE terrein SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE terrein ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE veiligh_bouwk SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE veiligh_bouwk ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE veiligh_install SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE veiligh_install ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE veiligh_ruimtelijk SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE veiligh_ruimtelijk ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

UPDATE veilighv_org SET datum_deleted = 'infinity' WHERE datum_deleted IS NULL;
ALTER TABLE veilighv_org ALTER COLUMN datum_deleted SET DEFAULT 'infinity';

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
ALTER TABLE objecten.aanwezig RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.aanwezig ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE aanwezig SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM bouwlagen WHERE self_deleted != 'infinity') sub WHERE aanwezig.bouwlaag_id = sub.id;
ALTER TABLE aanwezig ADD CONSTRAINT aanwezig_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES bouwlagen (id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.afw_binnendekking RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.afw_binnendekking ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE afw_binnendekking SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM bouwlagen WHERE self_deleted != 'infinity') sub WHERE afw_binnendekking.bouwlaag_id = sub.id;
UPDATE afw_binnendekking SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE afw_binnendekking.object_id = sub.id;
ALTER TABLE afw_binnendekking ADD CONSTRAINT afw_binnendekking_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE afw_binnendekking ADD CONSTRAINT afw_binnendekking_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES bouwlagen(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.bedrijfshulpverlening RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.bedrijfshulpverlening ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE bedrijfshulpverlening SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE bedrijfshulpverlening.object_id = sub.id;
ALTER TABLE bedrijfshulpverlening ADD CONSTRAINT bedrijfshulpverlening_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.bereikbaarheid RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.bereikbaarheid ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE bereikbaarheid SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE bereikbaarheid.object_id = sub.id;
ALTER TABLE bereikbaarheid ADD CONSTRAINT bereikbaarheid_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.dreiging RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.dreiging ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE dreiging SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM bouwlagen WHERE self_deleted != 'infinity') sub WHERE dreiging.bouwlaag_id = sub.id;
UPDATE dreiging SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE dreiging.object_id = sub.id;
ALTER TABLE dreiging ADD CONSTRAINT dreiging_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE dreiging ADD CONSTRAINT dreiging_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES bouwlagen(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE beheersmaatregelen RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE beheersmaatregelen ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE beheersmaatregelen SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM dreiging WHERE self_deleted != 'infinity') sub WHERE beheersmaatregelen.dreiging_id = sub.id;
ALTER TABLE beheersmaatregelen ADD CONSTRAINT beheersmaatregelen_dreiging_id_fk FOREIGN KEY (dreiging_id, parent_deleted) REFERENCES dreiging (id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.contactpersoon RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.contactpersoon ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE contactpersoon SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE contactpersoon.object_id = sub.id;
ALTER TABLE contactpersoon ADD CONSTRAINT contactpersoon_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.gebiedsgerichte_aanpak RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.gebiedsgerichte_aanpak ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE gebiedsgerichte_aanpak SET parent_deleted = sub.sel_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE gebiedsgerichte_aanpak.object_id = sub.id;
ALTER TABLE gebiedsgerichte_aanpak ADD CONSTRAINT gebiedsgerichte_aanpak_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE gebruiksfunctie RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE gebruiksfunctie ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE gebruiksfunctie SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE gebruiksfunctie.object_id = sub.id;
ALTER TABLE gebruiksfunctie ADD CONSTRAINT gebruiksfunctie_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.gevaarlijkestof_opslag RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.gevaarlijkestof_opslag ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE gevaarlijkestof_opslag SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM bouwlagen WHERE self_deleted != 'infinity') sub WHERE gevaarlijkestof_opslag.bouwlaag_id = sub.id;
UPDATE gevaarlijkestof_opslag SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE gevaarlijkestof_opslag.object_id = sub.id;
ALTER TABLE gevaarlijkestof_opslag ADD CONSTRAINT gevaarlijkestof_opslag_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE gevaarlijkestof_opslag ADD CONSTRAINT gevaarlijkestof_opslag_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES bouwlagen(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.gevaarlijkestof RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.gevaarlijkestof ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE gevaarlijkestof SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM gevaarlijkestof_opslag WHERE self_deleted != 'infinity') sub WHERE gevaarlijkestof.opslag_id = sub.id;
ALTER TABLE gevaarlijkestof ADD CONSTRAINT gevaarlijkestof_opslag_id_fk FOREIGN KEY (opslag_id, parent_deleted) REFERENCES gevaarlijkestof_opslag (id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.gevaarlijkestof_schade_cirkel RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.gevaarlijkestof_schade_cirkel ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE gevaarlijkestof_schade_cirkel SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM gevaarlijkestof WHERE self_deleted != 'infinity') sub WHERE gevaarlijkestof_schade_cirkel.gevaarlijkestof_id = sub.id;
ALTER TABLE gevaarlijkestof_schade_cirkel ADD CONSTRAINT schade_cirkel_gevaarlijkestof_id_fk FOREIGN KEY (gevaarlijkestof_id, parent_deleted) REFERENCES gevaarlijkestof (id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.grid RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.grid ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE grid SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE grid.object_id = sub.id;
ALTER TABLE grid ADD CONSTRAINT grid_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.historie RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.historie ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE historie SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE historie.object_id = sub.id;
ALTER TABLE historie ADD CONSTRAINT historie_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.isolijnen RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.isolijnen ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE isolijnen SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE isolijnen.object_id = sub.id;
ALTER TABLE isolijnen ADD CONSTRAINT isolijnen_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.ingang RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.ingang ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE ingang SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM bouwlagen WHERE self_deleted != 'infinity') sub WHERE ingang.bouwlaag_id = sub.id;
UPDATE ingang SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE ingang.object_id = sub.id;
ALTER TABLE ingang ADD CONSTRAINT ingang_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ingang ADD CONSTRAINT ingang_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES bouwlagen(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.sleutelkluis RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.sleutelkluis ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE sleutelkluis SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM ingang WHERE self_deleted != 'infinity') sub WHERE sleutelkluis.ingang_id = sub.id;
ALTER TABLE sleutelkluis ADD CONSTRAINT sleutelkluis_ingang_id_fk FOREIGN KEY (ingang_id, parent_deleted) REFERENCES ingang (id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.label RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.label ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE label SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM bouwlagen WHERE self_deleted != 'infinity') sub WHERE label.bouwlaag_id = sub.id;
UPDATE label SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE label.object_id = sub.id;
ALTER TABLE label ADD CONSTRAINT label_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE label ADD CONSTRAINT label_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES bouwlagen(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.opstelplaats RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.opstelplaats ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE opstelplaats SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE opstelplaats.object_id = sub.id;
ALTER TABLE opstelplaats ADD CONSTRAINT opstelplaats_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.points_of_interest RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.points_of_interest ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE points_of_interest SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE points_of_interest.object_id = sub.id;
ALTER TABLE points_of_interest ADD CONSTRAINT points_of_interest_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.ruimten RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.ruimten ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE ruimten SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM bouwlagen WHERE self_deleted != 'infinity') sub WHERE ruimten.bouwlaag_id = sub.id;
ALTER TABLE ruimten ADD CONSTRAINT ruimten_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES bouwlagen (id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.scenario_locatie RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.scenario_locatie ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE scenario_locatie SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM bouwlagen WHERE self_deleted != 'infinity') sub WHERE scenario_locatie.bouwlaag_id = sub.id;
UPDATE scenario_locatie SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE scenario_locatie.object_id = sub.id;
ALTER TABLE scenario_locatie ADD CONSTRAINT scenario_locatie_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE scenario_locatie ADD CONSTRAINT scenario_locatie_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES bouwlagen(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.scenario RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.scenario ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE scenario SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM scenario_locatie WHERE self_deleted != 'infinity') sub WHERE scenario.scenario_locatie_id = sub.id;
ALTER TABLE scenario ADD CONSTRAINT scenario_locatie_id_fk FOREIGN KEY (scenario_locatie_id, parent_deleted) REFERENCES scenario_locatie (id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.sectoren RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.sectoren ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE sectoren SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE sectoren.object_id = sub.id;
ALTER TABLE sectoren ADD CONSTRAINT sectoren_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.terrein RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.terrein ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE terrein SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE terrein.object_id = sub.id;
ALTER TABLE terrein ADD CONSTRAINT terrein_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.veiligh_bouwk RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.veiligh_bouwk ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE veiligh_bouwk SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM bouwlagen WHERE self_deleted != 'infinity') sub WHERE veiligh_bouwk.bouwlaag_id = sub.id;
ALTER TABLE veiligh_bouwk ADD CONSTRAINT veiligh_bouwk_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES bouwlagen (id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.veiligh_install RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.veiligh_install ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE veiligh_install SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM bouwlagen WHERE self_deleted != 'infinity') sub WHERE veiligh_install.bouwlaag_id = sub.id;
ALTER TABLE veiligh_install ADD CONSTRAINT veiligh_install_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id, parent_deleted) REFERENCES bouwlagen (id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.veiligh_ruimtelijk RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.veiligh_ruimtelijk ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE veiligh_ruimtelijk SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE veiligh_ruimtelijk.object_id = sub.id;
ALTER TABLE veiligh_ruimtelijk ADD CONSTRAINT veiligh_ruimtelijk_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.veilighv_org RENAME COLUMN datum_deleted TO self_deleted;
ALTER TABLE objecten.veilighv_org ADD COLUMN parent_deleted timestamptz default 'infinity';
UPDATE veilighv_org SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE veilighv_org.object_id = sub.id;
ALTER TABLE veilighv_org ADD CONSTRAINT veilighv_org_object_id_fk FOREIGN KEY (object_id, parent_deleted) REFERENCES "object"(id, self_deleted) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.aanwezig FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.bedrijfshulpverlening FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.dreiging FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON beheersmaatregelen FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.contactpersoon FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON gebruiksfunctie FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.gevaarlijkestof_opslag FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.gevaarlijkestof FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.gevaarlijkestof_schade_cirkel FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.grid FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.historie FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.ingang FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.label FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.ruimten FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.scenario FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.sectoren FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.terrein FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.veiligh_ruimtelijk FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();
CREATE TRIGGER trg_set_delete_after_parent AFTER UPDATE OF parent_deleted ON objecten.veilighv_org FOR EACH ROW EXECUTE FUNCTION objecten.set_delete_timestamp();


DROP FUNCTION objecten.func_soft_delete_cascade() CASCADE;

DROP RULE IF EXISTS object_del ON object_objecten;
CREATE RULE object_del AS
    ON DELETE TO object_objecten DO INSTEAD  DELETE FROM objecten.object
  WHERE (object.id = old.id);

CREATE OR REPLACE VIEW bouwlaag_afw_binnendekking
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
   FROM afw_binnendekking v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     JOIN afw_binnendekking_type st ON v.soort::text = st.naam::text
  WHERE v.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW bouwlaag_bouwlagen
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.bouwlaag,
    b.bouwdeel,
    b.pand_id,
    b.datum_deleted,
    b.fotografie_id 
   FROM bouwlagen b
  WHERE b.datum_deleted = 'infinity';

DROP TRIGGER IF EXISTS bouwlagen_soft_del_cascade ON bouwlaag_bouwlagen;

CREATE OR REPLACE VIEW bouwlaag_dreiging
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
   FROM dreiging v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     JOIN dreiging_type st ON v.dreiging_type_id = st.id
  WHERE v.datum_deleted = 'infinity';

DROP TRIGGER IF EXISTS bouwlaag_dreiging_soft_del_cascade ON bouwlaag_dreiging;

CREATE OR REPLACE VIEW bouwlaag_ingang
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
   FROM ingang v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     JOIN ingang_type it ON v.ingang_type_id = it.id
  WHERE v.datum_deleted = 'infinity';

DROP TRIGGER IF EXISTS bouwlaag_ingang_soft_del_cascade ON bouwlaag_ingang;

CREATE OR REPLACE VIEW bouwlaag_label
AS SELECT l.id,
    l.geom,
    l.soort,
    l.omschrijving,
    l.bouwlaag_id,
    l.object_id,
    b.bouwlaag,
    l.rotatie,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM label l
     JOIN bouwlagen b ON l.bouwlaag_id = b.id
     JOIN label_type st ON l.soort::text = st.naam::text
  WHERE l.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW bouwlaag_opslag
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
    b.bouwlaag,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM gevaarlijkestof_opslag o
     JOIN bouwlagen b ON o.bouwlaag_id = b.id
     JOIN gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE o.datum_deleted = 'infinity';

DROP TRIGGER IF EXISTS bouwlaag_opslag_soft_del_cascade ON bouwlaag_opslag;

CREATE OR REPLACE VIEW bouwlaag_ruimten
AS SELECT v.id,
    v.geom,
    v.ruimten_type_id,
    v.omschrijving,
    v.fotografie_id,
    v.bouwlaag_id,
    b.bouwlaag,
    ''::text AS applicatie
   FROM ruimten v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
  WHERE v.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW bouwlaag_scenario_locatie
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
    b.bouwlaag,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM scenario_locatie o
     JOIN bouwlagen b ON o.bouwlaag_id = b.id
     JOIN scenario_locatie_type st ON 'Scenario locatie'::text = st.naam
  WHERE o.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW bouwlaag_sleutelkluis
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
   FROM sleutelkluis v
     JOIN ( SELECT b.bouwlaag,
            ib.id,
            ib.bouwlaag_id
           FROM ingang ib
             JOIN bouwlagen b ON ib.bouwlaag_id = b.id) part ON v.ingang_id = part.id
     JOIN sleutelkluis_type it ON v.sleutelkluis_type_id = it.id
  WHERE v.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW bouwlaag_veiligh_bouwk
AS SELECT v.id,
    v.geom,
    v.soort,
    v.fotografie_id,
    v.bouwlaag_id,
    b.bouwlaag,
    ''::text AS applicatie
   FROM veiligh_bouwk v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
  WHERE v.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW bouwlaag_veiligh_install
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
   FROM veiligh_install v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     JOIN veiligh_install_type vt ON v.veiligh_install_type_id = vt.id
  WHERE v.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_bereikbaarheid
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.obstakels,
    l.wegafzetting,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    part.typeobject
   FROM bereikbaarheid l
     JOIN object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_bgt
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.basisreg_identifier,
    b.formelenaam,
    b.bijzonderheden,
    b.pers_max,
    b.pers_nietz_max,
    b.datum_geldig_tot,
    b.datum_geldig_vanaf,
    b.bron,
    b.bron_tabel,
    b.fotografie_id,
    b.bodemgesteldheid_type_id,
    part.typeobject
   FROM object b
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE b.bron::text = 'BGT'::text AND b.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_dreiging
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
    st.size_object AS size,
    ''::text AS applicatie,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot
   FROM dreiging v
     JOIN object b ON v.object_id = b.id
     JOIN dreiging_type st ON v.dreiging_type_id = st.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.datum_deleted = 'infinity';

DROP TRIGGER IF EXISTS object_dreiging_soft_del_cascade ON object_dreiging;

CREATE OR REPLACE VIEW object_gebiedsgerichte_aanpak
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.bijzonderheden,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot
   FROM gebiedsgerichte_aanpak l
     JOIN object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_grid
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.y_as_label,
    b.x_as_label,
    b.object_id,
    b.afstand,
    b.vaknummer,
    b.scale,
    b.papersize,
    b.orientation,
    b.type,
    b.uuid,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM grid b
     JOIN object o ON b.object_id = o.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_ingang
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
    it.symbol_name,
    it.size_object AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM ingang v
     JOIN object b ON v.object_id = b.id
     JOIN ingang_type it ON v.ingang_type_id = it.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.datum_deleted = 'infinity';

DROP TRIGGER IF EXISTS object_ingang_soft_del_cascade ON object_ingang;

CREATE OR REPLACE VIEW object_isolijnen
AS SELECT l.id,
    l.geom,
    l.hoogte,
    l.omschrijving,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM isolijnen l
     LEFT JOIN object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_label
AS SELECT l.id,
    l.geom,
    l.soort,
    l.omschrijving,
    l.bouwlaag_id,
    l.object_id,
    b.formelenaam,
    l.rotatie,
    st.symbol_name,
    st.size_object AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM label l
     JOIN object b ON l.object_id = b.id
     JOIN label_type st ON l.soort::text = st.naam::text
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_objecten
AS SELECT DISTINCT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.basisreg_identifier,
    b.formelenaam,
    b.bijzonderheden,
    b.pers_max,
    b.pers_nietz_max,
    b.datum_geldig_tot,
    b.datum_geldig_vanaf,
    b.bron,
    b.bron_tabel,
    b.fotografie_id,
    b.bodemgesteldheid_type_id,
    b.min_bouwlaag,
    b.max_bouwlaag,
    part.typeobject
   FROM object b
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE b.datum_deleted = 'infinity';

DROP TRIGGER IF EXISTS objecten_soft_del_cascade ON object_objecten;

CREATE OR REPLACE VIEW object_opslag
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
    st.size_object AS size,
    st.symbol_name,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM gevaarlijkestof_opslag o
     JOIN object b ON o.object_id = b.id
     JOIN gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.datum_deleted = 'infinity';

DROP TRIGGER IF EXISTS object_opslag_soft_del_cascade ON object_opslag;

CREATE OR REPLACE VIEW object_opstelplaats
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    l.rotatie,
    st.symbol_name,
    st.size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM opstelplaats l
     JOIN object b ON l.object_id = b.id
     JOIN opstelplaats_type st ON l.soort::text = st.naam::text
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_points_of_interest
AS SELECT b.id,
    b.geom,
    b.points_of_interest_type_id,
    b.label,
    b.bijzonderheid,
    b.fotografie_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    vt.symbol_name,
    vt.size,
    ''::text AS applicatie,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM points_of_interest b
     JOIN object o ON b.object_id = o.id
     JOIN points_of_interest_type vt ON b.points_of_interest_type_id = vt.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_scenario_locatie
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
    st.size_object AS size,
    st.symbol_name,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM scenario_locatie o
     JOIN object b ON o.object_id = b.id
     JOIN scenario_locatie_type st ON 'Scenario locatie'::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.datum_deleted = 'infinity';

DROP TRIGGER IF EXISTS object_scenario_locatie_soft_del_cascade ON object_scenario_locatie;

CREATE OR REPLACE VIEW object_sectoren
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.omschrijving,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM sectoren l
     JOIN object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_sleutelkluis
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
    it.symbol_name,
    it.size_object AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM sleutelkluis v
     JOIN ingang i ON v.ingang_id = i.id
     JOIN sleutelkluis_type it ON v.sleutelkluis_type_id = it.id
     JOIN object b ON i.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_terrein
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.object_id,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM terrein b
     JOIN object o ON b.object_id = o.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW object_veiligh_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.veiligh_ruimtelijk_type_id,
    b.label,
    b.bijzonderheid,
    b.fotografie_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    vt.symbol_name,
    vt.size,
    ''::text AS applicatie,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM veiligh_ruimtelijk b
     JOIN object o ON b.object_id = o.id
     JOIN veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW schade_cirkel_calc
AS SELECT sc.id,
    sc.datum_aangemaakt,
    sc.datum_gewijzigd,
    sc.straal,
    sc.soort,
    sc.gevaarlijkestof_id,
    st_buffer(part.geom, sc.straal::double precision)::geometry(Polygon,28992) AS geom_cirkel
   FROM gevaarlijkestof_schade_cirkel sc
     LEFT JOIN ( SELECT gb.id,
            ops.geom
           FROM gevaarlijkestof gb
             LEFT JOIN gevaarlijkestof_opslag ops ON gb.opslag_id = ops.id) part ON sc.gevaarlijkestof_id = part.id
  WHERE sc.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW status_objectgegevens
AS SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    historie.status
   FROM object
     LEFT JOIN historie ON historie.id = (( SELECT h.id
           FROM historie h
          WHERE h.object_id = object.id
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1))
  WHERE object.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW stavaza_objecten
AS SELECT obj.team,
    obj.totaal,
    obj.totaal_in_gebruik,
    obj.totaal_in_concept,
    obj.totaal_in_archief,
    obj.totaal_geen_status,
    obj.totaal_prio_1,
    obj.totaal_prio_2,
    obj.totaal_prio_3,
    obj.totaal_prio_4,
    obj.totaal_zonder_prio,
    obj.prio_1_in_gebruik,
    obj.prio_2_in_gebruik,
    obj.prio_3_in_gebruik,
    obj.prio_4_in_gebruik,
    obj.prio_1_concept,
    obj.prio_2_concept,
    obj.prio_3_concept,
    obj.prio_4_concept,
    obj.team_geom
   FROM ( SELECT o.team,
            count(o.team) AS totaal,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text) AS totaal_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text) AS totaal_in_concept,
            count(o.status) FILTER (WHERE o.status::text = 'archief'::text) AS totaal_in_archief,
            sum(
                CASE
                    WHEN o.status IS NULL THEN 1
                    ELSE 0
                END) AS totaal_geen_status,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 1) AS totaal_prio_1,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 2) AS totaal_prio_2,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 3) AS totaal_prio_3,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 4) AS totaal_prio_4,
            sum(
                CASE
                    WHEN mc.prio_prod IS NULL OR mc.matrix_code::text = '999'::text THEN 1
                    ELSE 0
                END) AS totaal_zonder_prio,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 1) AS prio_1_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 2) AS prio_2_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 3) AS prio_3_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 4) AS prio_4_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 1) AS prio_1_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 2) AS prio_2_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 3) AS prio_3_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 4) AS prio_4_concept,
            o.team_geom
           FROM ( SELECT object.formelenaam,
                    object.basisreg_identifier,
                    object.geom,
                    object.id AS object_id,
                    historie.datum_aangemaakt,
                    historie.aanpassing,
                    historie.status,
                    historie.matrix_code_id,
                    tg.naam AS team,
                    tg.geom AS team_geom
                   FROM object
                     LEFT JOIN historie ON historie.id = (( SELECT h.id
                           FROM historie h
                          WHERE h.object_id = object.id
                          ORDER BY h.datum_aangemaakt DESC
                         LIMIT 1))
                     LEFT JOIN algemeen.team tg ON st_intersects(object.geom, tg.geom)
                  WHERE object.datum_deleted = 'infinity'
                  ORDER BY historie.status) o
             LEFT JOIN historie_matrix_code mc ON o.matrix_code_id = mc.id
          GROUP BY o.team, o.team_geom) obj;

CREATE OR REPLACE VIEW stavaza_status_gemeente
AS SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.status) FILTER (WHERE s.status::text = 'in gebruik'::text) AS totaal_in_gebruik,
    count(s.status) FILTER (WHERE s.status::text = 'concept'::text) AS totaal_in_concept,
    count(s.status) FILTER (WHERE s.status::text = 'archief'::text) AS totaal_in_archief,
    sum(
        CASE
            WHEN s.status IS NULL THEN 1
            ELSE 0
        END) AS totaal_geen_status,
    g.geom
   FROM status_objectgegevens s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;

CREATE OR REPLACE VIEW stavaza_update_gemeente
AS SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.conditie) FILTER (WHERE s.conditie = 'up-to-date'::text) AS up_to_date,
    count(s.conditie) FILTER (WHERE s.conditie = 'updaten binnen 3 maanden'::text) AS binnen_3_maanden,
    count(s.conditie) FILTER (WHERE s.conditie = 'updaten'::text) AS updaten,
    count(s.conditie) FILTER (WHERE s.conditie = 'nog niet gemaakt'::text) AS nog_maken,
    g.geom
   FROM stavaza_volgende_update s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;

CREATE OR REPLACE VIEW stavaza_volgende_update
AS SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    historie.datum_aangemaakt,
    object.datum_gewijzigd,
    historie.status,
    historie.aanpassing,
    historie_matrix_code.matrix_code,
    historie_matrix_code.actualisatie,
    historie.datum_aangemaakt::date + '1 year'::interval *
        CASE
            WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
            WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
            WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
            WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
            WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
            ELSE NULL::integer
        END::double precision AS volgende_update,
        CASE
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) >= now() THEN 'up-to-date'::text
            WHEN (historie.datum_aangemaakt::date + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) < now() THEN 'updaten'::text
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) IS NULL THEN 'nog niet gemaakt'::text
            ELSE 'updaten binnen 3 maanden'::text
        END AS conditie
   FROM object
     LEFT JOIN historie ON historie.id = (( SELECT h.id
           FROM historie h
          WHERE h.object_id = object.id AND h.aanpassing::text <> 'aanpassing'::text
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN historie_matrix_code ON historie.matrix_code_id = historie_matrix_code.id
  WHERE object.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_afw_binnendekking
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
    dt.symbol_name,
    dt.size
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN terrein t ON o.id = t.object_id
     JOIN afw_binnendekking d ON st_intersects(t.geom, d.geom)
     JOIN afw_binnendekking_type dt ON d.soort::text = dt.naam::text
     JOIN bouwlagen b ON d.bouwlaag_id = b.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted = 'infinity' AND d.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_bedrijfshulpverlening
AS SELECT b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.ademluchtdragend,
    b.object_id,
    o.formelenaam
   FROM object o
     JOIN bedrijfshulpverlening b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted = 'infinity' AND o.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_contactpersoon
AS SELECT b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.object_id,
    b.soort,
    o.formelenaam
   FROM object o
     JOIN contactpersoon b ON o.id = b.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted = 'infinity' AND o.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_dreiging_bouwlaag
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
    dt.size
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN terrein t ON o.id = t.object_id
     JOIN dreiging d ON st_intersects(t.geom, d.geom)
     JOIN bouwlagen b ON d.bouwlaag_id = b.id
     JOIN dreiging_type dt ON d.dreiging_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND d.datum_deleted = 'infinity' AND t.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_dreiging_ruimtelijk
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
    vt.size_object AS size
   FROM object o
     JOIN dreiging b ON o.id = b.object_id
     JOIN dreiging_type vt ON b.dreiging_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted = 'infinity' AND o.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_gevaarlijkestof_bouwlaag
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
    st.size
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN terrein t ON o.id = t.object_id
     JOIN gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN gevaarlijkestof d ON op.id = d.opslag_id
     JOIN gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
     JOIN bouwlagen b ON op.bouwlaag_id = b.id
     JOIN gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted = 'infinity' AND t.datum_deleted = 'infinity' AND d.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_gevaarlijkestof_ruimtelijk
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
    st.size_object AS size
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN gevaarlijkestof d ON op.id = d.opslag_id
     JOIN gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted = 'infinity' AND o.datum_deleted = 'infinity' AND d.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_ingang_bouwlaag
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
    dt.size
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN terrein t ON o.id = t.object_id
     JOIN ingang d ON st_intersects(t.geom, d.geom)
     JOIN bouwlagen b ON d.bouwlaag_id = b.id
     JOIN ingang_type dt ON d.ingang_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted = 'infinity' AND d.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_ingang_ruimtelijk
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
    vt.size_object AS size
   FROM object o
     JOIN ingang b ON o.id = b.object_id
     JOIN ingang_type vt ON b.ingang_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted = 'infinity' AND b.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_label_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.omschrijving,
    d.soort,
    d.rotatie,
    d.bouwlaag_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vt.size
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN terrein t ON o.id = t.object_id
     JOIN label d ON st_intersects(t.geom, d.geom)
     JOIN bouwlagen b ON d.bouwlaag_id = b.id
     JOIN label_type vt ON d.soort::text = vt.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND d.datum_deleted = 'infinity' AND t.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_label_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.rotatie,
    b.bouwlaag_id,
    b.object_id,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.size_object AS size
   FROM object o
     JOIN label b ON o.id = b.object_id
     JOIN label_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted = 'infinity' AND b.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_objectgegevens
AS SELECT o.id,
    o.formelenaam,
    o.geom,
    o.basisreg_identifier,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.bijzonderheden,
    o.pers_max,
    o.pers_nietz_max,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.bron,
    o.bron_tabel,
    o.fotografie_id,
    bg.naam AS bodemgesteldheid,
    o.min_bouwlaag,
    o.max_bouwlaag,
    gf.gebruiksfuncties,
    round(st_x(o.geom)) AS x,
    round(st_y(o.geom)) AS y,
    part.typeobject
   FROM object o
     LEFT JOIN bodemgesteldheid_type bg ON o.bodemgesteldheid_type_id = bg.id
     LEFT JOIN ( SELECT DISTINCT g.object_id,
            string_agg(gt.naam, ', '::text) AS gebruiksfuncties
           FROM gebruiksfunctie g
             JOIN gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
          GROUP BY g.object_id) gf ON o.id = gf.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime,
            historie.typeobject
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id, historie.typeobject) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_opstelplaats
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
    vt.size
   FROM object o
     JOIN opstelplaats b ON o.id = b.object_id
     JOIN opstelplaats_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted = 'infinity' AND b.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_points_of_interest
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.points_of_interest_type_id,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    b.bijzonderheid,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM object o
     JOIN points_of_interest b ON o.id = b.object_id
     JOIN points_of_interest_type vt ON b.points_of_interest_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted = 'infinity' AND b.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_scenario_bouwlaag
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
    slt.size_object AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN terrein t ON o.id = t.object_id
     JOIN scenario_locatie op ON st_intersects(t.geom, op.geom)
     JOIN scenario d ON op.id = d.scenario_locatie_id
     JOIN scenario_locatie_type slt ON 'Scenario locatie'::text = slt.naam
     LEFT JOIN scenario_type st ON d.scenario_type_id = st.id
     JOIN bouwlagen b ON op.bouwlaag_id = b.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted = 'infinity' AND t.datum_deleted = 'infinity' AND d.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_scenario_ruimtelijk
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
    slt.size_object AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN scenario_locatie op ON o.id = op.object_id
     JOIN scenario d ON op.id = d.scenario_locatie_id
     JOIN scenario_locatie_type slt ON 'Scenario locatie'::text = slt.naam
     LEFT JOIN scenario_type st ON d.scenario_type_id = st.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted = 'infinity' AND o.datum_deleted = 'infinity' AND d.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_sleutelkluis_bouwlaag
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
    dt.size
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN terrein t ON o.id = t.object_id
     JOIN sleutelkluis d ON st_intersects(t.geom, d.geom)
     JOIN ingang i ON d.ingang_id = i.id
     JOIN bouwlagen b ON i.bouwlaag_id = b.id
     JOIN sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     LEFT JOIN sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted = 'infinity' AND d.datum_deleted = 'infinity' AND i.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_sleutelkluis_ruimtelijk
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
    dt.size_object AS size
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN ingang i ON o.id = i.object_id
     JOIN sleutelkluis d ON i.id = d.ingang_id
     JOIN sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     LEFT JOIN sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted = 'infinity' AND d.datum_deleted = 'infinity' AND i.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_veiligh_install
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
    dt.size
   FROM object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN terrein t ON o.id = t.object_id
     JOIN veiligh_install d ON st_intersects(t.geom, d.geom)
     JOIN bouwlagen b ON d.bouwlaag_id = b.id
     JOIN veiligh_install_type dt ON d.veiligh_install_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted = 'infinity' AND d.datum_deleted = 'infinity';

CREATE OR REPLACE VIEW view_veiligh_ruimtelijk
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
    vt.size
   FROM object o
     JOIN veiligh_ruimtelijk b ON o.id = b.object_id
     JOIN veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted = 'infinity'
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted = 'infinity' AND b.datum_deleted = 'infinity';

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 5;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 353; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = 'v2';
UPDATE algemeen.applicatie SET datum = now();