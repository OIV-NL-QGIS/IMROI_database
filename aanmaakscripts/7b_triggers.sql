SET ROLE oiv_admin;

SET search_path = objecten;

CREATE OR REPLACE FUNCTION set_timestamp()
  RETURNS trigger AS
$BODY$
BEGIN
   NEW := NEW #= hstore(TG_ARGV[0], 'now()');
   RETURN NEW;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
GRANT EXECUTE ON FUNCTION set_timestamp() TO public;
GRANT EXECUTE ON FUNCTION set_timestamp() TO oiv_write;

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON object
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON aanwezig
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON gevaarlijkestof_opslag
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON historie
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON label
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON bouwlagen
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON gevaarlijkestof
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON pictogram_zonder_object
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON gevaarlijkestof_schade_cirkel
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON veilighv_org
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON opstelplaats
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON scenario
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON bedrijfshulpverlening
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON contactpersoon
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON bereikbaarheid
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON veiligh_ruimtelijk
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON veiligh_install
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON veiligh_bouwk
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON ruimten
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON ingang
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON dreiging
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
 
CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON sleutelkluis
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON afw_binnendekking
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON afw_binnendekking
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON bereikbaarheid
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON bedrijfshulpverlening
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON contactpersoon
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON dreiging
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON ingang
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON opstelplaats
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON ruimten
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON scenario
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON sectoren
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON sleutelkluis
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON veiligh_bouwk
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON veiligh_install
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON veiligh_ruimtelijk
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON veilighv_org
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert 
  BEFORE INSERT
  ON object
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON historie
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON bouwlagen
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON label
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON gevaarlijkestof_opslag
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON gevaarlijkestof
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON aanwezig
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON gevaarlijkestof_schade_cirkel
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON pictogram_zonder_object
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON sectoren
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
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

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON gebruiksfunctie
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON gebruiksfunctie
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON beheersmaatregelen
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON beheersmaatregelen
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON isolijnen
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON isolijnen
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON terrein
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON terrein
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON grid
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON grid
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');