--Extra analyse lagen t.b.v. bluswater beheer, analyse bag pand niet bereikt binnen 100m straal
SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

DROP VIEW IF EXISTS view_bereikbaarheid;
CREATE OR REPLACE VIEW view_bereikbaarheid AS 
 SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.obstakels,
    b.wegafzetting,
    b.soort,
    b.object_id,
    b.fotografie_id,
    b.label,
    o.formelenaam
   FROM objecten.bereikbaarheid b
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id;

DROP VIEW IF EXISTS view_gevaarlijkestof_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_bouwlaag AS 
 SELECT gvs.id,
    gvs.opslag_id,
    gvs.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    gvs.hoeveelheid,
    gvs.eenheid,
    gvs.toestand,
    o.object_id,
    o.formelenaam,
    ops.bouwlaag,
    ops.bouwdeel,
    ops.geom,
    ops.locatie,
    ops.rotatie,
    round(st_x(ops.geom)) AS x,
    round(st_y(ops.geom)) AS y
   FROM objecten.gevaarlijkestof gvs
     LEFT JOIN objecten.gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN ( SELECT op.id,
            op.geom,
            op.bouwlaag_id,
            op.locatie,
            op.rotatie,
            b.bouwlaag,
            b.bouwdeel
           FROM objecten.gevaarlijkestof_opslag op
             JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
     JOIN ( SELECT object.formelenaam,
            object.id AS object_id,
            object.geovlak
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON st_intersects(ops.geom, o.geovlak);

DROP VIEW IF EXISTS view_gevaarlijkestof_ruimtelijk;
CREATE OR REPLACE VIEW view_gevaarlijkestof_ruimtelijk AS 
 SELECT s.id,
    s.opslag_id,
    s.datum_aangemaakt,
    s.datum_gewijzigd,
    s.omschrijving,
    s.gevaarlijkestof_vnnr_id,
    s.locatie,
    s.hoeveelheid,
    s.eenheid,
    s.toestand,
    s.handelingsaanwijzing,
    vn.vn_nr,
    vn.gevi_nr,
    vn.eric_kaart,
    part.geom,
    part.rotatie,
    part.formelenaam,
    round(st_x(part.geom)) AS x,
    round(st_y(part.geom)) AS y
   FROM objecten.gevaarlijkestof s
     JOIN ( SELECT b.id AS opslag_id,
            b.geom,
            b.rotatie,
            o.formelenaam
           FROM objecten.gevaarlijkestof_opslag b
             JOIN ( SELECT object.formelenaam,
                    object.id
                   FROM objecten.object
                     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                           FROM objecten.historie historie_1
                          WHERE historie_1.object_id = object.id
                          ORDER BY historie_1.datum_aangemaakt DESC
                         LIMIT 1))
                  WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id) part ON s.opslag_id = part.opslag_id
     LEFT JOIN objecten.gevaarlijkestof_vnnr vn ON s.gevaarlijkestof_vnnr_id = vn.id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 10;
UPDATE algemeen.applicatie SET revisie = 5;
UPDATE algemeen.applicatie SET db_versie = 2105; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();