SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON afw_binnendekking
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON bereikbaarheid
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON bedrijfshulpverlening
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON contactpersoon
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON dreiging
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON ingang
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON opstelplaats
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON ruimten
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON scenario
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON sleutelkluis
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON veiligh_bouwk
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON veiligh_install
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON veiligh_ruimtelijk
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON veilighv_org
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

UPDATE algemeen.applicatie SET sub = 9;
UPDATE algemeen.applicatie SET revisie = 96;
UPDATE algemeen.applicatie SET db_versie = 996; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();