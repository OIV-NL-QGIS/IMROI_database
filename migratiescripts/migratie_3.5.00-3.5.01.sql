SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE OR REPLACE VIEW objecten.schade_cirkel_calc
AS SELECT sc.id,
    sc.datum_aangemaakt,
    sc.datum_gewijzigd,
    sc.straal,
    sc.soort,
    sc.gevaarlijkestof_id,
    st_buffer(part.geom, sc.straal::double precision)::geometry(Polygon,28992) AS geom_cirkel
   FROM objecten.gevaarlijkestof_schade_cirkel sc
     LEFT JOIN ( SELECT gb.id,
            ops.geom
           FROM objecten.gevaarlijkestof gb
             LEFT JOIN objecten.gevaarlijkestof_opslag ops ON gb.opslag_id = ops.id) part ON sc.gevaarlijkestof_id = part.id
   WHERE sc.datum_deleted IS NULL;

UPDATE objecten.gevaarlijkestof_vnnr SET vn_nr = ' ' WHERE vn_nr = 'geen vn nummer';

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 5;
UPDATE algemeen.applicatie SET revisie = 1;
UPDATE algemeen.applicatie SET db_versie = 351; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
