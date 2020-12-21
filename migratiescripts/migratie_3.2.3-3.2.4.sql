SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO bluswater.alternatieve_type (id, naam) VALUES (15, 'Bovengrondse brandkraan');

CREATE OR REPLACE VIEW object_opstelplaats AS 
 SELECT v.id,
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
   FROM opstelplaats v
     JOIN ( SELECT object.formelenaam,
            object.datum_geldig_vanaf,
            object.datum_geldig_tot,
            object.id,
            historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON v.object_id = o.id
     JOIN opstelplaats_type st ON v.soort::text = st.naam::text;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 324; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();