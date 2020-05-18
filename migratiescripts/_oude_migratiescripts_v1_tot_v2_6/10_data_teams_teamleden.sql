SET ROLE oiv_admin;

SET search_path = algemeen, pg_catalog, public;

INSERT INTO team (id, naam, email, statcode) VALUES (100, 'VRZW', 'vrzw@vrzw.nl', 'VR11');

INSERT INTO teamlid (id, team_id, login, wachtwoord, naam, email) VALUES (100, 100, 'heijselaarb', '', 'Bas Heijselaar', NULL);
INSERT INTO teamlid (id, team_id, login, wachtwoord, naam, email) VALUES (101, 100, 'veendvd', '', 'Dave van der Veen', NULL);
INSERT INTO teamlid (id, team_id, login, wachtwoord, naam, email) VALUES (102, 100, 'johanzenj', '', 'Jimmy Johanzen', NULL);
INSERT INTO teamlid (id, team_id, login, wachtwoord, naam, email) VALUES (103, 100, 'atenm', '', 'Martijn Aten', NULL);
INSERT INTO teamlid (id, team_id, login, wachtwoord, naam, email) VALUES (104, 100, 'graafrd', '', 'Rens de Graaf', NULL);
INSERT INTO teamlid (id, team_id, login, wachtwoord, naam, email) VALUES (105, 100, 'molr', '', 'Robin Mol', NULL);
INSERT INTO teamlid (id, team_id, login, wachtwoord, naam, email) VALUES (106, 100, 'bakkers', '', 'Sharon Bakker', NULL);
INSERT INTO teamlid (id, team_id, login, wachtwoord, naam, email) VALUES (107, 100, 'hulstb', '', 'Bob Hulst', NULL);