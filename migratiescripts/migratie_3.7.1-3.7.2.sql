SET ROLE oiv_admin;

--Zorg dat je hiervoor alles in geoserver klaar hebt staan en hebt getest
DROP VIEW IF EXISTS objecten.view_afw_binnendekking CASCADE;
--DROP VIEW IF EXISTS objecten.view_bedrijfshulpverlening CASCADE;
DROP VIEW IF EXISTS objecten.view_bereikbaarheid CASCADE;
DROP VIEW IF EXISTS objecten.view_bouwlagen CASCADE;
--DROP VIEW IF EXISTS objecten.view_contactpersoon CASCADE;
DROP VIEW IF EXISTS objecten.view_dreiging_bouwlaag CASCADE;
DROP VIEW IF EXISTS objecten.view_dreiging_ruimtelijk CASCADE;
DROP VIEW IF EXISTS objecten.view_gebiedsgerichte_aanpak CASCADE;
DROP VIEW IF EXISTS objecten.view_gevaarlijkestof_bouwlaag CASCADE;
DROP VIEW IF EXISTS objecten.view_gevaarlijkestof_ruimtelijk CASCADE;
DROP VIEW IF EXISTS objecten.view_grid CASCADE;
DROP VIEW IF EXISTS objecten.view_ingang_bouwlaag CASCADE;
DROP VIEW IF EXISTS objecten.view_ingang_ruimtelijk CASCADE;
DROP VIEW IF EXISTS objecten.view_isolijnen CASCADE;
DROP VIEW IF EXISTS objecten.view_label_bouwlaag CASCADE;
DROP VIEW IF EXISTS objecten.view_label_ruimtelijk CASCADE;
DROP VIEW IF EXISTS objecten.view_objectgegevens CASCADE;
DROP VIEW IF EXISTS objecten.view_opstelplaats CASCADE;
DROP VIEW IF EXISTS objecten.view_points_of_interest CASCADE;
DROP VIEW IF EXISTS objecten.view_ruimten CASCADE;
DROP VIEW IF EXISTS objecten.view_scenario_bouwlaag CASCADE;
DROP VIEW IF EXISTS objecten.view_scenario_ruimtelijk CASCADE;
DROP VIEW IF EXISTS objecten.view_schade_cirkel_bouwlaag CASCADE;
DROP VIEW IF EXISTS objecten.view_schade_cirkel_ruimtelijk CASCADE;
DROP VIEW IF EXISTS objecten.view_sectoren CASCADE;
DROP VIEW IF EXISTS objecten.view_sleutelkluis_bouwlaag CASCADE;
DROP VIEW IF EXISTS objecten.view_sleutelkluis_ruimtelijk CASCADE;
DROP VIEW IF EXISTS objecten.view_terrein CASCADE;
DROP VIEW IF EXISTS objecten.view_veiligh_bouwk CASCADE;
DROP VIEW IF EXISTS objecten.view_veiligh_install CASCADE;
DROP VIEW IF EXISTS objecten.view_veiligh_ruimtelijk CASCADE;

