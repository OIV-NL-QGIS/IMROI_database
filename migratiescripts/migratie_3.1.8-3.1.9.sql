SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TYPE object_type AS ENUM ('Gebouw', 'Evenement', 'Natuur', 'Waterongeval');
ALTER TABLE historie ADD COLUMN typeobject object_type;

ALTER TABLE veiligh_ruimtelijk_type ADD COLUMN size INTEGER;
UPDATE veiligh_ruimtelijk_type SET size = 6;

CREATE OR REPLACE VIEW object_veiligh_ruimtelijk AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    vt.symbol_name,
    vt.size
   FROM veiligh_ruimtelijk b
     JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id
     JOIN veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id;

CREATE OR REPLACE RULE veiligh_ruimtelijk_del AS
    ON DELETE TO object_veiligh_ruimtelijk DO INSTEAD  DELETE FROM veiligh_ruimtelijk
  WHERE veiligh_ruimtelijk.id = old.id;

CREATE OR REPLACE RULE veiligh_ruimtelijk_ins AS
    ON INSERT TO object_veiligh_ruimtelijk DO INSTEAD INSERT INTO veiligh_ruimtelijk (geom, veiligh_ruimtelijk_type_id, label, rotatie, object_id, fotografie_id)
  VALUES (new.geom, new.veiligh_ruimtelijk_type_id, new.label, new.rotatie, new.object_id, new.fotografie_id)
  RETURNING veiligh_ruimtelijk.id,
    veiligh_ruimtelijk.geom,
    veiligh_ruimtelijk.datum_aangemaakt,
    veiligh_ruimtelijk.datum_gewijzigd,
    veiligh_ruimtelijk.veiligh_ruimtelijk_type_id,
    veiligh_ruimtelijk.label,
    veiligh_ruimtelijk.object_id,
    veiligh_ruimtelijk.rotatie,
    veiligh_ruimtelijk.fotografie_id,
    (SELECT formelenaam FROM object o WHERE o.id = veiligh_ruimtelijk.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = veiligh_ruimtelijk.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = veiligh_ruimtelijk.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = veiligh_ruimtelijk.object_id LIMIT 1),
    (SELECT st.symbol_name FROM veiligh_ruimtelijk_type st WHERE st.id = veiligh_ruimtelijk.veiligh_ruimtelijk_type_id),
    (SELECT st.size FROM veiligh_ruimtelijk_type st WHERE st.id = veiligh_ruimtelijk.veiligh_ruimtelijk_type_id);

CREATE OR REPLACE RULE veiligh_ruimtelijk_upd AS
    ON UPDATE TO object_veiligh_ruimtelijk DO INSTEAD 
    UPDATE veiligh_ruimtelijk SET geom = new.geom, veiligh_ruimtelijk_type_id = new.veiligh_ruimtelijk_type_id, rotatie = new.rotatie, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE veiligh_ruimtelijk.id = new.id;

CREATE OR REPLACE VIEW object_dreiging AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    vt.symbol_name,
    vt.size
   FROM dreiging b
     JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id
     JOIN dreiging_type vt ON b.dreiging_type_id = vt.id
   WHERE object_id IS NOT NULL;

CREATE OR REPLACE RULE dreiging_del AS
    ON DELETE TO object_dreiging DO INSTEAD DELETE FROM dreiging
  WHERE dreiging.id = old.id;

CREATE OR REPLACE RULE dreiging_ins AS
    ON INSERT TO object_dreiging DO INSTEAD INSERT INTO dreiging (geom, dreiging_type_id, label, rotatie, object_id, fotografie_id)
  VALUES (new.geom, new.dreiging_type_id, new.label, new.rotatie, new.object_id, new.fotografie_id)
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
    (SELECT formelenaam FROM object o WHERE o.id = dreiging.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = dreiging.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = dreiging.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = dreiging.object_id LIMIT 1),
    (SELECT st.symbol_name FROM dreiging_type st WHERE st.id = dreiging.dreiging_type_id),
    (SELECT st.size FROM dreiging_type st WHERE st.id = dreiging.dreiging_type_id);

CREATE OR REPLACE RULE dreiging_upd AS
    ON UPDATE TO object_dreiging DO INSTEAD UPDATE dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, rotatie = new.rotatie, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE dreiging.id = new.id;

