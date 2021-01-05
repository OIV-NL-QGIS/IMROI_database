SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

DROP VIEW objecten.bouwlaag_label;
DROP VIEW objecten.object_label;
ALTER TABLE objecten.label_type ALTER COLUMN size TYPE decimal;

CREATE OR REPLACE VIEW objecten.bouwlaag_label AS 
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
   FROM objecten.label l
     JOIN objecten.bouwlagen b ON l.bouwlaag_id = b.id
     JOIN objecten.label_type st ON l.soort::text = st.naam::text;

CREATE OR REPLACE RULE label_del AS
    ON DELETE TO objecten.bouwlaag_label DO INSTEAD  DELETE FROM objecten.label
  WHERE label.id = old.id;

CREATE OR REPLACE RULE label_ins AS
    ON INSERT TO objecten.bouwlaag_label DO INSTEAD  INSERT INTO objecten.label (geom, soort, omschrijving, rotatie, bouwlaag_id)
  VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING label.id,
    label.geom,
    label.datum_aangemaakt,
    label.datum_gewijzigd,
    label.omschrijving,
    label.soort,
    label.rotatie,
    label.bouwlaag_id,
    ( SELECT bouwlagen.bouwlaag
           FROM objecten.bouwlagen
          WHERE label.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    ( SELECT styles_symbols_type.size::DECIMAL
           FROM algemeen.styles_symbols_type
          WHERE label.soort::text = styles_symbols_type.naam) AS size,
    ( SELECT styles_symbols_type.symbol_name
           FROM algemeen.styles_symbols_type
          WHERE label.soort::text = styles_symbols_type.naam) AS symbol_name;

CREATE OR REPLACE RULE label_upd AS
    ON UPDATE TO objecten.bouwlaag_label DO INSTEAD  UPDATE objecten.label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id
  WHERE label.id = new.id;

CREATE OR REPLACE VIEW objecten.object_label AS 
 SELECT l.id,
    l.geom,
    l.datum_aangemaakt,
    l.datum_gewijzigd,
    l.omschrijving,
    l.rotatie,
    l.bouwlaag_id,
    l.object_id,
    l.soort,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    st.size,
    st.symbol_name
   FROM objecten.label l
     JOIN ( SELECT object.formelenaam,
            object.datum_geldig_vanaf,
            object.datum_geldig_tot,
            object.id,
            historie.typeobject
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON l.object_id = o.id
     JOIN objecten.label_type st ON l.soort::text = st.naam::text;

CREATE OR REPLACE RULE object_label_del AS
    ON DELETE TO objecten.object_label DO INSTEAD  DELETE FROM objecten.label
  WHERE label.id = old.id;

CREATE OR REPLACE RULE object_label_ins AS
    ON INSERT TO objecten.object_label DO INSTEAD  INSERT INTO objecten.label (geom, soort, omschrijving, rotatie, object_id)
  VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.object_id)
  RETURNING label.id,
    label.geom,
    label.datum_aangemaakt,
    label.datum_gewijzigd,
    label.omschrijving,
    label.rotatie,
    label.bouwlaag_id,
    label.object_id,
    label.soort,
    ( SELECT o.formelenaam
           FROM objecten.object o
          WHERE o.id = label.object_id) AS formelenaam,
    ( SELECT o.datum_geldig_vanaf
           FROM objecten.object o
          WHERE o.id = label.object_id) AS datum_geldig_vanaf,
    ( SELECT o.datum_geldig_tot
           FROM objecten.object o
          WHERE o.id = label.object_id) AS datum_geldig_tot,
    ( SELECT o.typeobject
           FROM objecten.historie o
          WHERE o.object_id = label.object_id
         LIMIT 1) AS typeobject,
    ( SELECT styles_symbols_type.size::DECIMAL
           FROM algemeen.styles_symbols_type
          WHERE label.soort::text = styles_symbols_type.naam) AS size,
    ( SELECT styles_symbols_type.symbol_name
           FROM algemeen.styles_symbols_type
          WHERE label.soort::text = styles_symbols_type.naam) AS symbol_name;

CREATE OR REPLACE RULE object_label_upd AS
    ON UPDATE TO objecten.object_label DO INSTEAD  UPDATE objecten.label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, object_id = new.object_id
  WHERE label.id = new.id;

CREATE OR REPLACE RULE object_bgt_ins AS
    ON INSERT TO objecten.object_bgt DO INSTEAD  INSERT INTO objecten.object (geom, basisreg_identifier, formelenaam, bron, bron_tabel)  SELECT new.geom,
            b.identificatie,
            new.formelenaam,
            b.bron,
            b.bron_tbl
           FROM algemeen.bgt_extent b
          WHERE st_intersects(new.geom, st_curvetoline(b.geovlak))
         LIMIT 1
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
    ( SELECT o.typeobject
           FROM objecten.historie o
          WHERE (o.object_id = object.id)
         LIMIT 1) AS typeobject;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 1;
UPDATE algemeen.applicatie SET db_versie = 321; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
