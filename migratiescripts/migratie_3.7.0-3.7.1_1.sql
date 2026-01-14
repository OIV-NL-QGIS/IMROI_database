SET ROLE oiv_admin;

UPDATE objecten.veiligh_install_type SET naam='Eerste hulp', symbol_name='vvz036', symbol_svg_png='svg' WHERE naam='ehbo';

UPDATE objecten.veiligh_install_type SET symbol_type = NULL WHERE symbol_svg_png = 'png';
UPDATE objecten.sleutelkluis_type SET symbol_type = NULL WHERE symbol_svg_png = 'png';
UPDATE objecten.scenario_locatie_type SET symbol_type = NULL WHERE symbol_svg_png = 'png';
UPDATE objecten.points_of_interest_type SET symbol_type = NULL WHERE symbol_svg_png = 'png';
UPDATE objecten.opstelplaats_type SET symbol_type = NULL WHERE symbol_svg_png = 'png';
UPDATE objecten.ingang_type SET symbol_type = NULL WHERE symbol_svg_png = 'png';
UPDATE objecten.gevaarlijkestof_opslag_type SET symbol_type = NULL WHERE symbol_svg_png = 'png';
UPDATE objecten.dreiging_type SET symbol_type = NULL WHERE symbol_svg_png = 'png';
UPDATE objecten.afw_binnendekking_type SET symbol_type = NULL WHERE symbol_svg_png = 'png';

