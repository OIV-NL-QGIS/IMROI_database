SET role oiv_admin;
SET search_path = mobiel, pg_catalog, public;

--aantal nieuwe symbolen voor industrie
INSERT INTO objecten.opstelplaats_type (id, naam, symbol_name, size) VALUES (21, 'Blus unit', 'blus_unit', 8);
INSERT INTO objecten.opstelplaats_type (id, naam, symbol_name, size) VALUES (22, 'Dompelpomp unit', 'dpu', 8);
INSERT INTO objecten.opstelplaats_type (id, naam, symbol_name, size) VALUES (23, 'Foambooster', 'foam_booster2', 8);
INSERT INTO objecten.opstelplaats_type (id, naam, symbol_name, size) VALUES (25, 'KRVE', 'krve', 8);
INSERT INTO objecten.opstelplaats_type (id, naam, symbol_name, size) VALUES (26, 'Schuim trailer', 'sv_trailer', 8);
INSERT INTO objecten.opstelplaats_type (id, naam, symbol_name, size) VALUES (27, 'UGV', 'ugv', 8);

UPDATE objecten.label_type SET symbol_name = naam;

ALTER TABLE objecten.object ADD COLUMN min_bouwlaag INTEGER;
ALTER TABLE objecten.object ADD COLUMN max_bouwlaag INTEGER;

DROP VIEW objecten.object_objecten;
CREATE OR REPLACE VIEW objecten.object_objecten
AS SELECT object.id,
    object.geom,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.basisreg_identifier,
    object.formelenaam,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    object.datum_geldig_tot,
    object.datum_geldig_vanaf,
    object.bron,
    object.bron_tabel,
    object.fotografie_id,
    object.bodemgesteldheid_type_id,
    object.min_bouwlaag,
    object.max_bouwlaag,
    o.typeobject
   FROM objecten.object
     JOIN ( SELECT object_1.id,
            historie.typeobject
           FROM objecten.object object_1
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object_1.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON object.id = o.id;

CREATE RULE object_del AS
    ON DELETE TO objecten.object_objecten DO INSTEAD  DELETE FROM objecten.object
  WHERE (object.id = old.id);

CREATE RULE object_ins AS
    ON INSERT TO objecten.object_objecten DO INSTEAD  INSERT INTO objecten.object (geom, basisreg_identifier, formelenaam, bron, bron_tabel)
  VALUES (new.geom, new.basisreg_identifier, new.formelenaam, new.bron, new.bron_tabel)
  RETURNING object.id,
    object.geom,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.basisreg_identifier,
    object.formelenaam,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    object.datum_geldig_tot,
    object.datum_geldig_vanaf,
    object.bron,
    object.bron_tabel,
    object.fotografie_id,
    object.bodemgesteldheid_type_id,
    object.min_bouwlaag,
    object.max_bouwlaag,
    ( SELECT o.typeobject
           FROM objecten.historie o
          WHERE (o.object_id = object.id)
         LIMIT 1) AS typeobject;

CREATE RULE object_upd AS
    ON UPDATE TO objecten.object_objecten DO INSTEAD  UPDATE objecten.object SET geom = new.geom, basisreg_identifier = new.basisreg_identifier, formelenaam = new.formelenaam, pers_max = new.pers_max, pers_nietz_max = new.pers_nietz_max, datum_geldig_tot = new.datum_geldig_tot, datum_geldig_vanaf = new.datum_geldig_vanaf,
                bron = new.bron, bron_tabel = new.bron_tabel, fotografie_id = new.fotografie_id, bodemgesteldheid_type_id = new.bodemgesteldheid_type_id, bijzonderheden = new.bijzonderheden, min_bouwlaag = new.min_bouwlaag, max_bouwlaag = new.max_bouwlaag
  WHERE (object.id = new.id);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 337; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();