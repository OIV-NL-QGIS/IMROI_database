--Extra analyse lagen t.b.v. bluswater beheer, analyse bag pand niet bereikt binnen 100m straal
SET ROLE oiv_admin;
SET search_path = bluswater, pg_catalog, public;

CREATE MATERIALIZED VIEW alternatieve_buffer_100m AS 
 SELECT alternatieve.id,
    alternatieve.datum_aangemaakt,
    alternatieve.datum_gewijzigd,
    alternatieve.type_id,
    alternatieve.liters_per,
    alternatieve.label,
    alternatieve.geom,
    st_buffer(alternatieve.geom, 100::double precision) AS geom_buf
   FROM alternatieve
WITH DATA;

CREATE INDEX alternatieve_buffer_geom_gist
  ON alternatieve_buffer_100m
  USING gist
  (geom_buf);

CREATE MATERIALIZED VIEW brandkranen_buffer_100m AS 
 SELECT brandkraan_2017_1.nummer,
    brandkraan_2017_1.geom,
    brandkraan_2017_1.type,
    brandkraan_2017_1.diameter,
    brandkraan_2017_1.postcode,
    brandkraan_2017_1.straat,
    brandkraan_2017_1.huisnummer,
    brandkraan_2017_1.capaciteit,
    brandkraan_2017_1.plaats,
    brandkraan_2017_1.gemeentenaam,
    st_buffer(brandkraan_2017_1.geom, 100::double precision) AS geom_buf
   FROM brandkraan_2017_1
WITH DATA;

CREATE INDEX brandkranen_buffer_geom_gist
  ON brandkranen_buffer_100m
  USING gist
  (geom_buf);

CREATE MATERIALIZED VIEW dekking_bluswater_bag AS 
 SELECT row_number() OVER (ORDER BY b.identificatie) AS tid,
    b.gid,
    b.identificatie,
    b.status,
    b.geovlak,
    b.gebruiksdoel,
    bb.nummer
   FROM algemeen.bag_extent b
     LEFT JOIN ( SELECT brandkranen_buffer_100m.nummer,
            brandkranen_buffer_100m.geom_buf
           FROM brandkranen_buffer_100m
        UNION
         SELECT concat('altern', alternatieve_buffer_100m.id)::character varying AS nummer,
            alternatieve_buffer_100m.geom_buf
           FROM alternatieve_buffer_100m) bb ON st_intersects(b.geovlak, bb.geom_buf)
WITH DATA;

CREATE INDEX dekking_bluswater_bag_gist
  ON dekking_bluswater_bag
  USING gist
  (geovlak);
  
CREATE MATERIALIZED VIEW dekking_bluswater_bag_distinct AS 
 SELECT DISTINCT ON (p.identificatie) p.tid,
    p.gid,
    p.identificatie,
    p.status,
    p.geovlak,
    p.gebruiksdoel,
    p.nummer
   FROM ( SELECT dekking_bluswater_bag.tid,
            dekking_bluswater_bag.gid,
            dekking_bluswater_bag.identificatie,
            dekking_bluswater_bag.status,
            dekking_bluswater_bag.geovlak,
            dekking_bluswater_bag.gebruiksdoel,
            dekking_bluswater_bag.nummer
           FROM dekking_bluswater_bag
          ORDER BY dekking_bluswater_bag.nummer DESC NULLS LAST) p
WITH DATA;

CREATE INDEX dekking_bluswater_bag_distinct_geom_gist
  ON dekking_bluswater_bag_distinct
  USING gist
  (geovlak);

ALTER TABLE bluswater.brandkraan_2017_1 RENAME TO brandkranen;