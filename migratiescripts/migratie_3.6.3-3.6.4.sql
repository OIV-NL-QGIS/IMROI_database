SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

DELETE FROM algemeen.styles WHERE id = 79;

INSERT INTO algemeen.styles (id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
	VALUES(79, 'Bereikbaarheid', 'poort_bottom', 2.4, '#ff000000', 'solid'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'round'::algemeen.eindstijl_type);
INSERT INTO algemeen.styles (id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
	VALUES(80, 'Bereikbaarheid', 'poort_top', 2, '#ffffffff', 'solid'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'round'::algemeen.eindstijl_type);

INSERT INTO algemeen.styles (id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
VALUES(81, 'Bereikbaarheid', 'oever-kade-bereikbaar', 0.3, '#ff58b65c', 'markbordered'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'flat'::algemeen.eindstijl_type);

INSERT INTO algemeen.styles (id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
VALUES(82, 'Bereikbaarheid', 'oever-kade-niet-bereikbaar', 0.3, '#ffe31a1c', 'markbordered'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'flat'::algemeen.eindstijl_type);
	
INSERT INTO objecten.bereikbaarheid_type (id, naam, style_ids) VALUES(30, 'poort', '79,80');
INSERT INTO objecten.bereikbaarheid_type (id, naam, style_ids) VALUES(31, 'oever-kade-bereikbaar', '81');
INSERT INTO objecten.bereikbaarheid_type (id, naam, style_ids) VALUES(32, 'oever-kade-niet-bereikbaar', '82');

CREATE OR REPLACE VIEW mobiel.werkvoorraad_objecten
AS SELECT DISTINCT o.id,
    o.geom,
    sub.object_id,
    part.typeobject
   FROM ( SELECT DISTINCT werkvoorraad_punt.object_id
           FROM mobiel.werkvoorraad_punt
          WHERE werkvoorraad_punt.object_id IS NOT NULL
        UNION
         SELECT DISTINCT werkvoorraad_label.object_id
           FROM mobiel.werkvoorraad_label
          WHERE werkvoorraad_label.object_id IS NOT NULL
        UNION
         SELECT DISTINCT werkvoorraad_lijn.object_id
           FROM mobiel.werkvoorraad_lijn
          WHERE werkvoorraad_lijn.object_id IS NOT NULL
        UNION
         SELECT DISTINCT werkvoorraad_vlak.object_id
           FROM mobiel.werkvoorraad_vlak
          WHERE werkvoorraad_vlak.object_id IS NOT NULL
        UNION
         SELECT DISTINCT t.object_id
           FROM mobiel.werkvoorraad_punt w
             JOIN objecten.bouwlagen b ON w.bouwlaag_id = b.id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w.bouwlaag_id IS NOT NULL
        UNION
         SELECT DISTINCT t.object_id
           FROM mobiel.werkvoorraad_label w
             JOIN objecten.bouwlagen b ON w.bouwlaag_id = b.id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w.bouwlaag_id IS NOT NULL
        UNION
         SELECT DISTINCT t.object_id
           FROM mobiel.werkvoorraad_lijn w
             JOIN objecten.bouwlagen b ON w.bouwlaag_id = b.id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w.bouwlaag_id IS NOT NULL
        UNION
         SELECT DISTINCT t.object_id
           FROM mobiel.werkvoorraad_vlak w
             JOIN objecten.bouwlagen b ON w.bouwlaag_id = b.id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w.bouwlaag_id IS NOT NULL) sub
     JOIN objecten.object o ON sub.object_id = o.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  	 WHERE o.self_deleted = 'infinity'::timestamp with time zone;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 364; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
