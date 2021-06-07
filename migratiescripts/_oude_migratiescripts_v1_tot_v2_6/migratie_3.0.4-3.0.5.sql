SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

TRUNCATE gt_pk_metadata_table;

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_afw_binnendekking', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_bereikbaarheid', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_bouwlagen', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_dreiging_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_dreiging_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_gevaarlijkestof_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_gevaarlijkestof_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_ingang_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_ingang_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_label_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_label_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_objectgegevens', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_opstelplaats', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_pictogram_zonder_object', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_schade_cirkel_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_schade_cirkel_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_ruimten', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_sectoren', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_sleutelkluis_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_sleutelkluis_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_veiligh_install', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_veiligh_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_veiligh_bouwk', 'id', 1, 'assigned');

--ADD fotografie en gebruiksfuncties to views object
DROP VIEW object_bgt;
DROP VIEW view_objectgegevens;

ALTER TABLE object DROP COLUMN IF EXISTS bhvaanwezig;

CREATE OR REPLACE VIEW object_bgt AS 
 SELECT id,
    geom,
    datum_aangemaakt,
    datum_gewijzigd,
    basisreg_identifier,
    formelenaam,
    bijzonderheden,
    pers_max,
    pers_nietz_max,
    geovlak,
    datum_geldig_tot,
    datum_geldig_vanaf,
    bron,
    bron_tabel,
    fotografie_id,
    bodemgesteldheid_type_id
   FROM object
  WHERE bron::text = 'BGT'::text;

CREATE OR REPLACE RULE object_bgt_ins AS
    ON INSERT TO object_bgt DO INSTEAD  INSERT INTO object (geom, basisreg_identifier, formelenaam, bron, bron_tabel)  SELECT new.geom,
            b.identificatie,
            new.formelenaam,
            b.bron,
            b.bron_tbl
           FROM algemeen.bgt_extent b
          WHERE st_intersects(new.geom, ST_CURVETOLINE(b.geovlak))
         LIMIT 1
  RETURNING id,
    geom,
    datum_aangemaakt,
    datum_gewijzigd,
    basisreg_identifier,
    formelenaam,
    bijzonderheden,
    pers_max,
    pers_nietz_max,
    geovlak,
    datum_geldig_tot,
    datum_geldig_vanaf,
    bron,
    bron_tabel,
    fotografie_id,
    bodemgesteldheid_type_id;

CREATE OR REPLACE VIEW view_objectgegevens AS 
 SELECT object.id,
    object.formelenaam,
    geom,
    basisreg_identifier,
    datum_aangemaakt,
    datum_gewijzigd,
    bijzonderheden,
    pers_max,
    pers_nietz_max,
    datum_geldig_vanaf,
    datum_geldig_tot,
    bron,
    bron_tabel,
    fotografie_id,
    bg.naam AS bodemgesteldheid,
    gf.gebruiksfuncties,
    round(st_x(geom)) AS x,
    round(st_y(geom)) AS y
   FROM object
     JOIN ( SELECT object_1.formelenaam,
            object_1.id AS object_id,
            object_1.geovlak
           FROM object object_1
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object_1.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object_1.datum_geldig_vanaf <= now() OR object_1.datum_geldig_vanaf IS NULL) AND (object_1.datum_geldig_tot > now() OR object_1.datum_geldig_tot IS NULL)) o ON id = o.object_id
     LEFT JOIN bodemgesteldheid_type bg ON bodemgesteldheid_type_id = bg.id
     LEFT JOIN (SELECT DISTINCT g.object_id, STRING_AGG(gt.naam, ', ') AS gebruiksfuncties FROM gebruiksfunctie g
                                INNER JOIN gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
                                GROUP BY g.object_id) gf ON object.id = gf.object_id;

--opruimen en verwijderen waterongevallen schema
CREATE TABLE waterongevallen_backup.wo_dieptelijnen AS
SELECT d.*, di.naam AS diepte FROM waterongevallen.dieptelijnen d
LEFT JOIN waterongevallen.dieptes di ON d.diepte_id = di.id;

CREATE TABLE waterongevallen_backup.wo_dieptevlakken AS
SELECT d.*, di.naam AS diepte FROM waterongevallen.dieptevlakken d
LEFT JOIN waterongevallen.dieptes di ON d.diepte_id = di.id;

ALTER TABLE waterongevallen.dieptelijnen DROP CONSTRAINT dieptes_id_fk;
ALTER TABLE waterongevallen.dieptevlakken DROP CONSTRAINT dieptes_id_fk;

DROP TABLE waterongevallen.dieptelijnen;
DROP TABLE waterongevallen.dieptevlakken;
DROP TABLE waterongevallen.dieptes;

ALTER TABLE waterongevallen_backup.wo_historie ALTER COLUMN status TYPE text;
ALTER TABLE waterongevallen_backup.wo_historie ALTER COLUMN aanpassing TYPE text;

DROP TABLE waterongevallen.wo_historie;
DROP TABLE waterongevallen.pictogrammen;
DROP TABLE waterongevallen.pictogrammen_lijst;

CREATE TABLE waterongevallen_backup.wo_id_conversie AS
SELECT * FROM waterongevallen.wo_id_conversie;

DROP TABLE waterongevallen.wo_id_conversie;
DROP TABLE waterongevallen.wo_lokatiegegevens;

CREATE TABLE waterongevallen_backup.toetreding_water AS
SELECT * FROM waterongevallen.toetreding_water;

DROP TABLE waterongevallen.lokatie;
DROP TABLE waterongevallen.lokatiegegevens;
DROP TABLE waterongevallen.toetreding_water;

DROP SCHEMA waterongevallen;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 0;
UPDATE algemeen.applicatie SET revisie = 5;
UPDATE algemeen.applicatie SET db_versie = 305; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();