CREATE OR REPLACE VIEW object_ingang AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    vt.symbol_name,
    vt.size
   FROM ingang b
     JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id
     JOIN ingang_type vt ON b.ingang_type_id = vt.id;

CREATE OR REPLACE RULE ingang_del AS
    ON DELETE TO object_ingang DO INSTEAD DELETE FROM ingang
  WHERE ingang.id = old.id;

CREATE OR REPLACE RULE ingang_ins AS
    ON INSERT TO object_ingang DO INSTEAD  INSERT INTO ingang (geom, ingang_type_id, label, rotatie, belemmering, voorzieningen, object_id, fotografie_id)
  VALUES (new.geom, new.ingang_type_id, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.object_id, new.fotografie_id)
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
    (SELECT formelenaam FROM object o WHERE o.id = ingang.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = ingang.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = ingang.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = ingang.object_id LIMIT 1),
    (SELECT st.symbol_name FROM ingang_type st WHERE st.id = ingang.ingang_type_id),
    (SELECT st.size FROM ingang_type st WHERE st.id = ingang.ingang_type_id);

CREATE OR REPLACE RULE ingang_upd AS
    ON UPDATE TO object_ingang DO INSTEAD 
    UPDATE ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE ingang.id = new.id;

CREATE OR REPLACE VIEW object_sleutelkluis AS 
 SELECT v.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    vt.symbol_name,
    vt.size 
   FROM sleutelkluis v
   INNER JOIN ingang ib ON v.ingang_id = ib.id
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON ib.object_id = o.id
   INNER JOIN sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id;

CREATE OR REPLACE RULE object_sleutelkluis_ins AS
    ON INSERT TO object_sleutelkluis DO INSTEAD  INSERT INTO sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, fotografie_id)
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
    (SELECT formelenaam FROM object o INNER JOIN ingang i ON o.id = i.object_id WHERE i.id = sleutelkluis.ingang_id),
    (SELECT datum_geldig_vanaf FROM object o INNER JOIN ingang i ON o.id = i.object_id WHERE i.id = sleutelkluis.ingang_id),
    (SELECT datum_geldig_tot FROM object o INNER JOIN ingang i ON o.id = i.object_id WHERE i.id = sleutelkluis.ingang_id),
    (SELECT typeobject FROM historie o INNER JOIN ingang i ON o.object_id = i.object_id WHERE i.id = sleutelkluis.ingang_id LIMIT 1),
    (SELECT st.symbol_name FROM sleutelkluis_type st WHERE st.id = sleutelkluis.sleutelkluis_type_id),
    (SELECT st.size FROM sleutelkluis_type st WHERE st.id = sleutelkluis.sleutelkluis_type_id);

CREATE OR REPLACE RULE object_sleutelkluis_upd AS
    ON UPDATE TO object_sleutelkluis DO INSTEAD UPDATE sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, sleuteldoel_type_id = new.sleuteldoel_type_id, ingang_id = new.ingang_id, fotografie_id = new.fotografie_id
  WHERE sleutelkluis.id = new.id;

CREATE OR REPLACE RULE object_ruimtelijk_del AS
    ON DELETE TO object_sleutelkluis DO INSTEAD  DELETE FROM sleutelkluis
  WHERE sleutelkluis.id = old.id;

DROP VIEW ruimtelijk_sleutelkluis;

INSERT INTO algemeen.styles_symbols_type VALUES ('Tankautospuit', 25, 'opstelplaats_tankautospuit');
INSERT INTO algemeen.styles_symbols_type VALUES ('Redvoertuig', 25, 'opstelplaats_redvoertuig');
INSERT INTO algemeen.styles_symbols_type VALUES ('Autoladder', 25, 'opstelplaats_autoladder');
INSERT INTO algemeen.styles_symbols_type VALUES ('WTS', 25, 'opstelplaats_wts');
INSERT INTO algemeen.styles_symbols_type VALUES ('Schuimblusvoertuig', 25, 'opstelplaats_sb');
INSERT INTO algemeen.styles_symbols_type VALUES ('UGS', 25, 'uitgangsstelling');
INSERT INTO algemeen.styles_symbols_type VALUES ('Boot te water laat plaats', 25, 'boot_te_water_laat_plaats');

