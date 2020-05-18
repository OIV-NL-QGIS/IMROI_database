SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON bluswater.alternatieve
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON bluswater.alternatieve
  FOR EACH ROW
  EXECUTE PROCEDURE objecten.set_timestamp('datum_gewijzigd');

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 10;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 2107; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();