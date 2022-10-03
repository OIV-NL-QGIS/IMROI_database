SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TABLE algemeen.styles_symbols_type
(
  naam TEXT PRIMARY KEY,
  size INTEGER,
  symbol_name TEXT
);

INSERT INTO algemeen.styles_symbols_type VALUES ('Dekkingsprobleem DMO', 25, 'dekkingsprobleem_dmo');
INSERT INTO algemeen.styles_symbols_type VALUES ('Dekkingsprobleem TMO', 25, 'dekkingsprobleem_tmo');

CREATE OR REPLACE VIEW bouwlaag_afw_binnendekking AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.soort,
    v.rotatie,
    v.label,
    v.handelingsaanwijzing,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    st.size,
    st.symbol_name
   FROM afw_binnendekking v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     INNER JOIN algemeen.styles_symbols_type st ON v.soort::TEXT = st.naam;

CREATE OR REPLACE RULE afw_binnendekking_del AS
    ON DELETE TO bouwlaag_afw_binnendekking DO INSTEAD  DELETE FROM afw_binnendekking
  WHERE afw_binnendekking.id = old.id;

CREATE OR REPLACE RULE afw_binnendekking_ins AS
    ON INSERT TO bouwlaag_afw_binnendekking DO INSTEAD  INSERT INTO afw_binnendekking (geom, soort, label, rotatie, handelingsaanwijzing, bouwlaag_id)
  VALUES (new.geom, new.soort, new.label, new.rotatie, new.handelingsaanwijzing, new.bouwlaag_id)
  RETURNING afw_binnendekking.id,
    afw_binnendekking.geom,
    afw_binnendekking.datum_aangemaakt,
    afw_binnendekking.datum_gewijzigd,
    afw_binnendekking.soort,
    afw_binnendekking.rotatie,
    afw_binnendekking.label,
    afw_binnendekking.handelingsaanwijzing,
    afw_binnendekking.bouwlaag_id,
    afw_binnendekking.object_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE afw_binnendekking.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT size FROM algemeen.styles_symbols_type WHERE afw_binnendekking.soort::TEXT = algemeen.styles_symbols_type.naam),
    (SELECT symbol_name FROM algemeen.styles_symbols_type WHERE afw_binnendekking.soort::TEXT = algemeen.styles_symbols_type.naam);

CREATE OR REPLACE RULE afw_binnendekking_bouwlaag_upd AS
    ON UPDATE TO bouwlaag_afw_binnendekking DO INSTEAD  UPDATE afw_binnendekking SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, handelingsaanwijzing = new.handelingsaanwijzing, bouwlaag_id = new.bouwlaag_id
        WHERE afw_binnendekking.id = new.id;

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_afw_binnendekking', 'id', 1, 'assigned');

ALTER TABLE veiligh_install_type ADD COLUMN size INTEGER;
ALTER TABLE veiligh_install_type DROP COLUMN categorie;

UPDATE veiligh_install_type SET size = 4;

DROP VIEW bouwlaag_veiligh_install;
CREATE OR REPLACE VIEW bouwlaag_veiligh_install AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.veiligh_install_type_id,
    v.label,
    v.bouwlaag_id,
    v.rotatie,
    v.fotografie_id,
    b.bouwlaag,
    vt.size,
    vt.symbol_name
   FROM veiligh_install v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     INNER JOIN veiligh_install_type vt ON v.veiligh_install_type_id = vt.id;

CREATE OR REPLACE RULE veiligh_install_del AS
    ON DELETE TO bouwlaag_veiligh_install DO INSTEAD  DELETE FROM veiligh_install
  WHERE veiligh_install.id = old.id;

CREATE OR REPLACE RULE veiligh_install_ins AS
    ON INSERT TO bouwlaag_veiligh_install DO INSTEAD  INSERT INTO veiligh_install (geom, veiligh_install_type_id, label, rotatie, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.veiligh_install_type_id, new.label, new.rotatie, new.bouwlaag_id, new.fotografie_id)
  RETURNING veiligh_install.id,
    veiligh_install.geom,
    veiligh_install.datum_aangemaakt,
    veiligh_install.datum_gewijzigd,
    veiligh_install.veiligh_install_type_id,
    veiligh_install.label,
    veiligh_install.bouwlaag_id,
    veiligh_install.rotatie,
    veiligh_install.fotografie_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE veiligh_install.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT size FROM veiligh_install_type WHERE veiligh_install.veiligh_install_type_id = veiligh_install_type.id),
    (SELECT symbol_name FROM veiligh_install_type WHERE veiligh_install.veiligh_install_type_id = veiligh_install_type.id);    

