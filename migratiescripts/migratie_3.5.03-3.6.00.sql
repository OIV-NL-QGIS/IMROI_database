SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

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

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 360; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();