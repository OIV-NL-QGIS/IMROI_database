SET ROLE oiv_admin;

ALTER TABLE objecten.afw_binnendekking_type ADD COLUMN symbol_svg_png varchar(5);
ALTER TABLE objecten.dreiging_type ADD COLUMN symbol_svg_png varchar(5);
ALTER TABLE objecten.gevaarlijkestof_opslag_type ADD COLUMN symbol_svg_png varchar(5);
ALTER TABLE objecten.ingang_type ADD COLUMN symbol_svg_png varchar(5);
ALTER TABLE objecten.opstelplaats_type ADD COLUMN symbol_svg_png varchar(5);
ALTER TABLE objecten.points_of_interest_type ADD COLUMN symbol_svg_png varchar(5);
ALTER TABLE objecten.scenario_locatie_type ADD COLUMN symbol_svg_png varchar(5);
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN symbol_svg_png varchar(5);
ALTER TABLE objecten.veiligh_install_type ADD COLUMN symbol_svg_png varchar(5);
ALTER TABLE bluswater.alternatieve_type ADD COLUMN symbol_svg_png varchar(5);
ALTER TABLE objecten.object_type ADD COLUMN symbol_svg_png varchar(5);

UPDATE objecten.object_type SET symbol_svg_png = CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;
UPDATE objecten.afw_binnendekking_type SET symbol_svg_png =	CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;
UPDATE objecten.dreiging_type SET symbol_svg_png = CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;
UPDATE objecten.gevaarlijkestof_opslag_type SET symbol_svg_png = CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;
UPDATE objecten.ingang_type SET symbol_svg_png = CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;
UPDATE objecten.opstelplaats_type SET symbol_svg_png = CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;
UPDATE objecten.points_of_interest_type SET symbol_svg_png = CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;
UPDATE objecten.scenario_locatie_type SET symbol_svg_png = CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;
UPDATE objecten.sleutelkluis_type SET symbol_svg_png = CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;
UPDATE objecten.veiligh_install_type SET symbol_svg_png = CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;
UPDATE bluswater.alternatieve_type SET symbol_svg_png = CASE WHEN symbol_name ~ '[a-z]{3}[0-9]{3}' THEN 'svg' ELSE 'png' END;

UPDATE algemeen.symbols_new SET base64_prefix = 'data:image/svg+xml;base64,';

INSERT INTO algemeen.symbols_new (symbol_name, symbol, base64_prefix)
SELECT sub.symbol_name, s.symbol, 'data:image/png;base64,'
FROM
(
SELECT symbol_name FROM objecten.object_type WHERE symbol_svg_png = 'png' 
UNION
 SELECT symbol_name FROM objecten.afw_binnendekking_type WHERE symbol_svg_png = 'png' 
UNION
 SELECT symbol_name FROM objecten.dreiging_type WHERE symbol_svg_png = 'png' 
UNION
 SELECT symbol_name FROM objecten.gevaarlijkestof_opslag_type WHERE symbol_svg_png = 'png' 
UNION
 SELECT symbol_name FROM objecten.ingang_type WHERE symbol_svg_png = 'png' 
UNION
 SELECT symbol_name FROM objecten.opstelplaats_type WHERE symbol_svg_png = 'png' 
UNION
 SELECT symbol_name FROM objecten.points_of_interest_type WHERE symbol_svg_png = 'png' 
UNION
 SELECT symbol_name FROM objecten.scenario_locatie_type WHERE symbol_svg_png = 'png' 
UNION
 SELECT symbol_name FROM objecten.sleutelkluis_type WHERE symbol_svg_png = 'png' 
UNION
 SELECT symbol_name FROM objecten.veiligh_install_type WHERE symbol_svg_png = 'png' 
UNION
 SELECT symbol_name FROM bluswater.alternatieve_type WHERE symbol_svg_png = 'png' ) sub
JOIN algemeen.symbols s ON sub.symbol_name = s.symbol_name;

DROP TABLE algemeen.symbols;
ALTER TABLE algemeen.symbols_new RENAME TO symbols;

DELETE FROM algemeen.symbols WHERE symbol_name = 'scenario_locatie' AND base64_prefix = 'data:image/svg+xml;base64,';

CREATE INDEX idx_symbol_name ON algemeen.symbols USING btree (symbol_name);
CREATE UNIQUE INDEX uidx_symbol_name ON algemeen.symbols USING btree (symbol_name);