DROP VIEW IF EXISTS objecten.view_afw_binnendekking_new;
CREATE OR REPLACE VIEW objecten.view_afw_binnendekking_new AS
SELECT 
    row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.opmerking,
    d.bouwlaag_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    concat_ws('_', dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
    CASE d.formaat_bouwlaag
        WHEN 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
        WHEN 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
        WHEN 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
        ELSE NULL::numeric
    END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden') AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    dt.symbol_svg_png,
    last_hist.typeobject
FROM objecten.object o
JOIN LATERAL (
    SELECT h.typeobject, h.status FROM objecten.historie h WHERE h.object_id = o.id AND h.parent_deleted = 'infinity' ORDER BY h.datum_aangemaakt DESC LIMIT 1) last_hist ON TRUE
JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity' AND t.self_deleted = 'infinity'
JOIN objecten.bouwlagen b ON ST_Intersects(t.geom, b.geom)
JOIN objecten.afw_binnendekking d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity' AND d.self_deleted = 'infinity'
JOIN objecten.afw_binnendekking_type dt ON d.soort::text = dt.naam::text
WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND last_hist.status = 'in gebruik';

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_afw_binnendekking_new;
CREATE MATERIALIZED VIEW objecten.mview_afw_binnendekking_new AS
    SELECT 
        row_number() OVER (ORDER BY d.id) AS gid,
        d.id,
        d.geom,
        d.datum_aangemaakt,
        d.datum_gewijzigd,
        d.soort,
        d.rotatie,
        d.label,
        d.opmerking,
        d.bouwlaag_id,
        o.formelenaam,
        o.id AS object_id,
        b.bouwlaag,
        b.bouwdeel,
        concat_ws('_', dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
        CASE d.formaat_bouwlaag
            WHEN 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
        o.share,
        COALESCE(d.label_positie, 'onder - midden') AS label_positie,
        CASE
            WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
            WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
            ELSE 0
        END AS dx_factor,
        CASE
            WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
            WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
            ELSE 0
        END AS dy_factor,
        CASE
            WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
            WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
            ELSE 0.5
        END AS anch_x,
        dt.symbol_svg_png,
        last_hist.typeobject
    FROM objecten.object o
    JOIN LATERAL (
        SELECT h.typeobject, h.status FROM objecten.historie h WHERE h.object_id = o.id AND h.parent_deleted = 'infinity' ORDER BY h.datum_aangemaakt DESC LIMIT 1) last_hist ON TRUE
    JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity' AND t.self_deleted = 'infinity'
    JOIN objecten.bouwlagen b ON ST_Intersects(t.geom, b.geom)
    JOIN objecten.afw_binnendekking d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity' AND d.self_deleted = 'infinity'
    JOIN objecten.afw_binnendekking_type dt ON d.soort::text = dt.naam::text
    WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND last_hist.status = 'in gebruik'
WITH DATA;

DROP VIEW IF EXISTS objecten.view_dreiging_bouwlaag_new;
CREATE OR REPLACE VIEW objecten.view_dreiging_bouwlaag_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.opmerking,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    concat_ws('_', dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    dt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.dreiging d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.dreiging_type dt ON d.soort::text = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_dreiging_bouwlaag_new;
CREATE MATERIALIZED VIEW objecten.mview_dreiging_bouwlaag_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.opmerking,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    concat_ws('_', dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    dt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.dreiging d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.dreiging_type dt ON d.soort::text = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_dreiging_ruimtelijk_new;
CREATE OR REPLACE VIEW objecten.view_dreiging_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.rotatie,
    b.label,
    b.opmerking,
    b.bouwlaag_id,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    concat_ws('_', vt.symbol_name, vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    vt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.dreiging b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.dreiging_type vt ON b.soort::text = vt.naam
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_dreiging_ruimtelijk_new;
CREATE MATERIALIZED VIEW objecten.mview_dreiging_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.rotatie,
    b.label,
    b.opmerking,
    b.bouwlaag_id,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    concat_ws('_', vt.symbol_name, vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    vt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.dreiging b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.dreiging_type vt ON b.soort::text = vt.naam
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::TEXT;

DROP VIEW IF EXISTS objecten.view_gevaarlijkestof_bouwlaag_new;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_bouwlaag_new
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
    op.geom,
    op.opmerking AS locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    concat_ws('_', st.symbol_name, st.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN op.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN op.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    st.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.gevaarlijkestof_opslag op ON op.bouwlaag_id = b.id AND op.parent_deleted = 'infinity'::timestamp with time zone AND op.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof_opslag_type st ON op.soort::text = st.naam
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_gevaarlijkestof_bouwlaag_new;
CREATE MATERIALIZED VIEW objecten.mview_gevaarlijkestof_bouwlaag_new
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
    op.geom,
    op.opmerking AS locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    concat_ws('_', st.symbol_name, st.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN op.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN op.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    st.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.gevaarlijkestof_opslag op ON op.bouwlaag_id = b.id AND op.parent_deleted = 'infinity'::timestamp with time zone AND op.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof_opslag_type st ON op.soort::text = st.naam
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_gevaarlijkestof_ruimtelijk_new;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_ruimtelijk_new
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
    op.geom,
    op.opmerking AS locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    concat_ws('_', st.symbol_name, st.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN op.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN op.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    st.symbol_svg_png,
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
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_gevaarlijkestof_ruimtelijk_new;
CREATE MATERIALIZED VIEW objecten.mview_gevaarlijkestof_ruimtelijk_new
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
    op.geom,
    op.opmerking AS locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    concat_ws('_', st.symbol_name, st.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN op.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN op.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    st.symbol_svg_png,
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
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_ingang_bouwlaag_new;
CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.opmerking,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    concat_ws('_', dt.symbol_name, dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    dt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.ingang d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.ingang_type dt ON d.soort::text = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_ingang_bouwlaag_new;
CREATE MATERIALIZED VIEW objecten.mview_ingang_bouwlaag_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.opmerking,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    concat_ws('_', dt.symbol_name, dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    dt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.ingang d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.ingang_type dt ON d.soort::text = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_ingang_ruimtelijk_new;
CREATE OR REPLACE VIEW objecten.view_ingang_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.rotatie,
    b.label,
    b.opmerking,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    concat_ws('_', vt.symbol_name, vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    vt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.ingang b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.ingang_type vt ON b.soort::text = vt.naam
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_ingang_ruimtelijk_new;
CREATE MATERIALIZED VIEW objecten.mview_ingang_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.rotatie,
    b.label,
    b.opmerking,
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    concat_ws('_', vt.symbol_name, vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    vt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.ingang b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.ingang_type vt ON b.soort::text = vt.naam
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_opstelplaats_new;
CREATE OR REPLACE VIEW objecten.view_opstelplaats_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.rotatie,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    b.opmerking,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    concat_ws('_', vt.symbol_name, vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    vt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.opstelplaats b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.opstelplaats_type vt ON b.soort::text = vt.naam::text
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_opstelplaats_new;
CREATE MATERIALIZED VIEW objecten.mview_opstelplaats_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.rotatie,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    b.opmerking,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    concat_ws('_', vt.symbol_name, vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    vt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.opstelplaats b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.opstelplaats_type vt ON b.soort::text = vt.naam::text
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_points_of_interest_new;
CREATE OR REPLACE VIEW objecten.view_points_of_interest_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    b.opmerking,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    concat_ws('_', vt.symbol_name, vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    vt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.points_of_interest b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.points_of_interest_type vt ON b.soort::text = vt.naam
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_points_of_interest_new;
CREATE MATERIALIZED VIEW objecten.mview_points_of_interest_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    b.opmerking,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    concat_ws('_', vt.symbol_name, vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    vt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.points_of_interest b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.points_of_interest_type vt ON b.soort::text = vt.naam
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_scenario_bouwlaag_new;
CREATE OR REPLACE VIEW objecten.view_scenario_bouwlaag_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.soort AS locatie_type,
    d.omschrijving,
    d.soort,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.opmerking,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    concat_ws('_', slt.symbol_name, slt.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_bouwlaag = 'klein'::algemeen.formaat THEN slt.size_bouwlaag_klein
            WHEN op.formaat_bouwlaag = 'middel'::algemeen.formaat THEN slt.size_bouwlaag_middel
            WHEN op.formaat_bouwlaag = 'groot'::algemeen.formaat THEN slt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    slt.symbol_svg_png,
    last_hist.typeobject,
    b.bouwlaag,
    b.id AS bouwlaag_id
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.scenario_locatie op ON op.bouwlaag_id = b.id AND op.parent_deleted = 'infinity'::timestamp with time zone AND op.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.scenario_locatie_type slt ON op.soort::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.soort::text = st.naam
     LEFT JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_scenario_bouwlaag_new;
CREATE MATERIALIZED VIEW objecten.mview_scenario_bouwlaag_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.soort AS locatie_type,
    d.omschrijving,
    d.soort,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.opmerking,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    concat_ws('_', slt.symbol_name, slt.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_bouwlaag = 'klein'::algemeen.formaat THEN slt.size_bouwlaag_klein
            WHEN op.formaat_bouwlaag = 'middel'::algemeen.formaat THEN slt.size_bouwlaag_middel
            WHEN op.formaat_bouwlaag = 'groot'::algemeen.formaat THEN slt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    slt.symbol_svg_png,
    last_hist.typeobject,
    b.bouwlaag,
    b.id AS bouwlaag_id
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.scenario_locatie op ON op.bouwlaag_id = b.id AND op.parent_deleted = 'infinity'::timestamp with time zone AND op.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.scenario_locatie_type slt ON op.soort::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.soort::text = st.naam
     LEFT JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_scenario_ruimtelijk_new;
CREATE OR REPLACE VIEW objecten.view_scenario_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.soort AS locatie_type,
    d.omschrijving,
    d.soort,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.opmerking,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    concat_ws('_', slt.symbol_name, slt.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_object = 'klein'::algemeen.formaat THEN slt.size_object_klein
            WHEN op.formaat_object = 'middel'::algemeen.formaat THEN slt.size_object_middel
            WHEN op.formaat_object = 'groot'::algemeen.formaat THEN slt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    slt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.scenario_locatie op ON o.id = op.object_id
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.scenario_locatie_type slt ON op.soort::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.soort::text = st.naam
     LEFT JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_scenario_ruimtelijk_new;
CREATE MATERIALIZED VIEW objecten.mview_scenario_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.soort AS locatie_type,
    d.omschrijving,
    d.soort,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.opmerking,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    concat_ws('_', slt.symbol_name, slt.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_object = 'klein'::algemeen.formaat THEN slt.size_object_klein
            WHEN op.formaat_object = 'middel'::algemeen.formaat THEN slt.size_object_middel
            WHEN op.formaat_object = 'groot'::algemeen.formaat THEN slt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    slt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.scenario_locatie op ON o.id = op.object_id
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.scenario_locatie_type slt ON op.soort::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.soort::text = st.naam
     LEFT JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_sleutelkluis_bouwlaag_new;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.opmerking,
    d.sleuteldoel,
    d.rotatie,
    d.label,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    d.bouwlaag_id,
    concat_ws('_', st.symbol_name, st.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    st.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.sleutelkluis d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.sleutelkluis_type st ON d.soort::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_sleutelkluis_bouwlaag_new;
CREATE MATERIALIZED VIEW objecten.mview_sleutelkluis_bouwlaag_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.opmerking,
    d.sleuteldoel,
    d.rotatie,
    d.label,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    d.bouwlaag_id,
    concat_ws('_', st.symbol_name, st.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    st.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.sleutelkluis d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.sleutelkluis_type st ON d.soort::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_sleutelkluis_ruimtelijk_new;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.opmerking,
    d.sleuteldoel,
    d.rotatie,
    d.label,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    d.object_id,
    concat_ws('_', st.symbol_name, st.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN d.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN d.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    st.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.sleutelkluis d ON o.id = d.object_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.sleutelkluis_type st ON d.soort::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_sleutelkluis_ruimtelijk_new;
CREATE MATERIALIZED VIEW objecten.mview_sleutelkluis_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.opmerking,
    d.sleuteldoel,
    d.rotatie,
    d.label,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    d.object_id,
    concat_ws('_', st.symbol_name, st.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN d.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN d.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    st.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.sleutelkluis d ON o.id = d.object_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.sleutelkluis_type st ON d.soort::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_veiligh_install_new;
CREATE OR REPLACE VIEW objecten.view_veiligh_install_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    d.opmerking,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    concat_ws('_', dt.symbol_name, dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    dt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.veiligh_install d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.veiligh_install_type dt ON d.soort::text = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_veiligh_install_new;
CREATE MATERIALIZED VIEW objecten.mview_veiligh_install_new
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    d.opmerking,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    concat_ws('_', dt.symbol_name, dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    dt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.veiligh_install d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.veiligh_install_type dt ON d.soort::text = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_veiligh_ruimtelijk_new;
CREATE OR REPLACE VIEW objecten.view_veiligh_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.opmerking,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    concat_ws('_', vt.symbol_name, vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    vt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.veiligh_install b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.veiligh_install_type vt ON b.soort::text = vt.naam
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_veiligh_ruimtelijk_new;
CREATE MATERIALIZED VIEW objecten.mview_veiligh_ruimtelijk_new
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.opmerking,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    concat_ws('_', vt.symbol_name, vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    vt.symbol_svg_png,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.veiligh_install b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.veiligh_install_type vt ON b.soort::text = vt.naam
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

DROP VIEW IF EXISTS objecten.view_objectgegevens_new;
CREATE VIEW objecten.view_objectgegevens_new
AS SELECT row_number() OVER (ORDER BY o.id) AS gid,
    o.id,
    o.formelenaam,
    o.geom,
    o.basisreg_identifier,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.bijzonderheden,
    o.pers_max,
    o.pers_nietz_max,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.bron,
    o.bron_tabel,
    o.fotografie_id,
    bg.naam AS bodemgesteldheid,
    o.min_bouwlaag,
    o.max_bouwlaag,
    gf.gebruiksfuncties,
    round(st_x(o.geom)) AS x,
    round(st_y(o.geom)) AS y,
    o.share,
    dt.size,
    0 AS dx_factor,
    '-0.6'::numeric AS dy_factor,
    0.5 AS anch_x,
    dt.symbol_svg_png,
    concat_ws('_'::text, dt.symbol_name, dt.symbol_type) AS symbol_name,
    last_hist.typeobject
   FROM objecten.object o
     LEFT JOIN objecten.bodemgesteldheid_type bg ON o.bodemgesteldheid_type_id = bg.id
     LEFT JOIN ( SELECT DISTINCT g.object_id,
            string_agg(gt.naam, ', '::text) AS gebruiksfuncties
           FROM objecten.gebruiksfunctie g
             JOIN objecten.gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
          GROUP BY g.object_id) gf ON o.id = gf.object_id
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     LEFT JOIN objecten.object_type dt ON last_hist.typeobject::text = dt.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

DROP MATERIALIZED VIEW IF EXISTS objecten.mview_objectgegevens_new;
CREATE MATERIALIZED VIEW objecten.mview_objectgegevens_new
AS SELECT row_number() OVER (ORDER BY o.id) AS gid,
    o.id,
    o.formelenaam,
    o.geom,
    o.basisreg_identifier,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.bijzonderheden,
    o.pers_max,
    o.pers_nietz_max,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.bron,
    o.bron_tabel,
    o.fotografie_id,
    bg.naam AS bodemgesteldheid,
    o.min_bouwlaag,
    o.max_bouwlaag,
    gf.gebruiksfuncties,
    round(st_x(o.geom)) AS x,
    round(st_y(o.geom)) AS y,
    o.share,
    dt.size,
    0 AS dx_factor,
    '-0.6'::numeric AS dy_factor,
    0.5 AS anch_x,
    dt.symbol_svg_png,
    concat_ws('_'::text, dt.symbol_name, dt.symbol_type) AS symbol_name,
    last_hist.typeobject
   FROM objecten.object o
     LEFT JOIN objecten.bodemgesteldheid_type bg ON o.bodemgesteldheid_type_id = bg.id
     LEFT JOIN ( SELECT DISTINCT g.object_id,
            string_agg(gt.naam, ', '::text) AS gebruiksfuncties
           FROM objecten.gebruiksfunctie g
             JOIN objecten.gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
          GROUP BY g.object_id) gf ON o.id = gf.object_id
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     LEFT JOIN objecten.object_type dt ON last_hist.typeobject::text = dt.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text
WITH DATA;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 7;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 3702; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();