CREATE OR REPLACE RULE veiligh_install_upd AS
    ON UPDATE TO bouwlaag_veiligh_install DO INSTEAD  UPDATE veiligh_install SET geom = new.geom, veiligh_install_type_id = new.veiligh_install_type_id, bouwlaag_id = new.bouwlaag_id, label = new.label, rotatie = new.rotatie, fotografie_id = new.fotografie_id
  WHERE veiligh_install.id = new.id;

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_veiligh_install', 'id', 1, 'assigned');

ALTER TABLE ingang_type ADD COLUMN size INTEGER;
UPDATE ingang_type SET size = 9 WHERE id IN (32, 47);
UPDATE ingang_type SET size = 3 WHERE id IN (35, 165);
UPDATE ingang_type SET size = 5 WHERE id IN (153, 173, 174, 1011);
UPDATE ingang_type SET size = 4 WHERE id IN (1012, 1013);

DROP VIEW bouwlaag_ingang;
CREATE OR REPLACE VIEW bouwlaag_ingang AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.ingang_type_id,
    v.rotatie,
    v.label,
    v.belemmering,
    v.voorzieningen,
    v.bouwlaag_id,
    v.object_id,
    v.fotografie_id,
    b.bouwlaag,
    it.symbol_name,
    it.size
   FROM ingang v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     INNER JOIN ingang_type it ON v.ingang_type_id = it.id ;

CREATE OR REPLACE RULE ingang_del AS
    ON DELETE TO bouwlaag_ingang DO INSTEAD  DELETE FROM ingang
  WHERE ingang.id = old.id;

CREATE OR REPLACE RULE ingang_ins AS
    ON INSERT TO bouwlaag_ingang DO INSTEAD  INSERT INTO ingang (geom, ingang_type_id, label, rotatie, belemmering, voorzieningen, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.ingang_type_id, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.bouwlaag_id, new.fotografie_id)
  RETURNING ingang.id,
    ingang.geom,
    ingang.datum_aangemaakt,
    ingang.datum_gewijzigd,
    ingang.ingang_type_id,
    ingang.rotatie,
    ingang.label,
    ingang.belemmering,
    ingang.voorzieningen,
    ingang.bouwlaag_id,
    ingang.object_id,
    ingang.fotografie_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE ingang.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT symbol_name FROM ingang_type WHERE ingang.ingang_type_id = ingang_type.id),
    (SELECT size FROM ingang_type WHERE ingang.ingang_type_id = ingang_type.id);

CREATE OR REPLACE RULE ingang_upd AS
    ON UPDATE TO bouwlaag_ingang DO INSTEAD  UPDATE ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE ingang.id = new.id;

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_ingang', 'id', 1, 'assigned');

ALTER TABLE sleutelkluis_type ADD COLUMN symbol_name TEXT;
ALTER TABLE sleutelkluis_type ADD COLUMN size INTEGER;
UPDATE sleutelkluis_type SET symbol_name = 'sleutelbuis', size = 4 WHERE id = 1;
UPDATE sleutelkluis_type SET symbol_name = 'sleutelkluis', size = 4 WHERE id = 148;
UPDATE sleutelkluis_type SET symbol_name = 'sleutelkluis_havenbedrijf', size = 4 WHERE id = 10;

DROP VIEW bouwlaag_sleutelkluis;
CREATE OR REPLACE VIEW bouwlaag_sleutelkluis AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.sleutelkluis_type_id,
    v.rotatie,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.ingang_id,
    v.fotografie_id,
    part.bouwlaag,
    it.symbol_name,
    it.size
   FROM sleutelkluis v
     JOIN ( SELECT b.bouwlaag, ib.id FROM ingang ib JOIN bouwlagen b ON ib.bouwlaag_id = b.id) part ON v.ingang_id = part.id
     INNER JOIN sleutelkluis_type it ON v.sleutelkluis_type_id = it.id;

CREATE OR REPLACE RULE sleutelkluis_del AS
    ON DELETE TO bouwlaag_sleutelkluis DO INSTEAD  DELETE FROM sleutelkluis
  WHERE sleutelkluis.id = old.id;

CREATE OR REPLACE RULE sleutelkluis_ins AS
    ON INSERT TO bouwlaag_sleutelkluis DO INSTEAD  INSERT INTO sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, fotografie_id)
  VALUES (new.geom, new.sleutelkluis_type_id, new.label, new.rotatie, new.aanduiding_locatie, new.sleuteldoel_type_id, new.ingang_id, new.fotografie_id)
  RETURNING sleutelkluis.id,
    sleutelkluis.geom,
    sleutelkluis.datum_aangemaakt,
    sleutelkluis.datum_gewijzigd,
    sleutelkluis.sleutelkluis_type_id,
    sleutelkluis.rotatie,
    sleutelkluis.label,
    sleutelkluis.aanduiding_locatie,
    sleutelkluis.sleuteldoel_type_id,
    sleutelkluis.ingang_id,
    sleutelkluis.fotografie_id,
    (SELECT bouwlaag FROM bouwlagen b INNER JOIN ingang i ON b.id = i.bouwlaag_id INNER JOIN sleutelkluis s ON i.id = s.ingang_id WHERE i.id = sleutelkluis.ingang_id) AS bouwlaag,
    (SELECT symbol_name FROM sleutelkluis_type WHERE sleutelkluis.sleutelkluis_type_id = sleutelkluis_type.id),
    (SELECT size FROM sleutelkluis_type WHERE sleutelkluis.sleutelkluis_type_id = sleutelkluis_type.id);

