set role oiv_admin;

GRANT SELECT ON TABLE algemeen.team TO oiv_read;
GRANT SELECT ON TABLE algemeen.teamlid TO oiv_read;
GRANT SELECT ON TABLE algemeen.veiligheidsregio TO oiv_read;
GRANT UPDATE, INSERT, DELETE ON TABLE algemeen.veiligheidsregio TO oiv_write;

GRANT SELECT, USAGE ON SEQUENCE algemeen.team_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE algemeen.team_id_seq TO oiv_write;
GRANT SELECT ON TABLE algemeen.teamlid TO oiv_read;

GRANT SELECT ON TABLE objecten.aanwezig TO oiv_read;
GRANT UPDATE, INSERT, DELETE ON TABLE objecten.aanwezig TO oiv_write;
GRANT SELECT ON TABLE objecten.aanwezig_type TO oiv_read;
GRANT SELECT ON TABLE objecten.gevaarlijkestof TO oiv_read;
GRANT UPDATE, INSERT, DELETE ON TABLE objecten.gevaarlijkestof TO oiv_write;

GRANT SELECT ON TABLE objecten.gevaarlijkestof_vnnr TO oiv_read;
GRANT SELECT ON TABLE objecten.historie TO oiv_read;
GRANT UPDATE, INSERT, DELETE ON TABLE objecten.historie TO oiv_write;

GRANT SELECT ON TABLE objecten.object TO oiv_read;
GRANT UPDATE, INSERT, DELETE ON TABLE objecten.object TO oiv_write;

GRANT SELECT ON TABLE objecten.veiligh_bouwk TO oiv_read;
GRANT UPDATE, INSERT, DELETE ON TABLE objecten.veiligh_bouwk TO oiv_write;
GRANT SELECT ON TABLE objecten.veiligh_install TO oiv_read;
GRANT UPDATE, INSERT, DELETE ON TABLE objecten.veiligh_install TO oiv_write;
GRANT SELECT ON TABLE objecten.veiligh_ruimtelijk TO oiv_read;
GRANT UPDATE, INSERT, DELETE ON TABLE objecten.veiligh_ruimtelijk TO oiv_write;

GRANT SELECT, USAGE ON SEQUENCE objecten.aanwezig_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.aanwezig_id_seq TO oiv_write;
GRANT SELECT, USAGE ON SEQUENCE objecten.gevaarlijkestof_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.gevaarlijkestof_id_seq TO oiv_write;
GRANT SELECT, USAGE ON SEQUENCE objecten.historie_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.historie_id_seq TO oiv_write;
GRANT SELECT, USAGE ON SEQUENCE objecten.object_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.object_id_seq TO oiv_write;
GRANT UPDATE ON SEQUENCE objecten.veiligh_bouwk_id_seq TO oiv_write;
GRANT SELECT, USAGE ON SEQUENCE objecten.veiligh_install_id_seq TO oiv_read;
GRANT UPDATE ON SEQUENCE objecten.veiligh_install_id_seq TO oiv_write;