ALTER VIEW objecten.view_afw_binnendekking_new RENAME TO view_afw_binnendekking;
--ALTER VIEW objecten.view_bedrijfshulpverlening_new RENAME TO view_bedrijfshulpverlening;
ALTER VIEW objecten.view_bereikbaarheid_new RENAME TO view_bereikbaarheid;
ALTER VIEW objecten.view_bouwlagen_new RENAME TO view_bouwlagen;
--ALTER VIEW objecten.view_contactpersoon_new RENAME TO view_contactpersoon;
ALTER VIEW objecten.view_dreiging_bouwlaag_new RENAME TO view_dreiging_bouwlaag;
ALTER VIEW objecten.view_dreiging_ruimtelijk_new RENAME TO view_dreiging_ruimtelijk;
ALTER VIEW objecten.view_gebiedsgerichte_aanpak_new RENAME TO view_gebiedsgerichte_aanpak;
ALTER VIEW objecten.view_gevaarlijkestof_bouwlaag_new RENAME TO view_gevaarlijkestof_bouwlaag;
ALTER VIEW objecten.view_gevaarlijkestof_ruimtelijk_new RENAME TO view_gevaarlijkestof_ruimtelijk;
ALTER VIEW objecten.view_grid_new RENAME TO view_grid;
ALTER VIEW objecten.view_ingang_bouwlaag_new RENAME TO view_ingang_bouwlaag;
ALTER VIEW objecten.view_ingang_ruimtelijk_new RENAME TO view_ingang_ruimtelijk;
ALTER VIEW objecten.view_isolijnen_new RENAME TO view_isolijnen;
ALTER VIEW objecten.view_label_bouwlaag_new RENAME TO view_label_bouwlaag;
ALTER VIEW objecten.view_label_ruimtelijk_new RENAME TO view_label_ruimtelijk;
ALTER VIEW objecten.view_objectgegevens_new RENAME TO view_objectgegevens;
ALTER VIEW objecten.view_opstelplaats_new RENAME TO view_opstelplaats;
ALTER VIEW objecten.view_points_of_interest_new RENAME TO view_points_of_interest;
ALTER VIEW objecten.view_ruimten_new RENAME TO view_ruimten;
ALTER VIEW objecten.view_scenario_bouwlaag_new RENAME TO view_scenario_bouwlaag;
ALTER VIEW objecten.view_scenario_ruimtelijk_new RENAME TO view_scenario_ruimtelijk;
ALTER VIEW objecten.view_schade_cirkel_bouwlaag_new RENAME TO view_schade_cirkel_bouwlaag;
ALTER VIEW objecten.view_schade_cirkel_ruimtelijk_new RENAME TO view_schade_cirkel_ruimtelijk;
ALTER VIEW objecten.view_sectoren_new RENAME TO view_sectoren;
ALTER VIEW objecten.view_sleutelkluis_bouwlaag_new RENAME TO view_sleutelkluis_bouwlaag;
ALTER VIEW objecten.view_sleutelkluis_ruimtelijk_new RENAME TO view_sleutelkluis_ruimtelijk;
ALTER VIEW objecten.view_terrein_new RENAME TO view_terrein;
ALTER VIEW objecten.view_veiligh_bouwk_new RENAME TO view_veiligh_bouwk;
ALTER VIEW objecten.view_veiligh_install_new RENAME TO view_veiligh_install;
ALTER VIEW objecten.view_veiligh_ruimtelijk_new RENAME TO view_veiligh_ruimtelijk;

--Zorg dat je hiervoor alles in geoserver klaar hebt staan en hebt getest
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_afw_binnendekking CASCADE;
--DROP MATERIALIZED VIEW IF EXISTS objecten.mview_bedrijfshulpverlening CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_bereikbaarheid CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_bouwlagen CASCADE;
--DROP MATERIALIZED VIEW IF EXISTS objecten.mview_contactpersoon CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_dreiging_bouwlaag CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_dreiging_ruimtelijk CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_gebiedsgerichte_aanpak CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_gevaarlijkestof_bouwlaag CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_gevaarlijkestof_ruimtelijk CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_grid CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_ingang_bouwlaag CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_ingang_ruimtelijk CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_isolijnen CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_label_bouwlaag CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_label_ruimtelijk CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_objectgegevens CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_opstelplaats CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_points_of_interest CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_ruimten CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_scenario_bouwlaag CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_scenario_ruimtelijk CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_schade_cirkel_bouwlaag CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_schade_cirkel_ruimtelijk CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_sectoren CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_sleutelkluis_bouwlaag CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_sleutelkluis_ruimtelijk CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_terrein CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_veiligh_bouwk CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_veiligh_install CASCADE;
DROP MATERIALIZED VIEW IF EXISTS objecten.mview_veiligh_ruimtelijk CASCADE;