CREATE OR REPLACE RULE sleutelkluis_upd AS
    ON UPDATE TO bouwlaag_sleutelkluis DO INSTEAD  UPDATE sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, sleuteldoel_type_id = new.sleuteldoel_type_id, ingang_id = new.ingang_id, fotografie_id = new.fotografie_id
  WHERE sleutelkluis.id = new.id;

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_sleutelkluis', 'id', 1, 'assigned');

INSERT INTO algemeen.styles_symbols_type VALUES ('Opslag stoffen', 3, 'opslag_stoffen');

DROP VIEW bouwlaag_opslag;
CREATE OR REPLACE VIEW bouwlaag_opslag AS 
 SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
    b.bouwlaag,
    st.symbol_name,
    st.size
   FROM gevaarlijkestof_opslag o
     JOIN bouwlagen b ON o.bouwlaag_id = b.id
     INNER JOIN algemeen.styles_symbols_type st ON 'Opslag stoffen' = st.naam;

CREATE OR REPLACE RULE opslag_del AS
    ON DELETE TO bouwlaag_opslag DO INSTEAD  DELETE FROM gevaarlijkestof_opslag
  WHERE gevaarlijkestof_opslag.id = old.id;

CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_opslag DO INSTEAD  INSERT INTO gevaarlijkestof_opslag (geom, locatie, bouwlaag_id, fotografie_id, rotatie)
  VALUES (new.geom, new.locatie, new.bouwlaag_id, new.fotografie_id, new.rotatie)
  RETURNING gevaarlijkestof_opslag.id,
    gevaarlijkestof_opslag.geom,
    gevaarlijkestof_opslag.datum_aangemaakt,
    gevaarlijkestof_opslag.datum_gewijzigd,
    gevaarlijkestof_opslag.locatie,
    gevaarlijkestof_opslag.bouwlaag_id,
    gevaarlijkestof_opslag.object_id,
    gevaarlijkestof_opslag.fotografie_id,
    gevaarlijkestof_opslag.rotatie,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE gevaarlijkestof_opslag.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT symbol_name FROM algemeen.styles_symbols_type WHERE naam = 'Opslag stoffen'),
    (SELECT size FROM algemeen.styles_symbols_type WHERE naam = 'Opslag stoffen');

CREATE OR REPLACE RULE opslag_upd AS
    ON UPDATE TO bouwlaag_opslag DO INSTEAD  UPDATE gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE gevaarlijkestof_opslag.id = new.id;

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_opslag', 'id', 1, 'assigned');

ALTER TABLE dreiging_type DROP COLUMN omschrijving;
ALTER TABLE dreiging_type ADD COLUMN size INTEGER;
UPDATE dreiging_type SET size = 4;

DROP VIEW bouwlaag_dreiging;
CREATE OR REPLACE VIEW bouwlaag_dreiging AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.dreiging_type_id,
    v.rotatie,
    v.label,
    v.bouwlaag_id,
    v.object_id,
    v.fotografie_id,
    b.bouwlaag,
    st.symbol_name,
    st.size
   FROM dreiging v JOIN bouwlagen b ON v.bouwlaag_id = b.id
   INNER JOIN dreiging_type st ON v.dreiging_type_id = st.id;

CREATE OR REPLACE RULE dreiging_del AS
    ON DELETE TO bouwlaag_dreiging DO INSTEAD  DELETE FROM dreiging
  WHERE dreiging.id = old.id;

CREATE OR REPLACE RULE dreiging_ins AS
    ON INSERT TO bouwlaag_dreiging DO INSTEAD  INSERT INTO dreiging (geom, dreiging_type_id, label, rotatie, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.dreiging_type_id, new.label, new.rotatie, new.bouwlaag_id, new.fotografie_id)
  RETURNING dreiging.id,
    dreiging.geom,
    dreiging.datum_aangemaakt,
    dreiging.datum_gewijzigd,
    dreiging.dreiging_type_id,
    dreiging.rotatie,
    dreiging.label,
    dreiging.bouwlaag_id,
    dreiging.object_id,
    dreiging.fotografie_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE dreiging.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT symbol_name FROM dreiging_type st WHERE id = dreiging.dreiging_type_id),
    (SELECT size FROM dreiging_type st WHERE id = dreiging.dreiging_type_id);