CREATE OR REPLACE VIEW object_opstelplaats AS 
 SELECT v.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    st.symbol_name,
    st.size
   FROM opstelplaats v
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON v.object_id = o.id
   INNER JOIN algemeen.styles_symbols_type st ON v.soort::text = st.naam;

CREATE OR REPLACE RULE object_opstelplaats_upd AS
    ON UPDATE TO object_opstelplaats DO INSTEAD UPDATE opstelplaats SET geom = new.geom, soort = new.soort::opstelplaats_type, rotatie = new.rotatie, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE opstelplaats.id = new.id;

CREATE OR REPLACE RULE object_opstelplaats_del AS
    ON DELETE TO object_opstelplaats DO INSTEAD  DELETE FROM opstelplaats
  WHERE opstelplaats.id = old.id;

CREATE OR REPLACE RULE object_opstelplaats_ins AS
    ON INSERT TO object_opstelplaats DO INSTEAD  INSERT INTO opstelplaats (geom, soort, label, rotatie, object_id, fotografie_id)
  VALUES (new.geom, new.soort, new.label, new.rotatie, new.object_id, new.fotografie_id)
  RETURNING opstelplaats.id,
    opstelplaats.geom,
    opstelplaats.datum_aangemaakt,
    opstelplaats.datum_gewijzigd,
    opstelplaats.soort,
    opstelplaats.rotatie,
    opstelplaats.object_id,
    opstelplaats.fotografie_id,
    opstelplaats.label,   
    (SELECT formelenaam FROM object o WHERE o.id = opstelplaats.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = opstelplaats.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = opstelplaats.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = opstelplaats.object_id LIMIT 1),
    (SELECT styles_symbols_type.symbol_name FROM algemeen.styles_symbols_type WHERE styles_symbols_type.naam = 'Opslag stoffen'::text) AS symbol_name,
    (SELECT styles_symbols_type.size FROM algemeen.styles_symbols_type WHERE styles_symbols_type.naam = 'Opslag stoffen'::text) AS size;    

CREATE OR REPLACE VIEW object_opslag AS 
 SELECT v.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    st.symbol_name,
    st.size
   FROM gevaarlijkestof_opslag v
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON v.object_id = o.id
   INNER JOIN algemeen.styles_symbols_type st ON 'Opslag stoffen'::text = st.naam;

CREATE OR REPLACE RULE opslag_del AS
    ON DELETE TO object_opslag DO INSTEAD  DELETE FROM gevaarlijkestof_opslag
  WHERE gevaarlijkestof_opslag.id = old.id;

CREATE OR REPLACE RULE opslag_upd AS
    ON UPDATE TO object_opslag DO INSTEAD  UPDATE gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE gevaarlijkestof_opslag.id = new.id;

CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO object_opslag DO INSTEAD INSERT INTO gevaarlijkestof_opslag (geom, locatie, object_id, fotografie_id, rotatie)
  VALUES (new.geom, new.locatie, new.object_id, new.fotografie_id, new.rotatie)
  RETURNING gevaarlijkestof_opslag.id,
    gevaarlijkestof_opslag.geom,
    gevaarlijkestof_opslag.datum_aangemaakt,
    gevaarlijkestof_opslag.datum_gewijzigd,
    gevaarlijkestof_opslag.locatie,
    gevaarlijkestof_opslag.bouwlaag_id,
    gevaarlijkestof_opslag.object_id,
    gevaarlijkestof_opslag.fotografie_id,
    gevaarlijkestof_opslag.rotatie,
    (SELECT formelenaam FROM object o WHERE o.id = gevaarlijkestof_opslag.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = gevaarlijkestof_opslag.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = gevaarlijkestof_opslag.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = gevaarlijkestof_opslag.object_id LIMIT 1),
    (SELECT styles_symbols_type.symbol_name FROM algemeen.styles_symbols_type WHERE styles_symbols_type.naam = 'Opslag stoffen'::text) AS symbol_name,
    (SELECT styles_symbols_type.size FROM algemeen.styles_symbols_type WHERE styles_symbols_type.naam = 'Opslag stoffen'::text) AS size;

