SET ROLE oiv_admin;

CREATE OR REPLACE VIEW algemeen.vw_styles_ids
AS WITH base AS (
         SELECT
                CASE
                    WHEN s.soortnaam::text ~~ '%_bottom'::text THEN replace(s.soortnaam::text, '_bottom'::text, ''::text)::character varying
                    WHEN s.soortnaam::text ~~ '%_middle'::text THEN replace(s.soortnaam::text, '_middle'::text, ''::text)::character varying
                    WHEN s.soortnaam::text ~~ '%_top'::text THEN replace(s.soortnaam::text, '_top'::text, ''::text)::character varying
                    WHEN s.soortnaam::text ~~ '%-mark'::text THEN replace(s.soortnaam::text, '-mark'::text, ''::text)::character varying
                    ELSE s.soortnaam
                END AS naam,
                CASE
                    WHEN s.soortnaam::text ~~ '%_bottom'::text THEN 1
                    WHEN s.soortnaam::text ~~ '%_middle'::text THEN 2
                    WHEN s.soortnaam::text ~~ '%_top'::text THEN 3
                    ELSE 0
                END AS volgorde,
            jsonb_build_object('lijnkleur', '#'::text || "right"(s.lijnkleur::text, 6), 'lijndikte', s.lijndikte, 'lijnopacity', round((('x'::text || substr(s.lijnkleur::text, 2, 2)))::bit(8)::integer::numeric / 255.0, 1), 'lijnstijl', s.lijnstijl, 'verbindingsstijl', s.verbindingsstijl, 'eindstijl', s.eindstijl, 'vulkleur', '#'::text || "right"(s.vulkleur::text, 6), 'vulopacity', round((('x'::text || substr(s.vulkleur::text, 2, 2)))::bit(8)::integer::numeric / 255.0, 1), 'vulstijl', s.vulstijl) AS style_json,
            s.lijnstijl,
            s.lijndikte,
            s.id
           FROM algemeen.styles s
        ), grouped AS (
         SELECT base.naam,
            jsonb_agg(base.style_json ORDER BY base.volgorde) FILTER (WHERE base.lijnstijl = 'solid'::algemeen.lijnstijl_type) AS solids,
            jsonb_agg(base.style_json) FILTER (WHERE base.lijnstijl = ANY (ARRAY['dash'::algemeen.lijnstijl_type, 'dot'::algemeen.lijnstijl_type, 'dash dot'::algemeen.lijnstijl_type, 'mark'::algemeen.lijnstijl_type])) -> 0 AS special,
            max(base.lijnstijl) FILTER (WHERE base.lijnstijl = ANY (ARRAY['dash'::algemeen.lijnstijl_type, 'dot'::algemeen.lijnstijl_type, 'dash dot'::algemeen.lijnstijl_type, 'mark'::algemeen.lijnstijl_type])) AS special_style,
            max(base.lijndikte) AS lijndikte_max,
            string_agg(base.id::text, ','::text ORDER BY base.volgorde) AS style_ids
           FROM base
          GROUP BY base.naam
        )
 SELECT naam,
    style_ids,
    lijndikte_max,
    special_style,
    jsonb_build_object('style', jsonb_build_array(COALESCE(solids -> 0, '{}'::jsonb), COALESCE(solids -> 1, '{}'::jsonb), COALESCE(special, '{}'::jsonb))) AS styles
   FROM grouped;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_bereikbaarheid_new;
CREATE MATERIALIZED VIEW objecten.mview_bereikbaarheid_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.opmerking,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    o.formelenaam,
    o.share,
    last_hist.typeobject,
    vsi.style_ids,
    vsi.styles
   FROM objecten.object o
     JOIN objecten.bereikbaarheid b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.bereikbaarheid_type st ON b.soort::text = st.naam::text
     JOIN algemeen.vw_styles_ids vsi ON st.naam::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_bereikbaarheid_new;
CREATE VIEW objecten.view_bereikbaarheid_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.opmerking,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    o.formelenaam,
    o.share,
    last_hist.typeobject,
    vsi.style_ids,
    vsi.styles
   FROM objecten.object o
     JOIN objecten.bereikbaarheid b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.bereikbaarheid_type st ON b.soort::text = st.naam::text
     JOIN algemeen.vw_styles_ids vsi ON st.naam::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_bouwlagen_new;