ALTER MATERIALIZED VIEW objecten.mview_afw_binnendekking_new RENAME TO mview_afw_binnendekking;
ALTER MATERIALIZED VIEW objecten.mview_bedrijfshulpverlening_new RENAME TO mview_bedrijfshulpverlening;
ALTER MATERIALIZED VIEW objecten.mview_bereikbaarheid_new RENAME TO mview_bereikbaarheid;
ALTER MATERIALIZED VIEW objecten.mview_bouwlagen_new RENAME TO mview_bouwlagen;
ALTER MATERIALIZED VIEW objecten.mview_contactpersoon_new RENAME TO mview_contactpersoon;
ALTER MATERIALIZED VIEW objecten.mview_dreiging_bouwlaag_new RENAME TO mview_dreiging_bouwlaag;
ALTER MATERIALIZED VIEW objecten.mview_dreiging_ruimtelijk_new RENAME TO mview_dreiging_ruimtelijk;
ALTER MATERIALIZED VIEW objecten.mview_gebiedsgerichte_aanpak_new RENAME TO mview_gebiedsgerichte_aanpak;
ALTER MATERIALIZED VIEW objecten.mview_gevaarlijkestof_bouwlaag_new RENAME TO mview_gevaarlijkestof_bouwlaag;
ALTER MATERIALIZED VIEW objecten.mview_gevaarlijkestof_ruimtelijk_new RENAME TO mview_gevaarlijkestof_ruimtelijk;
ALTER MATERIALIZED VIEW objecten.mview_grid_new RENAME TO mview_grid;
ALTER MATERIALIZED VIEW objecten.mview_ingang_bouwlaag_new RENAME TO mview_ingang_bouwlaag;
ALTER MATERIALIZED VIEW objecten.mview_ingang_ruimtelijk_new RENAME TO mview_ingang_ruimtelijk;
ALTER MATERIALIZED VIEW objecten.mview_isolijnen_new RENAME TO mview_isolijnen;
ALTER MATERIALIZED VIEW objecten.mview_label_bouwlaag_new RENAME TO mview_label_bouwlaag;
ALTER MATERIALIZED VIEW objecten.mview_label_ruimtelijk_new RENAME TO mview_label_ruimtelijk;
ALTER MATERIALIZED VIEW objecten.mview_objectgegevens_new RENAME TO mview_objectgegevens;
ALTER MATERIALIZED VIEW objecten.mview_opstelplaats_new RENAME TO mview_opstelplaats;
ALTER MATERIALIZED VIEW objecten.mview_points_of_interest_new RENAME TO mview_points_of_interest;
ALTER MATERIALIZED VIEW objecten.mview_ruimten_new RENAME TO mview_ruimten;
ALTER MATERIALIZED VIEW objecten.mview_scenario_bouwlaag_new RENAME TO mview_scenario_bouwlaag;
ALTER MATERIALIZED VIEW objecten.mview_scenario_ruimtelijk_new RENAME TO mview_scenario_ruimtelijk;
ALTER MATERIALIZED VIEW objecten.mview_schade_cirkel_bouwlaag_new RENAME TO mview_schade_cirkel_bouwlaag;
ALTER MATERIALIZED VIEW objecten.mview_schade_cirkel_ruimtelijk_new RENAME TO mview_schade_cirkel_ruimtelijk;
ALTER MATERIALIZED VIEW objecten.mview_sectoren_new RENAME TO mview_sectoren;
ALTER MATERIALIZED VIEW objecten.mview_sleutelkluis_bouwlaag_new RENAME TO mview_sleutelkluis_bouwlaag;
ALTER MATERIALIZED VIEW objecten.mview_sleutelkluis_ruimtelijk_new RENAME TO mview_sleutelkluis_ruimtelijk;
ALTER MATERIALIZED VIEW objecten.mview_terrein_new RENAME TO mview_terrein;
ALTER MATERIALIZED VIEW objecten.mview_veiligh_bouwk_new RENAME TO mview_veiligh_bouwk;
ALTER MATERIALIZED VIEW objecten.mview_veiligh_install_new RENAME TO mview_veiligh_install;
ALTER MATERIALIZED VIEW objecten.mview_veiligh_ruimtelijk_new RENAME TO mview_veiligh_ruimtelijk;