CREATE OR REPLACE VIEW object_label AS 
 SELECT l.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    st.size,
    st.symbol_name
   FROM objecten.label l
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON l.object_id = o.id     
   INNER JOIN algemeen.styles_symbols_type st ON l.soort::text = st.naam;

CREATE OR REPLACE RULE object_label_del AS
    ON DELETE TO object_label DO INSTEAD  DELETE FROM label
  WHERE label.id = old.id;

CREATE OR REPLACE RULE object_label_upd AS
    ON UPDATE TO object_label DO INSTEAD  UPDATE label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, object_id = new.object_id
  WHERE label.id = new.id;

CREATE OR REPLACE RULE object_label_ins AS
    ON INSERT TO object_label DO INSTEAD  INSERT INTO objecten.label (geom, soort, omschrijving, rotatie, object_id)
  VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.object_id)
  RETURNING label.id,
    label.geom,
    label.datum_aangemaakt,
    label.datum_gewijzigd,
    label.omschrijving,
    label.soort,
    label.rotatie,
    label.bouwlaag_id,
    label.object_id,
    (SELECT formelenaam FROM object o WHERE o.id = label.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = label.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = label.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = label.object_id LIMIT 1),
    (SELECT size FROM algemeen.styles_symbols_type WHERE label.soort::TEXT = algemeen.styles_symbols_type.naam),
    (SELECT symbol_name FROM algemeen.styles_symbols_type WHERE label.soort::TEXT = algemeen.styles_symbols_type.naam);

CREATE OR REPLACE VIEW object_bereikbaarheid AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM bereikbaarheid b
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE object_bereikbaarheid_del AS
    ON DELETE TO object_bereikbaarheid DO INSTEAD  DELETE FROM bereikbaarheid
  WHERE bereikbaarheid.id = old.id;

CREATE OR REPLACE RULE object_bereikbaarheid_upd AS
    ON UPDATE TO object_bereikbaarheid DO INSTEAD  
    UPDATE bereikbaarheid SET geom = new.geom, obstakels = new.obstakels, wegafzetting = new.wegafzetting, soort = new.soort, object_id = new.object_id, fotografie_id = new.fotografie_id, label = new.label
  WHERE bereikbaarheid.id = new.id;

CREATE OR REPLACE RULE object_bereikbaarheid_ins AS
    ON INSERT TO object_bereikbaarheid DO INSTEAD  INSERT INTO bereikbaarheid (geom, obstakels, wegafzetting, soort, object_id, fotografie_id, label)
  VALUES (new.geom, new.obstakels, new.wegafzetting, new.soort, new.object_id, new.fotografie_id, new.label)
  RETURNING bereikbaarheid.id,
    bereikbaarheid.geom,
    bereikbaarheid.datum_aangemaakt,
    bereikbaarheid.datum_gewijzigd,
    bereikbaarheid.obstakels,
    bereikbaarheid.wegafzetting,
    bereikbaarheid.soort,
    bereikbaarheid.object_id,
    bereikbaarheid.fotografie_id,
    bereikbaarheid.label,
    (SELECT formelenaam FROM object o WHERE o.id = bereikbaarheid.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = bereikbaarheid.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = bereikbaarheid.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = bereikbaarheid.object_id LIMIT 1);

CREATE OR REPLACE VIEW object_sectoren AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM sectoren b
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE object_sectoren_del AS
    ON DELETE TO object_sectoren DO INSTEAD  DELETE FROM sectoren
  WHERE sectoren.id = old.id;

CREATE OR REPLACE RULE object_sectoren_upd AS
    ON UPDATE TO object_sectoren DO INSTEAD  
    UPDATE sectoren SET geom = new.geom, soort = new.soort::sectoren_type, omschrijving = new.omschrijving, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE sectoren.id = new.id;

CREATE OR REPLACE RULE object_sectoren_ins AS
    ON INSERT TO object_sectoren DO INSTEAD  INSERT INTO sectoren (geom, soort, omschrijving, label, object_id, fotografie_id)
  VALUES (new.geom, new.soort, new.omschrijving, new.label, new.object_id, new.fotografie_id)
  RETURNING sectoren.id,
    sectoren.geom,
    sectoren.datum_aangemaakt,
    sectoren.datum_gewijzigd,
    sectoren.soort,
    sectoren.omschrijving,
    sectoren.label,
    sectoren.object_id,
    sectoren.fotografie_id,
    (SELECT formelenaam FROM object o WHERE o.id = sectoren.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = sectoren.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = sectoren.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = sectoren.object_id LIMIT 1);

