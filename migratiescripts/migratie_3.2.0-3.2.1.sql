SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO objecten.bodemgesteldheid_type(id, naam) VALUES (1, 'n.n.b.');
INSERT INTO objecten.bodemgesteldheid_type(id, naam) VALUES (2, 'klei');
INSERT INTO objecten.bodemgesteldheid_type(id, naam) VALUES (3, 'slib');
INSERT INTO objecten.bodemgesteldheid_type(id, naam) VALUES (4, 'zand');
INSERT INTO objecten.bodemgesteldheid_type(id, naam) VALUES (5, 'n.v.t.');

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

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 1;
UPDATE algemeen.applicatie SET db_versie = 321; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
