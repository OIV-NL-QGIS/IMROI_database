SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TABLE points_of_interest_type
(
  id smallint NOT NULL,
  naam text,
  symbol_name text,
  size integer,
  CONSTRAINT points_of_interest_type_pkey PRIMARY KEY (id)
);

CREATE TABLE points_of_interest
(
  id serial NOT NULL,
  geom geometry(Point,28992),
  datum_aangemaakt timestamp without time zone DEFAULT now(),
  datum_gewijzigd timestamp without time zone,
  points_of_interest_type_id integer,
  label text,
  object_id integer,
  rotatie integer DEFAULT 0,
  fotografie_id integer,
  bijzonderheid text,
  CONSTRAINT points_of_interest_pkey PRIMARY KEY (id),
  CONSTRAINT points_of_interest_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT points_of_interest_object_id_fk FOREIGN KEY (object_id)
      REFERENCES objecten.object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT points_of_interest_type_id_fk FOREIGN KEY (points_of_interest_type_id)
      REFERENCES objecten.points_of_interest_type (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE OR REPLACE VIEW object_points_of_interest AS 
 SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.points_of_interest_type_id,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    b.bijzonderheid,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    vt.symbol_name,
    vt.size
   FROM points_of_interest b
     JOIN ( SELECT object.formelenaam,
            object.datum_geldig_vanaf,
            object.datum_geldig_tot,
            object.id,
            historie.typeobject
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id
     JOIN points_of_interest_type vt ON b.points_of_interest_type_id = vt.id;

CREATE OR REPLACE RULE points_of_interest_del AS
    ON DELETE TO objecten.object_points_of_interest DO INSTEAD  DELETE FROM points_of_interest
  WHERE points_of_interest.id = old.id;

CREATE OR REPLACE RULE points_of_interest_ins AS
    ON INSERT TO objecten.object_points_of_interest DO INSTEAD  INSERT INTO points_of_interest (geom, points_of_interest_type_id, label, bijzonderheid, rotatie, object_id, fotografie_id)
  VALUES (new.geom, new.points_of_interest_type_id, new.label, new.bijzonderheid, new.rotatie, new.object_id, new.fotografie_id)
  RETURNING points_of_interest.id,
    points_of_interest.geom,
    points_of_interest.datum_aangemaakt,
    points_of_interest.datum_gewijzigd,
    points_of_interest.points_of_interest_type_id,
    points_of_interest.label,
    points_of_interest.object_id,
    points_of_interest.rotatie,
    points_of_interest.fotografie_id,
    points_of_interest.bijzonderheid,
    ( SELECT o.formelenaam
           FROM objecten.object o
          WHERE o.id = points_of_interest.object_id) AS formelenaam,
    ( SELECT o.datum_geldig_vanaf
           FROM objecten.object o
          WHERE o.id = points_of_interest.object_id) AS datum_geldig_vanaf,
    ( SELECT o.datum_geldig_tot
           FROM objecten.object o
          WHERE o.id = points_of_interest.object_id) AS datum_geldig_tot,
    ( SELECT o.typeobject
           FROM objecten.historie o
          WHERE o.object_id = points_of_interest.object_id
         LIMIT 1) AS typeobject,
    ( SELECT st.symbol_name
           FROM objecten.points_of_interest_type st
          WHERE st.id = points_of_interest.points_of_interest_type_id) AS symbol_name,
    ( SELECT st.size
           FROM objecten.points_of_interest_type st
          WHERE st.id = points_of_interest.points_of_interest_type_id) AS size;

CREATE OR REPLACE RULE points_of_interest_upd AS
    ON UPDATE TO objecten.object_points_of_interest DO INSTEAD  UPDATE points_of_interest SET geom = new.geom, points_of_interest_type_id = new.points_of_interest_type_id, 
        rotatie = new.rotatie, bijzonderheid = new.bijzonderheid, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE points_of_interest.id = new.id;

INSERT INTO points_of_interest_type (id, naam, symbol_name, size) VALUES 
     (1,'ANWB Paddenstoel','N19P01',6)
    ,(3,'Bungalowpark','N19P03',6)
    ,(4,'Camping','N19P04',6)
    ,(5,'Hotel','N19P05',6)
    ,(6,'Mountainbike route','N19P06',6)
    ,(7,'Restaurant','N19P07',6)
    ,(8,'Rustplaats','N19P08',6)
    ,(9,'Zittafel','N19P09',6)
    ,(10,'Wildrooster','N19P10',6)
    ,(12,'Ecoduct','N19P12',6)
    ,(15,'Uitzichtpunt','N19P15',6)
    ,(16,'Strandpaal, paal','N19P16',6)
    ,(17,'Zendmast','N19P17',6)
    ,(23,'Object vitale infrastructuur','N19P23',6)
    ,(24,'Solitair bouwwerk','N19P24',6)
    ,(25,'Solitair bouwwerk, risicogevend','N19P25',6)
    ,(26,'Solitair bouwwerk, risico-ontvangend','N19P26',6)
    ,(29,'Bivakplaats defensie','N19P29',6);

INSERT INTO veiligh_ruimtelijk_type (id, naam, categorie, symbol_name, size) VALUES 
     (2002, 'Wegafsluiting', '', 'N19P13', 6)
    ,(2003, 'Wegafsluiting, passeerbaar', '', 'N19P14', 6)
    ,(2001, 'Passeerplaats', '', 'N19P11', 6)
    ,(2004, 'Zwaartepunt', '', 'N19P27', 6)
    ,(2006, 'Heli landplaats', '', 'N19P30', 6)
    ,(2007, 'Heli land verbod', '', 'N19P31', 6)
    ,(2005, 'Overdrachtsplaats', '', 'N19P28', 6)
    ,(2008, 'Vuurhaard', '', 'N19P32', 6);

INSERT INTO dreiging_type (id, naam, symbol_name, size) VALUES 
     (301, 'Gastank', 'N19P18', 6);

INSERT INTO ingang_type (id, naam, symbol_name, "size") VALUES 
     (301, 'Inrijpunt', 'N19P02', 6);

ALTER TABLE bluswater.alternatieve_type ADD COLUMN symbol_name TEXT;
ALTER TABLE bluswater.alternatieve_type ADD COLUMN size INTEGER;

UPDATE bluswater.alternatieve_type SET symbol_name = 'geboorde_put_voordruk', size = 6 WHERE id = 1;
UPDATE bluswater.alternatieve_type SET symbol_name = 'geboorde_put', size = 6 WHERE id = 2;
UPDATE bluswater.alternatieve_type SET symbol_name = 'openwater_winput', size = 6 WHERE id = 3;
UPDATE bluswater.alternatieve_type SET symbol_name = 'stijgleiding_ld_afnamepunt', size = 6 WHERE id = 4;
UPDATE bluswater.alternatieve_type SET symbol_name = 'stijgleiding_ld_vulpunt', size = 6 WHERE id = 5;
UPDATE bluswater.alternatieve_type SET symbol_name = 'bluswaterriool', size = 6 WHERE id = 6;
UPDATE bluswater.alternatieve_type SET symbol_name = 'openwater_winput', size = 6 WHERE id = 7;
UPDATE bluswater.alternatieve_type SET symbol_name = 'afsluiter_omloop', size = 6 WHERE id = 8;
UPDATE bluswater.alternatieve_type SET symbol_name = 'particuliere_brandkraan', size = 6 WHERE id = 9;
UPDATE bluswater.alternatieve_type SET symbol_name = 'open_water', size = 6 WHERE id = 10;
UPDATE bluswater.alternatieve_type SET symbol_name = 'opstelplaats_wts', size = 6 WHERE id = 11;
UPDATE bluswater.alternatieve_type SET symbol_name = 'open_water_xxx_zijde', size = 6 WHERE id = 12;
UPDATE bluswater.alternatieve_type SET symbol_name = '', size = 6 WHERE id = 13;
UPDATE bluswater.alternatieve_type SET symbol_name = 'brandkraan_eigen_terrein', size = 6 WHERE id = 14;
UPDATE bluswater.alternatieve_type SET symbol_name = 'bovengrondse_brandkraan', size = 6 WHERE id = 15;

INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, "size") VALUES 
     (21, 'Waterinnampunt,open water', 'N19P19', 6)
    ,(22, 'Geboorde put', 'N19P20', 6)
    ,(23, 'Opvoerpomp of bronpomp', 'N19P21', 6)
    ,(24, 'Water innampunt (WIP)', 'N19P22', 6);

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 5;
UPDATE algemeen.applicatie SET db_versie = 325; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();