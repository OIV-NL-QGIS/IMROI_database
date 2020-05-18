SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

DROP VIEW view_object_aanw_pers;
DROP VIEW print_bouwlaag_aanwezig;

ALTER TABLE aanwezig ALTER COLUMN tijdvakeind TYPE timestamp without time zone USING CONCAT(current_date,' ',tijdvakeind)::timestamp without time zone;

CREATE OR REPLACE VIEW view_object_aanw_pers AS 
 SELECT b.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    a.id,
    a.datum_aangemaakt,
    a.datum_gewijzigd,
    a.dagen,
    a.tijdvakbegin,
    a.tijdvakeind,
    a.aantal,
    a.aantalniet,
    ag.naam,
    b.geom,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y
   FROM objecten.aanwezig a
     JOIN objecten.aanwezig_groep ag ON a.aanwezig_groep_id = ag.id
     JOIN ( SELECT o.formelenaam,
            o.id,
            o.geom,
            bouwlagen.id AS bouwlaag_id,
            bouwlagen.bouwlaag,
            bouwlagen.bouwdeel
           FROM ( SELECT object.formelenaam,
                    object.id,
                    object.geom
                   FROM objecten.object
                     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                           FROM objecten.historie historie_1
                          WHERE historie_1.object_id = object.id
                          ORDER BY historie_1.datum_aangemaakt DESC
                         LIMIT 1))
                  WHERE historie.historie_status_id = 2) o
             JOIN objecten.bouwlagen ON o.id = bouwlagen.object_id) b ON a.bouwlaag_id = b.bouwlaag_id;

CREATE OR REPLACE VIEW print_bouwlaag_aanwezig AS 
 SELECT a.id,
    o.formelenaam,
    o.pand_id,
    b.bouwlaag,
    b.bouwdeel,
    ag.naam AS aanwezig_groep,
    a.dagen,
    a.tijdvakbegin,
    a.tijdvakeind,
    a.aantal,
    a.aantalniet
   FROM objecten.aanwezig a
     LEFT JOIN objecten.aanwezig_groep ag ON a.aanwezig_groep_id = ag.id
     LEFT JOIN objecten.bouwlagen b ON a.bouwlaag_id = b.id
     LEFT JOIN objecten.object o ON b.object_id = o.id;

