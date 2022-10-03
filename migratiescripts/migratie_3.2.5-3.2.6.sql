SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE TABLE gebiedsgerichte_aanpak_type
(
  id smallint NOT NULL,
  naam character varying(50),
  CONSTRAINT gebiedsgerichte_aanpak_type_pkey PRIMARY KEY (id),
  CONSTRAINT naam_uk UNIQUE (naam)
);

CREATE TABLE gebiedsgerichte_aanpak
(
  id serial NOT NULL,
  geom geometry(MultiLineString,28992),
  datum_aangemaakt timestamp with time zone DEFAULT now(),
  datum_gewijzigd timestamp with time zone,
  soort character varying(50),
  label character varying(254),  
  bijzonderheden text,
  object_id integer NOT NULL,
  fotografie_id integer,
  CONSTRAINT gebiedsgerichte_aanpak_pkey PRIMARY KEY (id),
  CONSTRAINT gebiedsgerichte_aanpak_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT gebiedsgerichte_aanpak_object_id_fk FOREIGN KEY (object_id)
      REFERENCES objecten.object (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT soort_id_fk FOREIGN KEY (soort)
      REFERENCES objecten.gebiedsgerichte_aanpak_type (naam) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE OR REPLACE VIEW object_gebiedsgerichte_aanpak AS 
 SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.bijzonderheden,    
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM gebiedsgerichte_aanpak b
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
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE gebiedsgerichte_aanpak_del AS
    ON DELETE TO objecten.object_gebiedsgerichte_aanpak DO INSTEAD  DELETE FROM objecten.gebiedsgerichte_aanpak
  WHERE gebiedsgerichte_aanpak.id = old.id;

CREATE OR REPLACE RULE gebiedsgerichte_aanpak_upd AS
    ON UPDATE TO objecten.object_gebiedsgerichte_aanpak DO INSTEAD  UPDATE objecten.gebiedsgerichte_aanpak
    SET geom = new.geom, soort = new.soort, label = new.label, bijzonderheden = new.bijzonderheden,
    object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE gebiedsgerichte_aanpak.id = new.id;

CREATE OR REPLACE RULE gebiedsgerichte_aanpak_ins AS
    ON INSERT TO objecten.object_gebiedsgerichte_aanpak DO INSTEAD  INSERT INTO objecten.gebiedsgerichte_aanpak (geom, soort, label, bijzonderheden, object_id, fotografie_id)
  VALUES (new.geom, new.soort, new.label, new.bijzonderheden, new.object_id, new.fotografie_id)
  RETURNING gebiedsgerichte_aanpak.id,
    gebiedsgerichte_aanpak.geom,
    gebiedsgerichte_aanpak.datum_aangemaakt,
    gebiedsgerichte_aanpak.datum_gewijzigd,
    gebiedsgerichte_aanpak.soort,
    gebiedsgerichte_aanpak.label,
    gebiedsgerichte_aanpak.bijzonderheden,    
    gebiedsgerichte_aanpak.object_id,
    gebiedsgerichte_aanpak.fotografie_id,
    ( SELECT o.formelenaam
           FROM objecten.object o
          WHERE o.id = gebiedsgerichte_aanpak.object_id) AS formelenaam,
    ( SELECT o.datum_geldig_vanaf
           FROM objecten.object o
          WHERE o.id = gebiedsgerichte_aanpak.object_id) AS datum_geldig_vanaf,
    ( SELECT o.datum_geldig_tot
           FROM objecten.object o
          WHERE o.id = gebiedsgerichte_aanpak.object_id) AS datum_geldig_tot,
    ( SELECT o.typeobject
           FROM objecten.historie o
          WHERE o.object_id = gebiedsgerichte_aanpak.object_id
         LIMIT 1) AS typeobject;

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON gebiedsgerichte_aanpak
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON gebiedsgerichte_aanpak
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

CREATE TRIGGER trg_set_mutatie
  BEFORE UPDATE
  ON points_of_interest
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
  
CREATE TRIGGER trg_set_insert
  BEFORE INSERT
  ON points_of_interest
  FOR EACH ROW
  EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');

INSERT INTO gebiedsgerichte_aanpak_type (id, naam) VALUES
	 (1, 'Beheer bos: 100%')
	,(2, 'Beheer bos: 60%')
	,(3, 'Beheer bos: 30%')
	,(4, 'Beheer bos: 0%')
	,(5, 'Beheer heide: 100%')
	,(6, 'Beheer heide: niet gereed')
	,(7, 'Beheer heide: subcompartiment')
	,(8, 'Stoplijn in heide/gras')
	,(9, 'Stoplijn door voorbranden')
	,(10, 'Bos: compartiment gereed')
	,(11, 'Bos: subcompartiment of 60% gereed')
	,(12, 'Bos: compartimentsgrens in aanleg')
	,(13, 'Heide: gereed');

INSERT INTO sectoren_type (id, naam) VALUES
	 (21, 'Ecologisch kwetsbaar terrein')
	,(22, 'Drassig terrein, niet berijdbaar')
	,(23, 'Gevaarlijk terrein, nooit te betreden');

INSERT INTO bereikbaarheid_type (id, naam) VALUES
	 (21, 'Afrastering (algemeen)')
	,(22, 'Afrastering defensie/risico-objecten')
	,(23, 'Afrastering munitie')
  ,(24, 'Weg - berijdbaar alle voertuigen')
  ,(25, 'Weg - berijdbaar 4x4 zwaar')
  ,(26, 'Weg - berijdbaar 4x4 licht')
  ,(27, 'Weg - looproute');

INSERT INTO algemeen.styles (laagnaam,soortnaam,lijndikte,lijnkleur,lijnstijl,vulkleur,vulstijl,verbindingsstijl,eindstijl) VALUES 
   ('Sectoren','Ecologisch kwetsbaar terrein',0.6,'#ff74ac4a','solid','#ff74ac4a','b_diagonal','bevel',NULL)
  ,('Sectoren','Drassig terrein, niet berijdbaar',0.6,'#ff4fb0dc','solid','#ff4fb0dc','b_diagonal','bevel',NULL)
  ,('Sectoren','Gevaarlijk terrein, nooit te betreden',0.6,'#fffc1e1c','solid','#fffc1e1c','b_diagonal','bevel',NULL)
  ,('Gebiedsgerichte aanpak','Beheer heide: 100%',2,'#ff4d7731','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Beheer heide: niet gereed',2,'#ffc00300','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Beheer bos: 100%',2,'#ff4d7731','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Beheer bos: 60%',2,'#ffe9760d','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Beheer heide: subcompartiment',2,'#ffffff00','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Stoplijn in heide/gras_bottom',2,'#ffb37dc5','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Bos: compartimentsgrens in aanleg_top',2,'#ffa6a6a6','dot',NULL,NULL,'round','flat')
  ,('Gebiedsgerichte aanpak','Stoplijn door voorbranden_bottom',2,'#ff262626','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Bos: compartiment gereed',2,'#ff548235','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Heide: gereed_top',2,'#ffff0300','dot',NULL,NULL,'round','flat')
  ,('Gebiedsgerichte aanpak','Stoplijn door voorbranden_top',2,'#ffffffff','dot',NULL,NULL,'round','flat')
  ,('Gebiedsgerichte aanpak','Stoplijn in heide/gras_top',2,'#ffffffff','dot',NULL,NULL,'round','flat')
  ,('Gebiedsgerichte aanpak','Beheer bos: 30%',2,'#ffffff00','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Bos: subcompartiment of 60% gereed',2,'#ff548235','dot',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Bos: compartimentsgrens in aanleg_bottom',2,'#ff548235','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Heide: gereed_bottom',2,'#ff548235','solid',NULL,NULL,'round','round')
  ,('Gebiedsgerichte aanpak','Beheer bos: 0%',2,'#ffc00300','solid',NULL,NULL,'round','round')
  ,('Bereikbaarheid','Weg - berijdbaar 4x4 licht_top',4,'#ffff9f11','dot',NULL,NULL,'round','flat')
  ,('Bereikbaarheid','Weg - berijdbaar 4x4 zwaar_top',4,'#ffff9f11','solid',NULL,NULL,'round','round')
  ,('Bereikbaarheid','Weg - looproute_middle',4,'#ff3adef4','solid',NULL,NULL,'round','round')
  ,('Bereikbaarheid','Weg - berijdbaar alle voertuigen_top',4,'#ffff9f11','dash',NULL,NULL,'round','flat')
  ,('Bereikbaarheid','Weg - looproute_top',4,'#ffbf9000','dash',NULL,NULL,'round','flat')
  ,('Bereikbaarheid','Weg - berijdbaar alle voertuigen_bottom',6,'#ff000000','solid',NULL,NULL,'round','flat')
  ,('Bereikbaarheid','Weg - berijdbaar 4x4 zwaar_bottom',6,'#ff000000','solid',NULL,NULL,'round','flat')
  ,('Bereikbaarheid','Weg - berijdbaar 4x4 licht_bottom',6,'#ff000000','solid',NULL,NULL,'round','flat')
  ,('Bereikbaarheid','Weg - looproute_bottom',6,'#ff000000','solid',NULL,NULL,'round','flat')
  ,('Bereikbaarheid','Weg - berijdbaar alle voertuigen_middle',4,'#ffffffff','solid',NULL,NULL,'round','round')
  ,('Bereikbaarheid','Afrastering defensie/risico-objecten',1,'#ff565608','solid',NULL,NULL,'bevel','round')
  ,('Bereikbaarheid','Afrastering munitie',1,'#ffba2a26','solid',NULL,NULL,'bevel','round')
  ,('Bereikbaarheid','Afrastering (algemeen)',1,'#ff2a2a2a','solid',NULL,NULL,'bevel','round');

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 6;
UPDATE algemeen.applicatie SET db_versie = 326; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();