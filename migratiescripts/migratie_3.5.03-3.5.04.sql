SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE bluswater.alternatieve RENAME COLUMN datum_deleted TO self_deleted;

CREATE OR REPLACE VIEW objecten.status_objectgegevens
AS SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    historie.status
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT h.id
           FROM objecten.historie h
          WHERE h.object_id = object.id
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1))
  WHERE object.self_deleted = 'infinity'::timestamp with time zone;

ALTER TYPE algemeen.lijnstijl_type ADD VALUE 'mark';
ALTER TYPE algemeen.lijnstijl_type ADD VALUE 'markbordered';

INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(119, 'Bereikbaarheid', 'oever-kade', 8, '#ff868686', 'markbordered'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'flat'::algemeen.eindstijl_type);
INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(120, 'Bereikbaarheid', 'Afrastering defensie/risico-objecten-mark', 8, '#ff565608', 'mark'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'flat'::algemeen.eindstijl_type);
INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(122, 'Bereikbaarheid', 'Afrastering munitie-mark', 8, '#ffba2a26', 'mark'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'flat'::algemeen.eindstijl_type);
INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(123, 'Bereikbaarheid', 'Afrastering (algemeen)-mark', 8, '#ff2a2a2a', 'mark'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'flat'::algemeen.eindstijl_type);
INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(125, 'Bereikbaarheid', 'hekwerk-mark', 2, '#ffa2a2a2', 'mark'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'flat'::algemeen.eindstijl_type);

ALTER TABLE objecten.label_type ADD COLUMN style_ids varchar(25);

INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(126, 'Label', 'Algemeen', 1, '#00000000', 'solid'::algemeen.lijnstijl_type, '#00000000', 'solid'::algemeen.vulstijl_type, NULL, NULL);
INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(127, 'Label', 'Gevaar', 1, '#ffffffff', 'solid'::algemeen.lijnstijl_type, '#ffe31a1c', 'solid'::algemeen.vulstijl_type, NULL, NULL);
INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(128, 'Label', 'Voorzichtig', 1, '#ff000000', 'solid'::algemeen.lijnstijl_type, '#fffff302', 'solid'::algemeen.vulstijl_type, NULL, NULL);
INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(129, 'Label', 'Waarschuwing', 1, '#ff000000', 'solid'::algemeen.lijnstijl_type, '#ffff7f00', 'solid'::algemeen.vulstijl_type, NULL, NULL);
INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(130, 'Label', 'calamiteitendoorgang', 1, '#ffffffff', 'solid'::algemeen.lijnstijl_type, '#ffe31a1c', 'solid'::algemeen.vulstijl_type, NULL, NULL);
INSERT INTO algemeen.styles
(id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)
VALUES(131, 'Label', 'publieke ingang', 1, '#ffffffff', 'solid'::algemeen.lijnstijl_type, '#ff08a6f5', 'solid'::algemeen.vulstijl_type, NULL, NULL);

UPDATE objecten.label_type
SET naam='calamiteitendoorgang', symbol_name='calamiteitendoorgang', "size"=3, size_object=6, style_ids='130'
WHERE id=5;
UPDATE objecten.label_type
SET naam='publieke ingang', symbol_name='publieke ingang', "size"=3, size_object=6, style_ids='131'
WHERE id=6;
UPDATE objecten.label_type
SET naam='Algemeen', symbol_name='Algemeen', "size"=1, size_object=4, style_ids='126'
WHERE id=1;
UPDATE objecten.label_type
SET naam='Gevaar', symbol_name='Gevaar', "size"=1, size_object=4, style_ids='127'
WHERE id=2;
UPDATE objecten.label_type
SET naam='Voorzichtig', symbol_name='Voorzichtig', "size"=1, size_object=4, style_ids='128'
WHERE id=3;
UPDATE objecten.label_type
SET naam='Waarschuwing', symbol_name='Waarschuwing', "size"=1, size_object=4, style_ids='129'
WHERE id=4;

CREATE OR REPLACE VIEW objecten.view_label_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.omschrijving,
    d.soort,
    d.rotatie,
    d.bouwlaag_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vt.SIZE,
    vt.style_ids
   FROM objecten.object o
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone AND historie.self_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.label d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.label_type vt ON d.soort::text = vt.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone;
  
CREATE OR REPLACE VIEW objecten.view_label_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.rotatie,
    b.bouwlaag_id,
    b.object_id,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.size_object AS SIZE,
    vt.style_ids
   FROM objecten.object o
     JOIN objecten.label b ON o.id = b.object_id
     JOIN objecten.label_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone AND historie.self_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

UPDATE objecten.bereikbaarheid_type SET style_ids='119' WHERE naam='oever-kade';
UPDATE objecten.bereikbaarheid_type SET style_ids='64,123' WHERE naam='Afrastering (algemeen)';
UPDATE objecten.bereikbaarheid_type SET style_ids='62,120' WHERE naam='Afrastering defensie/risico-objecten';
UPDATE objecten.bereikbaarheid_type SET style_ids='63,122' WHERE naam='Afrastering munitie';
UPDATE objecten.bereikbaarheid_type SET style_ids='78,125' WHERE naam='hekwerk';

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
  WHERE sc.parent_deleted = 'infinity' AND sc.self_deleted = 'infinity';

ALTER TABLE gevaarlijkestof_schade_cirkel ALTER COLUMN parent_deleted SET default 'infinity';
ALTER TABLE objecten.gevaarlijkestof_schade_cirkel DISABLE TRIGGER trg_set_delete_after_parent;
UPDATE gevaarlijkestof_schade_cirkel SET parent_deleted = 'infinity' WHERE parent_deleted IS NULL;
ALTER TABLE objecten.gevaarlijkestof_schade_cirkel ENABLE TRIGGER trg_set_delete_after_parent;


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
                          WHERE h.object_id = object.id
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
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN objecten.historie_matrix_code ON historie.matrix_code_id = historie_matrix_code.id
  WHERE object.self_deleted = 'infinity'::timestamp with time zone;
  
-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 5;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 354; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();