CREATE MATERIALIZED VIEW objecten.mview_bouwlagen_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.bouwlaag,
    d.bouwdeel,
    d.pand_id,
    o.formelenaam,
    o.id AS object_id,
    o.min_bouwlaag,
    o.max_bouwlaag,
    sub.hoogste_bouwlaag,
    sub.laagste_bouwlaag,
    vsi.style_ids,
    vsi.styles,
    o.share
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.self_deleted = 'infinity'::timestamp with time zone AND t.parent_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen d ON st_intersects(t.geom, d.geom) AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN ( SELECT bouwlagen.pand_id,
            max(bouwlagen.bouwlaag) AS hoogste_bouwlaag,
            min(bouwlagen.bouwlaag) AS laagste_bouwlaag
           FROM objecten.bouwlagen
          GROUP BY bouwlagen.pand_id) sub ON d.pand_id::text = sub.pand_id::text
    JOIN algemeen.vw_styles_ids vsi ON 'Bouwlagen'::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_bouwlagen_new;
CREATE VIEW objecten.view_bouwlagen_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.bouwlaag,
    d.bouwdeel,
    d.pand_id,
    o.formelenaam,
    o.id AS object_id,
    o.min_bouwlaag,
    o.max_bouwlaag,
    sub.hoogste_bouwlaag,
    sub.laagste_bouwlaag,
    vsi.style_ids,
    vsi.styles,
    o.share
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.self_deleted = 'infinity'::timestamp with time zone AND t.parent_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen d ON st_intersects(t.geom, d.geom) AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN ( SELECT bouwlagen.pand_id,
            max(bouwlagen.bouwlaag) AS hoogste_bouwlaag,
            min(bouwlagen.bouwlaag) AS laagste_bouwlaag
           FROM objecten.bouwlagen
          GROUP BY bouwlagen.pand_id) sub ON d.pand_id::text = sub.pand_id::text
    JOIN algemeen.vw_styles_ids vsi ON 'Bouwlagen'::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_gebiedsgerichte_aanpak_new;
CREATE MATERIALIZED VIEW objecten.mview_gebiedsgerichte_aanpak_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.opmerking,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.gebiedsgerichte_aanpak b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.gebiedsgerichte_aanpak_type st ON b.soort::text = st.naam::text
     JOIN algemeen.vw_styles_ids vsi ON b.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_gebiedsgerichte_aanpak_new;
CREATE VIEW objecten.view_gebiedsgerichte_aanpak_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.opmerking,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.gebiedsgerichte_aanpak b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.gebiedsgerichte_aanpak_type st ON b.soort::text = st.naam::text
     JOIN algemeen.vw_styles_ids vsi ON b.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_grid_new;
CREATE MATERIALIZED VIEW objecten.mview_grid_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.y_as_label,
    b.x_as_label,
    b.object_id,
    b.afstand,
    b.vaknummer,
    b.scale,
    b.papersize,
    b.orientation,
    b.type,
    b.uuid,
    o.formelenaam,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.grid b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN algemeen.vw_styles_ids vsi ON b.type::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_grid_new;
CREATE VIEW objecten.view_grid_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.y_as_label,
    b.x_as_label,
    b.object_id,
    b.afstand,
    b.vaknummer,
    b.scale,
    b.papersize,
    b.orientation,
    b.type,
    b.uuid,
    o.formelenaam,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.grid b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN algemeen.vw_styles_ids vsi ON b.type::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_isolijnen_new;
CREATE MATERIALIZED VIEW objecten.mview_isolijnen_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.hoogte,
    b.opmerking AS omschrijving,
    b.object_id,
    o.formelenaam,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.isolijnen b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     LEFT JOIN objecten.isolijnen_type st ON b.hoogte::text = st.naam::text
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     LEFT JOIN algemeen.vw_styles_ids vsi ON b.hoogte::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_isolijnen_new;
CREATE VIEW objecten.view_isolijnen_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.hoogte,
    b.opmerking AS omschrijving,
    b.object_id,
    o.formelenaam,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.isolijnen b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     LEFT JOIN objecten.isolijnen_type st ON b.hoogte::text = st.naam::text
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     LEFT JOIN algemeen.vw_styles_ids vsi ON b.hoogte::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_ruimten_new;
CREATE MATERIALIZED VIEW objecten.mview_ruimten_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.opmerking,
    d.bouwlaag_id,
    d.fotografie_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.ruimten d ON st_intersects(t.geom, d.geom) AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.ruimten_type st ON d.soort = st.naam
     JOIN algemeen.vw_styles_ids vsi ON d.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_ruimten_new;
CREATE VIEW objecten.view_ruimten_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.opmerking,
    d.bouwlaag_id,
    d.fotografie_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.ruimten d ON st_intersects(t.geom, d.geom) AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.ruimten_type st ON d.soort = st.naam
     JOIN algemeen.vw_styles_ids vsi ON d.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_schade_cirkel_bouwlaag_new;
