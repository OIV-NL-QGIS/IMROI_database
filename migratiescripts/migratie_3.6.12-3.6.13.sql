SET ROLE oiv_admin;

CREATE OR REPLACE VIEW objecten.object_bereikbaarheid
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.opmerking,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot
   FROM objecten.bereikbaarheid l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

ALTER TABLE objecten.object_type ADD COLUMN IF NOT EXISTS size integer;
UPDATE objecten.object SET size = 8 WHERE size = 0;

  -- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 13;
UPDATE algemeen.applicatie SET db_versie = 3613; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();