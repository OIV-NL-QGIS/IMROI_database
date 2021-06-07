SET ROLE oiv_admin;
SET search_path = waterongevallen, pg_catalog, public;

CREATE SCHEMA waterongevallen_backup;

CREATE TABLE wo_lokatiegegevens AS
SELECT
  loc.id AS id,
  loc.geom,
  l.id AS gegevens_id,
  l.datum_aangemaakt,
  l.datum_gewijzigd,
  lokatienaam,
  straatnaam,
  max_diepte,
  bijzonderheden,
  k.naam AS oever_kade,
  f.naam AS functie,
  st.naam AS stroming,
  str.naam AS waterb_gem,
  s.naam AS scheepvaart1,
  se.naam AS scheepvaart2,
  b.naam AS bodemstructuur,
  l.bodemstructuur_id
FROM lokatie loc
LEFT JOIN lokatiegegevens l ON loc.wo_gegevens_id = l.id
LEFT JOIN kade k ON l.oever_kade_id = k.id
LEFT JOIN functie f ON l.functie_id = f.id
LEFT JOIN scheepvaart s ON l.scheepvaart1_id = s.id
LEFT JOIN scheepvaart se ON l.scheepvaart2_id = se.id
LEFT JOIN bodemstructuur b ON l.bodemstructuur_id = b.id
LEFT JOIN stroming st ON l.stroming_id = st.id
LEFT JOIN stroming str ON l.waterb_gem_id = str.id;

CREATE TABLE waterongevallen_backup.wo_lokatiegegevens AS
SELECT * FROM wo_lokatiegegevens;

ALTER TABLE wo_lokatiegegevens ADD COLUMN identificatie VARCHAR(254);
ALTER TABLE wo_lokatiegegevens ADD COLUMN bron VARCHAR(3);
ALTER TABLE wo_lokatiegegevens ADD COLUMN bron_tabel VARCHAR(25);
ALTER TABLE wo_lokatiegegevens ADD COLUMN geovlak geometry(MultiPolygon,28992);

UPDATE wo_lokatiegegevens l SET identificatie = p.identificatie,
                bron      = p.bron, 
                bron_tabel    = p.bron_tbl,
                geovlak     = p.geovlak
FROM
(SELECT DISTINCT ON (w.id) w.id, b.identificatie, b.bron, b.bron_tbl, ST_MULTI(ST_CURVETOLINE(b.geovlak))::geometry(MultiPolygon,28992) AS geovlak
 FROM algemeen.bgt_extent b 
 INNER JOIN wo_lokatiegegevens w ON ST_INTERSECTS(w.geom, ST_MULTI(ST_CURVETOLINE(b.geovlak))::geometry(MultiPolygon,28992))
) p
WHERE l.id = p.id;

ALTER TABLE objecten.object ADD COLUMN wo_lokatie_id INTEGER;
ALTER TABLE objecten.object ADD COLUMN IF NOT EXISTS fotografie_id INTEGER;
ALTER TABLE objecten.object ADD COLUMN bodemgesteldheid_type_id INTEGER;
ALTER TABLE objecten.object DROP CONSTRAINT IF EXISTS object_fotografie_id_fk;
ALTER TABLE objecten.object ADD CONSTRAINT object_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id);

CREATE TABLE objecten.bodemgesteldheid_type AS
SELECT * FROM bodemstructuur;

ALTER TABLE objecten.bodemgesteldheid_type ADD CONSTRAINT bodemgesteldheid_type_pkey PRIMARY KEY (id);

ALTER TABLE objecten.object ADD CONSTRAINT object_bodemgesteldheid_type_id_fk FOREIGN KEY (bodemgesteldheid_type_id)
      REFERENCES objecten.bodemgesteldheid_type (id);

INSERT INTO objecten.object (geom, datum_aangemaakt, datum_gewijzigd, basisreg_identifier, formelenaam, bijzonderheden, bron, bron_tabel, wo_lokatie_id, geovlak, bodemgesteldheid_type_id)
SELECT geom, datum_aangemaakt, datum_gewijzigd, identificatie, lokatienaam, bijzonderheden, bron, bron_tabel, id, geovlak, bodemstructuur_id
FROM wo_lokatiegegevens;

CREATE TABLE wo_id_conversie AS
SELECT id, wo_lokatie_id FROM objecten.object
WHERE wo_lokatie_id IS NOT NULL;

ALTER TABLE objecten.object DROP COLUMN wo_lokatie_id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 0;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 302; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();