CREATE MATERIALIZED VIEW objecten.mview_schade_cirkel_bouwlaag_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    st_buffer(op.geom, gsc.straal::double precision)::geometry(Polygon,28992) AS geom,
    op.opmerking AS locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    gsc.soort,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.self_deleted = 'infinity'::timestamp with time zone AND t.parent_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
     JOIN objecten.gevaarlijkestof_schade_cirkel_type st ON gsc.soort::text = st.naam::text
     JOIN algemeen.vw_styles_ids vsi ON gsc.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_schade_cirkel_bouwlaag_new;
CREATE VIEW objecten.view_schade_cirkel_bouwlaag_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    st_buffer(op.geom, gsc.straal::double precision)::geometry(Polygon,28992) AS geom,
    op.opmerking AS locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    gsc.soort,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.self_deleted = 'infinity'::timestamp with time zone AND t.parent_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
     JOIN objecten.gevaarlijkestof_schade_cirkel_type st ON gsc.soort::text = st.naam::text
     JOIN algemeen.vw_styles_ids vsi ON gsc.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_schade_cirkel_ruimtelijk_new;
CREATE MATERIALIZED VIEW objecten.mview_schade_cirkel_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    st_buffer(op.geom, gsc.straal::double precision)::geometry(Polygon,28992) AS geom,
    op.opmerking AS locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    gsc.soort,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
     JOIN objecten.gevaarlijkestof_schade_cirkel_type st ON gsc.soort::text = st.naam::text
     JOIN algemeen.vw_styles_ids vsi ON gsc.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_schade_cirkel_ruimtelijk_new;
CREATE VIEW objecten.view_schade_cirkel_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    st_buffer(op.geom, gsc.straal::double precision)::geometry(Polygon,28992) AS geom,
    op.opmerking AS locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    gsc.soort,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
     JOIN objecten.gevaarlijkestof_schade_cirkel_type st ON gsc.soort::text = st.naam::text
     JOIN algemeen.vw_styles_ids vsi ON gsc.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_sectoren_new;
CREATE MATERIALIZED VIEW objecten.mview_sectoren_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.opmerking,
    b.label,
    b.object_id,
    b.fotografie_id,
    b.soort,
    o.formelenaam,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.sectoren b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.sectoren_type st ON b.soort::text = st.naam::text
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN algemeen.vw_styles_ids vsi ON b.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_sectoren_new;
CREATE VIEW objecten.view_sectoren_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.opmerking,
    b.label,
    b.object_id,
    b.fotografie_id,
    b.soort,
    o.formelenaam,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.sectoren b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.sectoren_type st ON b.soort::text = st.naam::text
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN algemeen.vw_styles_ids vsi ON b.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_veiligh_bouwk_new;
CREATE MATERIALIZED VIEW objecten.mview_veiligh_bouwk_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.bouwlaag_id,
    d.fotografie_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.veiligh_bouwk d ON st_intersects(t.geom, d.geom) AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.veiligh_bouwk_type st ON d.soort::text = st.naam::text
     JOIN algemeen.vw_styles_ids vsi ON d.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_veiligh_bouwk_new;
CREATE VIEW objecten.view_veiligh_bouwk_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.bouwlaag_id,
    d.fotografie_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.veiligh_bouwk d ON st_intersects(t.geom, d.geom) AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.veiligh_bouwk_type st ON d.soort::text = st.naam::text
     JOIN algemeen.vw_styles_ids vsi ON d.soort::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_terrein_new;
CREATE MATERIALIZED VIEW objecten.mview_terrein_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.object_id,
    o.formelenaam,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN algemeen.vw_styles_ids vsi ON 'Object terrein'::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

DROP VIEW IF EXISTS objecten.view_terrein_new;
CREATE OR REPLACE VIEW objecten.view_terrein_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
    b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.object_id,
    o.formelenaam,
    vsi.style_ids,
    vsi.styles,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN algemeen.vw_styles_ids vsi ON 'Object terrein'::text = vsi.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_label_ruimtelijk_new;
