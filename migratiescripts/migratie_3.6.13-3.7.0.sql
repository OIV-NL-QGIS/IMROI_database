SET ROLE oiv_admin;

CREATE OR REPLACE VIEW objecten.stavaza_objecten
AS SELECT obj.team,
    obj.totaal,
    obj.totaal_in_gebruik,
    obj.totaal_in_concept,
    obj.totaal_in_archief,
    obj.totaal_geen_status,
    obj.totaal_prio_1,
    obj.totaal_prio_2,
    obj.totaal_prio_3,
    obj.totaal_prio_4,
    obj.totaal_zonder_prio,
    obj.prio_1_in_gebruik,
    obj.prio_2_in_gebruik,
    obj.prio_3_in_gebruik,
    obj.prio_4_in_gebruik,
    obj.prio_1_concept,
    obj.prio_2_concept,
    obj.prio_3_concept,
    obj.prio_4_concept,
    obj.team_geom
   FROM ( SELECT o.team,
            count(o.team) AS totaal,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text) AS totaal_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text) AS totaal_in_concept,
            count(o.status) FILTER (WHERE o.status::text = 'archief'::text) AS totaal_in_archief,
            sum(
                CASE
                    WHEN o.status IS NULL THEN 1
                    ELSE 0
                END) AS totaal_geen_status,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 1) AS totaal_prio_1,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 2) AS totaal_prio_2,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 3) AS totaal_prio_3,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 4) AS totaal_prio_4,
            sum(
                CASE
                    WHEN mc.prio_prod IS NULL OR mc.matrix_code::text = '999'::text THEN 1
                    ELSE 0
                END) AS totaal_zonder_prio,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 1) AS prio_1_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 2) AS prio_2_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 3) AS prio_3_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 4) AS prio_4_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 1) AS prio_1_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 2) AS prio_2_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 3) AS prio_3_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 4) AS prio_4_concept,
            o.team_geom
           FROM ( SELECT object.formelenaam,
                    object.basisreg_identifier,
                    object.geom,
                    object.id AS object_id,
                    historie.datum_aangemaakt,
                    historie.aanpassing,
                    historie.status,
                    historie.matrix_code_id,
                    tg.naam AS team,
                    tg.geom AS team_geom
                   FROM objecten.object
                     LEFT JOIN objecten.historie ON historie.id = (( SELECT h.id
                           FROM objecten.historie h
                          WHERE h.object_id = object.id AND h.aanpassing <> 'aanpassing'::TEXT
                          AND h.self_deleted = 'infinity'::timestamp with time zone
                          ORDER BY h.datum_aangemaakt DESC
                         LIMIT 1))
                     LEFT JOIN algemeen.team tg ON st_intersects(object.geom, tg.geom)
                  WHERE object.self_deleted = 'infinity'::timestamp with time zone
                  ORDER BY historie.status) o
             LEFT JOIN objecten.historie_matrix_code mc ON o.matrix_code_id = mc.id
          GROUP BY o.team, o.team_geom) obj;

CREATE OR REPLACE VIEW objecten.stavaza_volgende_update
AS SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    historie.datum_aangemaakt,
    object.datum_gewijzigd,
    historie.status,
    historie.aanpassing,
    historie_matrix_code.matrix_code,
    historie_matrix_code.actualisatie,
    historie.datum_aangemaakt::date + '1 year'::interval *
        CASE
            WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
            WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
            WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
            WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
            WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
            ELSE NULL::integer
        END::double precision AS volgende_update,
        CASE
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) >= now() THEN 'up-to-date'::text
            WHEN (historie.datum_aangemaakt::date + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) < now() THEN 'updaten'::text
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) IS NULL THEN 'nog niet gemaakt'::text
            ELSE 'updaten binnen 3 maanden'::text
        END AS conditie
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT h.id
           FROM objecten.historie h
          WHERE h.object_id = object.id AND h.aanpassing::text <> 'aanpassing'::text
                AND h.self_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN objecten.historie_matrix_code ON historie.matrix_code_id = historie_matrix_code.id
  WHERE object.self_deleted = 'infinity'::timestamp with time zone;

  -- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 7;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 3700; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();