--Indexen weer aanmaken
CREATE INDEX mview_bereikbaarheid_geom_idx ON objecten.mview_bereikbaarheid USING gist (geom);
CREATE UNIQUE INDEX mview_bereikbaarheid_gid_idx ON objecten.mview_bereikbaarheid USING btree (gid);
CREATE INDEX mview_bereikbaarheid_object_id_idx ON objecten.mview_bereikbaarheid USING btree (object_id);

CREATE INDEX mview_bouwlagen_bouwlaag_idx ON objecten.mview_bouwlagen USING btree (bouwlaag);
CREATE INDEX mview_bouwlagen_geom_idx ON objecten.mview_bouwlagen USING gist (geom);
CREATE UNIQUE INDEX mview_bouwlagen_gid_idx ON objecten.mview_bouwlagen USING btree (gid);
CREATE INDEX mview_bouwlagen_object_id_idx ON objecten.mview_bouwlagen USING btree (object_id);

CREATE INDEX mview_gebiedsgerichte_aanpak_geom_idx ON objecten.mview_gebiedsgerichte_aanpak USING gist (geom);
CREATE UNIQUE INDEX mview_gebiedsgerichte_aanpak_gid_idx ON objecten.mview_gebiedsgerichte_aanpak USING btree (gid);
CREATE INDEX mview_gebiedsgerichte_aanpak_object_id_idx ON objecten.mview_gebiedsgerichte_aanpak USING btree (object_id);

CREATE INDEX mview_grid_geom_idx ON objecten.mview_grid USING gist (geom);
CREATE UNIQUE INDEX mview_grid_gid_idx ON objecten.mview_grid USING btree (gid);
CREATE INDEX mview_grid_object_id_idx ON objecten.mview_grid USING btree (object_id);

CREATE INDEX mview_isolijnen_geom_idx ON objecten.mview_isolijnen USING gist (geom);
CREATE UNIQUE INDEX mview_isolijnen_gid_idx ON objecten.mview_isolijnen USING btree (gid);
CREATE INDEX mview_isolijnen_object_id_idx ON objecten.mview_isolijnen USING btree (object_id);

CREATE INDEX mview_ruimten_bouwlaag_id_idx ON objecten.mview_ruimten USING btree (bouwlaag_id);
CREATE INDEX mview_ruimten_bouwlaag_idx ON objecten.mview_ruimten USING btree (bouwlaag);
CREATE INDEX mview_ruimten_geom_idx ON objecten.mview_ruimten USING gist (geom);
CREATE UNIQUE INDEX mview_ruimten_gid_idx ON objecten.mview_ruimten USING btree (gid);
CREATE INDEX mview_ruimten_object_id_idx ON objecten.mview_ruimten USING btree (object_id);

CREATE INDEX mview_schade_cirkel_bouwlaag_bouwlaag_idx ON objecten.mview_schade_cirkel_bouwlaag USING btree (bouwlaag);
CREATE INDEX mview_schade_cirkel_bouwlaag_geom_idx ON objecten.mview_schade_cirkel_bouwlaag USING gist (geom);
CREATE UNIQUE INDEX mview_schade_cirkel_bouwlaag_gid_idx ON objecten.mview_schade_cirkel_bouwlaag USING btree (gid);
CREATE INDEX mview_schade_cirkel_bouwlaag_id_bouwlaag_idx ON objecten.mview_schade_cirkel_bouwlaag USING btree (bouwlaag_id);
CREATE INDEX mview_schade_cirkel_bouwlaag_object_id_idx ON objecten.mview_schade_cirkel_bouwlaag USING btree (object_id);

CREATE INDEX mview_schade_cirkel_ruimtelijk_geom_idx ON objecten.mview_schade_cirkel_ruimtelijk USING gist (geom);
CREATE UNIQUE INDEX mview_schade_cirkel_ruimtelijk_gid_idx ON objecten.mview_schade_cirkel_ruimtelijk USING btree (gid);
CREATE INDEX mview_schade_cirkel_ruimtelijk_object_id_idx ON objecten.mview_schade_cirkel_ruimtelijk USING btree (object_id);