CREATE MATERIALIZED VIEW objecten.mview_label_ruimtelijk_new
AS 
  WITH base AS (
      SELECT 
          row_number() OVER (ORDER BY b.id) AS gid,
          b.id,
          b.geom,
          b.datum_aangemaakt,
          b.datum_gewijzigd,
          concat(vt.prefix, b.omschrijving)::character varying(254) AS omschrijving,
          replace(concat(vt.prefix, b.omschrijving)::character varying(254)::text, '\'::text, E'\n') AS omschrijving_gs,
          b.opmerking,
          b.rotatie,
          b.bouwlaag_id,
          b.object_id,
          b.soort,
          o.formelenaam,
          round(st_x(b.geom)) AS x,
          round(st_y(b.geom)) AS y,
          CASE
              WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
              WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
              WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
              ELSE NULL::numeric
          END AS size,
          vt.style_ids,
          o.share,
          last_hist.typeobject,
          '#'::text || "right"(s.lijnkleur::text, 6) AS lijnkleur
      FROM objecten.object o
      JOIN objecten.label b ON o.id = b.object_id
      JOIN algemeen.styles s ON b.soort = s.soortnaam
      JOIN objecten.label_type vt ON b.soort::text = vt.naam::text AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
      JOIN LATERAL (
          SELECT h.typeobject, h.status
          FROM objecten.historie h
          WHERE h.object_id = o.id 
            AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
          LIMIT 1
      ) last_hist ON true
      WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL)
        AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
        AND o.self_deleted = 'infinity'::timestamp with time zone
        AND last_hist.status::text = 'in gebruik'::text
  ),
  split_lines AS (
      SELECT base.*, unnest(string_to_array(omschrijving_gs, E'\n')) AS line FROM base
  ),
  line_metrics AS (
      SELECT id, geom, rotatie, size, MAX(char_length(line)) AS max_length, COUNT(*) AS n_lines FROM split_lines
      GROUP BY id, geom, rotatie, size
  ),
  label_boxes AS (
      SELECT
          b.id,
          ST_Rotate(
              ST_MakeEnvelope(
                  ST_X(b.geom) - b.max_length * b.size * 0.3 - 1,
                  ST_Y(b.geom) - b.n_lines * b.size * 1.0 / 2 - 1,
                  ST_X(b.geom) + b.max_length * b.size * 0.3 + 1,
                  ST_Y(b.geom) + b.n_lines * b.size * 1.0 / 2,
                  ST_SRID(b.geom)
              )::geometry,
              radians(360 - COALESCE(b.rotatie,0)),
              b.geom
          ) AS label_box
      FROM line_metrics b
  )
  SELECT base.*, lb.label_box FROM base
  JOIN label_boxes lb USING (id)
WITH DATA;

