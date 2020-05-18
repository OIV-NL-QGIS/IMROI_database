SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE INDEX voorziening__zonder_geom_gist
  ON objecten.voorziening_zonder_object
  USING btree
  (geom);

-- ADD actualisatie code "D" to the update query  
DROP VIEW IF EXISTS objecten.volgende_update CASCADE;      
        
CREATE OR REPLACE VIEW objecten.volgende_update AS 
 SELECT object.id,
    object.formelenaam,
    object.geom,
    object.pand_id,
    historie.datum_aangemaakt,
    beh.behandelaar,
    afh.afhandelaar,
    g.gemeentena,
    object.datum_gewijzigd,
    historie_status.naam AS status,
    historie_aanpassing.naam AS aanpassing,
    matrix_code.matrix_code,
    matrix_code.actualisatie,
    historie.datum_aangemaakt::date + '1 year'::interval *
        CASE
            WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
            WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
            WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
            WHEN matrix_code.actualisatie::text = 'D'::text THEN 10
            WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
            ELSE NULL::integer
        END::double precision AS volgende_update,
        CASE
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) >= now() THEN 'up-to-date'::text
            WHEN (historie.datum_aangemaakt::date + '1 year'::interval *
            CASE
                WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) < now() THEN 'updaten'::text
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) IS NULL THEN 'nog niet gemaakt'::text
            ELSE 'updaten binnen 3 maanden'::text
        END AS conditie
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
           FROM objecten.historie historie_1
          WHERE historie_1.object_id = object.id AND historie_1.historie_aanpassing_id <> 1
          ORDER BY historie_1.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN objecten.historie_status ON historie.historie_status_id = historie_status.id
     LEFT JOIN (SELECT id, naam AS behandelaar FROM algemeen.teamlid) AS beh ON historie.teamlid_behandeld_id = beh.id
     LEFT JOIN (SELECT id, naam AS afhandelaar FROM algemeen.teamlid) AS afh ON historie.teamlid_afgehandeld_id = afh.id
     LEFT JOIN objecten.historie_aanpassing ON historie.historie_aanpassing_id = historie_aanpassing.id
     LEFT JOIN objecten.matrix_code ON historie.matrix_code_id = matrix_code.id
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(object.geom, g.geom);

CREATE OR REPLACE VIEW objecten.stavaza_update_gemeente AS 
 SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.conditie) FILTER (WHERE s.conditie = 'up-to-date'::text) AS up_to_date,
    count(s.conditie) FILTER (WHERE s.conditie = 'updaten binnen 3 maanden'::text) AS binnen_3_maanden,
    count(s.conditie) FILTER (WHERE s.conditie = 'updaten'::text) AS updaten,
    count(s.conditie) FILTER (WHERE s.conditie = 'nog niet gemaakt'::text) AS nog_maken,
    g.geom
   FROM objecten.volgende_update s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;

-- alter voorziening zonder object pand_id -> character varying
ALTER TABLE objecten.voorziening_zonder_object ALTER COLUMN pand_id TYPE character varying(16);
--Update pand_id waar de lengte van het pand_id = 15, dus de voorloop 0 is weggevallen
UPDATE objecten.voorziening_zonder_object SET pand_id = CONCAT('0', pand_id) WHERE length(pand_id) = 15;  
  
-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 242; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();