CREATE INDEX mview_sectoren_geom_idx ON objecten.mview_sectoren USING gist (geom);
CREATE UNIQUE INDEX mview_sectoren_gid_idx ON objecten.mview_sectoren USING btree (gid);
CREATE INDEX mview_sectoren_object_id_idx ON objecten.mview_sectoren USING btree (object_id);

CREATE INDEX mview_veiligh_bouwk_bouwlaag_id_idx ON objecten.mview_veiligh_bouwk USING btree (bouwlaag_id);
CREATE INDEX mview_veiligh_bouwk_bouwlaag_idx ON objecten.mview_veiligh_bouwk USING btree (bouwlaag);
CREATE INDEX mview_veiligh_bouwk_geom_idx ON objecten.mview_veiligh_bouwk USING gist (geom);
CREATE UNIQUE INDEX mview_veiligh_bouwk_gid_idx ON objecten.mview_veiligh_bouwk USING btree (gid);
CREATE INDEX mview_veiligh_bouwk_object_id_idx ON objecten.mview_veiligh_bouwk USING btree (object_id);

CREATE INDEX mview_terrein_geom_idx ON objecten.mview_terrein USING gist (geom);
CREATE UNIQUE INDEX mview_terrein_gid_idx ON objecten.mview_terrein USING btree (gid);
CREATE INDEX mview_terrein_object_id_idx ON objecten.mview_terrein USING btree (object_id);

CREATE INDEX mview_label_ruimtelijk_geom_idx ON objecten.mview_label_ruimtelijk USING gist (geom);
CREATE UNIQUE INDEX mview_label_ruimtelijk_gid_idx ON objecten.mview_label_ruimtelijk USING btree (gid);
CREATE INDEX mview_label_ruimtelijk_object_id_idx ON objecten.mview_label_ruimtelijk USING btree (object_id);

CREATE INDEX mview_label_bouwlaag_bouwlaag_idx ON objecten.mview_label_bouwlaag USING btree (bouwlaag);
CREATE INDEX mview_label_bouwlaag_geom_idx ON objecten.mview_label_bouwlaag USING gist (geom);
CREATE UNIQUE INDEX mview_label_bouwlaag_gid_idx ON objecten.mview_label_bouwlaag USING btree (gid);
CREATE INDEX mview_label_bouwlaag_id_bouwlaag_idx ON objecten.mview_label_bouwlaag USING btree (bouwlaag_id);
CREATE INDEX mview_label_bouwlaag_object_id_idx ON objecten.mview_label_bouwlaag USING btree (object_id);

CREATE INDEX mview_afw_binnendekking_bouwlaag_id_idx ON objecten.mview_afw_binnendekking USING btree (bouwlaag_id);
CREATE INDEX mview_afw_binnendekking_bouwlaag_idx ON objecten.mview_afw_binnendekking USING btree (bouwlaag);
CREATE INDEX mview_afw_binnendekking_geom_idx ON objecten.mview_afw_binnendekking USING gist (geom);
CREATE UNIQUE INDEX mview_afw_binnendekking_gid_idx ON objecten.mview_afw_binnendekking USING btree (gid);
CREATE INDEX mview_afw_binnendekking_object_id_idx ON objecten.mview_afw_binnendekking USING btree (object_id);

CREATE INDEX mview_dreiging_bouwlaag_bouwlaag_idx ON objecten.mview_dreiging_bouwlaag USING btree (bouwlaag);
CREATE INDEX mview_dreiging_bouwlaag_geom_idx ON objecten.mview_dreiging_bouwlaag USING gist (geom);
CREATE UNIQUE INDEX mview_dreiging_bouwlaag_gid_idx ON objecten.mview_dreiging_bouwlaag USING btree (gid);
CREATE INDEX mview_dreiging_bouwlaag_id_bouwlaag_idx ON objecten.mview_dreiging_bouwlaag USING btree (bouwlaag_id);
CREATE INDEX mview_dreiging_bouwlaag_object_id_idx ON objecten.mview_dreiging_bouwlaag USING btree (object_id);

