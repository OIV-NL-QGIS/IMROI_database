SET ROLE oiv_admin;
SET search_path = algemeen, pg_catalog, public;

CREATE TYPE lijnstijl_type AS ENUM ('no', 'solid', 'dash', 'dot', 'dash dot', 'dash dot dot');
CREATE TYPE vulstijl_type AS ENUM ('solid', 'horizontal', 'vertical', 'cross', 'b_diagonal', 'f_diagonal', 'diagonal_x', 'dense1', 'dense2', 'dense3', 'dense4', 'dense5', 'dense6', 'dense7', 'no');
CREATE TYPE verbindingsstijl_type AS ENUM ('bevel', 'miter', 'round');
CREATE TYPE eindstijl_type AS ENUM ('square', 'flat', 'round');

CREATE TABLE styles
(
id serial primary key,
laagnaam VARCHAR(100),
soortnaam VARCHAR(100) UNIQUE,
lijndikte decimal,
lijnkleur VARCHAR(9),
lijnstijl lijnstijl_type,
vulkleur VARCHAR(9),
vulstijl vulstijl_type,
verbindingsstijl verbindingsstijl_type,
eindstijl eindstijl_type
);

REVOKE ALL ON TABLE styles FROM GROUP oiv_write;

INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
			VALUES ('Bouwlagen', 'Bouwlagen', 0.26, '#ffa2a2a2', 'solid', '#fff7f6d7', 'solid', 'bevel', NULL);

INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
			VALUES ('Bouwkundige veiligheidsvoorzieningen', 'bouwdeelscheiding', 0.4, '#ff000000', 'solid', NULL, NULL, 'bevel', 'square');
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
			VALUES ('Bouwkundige veiligheidsvoorzieningen', 'rookwerendescheiding', 0.4, '#ff3288bd', 'solid', NULL, NULL, 'bevel', 'square');
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
			VALUES ('Bouwkundige veiligheidsvoorzieningen', '30 min brandwerende scheiding', 0.4, '#ffe31a1c', 'dash', NULL, NULL, 'bevel', 'square');
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
			VALUES ('Bouwkundige veiligheidsvoorzieningen', '60 min brandwerende scheiding', 0.4, '#ff33a02c', 'dash', NULL, NULL, 'bevel', 'square');
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Bouwkundige veiligheidsvoorzieningen', '120 min brandwerende scheiding', 0.4, '#ffe31a1c', 'solid', NULL, NULL, 'bevel', 'square');

INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Ruimten', 'verkeersruimte', 0.26, '#ff33a02c', 'solid', '#ffb2df8a', 'solid', 'bevel', NULL);
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Ruimten', 'bijzondere ruimte', 0.26, '#ff33a02c', 'solid', '#ffe31a1c', 'b_diagonal', 'bevel', NULL);
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Ruimten', 'overige ruimte', 0.26, '#ff33a02c', 'solid', '#fffff97a', 'solid', 'bevel', NULL);
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Ruimten', 'tijdelijke BAG', 0.26, '#ffa2a2a2', 'solid', '#fffb9a99', 'dense3', 'bevel', NULL);

INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Sectoren', 'persvak', 0.26, '#ffc37a21', 'solid', '#ffc5bbe4', 'solid', 'bevel', NULL);
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Sectoren', 'publieke sector', 0.26, '#ffb2b3a5', 'solid', '#fffbc2d1', 'solid', 'bevel', NULL);
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Sectoren', 'podium', 0.26, '#ff000000', 'solid', '#ff4c4c4c', 'solid', 'bevel', NULL);
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Sectoren', 'tent', 0.26, '#ffbfbfbf', 'solid', '#ff8490ca', 'solid', 'bevel', NULL);	

INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Isolijnen', '-4', 1, '#ff58b65c', 'solid', NULL, NULL, 'bevel', 'square');		
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Isolijnen', '-9', 1, '#ffff7f00', 'solid', NULL, NULL, 'bevel', 'square');		
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Isolijnen', '-15', 1, '#ffe31a1c', 'solid', NULL, NULL, 'bevel', 'square');		

INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Bereikbaarheid', 'calamiteitenroute', 0.8, '#ffe31a1c', 'dash dot', NULL, NULL, 'bevel', 'square');		
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Bereikbaarheid', 'vluchtroute publiek', 0.8, '#ff33a02c', 'dash dot', NULL, NULL, 'bevel', 'square');		
INSERT INTO styles (laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl)  
			VALUES ('Bereikbaarheid', 'aanrijdroute', 0.6, '#ff00ae22', 'solid', NULL, NULL, 'bevel', 'round');	

DROP VIEW objecten.view_ruimten;
DROP VIEW objecten.bouwlaag_ruimten;

ALTER TABLE objecten.ruimten DROP CONSTRAINT ruimten_type_id_fk;
ALTER TABLE objecten.ruimten ALTER COLUMN ruimten_type_id TYPE text;

UPDATE objecten.ruimten r SET ruimten_type_id = p.naam FROM
objecten.ruimten_type p
WHERE r.ruimten_type_id = p.id::text;

ALTER TABLE objecten.ruimten_type DROP COLUMN id;
ALTER TABLE objecten.ruimten_type ADD CONSTRAINT ruimten_type_pk PRIMARY KEY (naam);

ALTER TABLE objecten.ruimten ADD CONSTRAINT ruimten_type_id_fk FOREIGN KEY (ruimten_type_id)
      REFERENCES objecten.ruimten_type (naam) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

CREATE OR REPLACE VIEW objecten.bouwlaag_ruimten AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.ruimten_type_id,
    v.omschrijving,
    v.bouwlaag_id,
    v.fotografie_id,
    b.bouwlaag
   FROM objecten.ruimten v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE ruimten_del AS
    ON DELETE TO objecten.bouwlaag_ruimten DO INSTEAD  DELETE FROM objecten.ruimten
  WHERE ruimten.id = old.id;

CREATE OR REPLACE RULE ruimten_ins AS
    ON INSERT TO objecten.bouwlaag_ruimten DO INSTEAD  INSERT INTO objecten.ruimten (geom, ruimten_type_id, omschrijving, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.ruimten_type_id, new.omschrijving, new.bouwlaag_id, new.fotografie_id)
  RETURNING ruimten.id,
    ruimten.geom,
    ruimten.datum_aangemaakt,
    ruimten.datum_gewijzigd,
    ruimten.ruimten_type_id,
    ruimten.omschrijving,
    ruimten.bouwlaag_id,
    ruimten.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM objecten.bouwlagen
          WHERE ruimten.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE ruimten_upd AS
    ON UPDATE TO objecten.bouwlaag_ruimten DO INSTEAD  UPDATE objecten.ruimten SET geom = new.geom, ruimten_type_id = new.ruimten_type_id, omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE ruimten.id = new.id;

CREATE OR REPLACE VIEW objecten.view_ruimten AS 
 SELECT r.id,
    r.geom,
    r.datum_aangemaakt,
    r.datum_gewijzigd,
    r.ruimten_type_id,
    r.omschrijving,
    r.bouwlaag_id,
    r.fotografie_id,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel
   FROM objecten.ruimten r
     JOIN objecten.bouwlagen b ON r.bouwlaag_id = b.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_union(t_1.geom)::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t_1 ON o.id = t_1.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(r.geom, part.geovlak);


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 1;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 313; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();