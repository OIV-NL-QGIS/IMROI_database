SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

DROP VIEW view_schade_cirkel;
CREATE OR REPLACE VIEW view_schade_cirkel AS 
 SELECT b.formelenaam, b.bouwlaag, sc.id,
    sc.datum_aangemaakt,
    sc.datum_gewijzigd,
    sc.straal,
    sc.soort_cirkel,
    scs.naam AS cirkel_type,
    sc.opslag_id,
    st_buffer(ops.geom, sc.straal::double precision) AS geom_cirkel
   FROM gevaarlijkestof_schade_cirkel sc
     LEFT JOIN gevaarlijkestof_opslag ops ON sc.opslag_id = ops.id
     LEFT JOIN gevaarlijkestof_schade_cirkel_type scs ON sc.soort_cirkel = scs.id
     INNER JOIN (SELECT o.*, bouwlagen.id AS bouwlaag_id, bouwlagen.bouwlaag, bouwlagen.bouwdeel FROM (SELECT formelenaam, object.id, geom FROM object
		LEFT JOIN historie ON historie.id = 
		((SELECT id FROM historie WHERE historie.object_id = object.id 
		ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o INNER JOIN bouwlagen ON o.id = bouwlagen.object_id) b ON ops.bouwlaag_id = b.bouwlaag_id;

ALTER TABLE object ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE object ALTER COLUMN bhvaanwezig DROP NOT NULL;
ALTER TABLE historie ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE bouwlagen ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE voorziening ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE object_labels ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE opslag ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE gevaarlijkestof ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE aanwezig ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE vlakken ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE scheiding ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE schade_cirkel ALTER COLUMN datum_aangemaakt DROP NOT NULL;
ALTER TABLE voorziening_zonder_object ALTER COLUMN datum_aangemaakt DROP NOT NULL;

CREATE TRIGGER trg_set_mutatie BEFORE UPDATE ON bouwlagen       FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_mutatie BEFORE UPDATE ON gevaarlijkestof FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_mutatie BEFORE UPDATE ON voorziening_zonder_object FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

CREATE TRIGGER trg_set_insert BEFORE INSERT ON object       FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON historie     FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON bouwlagen    FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON voorziening  FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON object_labels FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON opslag       FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON gevaarlijkestof FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON aanwezig     FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON vlakken      FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON scheiding    FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON schade_cirkel FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON voorziening_zonder_object FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
        
-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 1;
UPDATE algemeen.applicatie SET db_versie = 241; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();