CREATE OR REPLACE RULE dreiging_upd AS
    ON UPDATE TO bouwlaag_dreiging DO INSTEAD  UPDATE dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE dreiging.id = new.id;

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_dreiging', 'id', 1, 'assigned');

INSERT INTO algemeen.styles_symbols_type VALUES ('Algemeen', 2, '');
INSERT INTO algemeen.styles_symbols_type VALUES ('Voorzichtig', 2, '');
INSERT INTO algemeen.styles_symbols_type VALUES ('Waarschuwing', 2, '');
INSERT INTO algemeen.styles_symbols_type VALUES ('Gevaar', 2, '');
INSERT INTO algemeen.styles_symbols_type VALUES ('calamiteitendoorgang', 2, '');
INSERT INTO algemeen.styles_symbols_type VALUES ('publieke ingang', 2, '');
INSERT INTO algemeen.styles_symbols_type VALUES ('CCR', 2, '');

DROP VIEW bouwlaag_label;
CREATE OR REPLACE VIEW bouwlaag_label AS 
 SELECT l.id,
    l.geom,
    l.datum_aangemaakt,
    l.datum_gewijzigd,
    l.omschrijving,
    l.soort,
    l.rotatie,
    l.bouwlaag_id,
    b.bouwlaag,
    st.size,
    st.symbol_name
   FROM label l
     JOIN bouwlagen b ON l.bouwlaag_id = b.id
     INNER JOIN algemeen.styles_symbols_type st ON l.soort::TEXT = st.naam;

CREATE OR REPLACE RULE label_del AS
    ON DELETE TO bouwlaag_label DO INSTEAD  DELETE FROM label
  WHERE label.id = old.id;

CREATE OR REPLACE RULE label_ins AS
    ON INSERT TO bouwlaag_label DO INSTEAD  INSERT INTO label (geom, soort, omschrijving, rotatie, bouwlaag_id)
  VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING label.id,
    label.geom,
    label.datum_aangemaakt,
    label.datum_gewijzigd,
    label.omschrijving,
    label.soort,
    label.rotatie,
    label.bouwlaag_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE label.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT size FROM algemeen.styles_symbols_type WHERE label.soort::TEXT = algemeen.styles_symbols_type.naam),
    (SELECT symbol_name FROM algemeen.styles_symbols_type WHERE label.soort::TEXT = algemeen.styles_symbols_type.naam);

CREATE OR REPLACE RULE label_upd AS
    ON UPDATE TO bouwlaag_label DO INSTEAD  UPDATE label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id
  WHERE label.id = new.id;

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_label', 'id', 1, 'assigned');

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_veiligh_bouwk', 'id', 1, 'assigned');

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_bgt', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'schade_cirkel_calc', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'veiligh_bouwk_types', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'ruimtelijk_sleutelkluis', 'id', 1, 'assigned');

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_ruimten', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'stavaza_objecten', 'team', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'stavaza_status_gemeente', 'gid', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'stavaza_update_gemeente', 'gid', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'stavaza_volgende_update', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'status_objectgegevens', 'id', 1, 'assigned');

INSERT INTO algemeen.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('algemeen', 'veiligheidsregio_huidig', 'id', 1, 'assigned');

DROP VIEW schade_cirkel_calc;
CREATE OR REPLACE VIEW schade_cirkel_calc AS 
 SELECT sc.id,
    sc.datum_aangemaakt,
    sc.datum_gewijzigd,
    sc.straal,
    sc.soort,
    sc.gevaarlijkestof_id,
    st_buffer(part.geom, sc.straal::double precision)::geometry(Polygon, 28992) AS geom_cirkel
   FROM gevaarlijkestof_schade_cirkel sc
     LEFT JOIN ( SELECT gb.id,
            ops.geom
           FROM gevaarlijkestof gb
             LEFT JOIN gevaarlijkestof_opslag ops ON gb.opslag_id = ops.id) part ON sc.gevaarlijkestof_id = part.id;

UPDATE dreiging_type SET symbol_name = 'radioactief_materiaal' WHERE symbol_name = 'straling';

ALTER TABLE ruimten_type DROP CONSTRAINT ruimten_type_pk CASCADE; 
ALTER TABLE ruimten_type ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE ruimten_type ADD CONSTRAINT UC_naam UNIQUE (naam);

ALTER TABLE ruimten ADD CONSTRAINT ruimten_type_id_fk FOREIGN KEY (ruimten_type_id)
      REFERENCES ruimten_type (naam) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION ;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 1;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 317; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
