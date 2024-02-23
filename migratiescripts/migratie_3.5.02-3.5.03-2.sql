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
UPDATE gebiedsgerichte_aanpak SET parent_deleted = sub.self_deleted FROM (SELECT id, self_deleted FROM object WHERE self_deleted != 'infinity') sub WHERE gebiedsgerichte_aanpak.object_id = sub.id;
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

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 5;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 353; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = 'v2';
UPDATE algemeen.applicatie SET datum = now();