CREATE INDEX mview_dreiging_ruimtelijk_geom_idx ON objecten.mview_dreiging_ruimtelijk USING gist (geom);
CREATE UNIQUE INDEX mview_dreiging_ruimtelijk_gid_idx ON objecten.mview_dreiging_ruimtelijk USING btree (gid);
CREATE INDEX mview_dreiging_ruimtelijk_object_id_idx ON objecten.mview_dreiging_ruimtelijk USING btree (object_id);

CREATE INDEX mview_gevaarlijkestof_bouwlaag_bouwlaag_idx ON objecten.mview_gevaarlijkestof_bouwlaag USING btree (bouwlaag);
CREATE INDEX mview_gevaarlijkestof_bouwlaag_geom_idx ON objecten.mview_gevaarlijkestof_bouwlaag USING gist (geom);
CREATE UNIQUE INDEX mview_gevaarlijkestof_bouwlaag_gid_idx ON objecten.mview_gevaarlijkestof_bouwlaag USING btree (gid);
CREATE INDEX mview_gevaarlijkestof_bouwlaag_id_bouwlaag_idx ON objecten.mview_gevaarlijkestof_bouwlaag USING btree (bouwlaag_id);
CREATE INDEX mview_gevaarlijkestof_bouwlaag_object_id_idx ON objecten.mview_gevaarlijkestof_bouwlaag USING btree (object_id);

CREATE INDEX mview_gevaarlijkestof_ruimtelijk_geom_idx ON objecten.mview_gevaarlijkestof_ruimtelijk USING gist (geom);
CREATE UNIQUE INDEX mview_gevaarlijkestof_ruimtelijk_gid_idx ON objecten.mview_gevaarlijkestof_ruimtelijk USING btree (gid);
CREATE INDEX mview_gevaarlijkestof_ruimtelijk_object_id_idx ON objecten.mview_gevaarlijkestof_ruimtelijk USING btree (object_id);

CREATE INDEX mview_ingang_bouwlaag_bouwlaag_idx ON objecten.mview_ingang_bouwlaag USING btree (bouwlaag);
CREATE INDEX mview_ingang_bouwlaag_geom_idx ON objecten.mview_ingang_bouwlaag USING gist (geom);
CREATE UNIQUE INDEX mview_ingang_bouwlaag_gid_idx ON objecten.mview_ingang_bouwlaag USING btree (gid);
CREATE INDEX mview_ingang_bouwlaag_id_bouwlaag_idx ON objecten.mview_ingang_bouwlaag USING btree (bouwlaag_id);
CREATE INDEX mview_ingang_bouwlaag_object_id_idx ON objecten.mview_ingang_bouwlaag USING btree (object_id);

CREATE INDEX mview_ingang_ruimtelijk_geom_idx ON objecten.mview_ingang_ruimtelijk USING gist (geom);
CREATE UNIQUE INDEX mview_ingang_ruimtelijk_gid_idx ON objecten.mview_ingang_ruimtelijk USING btree (gid);
CREATE INDEX mview_ingang_ruimtelijk_object_id_idx ON objecten.mview_ingang_ruimtelijk USING btree (object_id);

CREATE INDEX mview_opstelplaats_geom_idx ON objecten.mview_opstelplaats USING gist (geom);
CREATE UNIQUE INDEX mview_opstelplaats_gid_idx ON objecten.mview_opstelplaats USING btree (gid);
CREATE INDEX mview_opstelplaats_object_id_idx ON objecten.mview_opstelplaats USING btree (object_id);

CREATE INDEX mview_points_of_interest_geom_idx ON objecten.mview_points_of_interest USING gist (geom);
CREATE UNIQUE INDEX mview_points_of_interest_gid_idx ON objecten.mview_points_of_interest USING btree (gid);
CREATE INDEX mview_points_of_interest_object_id_idx ON objecten.mview_points_of_interest USING btree (object_id);

