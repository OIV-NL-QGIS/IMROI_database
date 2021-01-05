SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO objecten.bodemgesteldheid_type(id, naam) VALUES (1, 'n.n.b.') ON CONFLICT DO NOTHING/UPDATE;
INSERT INTO objecten.bodemgesteldheid_type(id, naam) VALUES (2, 'klei') ON CONFLICT DO NOTHING/UPDATE;
INSERT INTO objecten.bodemgesteldheid_type(id, naam) VALUES (3, 'slib') ON CONFLICT DO NOTHING/UPDATE;
INSERT INTO objecten.bodemgesteldheid_type(id, naam) VALUES (4, 'zand') ON CONFLICT DO NOTHING/UPDATE;
INSERT INTO objecten.bodemgesteldheid_type(id, naam) VALUES (5, 'n.v.t.') ON CONFLICT DO NOTHING/UPDATE;

ALTER TABLE objecten.gevaarlijke_stof_eenheid_type RENAME TO gevaarlijkestof_eenheid;
ALTER TABLE objecten.gevaarlijke_stof_toestand_type RENAME TO gevaarlijkestof_toestand;

CREATE OR REPLACE VIEW objecten.object_opstelplaats
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.rotatie,
    v.object_id,
    v.fotografie_id,
    v.label,
    v.soort,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    st.symbol_name,
    st.size
   FROM objecten.opstelplaats v
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
                 LIMIT 1))) o ON v.object_id = o.id
     JOIN objecten.opstelplaats_type st ON v.soort::text = st.naam;

DROP RULE object_sectoren_upd ON object_sectoren;
CREATE OR REPLACE RULE object_sectoren_upd AS
    ON UPDATE TO object_sectoren DO INSTEAD  
    UPDATE sectoren SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE sectoren.id = new.id;

DROP RULE object_opstelplaats_upd ON objecten.object_opstelplaats;
CREATE OR REPLACE RULE object_opstelplaats_upd AS
    ON UPDATE TO object_opstelplaats DO INSTEAD UPDATE opstelplaats SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE opstelplaats.id = new.id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 1;
UPDATE algemeen.applicatie SET db_versie = 321; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
