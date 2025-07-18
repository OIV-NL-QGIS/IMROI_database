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


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 9;
UPDATE algemeen.applicatie SET db_versie = 369; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();