CREATE INDEX mview_scenario_bouwlaag_bouwlaag_idx ON objecten.mview_scenario_bouwlaag USING btree (bouwlaag);
CREATE INDEX mview_scenario_bouwlaag_geom_idx ON objecten.mview_scenario_bouwlaag USING gist (geom);
CREATE UNIQUE INDEX mview_scenario_bouwlaag_gid_idx ON objecten.mview_scenario_bouwlaag USING btree (gid);
CREATE INDEX mview_scenario_bouwlaag_id_bouwlaag_idx ON objecten.mview_scenario_bouwlaag USING btree (bouwlaag_id);
CREATE INDEX mview_scenario_bouwlaag_object_id_idx ON objecten.mview_scenario_bouwlaag USING btree (object_id);

CREATE INDEX mview_scenario_ruimtelijk_geom_idx ON objecten.mview_scenario_ruimtelijk USING gist (geom);
CREATE UNIQUE INDEX mview_scenario_ruimtelijk_gid_idx ON objecten.mview_scenario_ruimtelijk USING btree (gid);
CREATE INDEX mview_scenario_ruimtelijk_object_id_idx ON objecten.mview_scenario_ruimtelijk USING btree (object_id);

CREATE INDEX mview_sleutelkluis_bouwlaag_bouwlaag_idx ON objecten.mview_sleutelkluis_bouwlaag USING btree (bouwlaag);
CREATE INDEX mview_sleutelkluis_bouwlaag_geom_idx ON objecten.mview_sleutelkluis_bouwlaag USING gist (geom);
CREATE UNIQUE INDEX mview_sleutelkluis_bouwlaag_gid_idx ON objecten.mview_sleutelkluis_bouwlaag USING btree (gid);
CREATE INDEX mview_sleutelkluis_bouwlaag_id_bouwlaag_idx ON objecten.mview_sleutelkluis_bouwlaag USING btree (bouwlaag_id);
CREATE INDEX mview_sleutelkluis_bouwlaag_object_id_idx ON objecten.mview_sleutelkluis_bouwlaag USING btree (object_id);

CREATE INDEX mview_sleutelkluis_ruimtelijk_geom_idx ON objecten.mview_sleutelkluis_ruimtelijk USING gist (geom);
CREATE UNIQUE INDEX mview_sleutelkluis_ruimtelijk_gid_idx ON objecten.mview_sleutelkluis_ruimtelijk USING btree (gid);
CREATE INDEX mview_sleutelkluis_ruimtelijk_object_id_idx ON objecten.mview_sleutelkluis_ruimtelijk USING btree (object_id);

CREATE INDEX mview_veiligh_install_bouwlaag_id_idx ON objecten.mview_veiligh_install USING btree (bouwlaag_id);
CREATE INDEX mview_veiligh_install_bouwlaag_idx ON objecten.mview_veiligh_install USING btree (bouwlaag);
CREATE INDEX mview_veiligh_install_geom_idx ON objecten.mview_veiligh_install USING gist (geom);
CREATE UNIQUE INDEX mview_veiligh_install_gid_idx ON objecten.mview_veiligh_install USING btree (gid);
CREATE INDEX mview_veiligh_install_object_id_idx ON objecten.mview_veiligh_install USING btree (object_id);

CREATE INDEX mview_veiligh_ruimtelijk_geom_idx ON objecten.mview_veiligh_ruimtelijk USING gist (geom);
CREATE UNIQUE INDEX mview_veiligh_ruimtelijk_gid_idx ON objecten.mview_veiligh_ruimtelijk USING btree (gid);
CREATE INDEX mview_veiligh_ruimtelijk_object_id_idx ON objecten.mview_veiligh_ruimtelijk USING btree (object_id);

CREATE INDEX mview_objectgegevens_basis_reg_idx ON objecten.mview_objectgegevens USING btree (basisreg_identifier);
CREATE INDEX mview_objectgegevens_geom_idx ON objecten.mview_objectgegevens USING gist (geom);
CREATE UNIQUE INDEX mview_objectgegevens_gid_idx ON objecten.mview_objectgegevens USING btree (gid);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 7;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 3702; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();