CREATE OR REPLACE VIEW object_isolijnen AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM isolijnen b
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE object_isolijnen_del AS
    ON DELETE TO object_isolijnen DO INSTEAD  DELETE FROM isolijnen
  WHERE isolijnen.id = old.id;

CREATE OR REPLACE RULE object_isolijnen_upd AS
    ON UPDATE TO object_isolijnen DO INSTEAD  
    UPDATE isolijnen SET geom = new.geom, hoogte = new.hoogte, omschrijving = new.omschrijving, object_id = new.object_id
  WHERE isolijnen.id = new.id;

CREATE OR REPLACE RULE object_isolijnen_ins AS
    ON INSERT TO object_isolijnen DO INSTEAD  INSERT INTO isolijnen (geom, hoogte, omschrijving, object_id)
  VALUES (new.geom, new.hoogte, new.omschrijving, new.object_id)
  RETURNING isolijnen.id,
    isolijnen.geom,
    isolijnen.datum_aangemaakt,
    isolijnen.datum_gewijzigd,
    isolijnen.hoogte,
    isolijnen.omschrijving,
     isolijnen.object_id,
    (SELECT formelenaam FROM object o WHERE o.id = isolijnen.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = isolijnen.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = isolijnen.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = isolijnen.object_id LIMIT 1);

CREATE OR REPLACE VIEW object_terrein AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM terrein b
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE object_terrein_del AS
    ON DELETE TO object_terrein DO INSTEAD  DELETE FROM terrein
  WHERE terrein.id = old.id;

CREATE OR REPLACE RULE object_terrein_upd AS
    ON UPDATE TO object_terrein DO INSTEAD  
    UPDATE terrein SET geom = new.geom, omschrijving = new.omschrijving, object_id = new.object_id
  WHERE terrein.id = new.id;

CREATE OR REPLACE RULE object_terrein_ins AS
    ON INSERT TO object_terrein DO INSTEAD  INSERT INTO terrein (geom, omschrijving, object_id)
  VALUES (new.geom, new.omschrijving, new.object_id)
  RETURNING terrein.id,
    terrein.geom,
    terrein.datum_aangemaakt,
    terrein.datum_gewijzigd,
    terrein.omschrijving,
    terrein.object_id,
    (SELECT formelenaam FROM object o WHERE o.id = terrein.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = terrein.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = terrein.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = terrein.object_id LIMIT 1);

CREATE OR REPLACE VIEW object_grid AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM grid b
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE object_grid_del AS
    ON DELETE TO object_grid DO INSTEAD  DELETE FROM grid
  WHERE grid.id = old.id;

CREATE OR REPLACE RULE object_grid_upd AS
    ON UPDATE TO object_grid DO INSTEAD  
    UPDATE grid SET geom = new.geom, x_as_label = new.x_as_label, y_as_label = new.y_as_label, object_id = new.object_id, afstand = new.afstand, vaknummer = new.vaknummer
  WHERE grid.id = new.id;

CREATE OR REPLACE RULE object_grid_ins AS
    ON INSERT TO object_grid DO INSTEAD  INSERT INTO grid (geom, x_as_label, y_as_label, object_id, afstand, vaknummer)
  VALUES (new.geom, new.x_as_label, new.y_as_label, new.object_id, new.afstand, new.vaknummer)
  RETURNING grid.id,
    grid.geom,
    grid.datum_aangemaakt,
    grid.datum_gewijzigd,
    grid.y_as_label,
    grid.x_as_label,
    grid.object_id,
    grid.afstand,
    grid.vaknummer,
    (SELECT formelenaam FROM object o WHERE o.id = grid.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = grid.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = grid.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = grid.object_id LIMIT 1);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 1;
UPDATE algemeen.applicatie SET revisie = 9;
UPDATE algemeen.applicatie SET db_versie = 319; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
