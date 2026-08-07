SET ROLE oiv_admin;

ALTER TABLE objecten.gebruiksfunctie ADD COLUMN soort TEXT;
UPDATE objecten.gebruiksfunctie SET soort = sub.naam
FROM (
SELECT * FROM objecten.gebruiksfunctie_type
) sub 
WHERE gebruiksfunctie.gebruiksfunctie_type_id = sub.id;

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
             JOIN objecten.gebruiksfunctie_type gt ON g.soort = gt.naam
          GROUP BY g.object_id) gf ON o.id = gf.object_id
     JOIN LATERAL ( SELECT h.typeobject,
            h.status
           FROM objecten.historie h
          WHERE h.object_id = o.id AND h.parent_deleted = 'infinity'::timestamp with time zone
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1) last_hist ON true
     LEFT JOIN objecten.object_type dt ON last_hist.typeobject::text = dt.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone AND last_hist.status::text = 'in gebruik'::text;

CREATE OR REPLACE VIEW objecten.view_objectgegevens_liveop
AS SELECT DISTINCT o.id,
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
    gf.gebruiksfuncties,
    round(st_x(o.geom)) AS x,
    round(st_y(o.geom)) AS y,
    h2.typeobject,
        CASE
            WHEN h2.typeobject::text = ANY (ARRAY['Gebouw'::character varying::text, 'Evenement'::character varying::text]) THEN max(b.bouwlaag)
            ELSE NULL::integer
        END AS hoogste_bouwlaag,
        CASE
            WHEN h2.typeobject::text = ANY (ARRAY['Gebouw'::character varying::text, 'Evenement'::character varying::text]) THEN min(b.bouwlaag)
            ELSE NULL::integer
        END AS laagste_bouwlaag
   FROM objecten.object o
     JOIN objecten.terrein t ON o.id = t.object_id
     LEFT JOIN objecten.bodemgesteldheid_type bg ON o.bodemgesteldheid_type_id = bg.id
     LEFT JOIN ( SELECT DISTINCT g.object_id,
            string_agg(gt.naam, ', '::text) AS gebruiksfuncties
           FROM objecten.gebruiksfunctie g
             JOIN objecten.gebruiksfunctie_type gt ON g.soort = gt.naam
          GROUP BY g.object_id) gf ON o.id = gf.object_id
     JOIN ( SELECT DISTINCT historie.object_id,
            max(historie.datum_aangemaakt) AS maxdatetime
           FROM objecten.historie
          WHERE historie.status::text = 'in gebruik'::text AND historie.parent_deleted = 'infinity'::timestamp with time zone
          GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.historie h2 ON part.maxdatetime = h2.datum_aangemaakt AND o.id = h2.object_id
     LEFT JOIN ( SELECT bouwlagen.id,
            bouwlagen.geom,
            bouwlagen.datum_aangemaakt,
            bouwlagen.datum_gewijzigd,
            bouwlagen.bouwlaag,
            bouwlagen.bouwdeel,
            bouwlagen.pand_id,
            bouwlagen.self_deleted,
            bouwlagen.fotografie_id
           FROM objecten.bouwlagen
          WHERE bouwlagen.self_deleted = 'infinity'::timestamp with time zone) b ON st_intersects(t.geom, b.geom)
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.self_deleted = 'infinity'::timestamp with time zone
  GROUP BY o.id, o.formelenaam, o.geom, o.basisreg_identifier, o.datum_aangemaakt, o.datum_gewijzigd, o.bijzonderheden, o.pers_max, o.pers_nietz_max, o.datum_geldig_vanaf, o.datum_geldig_tot, o.bron, o.bron_tabel, o.fotografie_id, bg.naam, gf.gebruiksfuncties, h2.typeobject;

DROP MATERIALIZED VIEW objecten.mview_objectgegevens;
CREATE MATERIALIZED VIEW objecten.mview_objectgegevens
TABLESPACE pg_default
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
             JOIN objecten.gebruiksfunctie_type gt ON g.soort = gt.naam
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

-- View indexes:
CREATE INDEX mview_objectgegevens_basis_reg_idx ON objecten.mview_objectgegevens USING btree (basisreg_identifier);
CREATE INDEX mview_objectgegevens_geom_idx ON objecten.mview_objectgegevens USING gist (geom);
CREATE UNIQUE INDEX mview_objectgegevens_gid_idx ON objecten.mview_objectgegevens USING btree (gid);

ALTER TABLE objecten.gebruiksfunctie DROP CONSTRAINT gebruiksfunctie_type_id_fk;
ALTER TABLE objecten.gebruiksfunctie_type ADD CONSTRAINT gebruiksfunctie_type_naam_uc UNIQUE (naam);
ALTER TABLE objecten.gebruiksfunctie ADD CONSTRAINT gebruiksfunctie_soort_fk FOREIGN KEY (soort) REFERENCES objecten.gebruiksfunctie_type(naam);
ALTER TABLE objecten.gebruiksfunctie DROP COLUMN gebruiksfunctie_type_id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 7;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 3703; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();