CREATE INDEX ON objecten.historie (object_id, datum_aangemaakt DESC);

DROP VIEW IF EXISTS objecten.view_afw_binnendekking;
CREATE OR REPLACE VIEW objecten.view_afw_binnendekking AS
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
    concat(dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
    CASE d.formaat_bouwlaag
        WHEN 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
        WHEN 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
        WHEN 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
        ELSE NULL::numeric
    END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden') AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_afw_binnendekking AS
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
    concat(dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
    CASE d.formaat_bouwlaag
        WHEN 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
        WHEN 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
        WHEN 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
        ELSE NULL::numeric
    END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden') AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_afw_binnendekking (gid);
CREATE INDEX mview_afw_binnendekking_geom_idx ON objecten.mview_afw_binnendekking USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_bedrijfshulpverlening;
CREATE OR REPLACE VIEW objecten.view_bedrijfshulpverlening
AS SELECT 
	row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.ademluchtdragend,
    b.object_id,
    o.formelenaam,
    o.share
   FROM objecten.object o
    JOIN objecten.bedrijfshulpverlening b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
	JOIN LATERAL (
    	SELECT h.typeobject, h.status FROM objecten.historie h WHERE h.object_id = o.id AND h.parent_deleted = 'infinity' ORDER BY h.datum_aangemaakt DESC LIMIT 1) last_hist ON TRUE
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
        AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status = 'in gebruik';

CREATE MATERIALIZED VIEW objecten.mview_bedrijfshulpverlening
AS SELECT 
	row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.ademluchtdragend,
    b.object_id,
    o.formelenaam,
    o.share
   FROM objecten.object o
    JOIN objecten.bedrijfshulpverlening b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
	JOIN LATERAL (
    	SELECT h.typeobject, h.status FROM objecten.historie h WHERE h.object_id = o.id AND h.parent_deleted = 'infinity' ORDER BY h.datum_aangemaakt DESC LIMIT 1) last_hist ON TRUE
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
        AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status = 'in gebruik';

CREATE UNIQUE INDEX ON objecten.mview_bedrijfshulpverlening (gid);

DROP VIEW IF EXISTS objecten.view_bereikbaarheid;
CREATE OR REPLACE VIEW objecten.view_bereikbaarheid
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
    st.style_ids,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.bereikbaarheid b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.bereikbaarheid_type st ON b.soort::text = st.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
        AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status = 'in gebruik';

CREATE MATERIALIZED VIEW objecten.mview_bereikbaarheid
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
    st.style_ids,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.bereikbaarheid b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.bereikbaarheid_type st ON b.soort::text = st.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
        AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status = 'in gebruik';

CREATE UNIQUE INDEX ON objecten.mview_bereikbaarheid (gid);
CREATE INDEX mview_bereikbaarheid_geom_idx ON objecten.mview_bereikbaarheid USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_bouwlagen;
CREATE OR REPLACE VIEW objecten.view_bouwlagen
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
    '1'::text AS style_ids,
    o.share
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.self_deleted = 'infinity'::timestamp with time ZONE AND t.parent_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen d ON st_intersects(t.geom, d.geom) AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN ( SELECT bouwlagen.pand_id,
            max(bouwlagen.bouwlaag) AS hoogste_bouwlaag,
            min(bouwlagen.bouwlaag) AS laagste_bouwlaag
           FROM objecten.bouwlagen
          GROUP BY bouwlagen.pand_id) sub ON d.pand_id::text = sub.pand_id::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_bouwlagen
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
    '1'::text AS style_ids,
    o.share
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     JOIN objecten.terrein t ON o.id = t.object_id AND t.self_deleted = 'infinity'::timestamp with time ZONE AND t.parent_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen d ON st_intersects(t.geom, d.geom) AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN ( SELECT bouwlagen.pand_id,
            max(bouwlagen.bouwlaag) AS hoogste_bouwlaag,
            min(bouwlagen.bouwlaag) AS laagste_bouwlaag
           FROM objecten.bouwlagen
          GROUP BY bouwlagen.pand_id) sub ON d.pand_id::text = sub.pand_id::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_bouwlagen (gid);
CREATE INDEX mview_bouwlagen_geom_idx ON objecten.mview_bouwlagen USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_contactpersoon;
CREATE OR REPLACE VIEW objecten.view_contactpersoon
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.object_id,
    b.soort,
    o.formelenaam,
    o.share
   FROM objecten.object o
     JOIN objecten.contactpersoon b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_contactpersoon
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.object_id,
    b.soort,
    o.formelenaam,
    o.share
   FROM objecten.object o
     JOIN objecten.contactpersoon b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_contactpersoon (gid);

DROP VIEW IF EXISTS objecten.view_dreiging_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_dreiging_bouwlaag
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
    concat(dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_dreiging_bouwlaag
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
    concat(dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_dreiging_bouwlaag (gid);
CREATE INDEX mview_dreiging_bouwlaag_geom_idx ON objecten.mview_dreiging_bouwlaag USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_dreiging_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_dreiging_ruimtelijk
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_dreiging_ruimtelijk
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_dreiging_ruimtelijk (gid);
CREATE INDEX mview_dreiging_ruimtelijk_geom_idx ON objecten.mview_dreiging_ruimtelijk USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_gebiedsgerichte_aanpak;
CREATE OR REPLACE VIEW objecten.view_gebiedsgerichte_aanpak
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
    st.style_ids,
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_gebiedsgerichte_aanpak
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
    st.style_ids,
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) 
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_gebiedsgerichte_aanpak (gid);
CREATE INDEX mview_gebiedsgerichte_aanpak_geom_idx ON objecten.mview_gebiedsgerichte_aanpak USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_gevaarlijkestof_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_bouwlaag
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
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN op.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN op.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_gevaarlijkestof_bouwlaag
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
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN op.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN op.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_gevaarlijkestof_bouwlaag (gid);
CREATE INDEX mview_gevaarlijkestof_bouwlaag_geom_idx ON objecten.mview_gevaarlijkestof_bouwlaag USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_gevaarlijkestof_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_ruimtelijk
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
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN op.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN op.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_gevaarlijkestof_ruimtelijk
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
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN op.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN op.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN op.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    op.label,
    COALESCE(op.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_gevaarlijkestof_ruimtelijk (gid);
CREATE INDEX mview_gevaarlijkestof_ruimtelijk_geom_idx ON objecten.mview_gevaarlijkestof_ruimtelijk USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_grid;
CREATE OR REPLACE VIEW objecten.view_grid
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
    31 AS style_ids,
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_grid
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
    31 AS style_ids,
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_grid (gid);
CREATE INDEX mview_grid_geom_idx ON objecten.mview_grid USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_ingang_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag
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
    concat(dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_ingang_bouwlaag
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
    concat(dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_ingang_bouwlaag (gid);
CREATE INDEX mview_ingang_bouwlaag_geom_idx ON objecten.mview_ingang_bouwlaag USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_ingang_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_ingang_ruimtelijk
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_ingang_ruimtelijk
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_ingang_ruimtelijk (gid);
CREATE INDEX mview_ingang_ruimtelijk_geom_idx ON objecten.mview_ingang_ruimtelijk USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_isolijnen;
CREATE OR REPLACE VIEW objecten.view_isolijnen
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.hoogte,
    b.opmerking AS omschrijving,
    b.object_id,
    o.formelenaam,
    st.style_ids,
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_isolijnen
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.hoogte,
    b.opmerking AS omschrijving,
    b.object_id,
    o.formelenaam,
    st.style_ids,
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
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_isolijnen (gid);
CREATE INDEX mview_isolijnen_geom_idx ON objecten.mview_isolijnen USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_label_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_label_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    concat(vt.prefix, d.omschrijving)::character varying(254) AS omschrijving,
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
    o.SHARE,
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
     JOIN objecten.label d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.label_type vt ON d.soort::text = vt.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_label_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    concat(vt.prefix, d.omschrijving)::character varying(254) AS omschrijving,
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
    o.SHARE,
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
     JOIN objecten.label d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.label_type vt ON d.soort::text = vt.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_label_bouwlaag (gid);
CREATE INDEX mview_label_bouwlaag_geom_idx ON objecten.mview_label_bouwlaag USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_label_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_label_ruimtelijk
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    concat(vt.prefix, b.omschrijving)::character varying(254) AS omschrijving,
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
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.label b ON o.id = b.object_id
     JOIN objecten.label_type vt ON b.soort::text = vt.naam::text AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_label_ruimtelijk
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    concat(vt.prefix, b.omschrijving)::character varying(254) AS omschrijving,
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
    last_hist.typeobject
   FROM objecten.object o
     JOIN objecten.label b ON o.id = b.object_id
     JOIN objecten.label_type vt ON b.soort::text = vt.naam::text AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_label_ruimtelijk (gid);
CREATE INDEX mview_label_ruimtelijk_geom_idx ON objecten.mview_label_ruimtelijk USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_objectgegevens;
CREATE OR REPLACE VIEW objecten.view_objectgegevens
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
    o.SHARE,
    dt.SIZE,
    concat(dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
    dt.symbol_svg_png,
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
         LIMIT 1) last_hist ON TRUE
     LEFT JOIN objecten.object_type dt ON last_hist.typeobject = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_objectgegevens
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
    o.SHARE,
    dt.SIZE,
    concat(dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
    dt.symbol_svg_png,
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
         LIMIT 1) last_hist ON TRUE
     LEFT JOIN objecten.object_type dt ON last_hist.typeobject = dt.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_objectgegevens (gid);
CREATE INDEX mview_objectgegevens_geom_idx ON objecten.mview_objectgegevens USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_opstelplaats;
CREATE OR REPLACE VIEW objecten.view_opstelplaats
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_opstelplaats
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_opstelplaats (gid);
CREATE INDEX mview_opstelplaats_geom_idx ON objecten.mview_opstelplaats USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_points_of_interest;
CREATE OR REPLACE VIEW objecten.view_points_of_interest
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_points_of_interest
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_points_of_interest (gid);
CREATE INDEX mview_points_of_interest_geom_idx ON objecten.mview_points_of_interest USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_ruimten;
CREATE OR REPLACE VIEW objecten.view_ruimten
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
    st.style_ids,
    o.SHARE,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.ruimten d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.ruimten_type st ON d.soort = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_ruimten
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
    st.style_ids,
    o.SHARE,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.ruimten d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.ruimten_type st ON d.soort = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_ruimten (gid);
CREATE INDEX mview_ruimten_geom_idx ON objecten.mview_ruimten USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_scenario_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_scenario_bouwlaag
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
    concat(slt.symbol_name, '_', slt.symbol_type) AS symbol_name,
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
    slt.symbol_svg_png,
    last_hist.typeobject,
    b.bouwlaag
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

CREATE MATERIALIZED VIEW objecten.mview_scenario_bouwlaag
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
    concat(slt.symbol_name, '_', slt.symbol_type) AS symbol_name,
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
    slt.symbol_svg_png,
    last_hist.typeobject,
    b.bouwlaag
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

CREATE UNIQUE INDEX ON objecten.mview_scenario_bouwlaag (gid);
CREATE INDEX mview_scenario_bouwlaag_geom_idx ON objecten.mview_scenario_bouwlaag USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_scenario_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_scenario_ruimtelijk
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
    concat(slt.symbol_name, '_', slt.symbol_type) AS symbol_name,
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

CREATE MATERIALIZED VIEW objecten.mview_scenario_ruimtelijk
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
    concat(slt.symbol_name, '_', slt.symbol_type) AS symbol_name,
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

CREATE UNIQUE INDEX ON objecten.mview_scenario_ruimtelijk (gid);
CREATE INDEX mview_scenario_ruimtelijk_geom_idx ON objecten.mview_scenario_ruimtelijk USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_schade_cirkel_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_schade_cirkel_bouwlaag
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
    st.style_ids,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.terrein t ON o.id = t.object_id AND t.self_deleted = 'infinity'::timestamp with time zone AND t.parent_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
     JOIN objecten.gevaarlijkestof_schade_cirkel_type st ON gsc.soort::text = st.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_schade_cirkel_bouwlaag
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
    st.style_ids,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.terrein t ON o.id = t.object_id AND t.self_deleted = 'infinity'::timestamp with time zone AND t.parent_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
     JOIN objecten.gevaarlijkestof_schade_cirkel_type st ON gsc.soort::text = st.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_schade_cirkel_bouwlaag (gid);
CREATE INDEX mview_schade_cirkel_bouwlaag_geom_idx ON objecten.mview_schade_cirkel_bouwlaag USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_schade_cirkel_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_schade_cirkel_ruimtelijk
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
    st.style_ids,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
     JOIN objecten.gevaarlijkestof_schade_cirkel_type st ON gsc.soort::text = st.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_schade_cirkel_ruimtelijk
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
    st.style_ids,
    o.share,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
     JOIN objecten.gevaarlijkestof_schade_cirkel_type st ON gsc.soort::text = st.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_schade_cirkel_ruimtelijk (gid);
CREATE INDEX mview_schade_cirkel_ruimtelijk_geom_idx ON objecten.mview_schade_cirkel_ruimtelijk USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_sectoren;
CREATE OR REPLACE VIEW objecten.view_sectoren
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
    st.style_ids,
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
         LIMIT 1) last_hist ON TRUE
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_sectoren
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
    st.style_ids,
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
         LIMIT 1) last_hist ON TRUE
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_sectoren (gid);
CREATE INDEX mview_sectoren_geom_idx ON objecten.mview_sectoren USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_sleutelkluis_bouwlaag;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag
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
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_sleutelkluis_bouwlaag
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
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_sleutelkluis_bouwlaag (gid);
CREATE INDEX mview_sleutelkluis_bouwlaag_geom_idx ON objecten.mview_sleutelkluis_bouwlaag USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_sleutelkluis_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_ruimtelijk
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
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN d.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN d.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_sleutelkluis_ruimtelijk
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
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN d.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN d.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_sleutelkluis_ruimtelijk (gid);
CREATE INDEX mview_sleutelkluis_ruimtelijk_geom_idx ON objecten.mview_sleutelkluis_ruimtelijk USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_terrein;
CREATE OR REPLACE VIEW objecten.view_terrein
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.object_id,
    o.formelenaam,
    o.SHARE,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
         JOIN objecten.terrein b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_terrein
AS SELECT row_number() OVER (ORDER BY b.id) AS gid,
	b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.object_id,
    o.formelenaam,
    o.SHARE,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
         JOIN objecten.terrein b ON o.id = b.object_id AND b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_terrein (gid);
CREATE INDEX mview_terrein_geom_idx ON objecten.mview_terrein USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_veiligh_bouwk;
CREATE OR REPLACE VIEW objecten.view_veiligh_bouwk
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
    st.style_ids,
    o.SHARE,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.veiligh_bouwk d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.veiligh_bouwk_type st ON d.soort::text = st.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE MATERIALIZED VIEW objecten.mview_veiligh_bouwk
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
    st.style_ids,
    o.SHARE,
    last_hist.typeobject
   FROM objecten.object o
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON TRUE
     JOIN objecten.terrein t ON o.id = t.object_id AND t.parent_deleted = 'infinity'::timestamp with time zone AND t.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.bouwlagen b ON st_intersects(t.geom, b.geom)
     JOIN objecten.veiligh_bouwk d ON d.bouwlaag_id = b.id AND d.parent_deleted = 'infinity'::timestamp with time zone AND d.self_deleted = 'infinity'::timestamp with time zone
     JOIN objecten.veiligh_bouwk_type st ON d.soort::text = st.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
			AND o.self_deleted = 'infinity'::timestamp with time ZONE AND last_hist.status::text = 'in gebruik'::text;

CREATE UNIQUE INDEX ON objecten.mview_veiligh_bouwk (gid);
CREATE INDEX mview_veiligh_bouwk_geom_idx ON objecten.mview_veiligh_bouwk USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_veiligh_install;
CREATE OR REPLACE VIEW objecten.view_veiligh_install
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
    concat(dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_veiligh_install
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
    concat(dt.symbol_name, '_', dt.symbol_type) AS symbol_name,
        CASE
            WHEN d.formaat_bouwlaag = 'klein'::algemeen.formaat THEN dt.size_bouwlaag_klein
            WHEN d.formaat_bouwlaag = 'middel'::algemeen.formaat THEN dt.size_bouwlaag_middel
            WHEN d.formaat_bouwlaag = 'groot'::algemeen.formaat THEN dt.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_veiligh_install (gid);
CREATE INDEX mview_veiligh_install_geom_idx ON objecten.mview_veiligh_install USING GIST (geom);

DROP VIEW IF EXISTS objecten.view_veiligh_ruimtelijk;
CREATE OR REPLACE VIEW objecten.view_veiligh_ruimtelijk
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE MATERIALIZED VIEW objecten.mview_veiligh_ruimtelijk
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
    concat(vt.symbol_name, '_', vt.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.share,
    COALESCE(b.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
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

CREATE UNIQUE INDEX ON objecten.mview_veiligh_ruimtelijk (gid);
CREATE INDEX mview_veiligh_ruimtelijk_geom_idx ON objecten.mview_veiligh_ruimtelijk USING GIST (geom);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 12;
UPDATE algemeen.applicatie SET db_versie = 3612; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
