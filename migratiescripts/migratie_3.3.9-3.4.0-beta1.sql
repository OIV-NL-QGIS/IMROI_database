SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

UPDATE objecten.sleutelkuis_type SET naam = 'Sleutelkuis Havenbedrijf', symbol_name = 'sleutelkluis_havenbedrijf'
WHERE id = 10;

UPDATE bluswater.alternatieve_type SET naam = 'Voorziening defect', symbol_name = 'bluswater_defect'
WHERE id = 9999;

CREATE OR REPLACE VIEW objecten.object_isolijnen
AS SELECT l.id,
    l.geom,
    l.hoogte,
    l.omschrijving,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.isolijnen l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE l.datum_deleted IS NULL;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 340; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();