DROP VIEW IF EXISTS objecten.view_label_ruimtelijk_new;
CREATE VIEW objecten.view_label_ruimtelijk_new
AS 
  WITH base AS (
      SELECT 
          row_number() OVER (ORDER BY b.id) AS gid,
          b.id,
          b.geom,
          b.datum_aangemaakt,
          b.datum_gewijzigd,
          concat(vt.prefix, b.omschrijving)::character varying(254) AS omschrijving,
          replace(concat(vt.prefix, b.omschrijving)::character varying(254)::text, '\'::text, E'\n') AS omschrijving_gs,
          b.opmerking,
          b.rotatie,
          b.bouwlaag_id,
          b.object_id,
          b.soort,
          o.formelenaam,
          round(st_x(b.geom)) AS x,
          round(st_y(b.geom)) AS y,
          CASE
              WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
              WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
              WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
              ELSE NULL::numeric
          END AS size,
          vt.style_ids,
          o.share,
          last_hist.typeobject,
          '#'::text || "right"(s.lijnkleur::text, 6) AS lijnkleur
      FROM objecten.object o
      JOIN objecten.label b ON o.id = b.object_id
      JOIN algemeen.styles s ON b.soort = s.soortnaam
      JOIN objecten.label_type vt ON b.soort::text = vt.naam::text AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
      JOIN LATERAL (
          SELECT h.typeobject, h.status
          FROM objecten.historie h
          WHERE h.object_id = o.id 
            AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
          LIMIT 1
      ) last_hist ON true
      WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL)
        AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
        AND o.self_deleted = 'infinity'::timestamp with time zone
        AND last_hist.status::text = 'in gebruik'::text
  ),
  split_lines AS (
      SELECT base.*, unnest(string_to_array(omschrijving_gs, E'\n')) AS line FROM base
  ),
  line_metrics AS (
      SELECT id, geom, rotatie, size, MAX(char_length(line)) AS max_length, COUNT(*) AS n_lines FROM split_lines
      GROUP BY id, geom, rotatie, size
  ),
  label_boxes AS (
      SELECT
          b.id,
          ST_Rotate(
              ST_MakeEnvelope(
                  ST_X(b.geom) - b.max_length * b.size * 0.3 - 1,
                  ST_Y(b.geom) - b.n_lines * b.size * 1.0 / 2 - 1,
                  ST_X(b.geom) + b.max_length * b.size * 0.3 + 1,
                  ST_Y(b.geom) + b.n_lines * b.size * 1.0 / 2,
                  ST_SRID(b.geom)
              )::geometry,
              radians(360 - COALESCE(b.rotatie,0)),
              b.geom
          ) AS label_box
      FROM line_metrics b
  )
  SELECT base.*, lb.label_box FROM base
  JOIN label_boxes lb USING (id);

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_label_bouwlaag_new;
CREATE MATERIALIZED VIEW objecten.mview_label_bouwlaag_new
AS 
  WITH base AS (
      SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    concat(vt.prefix, d.omschrijving)::character varying(254) AS omschrijving,
    replace(concat(vt.prefix, d.omschrijving)::character varying(254)::text, '\'::text, E'\n') AS omschrijving_gs,
    d.opmerking,
    d.soort,
    d.rotatie,
    d.bouwlaag_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vt.style_ids,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    last_hist.typeobject,
    '#'::text || "right"(s.lijnkleur::text, 6) AS lijnkleur
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.label d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.label_type vt ON d.soort::text = vt.naam::text
     JOIN algemeen.styles s ON d.soort = s.soortnaam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
  ),
  split_lines AS (
      SELECT base.*, unnest(string_to_array(omschrijving_gs, E'\n')) AS line FROM base
  ),
  line_metrics AS (
      SELECT id, geom, rotatie, size, MAX(char_length(line)) AS max_length, COUNT(*) AS n_lines FROM split_lines
      GROUP BY id, geom, rotatie, size
  ),
  label_boxes AS (
      SELECT
          b.id,
          ST_Rotate(
              ST_MakeEnvelope(
                  ST_X(b.geom) - b.max_length * b.size * 0.3 - 1,
                  ST_Y(b.geom) - b.n_lines * b.size * 1.0 / 2 - 1,
                  ST_X(b.geom) + b.max_length * b.size * 0.3 + 1,
                  ST_Y(b.geom) + b.n_lines * b.size * 1.0 / 2,
                  ST_SRID(b.geom)
              )::geometry,
              radians(360 - COALESCE(b.rotatie,0)),
              b.geom
          ) AS label_box
      FROM line_metrics b
  )
  SELECT base.*, lb.label_box FROM base
  JOIN label_boxes lb USING (id)
WITH DATA;

DROP VIEW IF EXISTS objecten.view_label_bouwlaag_new;
CREATE VIEW objecten.view_label_bouwlaag_new
AS 
  WITH base AS (
      SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    concat(vt.prefix, d.omschrijving)::character varying(254) AS omschrijving,
    replace(concat(vt.prefix, d.omschrijving)::character varying(254)::text, '\'::text, E'\n') AS omschrijving_gs,
    d.opmerking,
    d.soort,
    d.rotatie,
    d.bouwlaag_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vt.style_ids,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    last_hist.typeobject,
    '#'::text || "right"(s.lijnkleur::text, 6) AS lijnkleur
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.label d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.label_type vt ON d.soort::text = vt.naam::text
     JOIN algemeen.styles s ON d.soort = s.soortnaam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
  ),
  split_lines AS (
      SELECT base.*, unnest(string_to_array(omschrijving_gs, E'\n')) AS line FROM base
  ),
  line_metrics AS (
      SELECT id, geom, rotatie, size, MAX(char_length(line)) AS max_length, COUNT(*) AS n_lines FROM split_lines
      GROUP BY id, geom, rotatie, size
  ),
  label_boxes AS (
      SELECT
          b.id,
          ST_Rotate(
              ST_MakeEnvelope(
                  ST_X(b.geom) - b.max_length * b.size * 0.3 - 1,
                  ST_Y(b.geom) - b.n_lines * b.size * 1.0 / 2 - 1,
                  ST_X(b.geom) + b.max_length * b.size * 0.3 + 1,
                  ST_Y(b.geom) + b.n_lines * b.size * 1.0 / 2,
                  ST_SRID(b.geom)
              )::geometry,
              radians(360 - COALESCE(b.rotatie,0)),
              b.geom
          ) AS label_box
      FROM line_metrics b
  )
  SELECT base.*, lb.label_box FROM base
  JOIN label_boxes lb USING (id);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 7;
UPDATE algemeen.applicatie SET revisie = 1;
UPDATE algemeen.applicatie SET db_versie = 3701; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
