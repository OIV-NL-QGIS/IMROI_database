SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;
 
CREATE OR REPLACE VIEW view_bereikbaarheid AS
  SELECT b.*, o.formelenaam FROM bereikbaarheid b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL) 
         ) o 
  ON b.object_id = o.id;

DROP VIEW IF EXISTS objecten.view_opstelplaats;
CREATE OR REPLACE VIEW objecten.view_opstelplaats
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.rotatie,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.opstelplaats b
     JOIN objecten.opstelplaats_type vt ON b.soort = vt.naam
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id;


CREATE OR REPLACE VIEW view_sectoren AS
  SELECT b.*, o.formelenaam FROM sectoren b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id;

CREATE OR REPLACE VIEW view_isolijnen AS 
 SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.hoogte,
    b.omschrijving,
    b.object_id,
    o.formelenaam
   FROM isolijnen b
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND 
                (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND 
                (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id;

CREATE OR REPLACE VIEW objecten.view_veiligh_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.veiligh_ruimtelijk_type_id,
    b.label,
    b.object_id,
    b.rotatie,
    b.fotografie_id,
    vt.naam AS soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.veiligh_ruimtelijk b
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id
     JOIN objecten.veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id;

CREATE OR REPLACE VIEW objecten.view_ingang_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.ingang_type_id,
    b.rotatie,
    b.label,
    b.belemmering,
    b.voorzieningen,
    b.bouwlaag_id,
    b.object_id,
    b.fotografie_id,
    vt.naam AS soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.ingang b
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id
     JOIN objecten.ingang_type vt ON b.ingang_type_id = vt.id;

CREATE OR REPLACE VIEW view_label_ruimtelijk AS
  SELECT b.*, o.formelenaam, ROUND(ST_X(b.geom)) AS X, ROUND(ST_Y(b.geom)) AS Y FROM label b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id;

CREATE OR REPLACE VIEW objecten.view_dreiging_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dreiging_type_id,
    b.rotatie,
    b.label,
    b.bouwlaag_id,
    b.object_id,
    b.fotografie_id,
    vt.naam AS soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.dreiging b
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id
     JOIN objecten.dreiging_type vt ON b.dreiging_type_id = vt.id;
		
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_ruimtelijk
AS SELECT s.id,
    s.geom,
    s.datum_aangemaakt,
    s.datum_gewijzigd,
    s.sleutelkluis_type_id,
    s.rotatie,
    s.label,
    s.aanduiding_locatie,
    s.sleuteldoel_type_id,
    s.ingang_id,
    s.fotografie_id,
    st.naam AS type,
    sd.naam AS doel,
    part.formelenaam,
    part.object_id,
    round(st_x(s.geom)) AS x,
    round(st_y(s.geom)) AS y,
    st.symbol_name,
    st.size
   FROM objecten.sleutelkluis s
     JOIN ( SELECT b.id AS ingang_id,
            b.object_id,
            o.formelenaam
           FROM objecten.ingang b
             JOIN ( SELECT object.formelenaam,
                    object.id
                   FROM objecten.object
                     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                           FROM objecten.historie historie_1
                          WHERE historie_1.object_id = object.id
                          ORDER BY historie_1.datum_aangemaakt DESC
                         LIMIT 1))
                  WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id) part ON s.ingang_id = part.ingang_id
     LEFT JOIN objecten.sleutelkluis_type st ON s.sleutelkluis_type_id = st.id
     LEFT JOIN objecten.sleuteldoel_type sd ON s.sleuteldoel_type_id = sd.id;

CREATE OR REPLACE VIEW view_gevaarlijkestof_ruimtelijk AS
SELECT s.*, vn.vn_nr, vn.gevi_nr, vn.eric_kaart, part.geom, part.formelenaam, part.rotatie, ROUND(ST_X(part.geom)) AS X, ROUND(ST_Y(part.geom)) AS Y, part.object_id FROM gevaarlijkestof s
INNER JOIN
  (
  SELECT b.id AS opslag_id, b.geom, b.rotatie, o.formelenaam, b.object_id FROM gevaarlijkestof_opslag b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id
  ) part ON s.opslag_id = part.opslag_id
  LEFT JOIN gevaarlijkestof_vnnr vn ON s.gevaarlijkestof_vnnr_id = vn.id;

CREATE OR REPLACE VIEW view_contactpersoon AS
  SELECT b.*, o.formelenaam FROM contactpersoon b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id;

CREATE OR REPLACE VIEW view_bedrijfshulpverlening AS
  SELECT b.*, o.formelenaam FROM bedrijfshulpverlening b
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
         ) o 
  ON b.object_id = o.id;

-- Create new views t.b.v. de plugin
CREATE OR REPLACE VIEW bouwlaag_veiligh_install AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.veiligh_install_type_id,
    v.label,
    v.bouwlaag_id,
    v.rotatie,
    v.fotografie_id,
    b.bouwlaag,
    vt.size,
    vt.symbol_name
   FROM veiligh_install v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     INNER JOIN veiligh_install_type vt ON v.veiligh_install_type_id = vt.id;

CREATE OR REPLACE RULE veiligh_install_del AS
    ON DELETE TO bouwlaag_veiligh_install DO INSTEAD  DELETE FROM veiligh_install
  WHERE veiligh_install.id = old.id;

CREATE OR REPLACE RULE veiligh_install_ins AS
    ON INSERT TO bouwlaag_veiligh_install DO INSTEAD  INSERT INTO veiligh_install (geom, veiligh_install_type_id, label, rotatie, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.veiligh_install_type_id, new.label, new.rotatie, new.bouwlaag_id, new.fotografie_id)
  RETURNING veiligh_install.id,
    veiligh_install.geom,
    veiligh_install.datum_aangemaakt,
    veiligh_install.datum_gewijzigd,
    veiligh_install.veiligh_install_type_id,
    veiligh_install.label,
    veiligh_install.bouwlaag_id,
    veiligh_install.rotatie,
    veiligh_install.fotografie_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE veiligh_install.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT size FROM veiligh_install_type WHERE veiligh_install.veiligh_install_type_id = veiligh_install_type.id),
    (SELECT symbol_name FROM veiligh_install_type WHERE veiligh_install.veiligh_install_type_id = veiligh_install_type.id);    

CREATE OR REPLACE RULE veiligh_install_upd AS
    ON UPDATE TO bouwlaag_veiligh_install DO INSTEAD  UPDATE veiligh_install SET geom = new.geom, veiligh_install_type_id = new.veiligh_install_type_id, bouwlaag_id = new.bouwlaag_id, label = new.label, rotatie = new.rotatie, fotografie_id = new.fotografie_id
  WHERE veiligh_install.id = new.id;

-- Opslag stoffen
CREATE OR REPLACE VIEW bouwlaag_opslag AS 
 SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
    b.bouwlaag,
    st.symbol_name,
    st.size
   FROM gevaarlijkestof_opslag o
     JOIN bouwlagen b ON o.bouwlaag_id = b.id
     INNER JOIN algemeen.styles_symbols_type st ON 'Opslag stoffen' = st.naam;

CREATE OR REPLACE RULE opslag_del AS
    ON DELETE TO bouwlaag_opslag DO INSTEAD  DELETE FROM gevaarlijkestof_opslag
  WHERE gevaarlijkestof_opslag.id = old.id;

CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO bouwlaag_opslag DO INSTEAD  INSERT INTO gevaarlijkestof_opslag (geom, locatie, bouwlaag_id, fotografie_id, rotatie)
  VALUES (new.geom, new.locatie, new.bouwlaag_id, new.fotografie_id, new.rotatie)
  RETURNING gevaarlijkestof_opslag.id,
    gevaarlijkestof_opslag.geom,
    gevaarlijkestof_opslag.datum_aangemaakt,
    gevaarlijkestof_opslag.datum_gewijzigd,
    gevaarlijkestof_opslag.locatie,
    gevaarlijkestof_opslag.bouwlaag_id,
    gevaarlijkestof_opslag.object_id,
    gevaarlijkestof_opslag.fotografie_id,
    gevaarlijkestof_opslag.rotatie,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE gevaarlijkestof_opslag.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT symbol_name FROM algemeen.styles_symbols_type WHERE naam = 'Opslag stoffen'),
    (SELECT size FROM algemeen.styles_symbols_type WHERE naam = 'Opslag stoffen');

CREATE OR REPLACE RULE opslag_upd AS
    ON UPDATE TO bouwlaag_opslag DO INSTEAD  UPDATE gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE gevaarlijkestof_opslag.id = new.id;

-- labels
CREATE OR REPLACE VIEW bouwlaag_label AS 
 SELECT l.id,
    l.geom,
    l.datum_aangemaakt,
    l.datum_gewijzigd,
    l.omschrijving,
    l.soort,
    l.rotatie,
    l.bouwlaag_id,
    b.bouwlaag,
    st.size,
    st.symbol_name
   FROM label l
     JOIN bouwlagen b ON l.bouwlaag_id = b.id
     INNER JOIN label_type st ON l.soort::TEXT = st.naam;

CREATE OR REPLACE RULE label_del AS
    ON DELETE TO bouwlaag_label DO INSTEAD  DELETE FROM label
  WHERE label.id = old.id;

CREATE OR REPLACE RULE label_ins AS
    ON INSERT TO bouwlaag_label DO INSTEAD  INSERT INTO label (geom, soort, omschrijving, rotatie, bouwlaag_id)
  VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id)
  RETURNING label.id,
    label.geom,
    label.datum_aangemaakt,
    label.datum_gewijzigd,
    label.omschrijving,
    label.soort,
    label.rotatie,
    label.bouwlaag_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE label.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT size FROM algemeen.styles_symbols_type WHERE label.soort::TEXT = algemeen.styles_symbols_type.naam),
    (SELECT symbol_name FROM algemeen.styles_symbols_type WHERE label.soort::TEXT = algemeen.styles_symbols_type.naam);

CREATE OR REPLACE RULE label_upd AS
    ON UPDATE TO bouwlaag_label DO INSTEAD  UPDATE label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id
  WHERE label.id = new.id;

CREATE OR REPLACE VIEW bouwlaag_veiligh_bouwk AS
  SELECT v.*, b.bouwlaag FROM veiligh_bouwk v JOIN bouwlagen b ON v.bouwlaag_id = b.id;
  
CREATE OR REPLACE RULE veiligh_bouwk_del AS
    ON DELETE TO bouwlaag_veiligh_bouwk DO INSTEAD  DELETE FROM veiligh_bouwk
  WHERE veiligh_bouwk.id = old.id;

CREATE OR REPLACE RULE veiligh_bouwk_ins AS
    ON INSERT TO bouwlaag_veiligh_bouwk DO INSTEAD  INSERT INTO veiligh_bouwk (geom, soort, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.soort, new.bouwlaag_id, new.fotografie_id)
  RETURNING veiligh_bouwk.id,
    veiligh_bouwk.geom,
    veiligh_bouwk.datum_aangemaakt,
    veiligh_bouwk.datum_gewijzigd,
    veiligh_bouwk.soort,    
    veiligh_bouwk.bouwlaag_id,
    veiligh_bouwk.fotografie_id,
    ( SELECT bouwlagen.bouwlaag
           FROM bouwlagen
          WHERE veiligh_bouwk.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE veiligh_bouwk_upd AS
    ON UPDATE TO bouwlaag_veiligh_bouwk DO INSTEAD  UPDATE veiligh_bouwk SET geom = new.geom, soort = new.soort, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE veiligh_bouwk.id = new.id;
  
CREATE OR REPLACE VIEW bouwlaag_ruimten AS 
 SELECT v.*,
    b.bouwlaag
   FROM ruimten v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id;

CREATE OR REPLACE RULE ruimten_del AS
    ON DELETE TO bouwlaag_ruimten DO INSTEAD  DELETE FROM ruimten
  WHERE ruimten.id = old.id;

CREATE OR REPLACE RULE ruimten_ins AS
    ON INSERT TO bouwlaag_ruimten DO INSTEAD  INSERT INTO ruimten (geom, ruimten_type_id, omschrijving, bouwlaag_id, fotografie_id)
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
           FROM bouwlagen
          WHERE ruimten.bouwlaag_id = bouwlagen.id) AS bouwlaag;

CREATE OR REPLACE RULE ruimten_upd AS
    ON UPDATE TO bouwlaag_ruimten DO INSTEAD  UPDATE ruimten SET geom = new.geom, ruimten_type_id = new.ruimten_type_id, omschrijving = new.omschrijving, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE ruimten.id = new.id;

CREATE OR REPLACE VIEW bouwlaag_ingang AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.ingang_type_id,
    v.rotatie,
    v.label,
    v.belemmering,
    v.voorzieningen,
    v.bouwlaag_id,
    v.object_id,
    v.fotografie_id,
    b.bouwlaag,
    it.symbol_name,
    it.size
   FROM ingang v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     INNER JOIN ingang_type it ON v.ingang_type_id = it.id ;

CREATE OR REPLACE RULE ingang_del AS
    ON DELETE TO bouwlaag_ingang DO INSTEAD  DELETE FROM ingang
  WHERE ingang.id = old.id;

CREATE OR REPLACE RULE ingang_ins AS
    ON INSERT TO bouwlaag_ingang DO INSTEAD  INSERT INTO ingang (geom, ingang_type_id, label, rotatie, belemmering, voorzieningen, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.ingang_type_id, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.bouwlaag_id, new.fotografie_id)
  RETURNING ingang.id,
    ingang.geom,
    ingang.datum_aangemaakt,
    ingang.datum_gewijzigd,
    ingang.ingang_type_id,
    ingang.rotatie,
    ingang.label,
    ingang.belemmering,
    ingang.voorzieningen,
    ingang.bouwlaag_id,
    ingang.object_id,
    ingang.fotografie_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE ingang.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT symbol_name FROM ingang_type WHERE ingang.ingang_type_id = ingang_type.id),
    (SELECT size FROM ingang_type WHERE ingang.ingang_type_id = ingang_type.id);

CREATE OR REPLACE RULE ingang_upd AS
    ON UPDATE TO bouwlaag_ingang DO INSTEAD  UPDATE ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE ingang.id = new.id;

CREATE OR REPLACE VIEW bouwlaag_dreiging AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.dreiging_type_id,
    v.rotatie,
    v.label,
    v.bouwlaag_id,
    v.object_id,
    v.fotografie_id,
    b.bouwlaag,
    st.symbol_name,
    st.size
   FROM dreiging v JOIN bouwlagen b ON v.bouwlaag_id = b.id
   INNER JOIN dreiging_type st ON v.dreiging_type_id = st.id;

CREATE OR REPLACE RULE dreiging_del AS
    ON DELETE TO bouwlaag_dreiging DO INSTEAD  DELETE FROM dreiging
  WHERE dreiging.id = old.id;

CREATE OR REPLACE RULE dreiging_ins AS
    ON INSERT TO bouwlaag_dreiging DO INSTEAD  INSERT INTO dreiging (geom, dreiging_type_id, label, rotatie, bouwlaag_id, fotografie_id)
  VALUES (new.geom, new.dreiging_type_id, new.label, new.rotatie, new.bouwlaag_id, new.fotografie_id)
  RETURNING dreiging.id,
    dreiging.geom,
    dreiging.datum_aangemaakt,
    dreiging.datum_gewijzigd,
    dreiging.dreiging_type_id,
    dreiging.rotatie,
    dreiging.label,
    dreiging.bouwlaag_id,
    dreiging.object_id,
    dreiging.fotografie_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE dreiging.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT symbol_name FROM dreiging_type st WHERE id = dreiging.dreiging_type_id),
    (SELECT size FROM dreiging_type st WHERE id = dreiging.dreiging_type_id);

CREATE OR REPLACE RULE dreiging_upd AS
    ON UPDATE TO bouwlaag_dreiging DO INSTEAD  UPDATE dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
  WHERE dreiging.id = new.id;

CREATE OR REPLACE VIEW bouwlaag_sleutelkluis AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.sleutelkluis_type_id,
    v.rotatie,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.ingang_id,
    v.fotografie_id,
    part.bouwlaag,
    it.symbol_name,
    it.size
   FROM sleutelkluis v
     JOIN ( SELECT b.bouwlaag, ib.id FROM ingang ib JOIN bouwlagen b ON ib.bouwlaag_id = b.id) part ON v.ingang_id = part.id
     INNER JOIN sleutelkluis_type it ON v.sleutelkluis_type_id = it.id;

CREATE OR REPLACE RULE sleutelkluis_del AS
    ON DELETE TO bouwlaag_sleutelkluis DO INSTEAD  DELETE FROM sleutelkluis
  WHERE sleutelkluis.id = old.id;

CREATE OR REPLACE RULE sleutelkluis_ins AS
    ON INSERT TO bouwlaag_sleutelkluis DO INSTEAD  INSERT INTO sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, fotografie_id)
  VALUES (new.geom, new.sleutelkluis_type_id, new.label, new.rotatie, new.aanduiding_locatie, new.sleuteldoel_type_id, new.ingang_id, new.fotografie_id)
  RETURNING sleutelkluis.id,
    sleutelkluis.geom,
    sleutelkluis.datum_aangemaakt,
    sleutelkluis.datum_gewijzigd,
    sleutelkluis.sleutelkluis_type_id,
    sleutelkluis.rotatie,
    sleutelkluis.label,
    sleutelkluis.aanduiding_locatie,
    sleutelkluis.sleuteldoel_type_id,
    sleutelkluis.ingang_id,
    sleutelkluis.fotografie_id,
    (SELECT bouwlaag FROM bouwlagen b INNER JOIN ingang i ON b.id = i.bouwlaag_id INNER JOIN sleutelkluis s ON i.id = s.ingang_id WHERE i.id = sleutelkluis.ingang_id) AS bouwlaag,
    (SELECT symbol_name FROM sleutelkluis_type WHERE sleutelkluis.sleutelkluis_type_id = sleutelkluis_type.id),
    (SELECT size FROM sleutelkluis_type WHERE sleutelkluis.sleutelkluis_type_id = sleutelkluis_type.id);

CREATE OR REPLACE RULE sleutelkluis_upd AS
    ON UPDATE TO bouwlaag_sleutelkluis DO INSTEAD  UPDATE sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, sleuteldoel_type_id = new.sleuteldoel_type_id, ingang_id = new.ingang_id, fotografie_id = new.fotografie_id
  WHERE sleutelkluis.id = new.id;

CREATE OR REPLACE VIEW bouwlaag_afw_binnendekking AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.soort,
    v.rotatie,
    v.label,
    v.handelingsaanwijzing,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    st.size,
    st.symbol_name
   FROM afw_binnendekking v
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     INNER JOIN afw_binnendekking_type st ON v.soort::TEXT = st.naam;

CREATE OR REPLACE RULE afw_binnendekking_del AS
    ON DELETE TO bouwlaag_afw_binnendekking DO INSTEAD  DELETE FROM afw_binnendekking
  WHERE afw_binnendekking.id = old.id;

CREATE OR REPLACE RULE afw_binnendekking_ins AS
    ON INSERT TO bouwlaag_afw_binnendekking DO INSTEAD  INSERT INTO afw_binnendekking (geom, soort, label, rotatie, handelingsaanwijzing, bouwlaag_id)
  VALUES (new.geom, new.soort, new.label, new.rotatie, new.handelingsaanwijzing, new.bouwlaag_id)
  RETURNING afw_binnendekking.id,
    afw_binnendekking.geom,
    afw_binnendekking.datum_aangemaakt,
    afw_binnendekking.datum_gewijzigd,
    afw_binnendekking.soort,
    afw_binnendekking.rotatie,
    afw_binnendekking.label,
    afw_binnendekking.handelingsaanwijzing,
    afw_binnendekking.bouwlaag_id,
    afw_binnendekking.object_id,
    (SELECT bouwlagen.bouwlaag FROM bouwlagen WHERE afw_binnendekking.bouwlaag_id = bouwlagen.id) AS bouwlaag,
    (SELECT size FROM algemeen.styles_symbols_type WHERE afw_binnendekking.soort::TEXT = algemeen.styles_symbols_type.naam),
    (SELECT symbol_name FROM algemeen.styles_symbols_type WHERE afw_binnendekking.soort::TEXT = algemeen.styles_symbols_type.naam);

CREATE OR REPLACE RULE afw_binnendekking_bouwlaag_upd AS
    ON UPDATE TO bouwlaag_afw_binnendekking DO INSTEAD  UPDATE afw_binnendekking SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, handelingsaanwijzing = new.handelingsaanwijzing, bouwlaag_id = new.bouwlaag_id
        WHERE afw_binnendekking.id = new.id; 

-- Create views t.b.v. de management lagen
-- create view t.b.v. de laatste status van de objecten
CREATE OR REPLACE VIEW status_objectgegevens AS 
 SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    historie.status
   FROM object
     LEFT JOIN historie ON historie.id = (( SELECT h.id
           FROM historie h
          WHERE h.object_id = object.id
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1));
	 
REVOKE ALL ON TABLE status_objectgegevens FROM GROUP oiv_write;

CREATE OR REPLACE VIEW view_pictogram_zonder_object AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.voorziening_pictogram_id,
    v.label,
    v.rotatie,
    p.naam AS pictogram,
    round(st_x(v.geom)) AS x,
    round(st_y(v.geom)) AS y
   FROM pictogram_zonder_object v
     JOIN pictogram_zonder_object_type p ON v.voorziening_pictogram_id = p.id;
	
-- Create View t.b.v. berekenen schade cirkels
CREATE OR REPLACE VIEW schade_cirkel_calc AS 
 SELECT sc.id,
    sc.datum_aangemaakt,
    sc.datum_gewijzigd,
    sc.straal,
    sc.soort,
    sc.gevaarlijkestof_id,
    st_buffer(part.geom, sc.straal::double precision)::geometry(Polygon, 28992) AS geom_cirkel
   FROM gevaarlijkestof_schade_cirkel sc
     LEFT JOIN ( SELECT gb.id,
            ops.geom
           FROM gevaarlijkestof gb
             LEFT JOIN gevaarlijkestof_opslag ops ON gb.opslag_id = ops.id) part ON sc.gevaarlijkestof_id = part.id;

REVOKE ALL ON schade_cirkel_calc FROM oiv_write;

-- create view t.b.v. de controle volgende update van de objecten
CREATE OR REPLACE VIEW stavaza_volgende_update AS 
 SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    historie.datum_aangemaakt,
    object.datum_gewijzigd,
    historie.status,
    historie.aanpassing,
    historie_matrix_code.matrix_code,
    historie_matrix_code.actualisatie,
    historie.datum_aangemaakt::date + '1 year'::interval *
        CASE
            WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
            WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
            WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
            WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
            WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
            ELSE NULL::integer
        END::double precision AS volgende_update,
        CASE
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) >= now() THEN 'up-to-date'::text
            WHEN (historie.datum_aangemaakt::date + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) < now() THEN 'updaten'::text
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN historie_matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN historie_matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN historie_matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN historie_matrix_code.actualisatie::text = 'D'::text THEN 10
                WHEN historie_matrix_code.actualisatie::text = 'X'::text OR historie_matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) IS NULL THEN 'nog niet gemaakt'::text
            ELSE 'updaten binnen 3 maanden'::text
        END AS conditie
   FROM object
     LEFT JOIN historie ON historie.id = (( SELECT h.id
           FROM historie h
          WHERE h.object_id = object.id AND h.aanpassing::text <> 'aanpassing'::text
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN historie_matrix_code ON historie.matrix_code_id = historie_matrix_code.id;

REVOKE ALL ON stavaza_volgende_update FROM oiv_write;

-- create view t.b.v. de voortgang van productie en actualisatie van de objecten
CREATE OR REPLACE VIEW stavaza_objecten AS 
 SELECT obj.team,
    obj.totaal,
    obj.totaal_in_gebruik,
    obj.totaal_in_concept,
    obj.totaal_in_archief,
    obj.totaal_geen_status,
    obj.totaal_prio_1,
    obj.totaal_prio_2,
    obj.totaal_prio_3,
    obj.totaal_prio_4,
    obj.totaal_zonder_prio,
    obj.prio_1_in_gebruik,
    obj.prio_2_in_gebruik,
    obj.prio_3_in_gebruik,
    obj.prio_4_in_gebruik,
    obj.prio_1_concept,
    obj.prio_2_concept,
    obj.prio_3_concept,
    obj.prio_4_concept,
    obj.team_geom
   FROM ( SELECT o.team,
            count(o.team) AS totaal,
            count(status) FILTER (WHERE status::text = 'in gebruik'::text) AS totaal_in_gebruik,
            count(status) FILTER (WHERE status::text = 'concept'::text) AS totaal_in_concept,
            count(status) FILTER (WHERE status::text = 'archief'::text) AS totaal_in_archief,
            sum(
                CASE
                    WHEN status IS NULL THEN 1
                    ELSE 0
                END) AS totaal_geen_status,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 1) AS totaal_prio_1,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 2) AS totaal_prio_2,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 3) AS totaal_prio_3,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 4) AS totaal_prio_4,
            sum(
                CASE
                    WHEN mc.prio_prod IS NULL OR mc.matrix_code::text = '999'::text THEN 1
                    ELSE 0
                END) AS totaal_zonder_prio,
            count(status) FILTER (WHERE status::text = 'in gebruik'::text AND mc.prio_prod = 1) AS prio_1_in_gebruik,
            count(status) FILTER (WHERE status::text = 'in gebruik'::text AND mc.prio_prod = 2) AS prio_2_in_gebruik,
            count(status) FILTER (WHERE status::text = 'in gebruik'::text AND mc.prio_prod = 3) AS prio_3_in_gebruik,
            count(status) FILTER (WHERE status::text = 'in gebruik'::text AND mc.prio_prod = 4) AS prio_4_in_gebruik,
            count(status) FILTER (WHERE status::text = 'concept'::text AND mc.prio_prod = 1) AS prio_1_concept,
            count(status) FILTER (WHERE status::text = 'concept'::text AND mc.prio_prod = 2) AS prio_2_concept,
            count(status) FILTER (WHERE status::text = 'concept'::text AND mc.prio_prod = 3) AS prio_3_concept,
            count(status) FILTER (WHERE status::text = 'concept'::text AND mc.prio_prod = 4) AS prio_4_concept,
            o.team_geom
           FROM ( SELECT object.formelenaam,
                    object.basisreg_identifier,
                    object.geom,
                    object.id AS object_id,
                    historie.datum_aangemaakt,
                    historie.aanpassing,
                    historie.status,
                    historie.matrix_code_id,
                    tg.naam AS team,
                    tg.geom AS team_geom
                   FROM object
                     LEFT JOIN historie ON historie.id = (( SELECT h.id
                           FROM historie h
                          WHERE h.object_id = object.id
                          ORDER BY h.datum_aangemaakt DESC
                         LIMIT 1))
                     LEFT JOIN algemeen.team tg ON st_intersects(object.geom, tg.geom)
                  ORDER BY historie.status) o
             LEFT JOIN historie_matrix_code mc ON o.matrix_code_id = mc.id
          GROUP BY o.team, o.team_geom) obj;
	 
REVOKE ALL ON stavaza_objecten FROM oiv_write;

CREATE OR REPLACE VIEW stavaza_update_gemeente AS 
 SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.conditie) FILTER (WHERE s.conditie = 'up-to-date'::text) AS up_to_date,
    count(s.conditie) FILTER (WHERE s.conditie = 'updaten binnen 3 maanden'::text) AS binnen_3_maanden,
    count(s.conditie) FILTER (WHERE s.conditie = 'updaten'::text) AS updaten,
    count(s.conditie) FILTER (WHERE s.conditie = 'nog niet gemaakt'::text) AS nog_maken,
    g.geom
   FROM stavaza_volgende_update s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;
  
CREATE OR REPLACE VIEW stavaza_status_gemeente AS 
 SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.status) FILTER (WHERE s.status::text = 'in gebruik') AS totaal_in_gebruik,
    count(s.status) FILTER (WHERE s.status::text = 'concept') AS totaal_in_concept,
    count(s.status) FILTER (WHERE s.status::text = 'archief') AS totaal_in_archief,
    sum(
        CASE
            WHEN s.status IS NULL THEN 1
            ELSE 0
        END) AS totaal_geen_status,
    g.geom
   FROM status_objectgegevens s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;

-- create view bouwlagen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_bouwlagen AS
SELECT bl.id, bl.geom, bl.datum_aangemaakt, bl.datum_gewijzigd, bl.bouwlaag, bl.bouwdeel, part.object_id, part.formelenaam FROM bouwlagen bl
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part 
ON ST_INTERSECTS(bl.geom, part.geovlak);

-- create view bouwkundige veiligheidsvoorzieningen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_veiligh_bouwk AS
SELECT s.*, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel FROM veiligh_bouwk s
INNER JOIN bouwlagen b ON s.bouwlaag_id = b.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(s.geom, part.geovlak);

-- create view ruimten, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_ruimten AS 
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
   FROM ruimten r
     JOIN bouwlagen b ON r.bouwlaag_id = b.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            ST_MULTI(ST_UNION(t_1.geom))::geometry(MultiPolygon, 28992) as geovlak
           FROM object o
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN terrein t_1 ON o.id = t_1.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(r.geom, part.geovlak);

-- create view labels op een bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_label_bouwlaag AS 
SELECT l.id, l.geom, l.datum_aangemaakt, l.datum_gewijzigd, l.omschrijving, l.soort, l.rotatie, l.bouwlaag_id, part.formelenaam, part.object_id, b.bouwlaag, b.bouwdeel, ROUND(ST_X(l.geom)) AS X, ROUND(ST_Y(l.geom)) AS Y FROM label l
INNER JOIN bouwlagen b ON l.bouwlaag_id = b.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(l.geom, part.geovlak);

-- create view installatietechnische veiligheidsvoorzieningen, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW objecten.view_veiligh_install
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.veiligh_install_type_id,
    v.label,
    v.bouwlaag_id,
    v.rotatie,
    v.fotografie_id,
    v.bijzonderheid,
    t.naam AS soort,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(v.geom)) AS x,
    round(st_y(v.geom)) AS y,
    t.symbol_name,
    t.size
   FROM objecten.veiligh_install v
     JOIN objecten.veiligh_install_type t ON v.veiligh_install_type_id = t.id
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_multi(st_union(t_1.geom))::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t_1 ON o.id = t_1.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(v.geom, part.geovlak);

-- view van gevaarlijkestoffen locatie met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_gevaarlijkestof_bouwlaag AS 
SELECT gvs.id, gvs.opslag_id, gvs.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, gvs.eenheid, gvs.toestand,
    part.object_id, part.formelenaam, ops.bouwlaag, ops.bouwdeel, ops.geom, ops.locatie, ops.rotatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y, ops.bouwlaag_id FROM gevaarlijkestof gvs
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN 
  (SELECT op.id, op.geom, op.bouwlaag_id, op.locatie, op.rotatie, b.bouwlaag, b.bouwdeel FROM gevaarlijkestof_opslag op
  INNER JOIN bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(ops.geom, part.geovlak);

-- view van gevaarlijkestoffen schade crikel met gevaarlijke stoffen gecombineerd met formelenaam van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW view_schade_cirkel_bouwlaag AS 
SELECT gvs.id, gvs.opslag_id, gvs.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, gvs.hoeveelheid, gvs.eenheid, gvs.toestand,
    part.object_id, part.formelenaam, ops.bouwlaag, ops.bouwdeel, ST_BUFFER(ops.geom, gsc.straal)::geometry(Polygon,28992) AS geom, 
    ops.locatie, ROUND(ST_X(ops.geom)) AS X, ROUND(ST_Y(ops.geom)) AS Y, gsc.soort FROM gevaarlijkestof gvs
INNER JOIN gevaarlijkestof_schade_cirkel gsc ON gvs.id = gevaarlijkestof_id
LEFT JOIN gevaarlijkestof_vnnr vnnr ON gvs.gevaarlijkestof_vnnr_id = vnnr.id
INNER JOIN 
  (SELECT op.id, op.geom, op.bouwlaag_id, op.locatie, b.bouwlaag, b.bouwdeel FROM gevaarlijkestof_opslag op
  INNER JOIN bouwlagen b ON op.bouwlaag_id = b.id) ops ON gvs.opslag_id = ops.id
INNER JOIN (
  SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom))::geometry(MultiPolygon, 28992) as geovlak FROM object o
    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
    LEFT JOIN terrein t on o.id = t.object_id
    WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)
    GROUP BY formelenaam, o.id
    ) part
ON ST_INTERSECTS(ops.geom, part.geovlak);

CREATE OR REPLACE VIEW view_schade_cirkel_ruimtelijk AS
SELECT g.id, g.opslag_id, g.omschrijving, vnnr.vn_nr, vnnr.gevi_nr, vnnr.eric_kaart, g.hoeveelheid, g.eenheid, g.toestand,
    part.object_id, part.formelenaam, ST_BUFFER(part.geom, gsc.straal)::geometry(Polygon,28992) AS geom, part.locatie,
    ROUND(ST_X(part.geom)) AS X, ROUND(ST_Y(part.geom)) AS Y, gsc.soort FROM gevaarlijkestof g
INNER JOIN
  (
  SELECT ops.id AS opslag_id, ops.geom, ops.locatie, o.formelenaam, o.id AS object_id FROM gevaarlijkestof_opslag ops
  INNER JOIN (
        SELECT formelenaam, object.id FROM object
        LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = object.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
        WHERE status::text = 'in gebruik'::text AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL)) o 
  ON ops.object_id = o.id
  ) part ON g.opslag_id = part.opslag_id
INNER JOIN gevaarlijkestof_schade_cirkel gsc ON g.id = gevaarlijkestof_id
LEFT JOIN gevaarlijkestof_vnnr vnnr ON g.gevaarlijkestof_vnnr_id = vnnr.id;

-- create view dreiging bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW objecten.view_dreiging_bouwlaag
AS SELECT d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.dreiging_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    t.naam AS soort,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    t.symbol_name,
    t.size
   FROM objecten.dreiging d
     JOIN objecten.dreiging_type t ON d.dreiging_type_id = t.id
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_multi(st_union(t_1.geom))::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t_1 ON o.id = t_1.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(d.geom, part.geovlak);

-- create view ingang bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag
AS SELECT i.id,
    i.geom,
    i.datum_aangemaakt,
    i.datum_gewijzigd,
    i.ingang_type_id,
    i.rotatie,
    i.label,
    i.bouwlaag_id,
    i.fotografie_id,
    t.naam AS soort,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(i.geom)) AS x,
    round(st_y(i.geom)) AS y,
    t.symbol_name,
    t.size
   FROM objecten.ingang i
     JOIN objecten.ingang_type t ON i.ingang_type_id = t.id
     JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_multi(st_union(t_1.geom))::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t_1 ON o.id = t_1.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(i.geom, part.geovlak);

-- create view sleutelkluis bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag
AS SELECT s.id,
    s.geom,
    s.datum_aangemaakt,
    s.datum_gewijzigd,
    s.sleutelkluis_type_id,
    st.naam AS type,
    s.rotatie,
    s.label,
    s.aanduiding_locatie,
    s.sleuteldoel_type_id,
    sd.naam AS doel,
    s.ingang_id,
    s.fotografie_id,
    sub.formelenaam,
    sub.object_id,
    part.bouwlaag,
    part.bouwdeel,
    round(st_x(s.geom)) AS x,
    round(st_y(s.geom)) AS y,
    part.bouwlaag_id,
    st.symbol_name,
    st.size
   FROM objecten.sleutelkluis s
     JOIN ( SELECT i.id,
            i.geom,
            i.datum_aangemaakt,
            i.datum_gewijzigd,
            i.ingang_type_id,
            i.rotatie,
            i.label,
            i.belemmering,
            i.voorzieningen,
            i.bouwlaag_id,
            i.object_id,
            i.fotografie_id,
            b.bouwlaag,
            b.bouwdeel
           FROM objecten.ingang i
             JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id) part ON s.ingang_id = part.id
     JOIN objecten.sleutelkluis_type st ON s.sleutelkluis_type_id = st.id
     LEFT JOIN objecten.sleuteldoel_type sd ON s.sleuteldoel_type_id = sd.id
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_multi(st_union(t.geom))::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t ON o.id = t.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) sub ON st_intersects(s.geom, sub.geovlak);

-- create view dreiging bouwlaag, icm formelenaam object van alle objecten die de status hebben "in gebruik"
CREATE OR REPLACE VIEW objecten.view_afw_binnendekking
AS SELECT a.id,
    a.geom,
    a.datum_aangemaakt,
    a.datum_gewijzigd,
    a.soort,
    a.rotatie,
    a.label,
    a.handelingsaanwijzing,
    a.bouwlaag_id,
    part.formelenaam,
    part.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(a.geom)) AS x,
    round(st_y(a.geom)) AS y,
    t.symbol_name,
    t.size
   FROM objecten.afw_binnendekking a
     JOIN objecten.bouwlagen b ON a.bouwlaag_id = b.id
     JOIN objecten.afw_binnendekking_type t ON a.soort = t.naam
     JOIN ( SELECT DISTINCT o.formelenaam,
            o.id AS object_id,
            st_multi(st_union(t.geom))::geometry(MultiPolygon,28992) AS geovlak
           FROM objecten.object o
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = o.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
             LEFT JOIN objecten.terrein t ON o.id = t.object_id
          WHERE historie.status::text = 'in gebruik'::text AND (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
          GROUP BY o.formelenaam, o.id) part ON st_intersects(a.geom, part.geovlak);

CREATE OR REPLACE VIEW objecten.view_objectgegevens
AS SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    object.datum_geldig_vanaf,
    object.datum_geldig_tot,
    object.bron,
    object.bron_tabel,
    object.fotografie_id,
    bg.naam AS bodemgesteldheid,
    gf.gebruiksfuncties,
    round(st_x(object.geom)) AS x,
    round(st_y(object.geom)) AS y,
    o.typeobject
   FROM objecten.object
     JOIN ( SELECT object_1.formelenaam,
            object_1.id AS object_id,
            historie.typeobject
           FROM objecten.object object_1
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id 
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object_1.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object_1.datum_geldig_vanaf <= now() OR object_1.datum_geldig_vanaf IS NULL) AND (object_1.datum_geldig_tot > now() OR object_1.datum_geldig_tot IS NULL)) o ON object.id = o.object_id
     LEFT JOIN objecten.bodemgesteldheid_type bg ON object.bodemgesteldheid_type_id = bg.id
     LEFT JOIN ( SELECT DISTINCT g.object_id,
            string_agg(gt.naam, ', '::text) AS gebruiksfuncties
           FROM objecten.gebruiksfunctie g
             JOIN objecten.gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
          GROUP BY g.object_id) gf ON object.id = gf.object_id;

CREATE OR REPLACE VIEW veiligh_bouwk_types AS
select 
row_number() OVER (ORDER BY e.enumlabel)::integer AS id, e.enumlabel::text as naam
from pg_type t 
   join pg_enum e on t.oid = e.enumtypid  
   join pg_catalog.pg_namespace n ON n.oid = t.typnamespace
where t.typname = 'veiligh_bouwk_type';

CREATE OR REPLACE VIEW object_bgt AS 
 SELECT object.*,
    o.typeobject
   FROM object
   INNER JOIN ( SELECT object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON object.id = o.id
  WHERE object.bron::text = 'BGT'::text;

CREATE OR REPLACE VIEW object_veiligh_ruimtelijk AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    vt.symbol_name,
    vt.size
   FROM veiligh_ruimtelijk b
     JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id
     JOIN veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id;

CREATE OR REPLACE RULE veiligh_ruimtelijk_del AS
    ON DELETE TO object_veiligh_ruimtelijk DO INSTEAD  DELETE FROM veiligh_ruimtelijk
  WHERE veiligh_ruimtelijk.id = old.id;

CREATE OR REPLACE RULE veiligh_ruimtelijk_ins AS
    ON INSERT TO object_veiligh_ruimtelijk DO INSTEAD INSERT INTO veiligh_ruimtelijk (geom, veiligh_ruimtelijk_type_id, label, rotatie, object_id, fotografie_id)
  VALUES (new.geom, new.veiligh_ruimtelijk_type_id, new.label, new.rotatie, new.object_id, new.fotografie_id)
  RETURNING veiligh_ruimtelijk.id,
    veiligh_ruimtelijk.geom,
    veiligh_ruimtelijk.datum_aangemaakt,
    veiligh_ruimtelijk.datum_gewijzigd,
    veiligh_ruimtelijk.veiligh_ruimtelijk_type_id,
    veiligh_ruimtelijk.label,
    veiligh_ruimtelijk.object_id,
    veiligh_ruimtelijk.rotatie,
    veiligh_ruimtelijk.fotografie_id,
    veiligh_ruimtelijk.bijzonderheid,
    (SELECT formelenaam FROM object o WHERE o.id = veiligh_ruimtelijk.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = veiligh_ruimtelijk.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = veiligh_ruimtelijk.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = veiligh_ruimtelijk.object_id LIMIT 1),
    (SELECT st.symbol_name FROM veiligh_ruimtelijk_type st WHERE st.id = veiligh_ruimtelijk.veiligh_ruimtelijk_type_id),
    (SELECT st.size FROM veiligh_ruimtelijk_type st WHERE st.id = veiligh_ruimtelijk.veiligh_ruimtelijk_type_id);

CREATE OR REPLACE RULE veiligh_ruimtelijk_upd AS
    ON UPDATE TO object_veiligh_ruimtelijk DO INSTEAD 
    UPDATE veiligh_ruimtelijk SET geom = new.geom, veiligh_ruimtelijk_type_id = new.veiligh_ruimtelijk_type_id, rotatie = new.rotatie, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE veiligh_ruimtelijk.id = new.id;

CREATE OR REPLACE VIEW object_dreiging AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    vt.symbol_name,
    vt.size
   FROM dreiging b
     JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id
     JOIN dreiging_type vt ON b.dreiging_type_id = vt.id
   WHERE object_id IS NOT NULL;

CREATE OR REPLACE RULE dreiging_del AS
    ON DELETE TO object_dreiging DO INSTEAD DELETE FROM dreiging
  WHERE dreiging.id = old.id;

CREATE OR REPLACE RULE dreiging_ins AS
    ON INSERT TO object_dreiging DO INSTEAD INSERT INTO dreiging (geom, dreiging_type_id, label, rotatie, object_id, fotografie_id)
  VALUES (new.geom, new.dreiging_type_id, new.label, new.rotatie, new.object_id, new.fotografie_id)
  RETURNING dreiging.id,
    dreiging.geom,
    dreiging.datum_aangemaakt,
    dreiging.datum_gewijzigd,
    dreiging.dreiging_type_id,
    dreiging.rotatie,
    dreiging.label,
    dreiging.bouwlaag_id,
    dreiging.object_id,
    dreiging.fotografie_id,
    dreiging.omschrijving,
    (SELECT formelenaam FROM object o WHERE o.id = dreiging.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = dreiging.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = dreiging.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = dreiging.object_id LIMIT 1),
    (SELECT st.symbol_name FROM dreiging_type st WHERE st.id = dreiging.dreiging_type_id),
    (SELECT st.size FROM dreiging_type st WHERE st.id = dreiging.dreiging_type_id);

CREATE OR REPLACE RULE dreiging_upd AS
    ON UPDATE TO object_dreiging DO INSTEAD UPDATE dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, rotatie = new.rotatie, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE dreiging.id = new.id;

CREATE OR REPLACE VIEW object_ingang AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    vt.symbol_name,
    vt.size
   FROM ingang b
     JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id
     JOIN ingang_type vt ON b.ingang_type_id = vt.id;

CREATE OR REPLACE RULE ingang_del AS
    ON DELETE TO object_ingang DO INSTEAD DELETE FROM ingang
  WHERE ingang.id = old.id;

CREATE OR REPLACE RULE ingang_ins AS
    ON INSERT TO object_ingang DO INSTEAD  INSERT INTO ingang (geom, ingang_type_id, label, rotatie, belemmering, voorzieningen, object_id, fotografie_id)
  VALUES (new.geom, new.ingang_type_id, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.object_id, new.fotografie_id)
  RETURNING ingang.id,
    ingang.geom,
    ingang.datum_aangemaakt,
    ingang.datum_gewijzigd,
    ingang.ingang_type_id,
    ingang.rotatie,
    ingang.label,
    ingang.belemmering,
    ingang.voorzieningen,
    ingang.bouwlaag_id,
    ingang.object_id,
    ingang.fotografie_id,
    (SELECT formelenaam FROM object o WHERE o.id = ingang.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = ingang.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = ingang.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = ingang.object_id LIMIT 1),
    (SELECT st.symbol_name FROM ingang_type st WHERE st.id = ingang.ingang_type_id),
    (SELECT st.size FROM ingang_type st WHERE st.id = ingang.ingang_type_id);

CREATE OR REPLACE RULE ingang_upd AS
    ON UPDATE TO object_ingang DO INSTEAD 
    UPDATE ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE ingang.id = new.id;

CREATE OR REPLACE VIEW object_sleutelkluis AS 
 SELECT v.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    vt.symbol_name,
    vt.size 
   FROM sleutelkluis v
   INNER JOIN ingang ib ON v.ingang_id = ib.id
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON ib.object_id = o.id
   INNER JOIN sleutelkluis_type vt ON v.sleutelkluis_type_id = vt.id;

CREATE OR REPLACE RULE object_sleutelkluis_ins AS
    ON INSERT TO object_sleutelkluis DO INSTEAD  INSERT INTO sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, fotografie_id)
  VALUES (new.geom, new.sleutelkluis_type_id, new.label, new.rotatie, new.aanduiding_locatie, new.sleuteldoel_type_id, new.ingang_id, new.fotografie_id)
  RETURNING sleutelkluis.id,
    sleutelkluis.geom,
    sleutelkluis.datum_aangemaakt,
    sleutelkluis.datum_gewijzigd,
    sleutelkluis.sleutelkluis_type_id,
    sleutelkluis.rotatie,
    sleutelkluis.label,
    sleutelkluis.aanduiding_locatie,
    sleutelkluis.sleuteldoel_type_id,
    sleutelkluis.ingang_id,
    sleutelkluis.fotografie_id,
    (SELECT formelenaam FROM object o INNER JOIN ingang i ON o.id = i.object_id WHERE i.id = sleutelkluis.ingang_id),
    (SELECT datum_geldig_vanaf FROM object o INNER JOIN ingang i ON o.id = i.object_id WHERE i.id = sleutelkluis.ingang_id),
    (SELECT datum_geldig_tot FROM object o INNER JOIN ingang i ON o.id = i.object_id WHERE i.id = sleutelkluis.ingang_id),
    (SELECT typeobject FROM historie o INNER JOIN ingang i ON o.object_id = i.object_id WHERE i.id = sleutelkluis.ingang_id LIMIT 1),
    (SELECT st.symbol_name FROM sleutelkluis_type st WHERE st.id = sleutelkluis.sleutelkluis_type_id),
    (SELECT st.size FROM sleutelkluis_type st WHERE st.id = sleutelkluis.sleutelkluis_type_id);

CREATE OR REPLACE RULE object_sleutelkluis_upd AS
    ON UPDATE TO object_sleutelkluis DO INSTEAD UPDATE sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, sleuteldoel_type_id = new.sleuteldoel_type_id, ingang_id = new.ingang_id, fotografie_id = new.fotografie_id
  WHERE sleutelkluis.id = new.id;

CREATE OR REPLACE RULE object_ruimtelijk_del AS
    ON DELETE TO object_sleutelkluis DO INSTEAD  DELETE FROM sleutelkluis
  WHERE sleutelkluis.id = old.id;

CREATE OR REPLACE VIEW object_opstelplaats AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.rotatie,
    v.object_id,
    v.fotografie_id,
    v.label,
    v.soort,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    st.symbol_name,
    st.size
   FROM opstelplaats v
     JOIN ( SELECT object.formelenaam,
            object.datum_geldig_vanaf,
            object.datum_geldig_tot,
            object.id,
            historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON v.object_id = o.id
     JOIN opstelplaats_type st ON v.soort::text = st.naam::text;

CREATE OR REPLACE RULE object_opstelplaats_upd AS
    ON UPDATE TO object_opstelplaats DO INSTEAD UPDATE opstelplaats SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE opstelplaats.id = new.id;

CREATE OR REPLACE RULE object_opstelplaats_del AS
    ON DELETE TO object_opstelplaats DO INSTEAD  DELETE FROM opstelplaats
  WHERE opstelplaats.id = old.id;

CREATE OR REPLACE RULE object_opstelplaats_ins AS
    ON INSERT TO object_opstelplaats DO INSTEAD  INSERT INTO opstelplaats (geom, soort, label, rotatie, object_id, fotografie_id)
  VALUES (new.geom, new.soort, new.label, new.rotatie, new.object_id, new.fotografie_id)
  RETURNING opstelplaats.id,
    opstelplaats.geom,
    opstelplaats.datum_aangemaakt,
    opstelplaats.datum_gewijzigd,
    opstelplaats.rotatie,
    opstelplaats.object_id,
    opstelplaats.fotografie_id,
    opstelplaats.label,
    opstelplaats.soort,
    (SELECT formelenaam FROM object o WHERE o.id = opstelplaats.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = opstelplaats.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = opstelplaats.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = opstelplaats.object_id LIMIT 1),
    (SELECT styles_symbols_type.symbol_name FROM algemeen.styles_symbols_type WHERE styles_symbols_type.naam = 'Opslag stoffen'::text) AS symbol_name,
    (SELECT styles_symbols_type.size FROM algemeen.styles_symbols_type WHERE styles_symbols_type.naam = 'Opslag stoffen'::text) AS size; 

CREATE OR REPLACE VIEW object_opslag AS 
 SELECT v.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    st.symbol_name,
    st.size
   FROM gevaarlijkestof_opslag v
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON v.object_id = o.id
   INNER JOIN algemeen.styles_symbols_type st ON 'Opslag stoffen'::text = st.naam;

CREATE OR REPLACE RULE opslag_del AS
    ON DELETE TO object_opslag DO INSTEAD  DELETE FROM gevaarlijkestof_opslag
  WHERE gevaarlijkestof_opslag.id = old.id;

CREATE OR REPLACE RULE opslag_upd AS
    ON UPDATE TO object_opslag DO INSTEAD  UPDATE gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE gevaarlijkestof_opslag.id = new.id;

CREATE OR REPLACE RULE opslag_ins AS
    ON INSERT TO object_opslag DO INSTEAD INSERT INTO gevaarlijkestof_opslag (geom, locatie, object_id, fotografie_id, rotatie)
  VALUES (new.geom, new.locatie, new.object_id, new.fotografie_id, new.rotatie)
  RETURNING gevaarlijkestof_opslag.id,
    gevaarlijkestof_opslag.geom,
    gevaarlijkestof_opslag.datum_aangemaakt,
    gevaarlijkestof_opslag.datum_gewijzigd,
    gevaarlijkestof_opslag.locatie,
    gevaarlijkestof_opslag.bouwlaag_id,
    gevaarlijkestof_opslag.object_id,
    gevaarlijkestof_opslag.fotografie_id,
    gevaarlijkestof_opslag.rotatie,
    (SELECT formelenaam FROM object o WHERE o.id = gevaarlijkestof_opslag.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = gevaarlijkestof_opslag.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = gevaarlijkestof_opslag.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = gevaarlijkestof_opslag.object_id LIMIT 1),
    (SELECT styles_symbols_type.symbol_name FROM algemeen.styles_symbols_type WHERE styles_symbols_type.naam = 'Opslag stoffen'::text) AS symbol_name,
    (SELECT styles_symbols_type.size FROM algemeen.styles_symbols_type WHERE styles_symbols_type.naam = 'Opslag stoffen'::text) AS size;

CREATE OR REPLACE VIEW object_objecten AS 
 SELECT object.*,
    o.typeobject
   FROM object
   INNER JOIN ( SELECT object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON object.id = o.id;

CREATE OR REPLACE RULE object_del AS
    ON DELETE TO object_objecten DO INSTEAD  DELETE FROM object
  WHERE object.id = old.id;

CREATE OR REPLACE RULE object_upd AS
    ON UPDATE TO objecten.object_objecten DO INSTEAD  
		UPDATE objecten.object 
		SET geom = new.geom, basisreg_identifier = new.basisreg_identifier, formelenaam = new.formelenaam, 
			pers_max = new.pers_max, pers_nietz_max = new.pers_nietz_max, datum_geldig_tot = new.datum_geldig_tot, 
			datum_geldig_vanaf = new.datum_geldig_vanaf, bron = new.bron, bron_tabel = new.bron_tabel, fotografie_id = new.fotografie_id, 
			bodemgesteldheid_type_id = new.bodemgesteldheid_type_id, bijzonderheden = new.bijzonderheden
  WHERE object.id = new.id;

CREATE OR REPLACE RULE object_ins AS
    ON INSERT TO object_objecten DO INSTEAD INSERT INTO object (geom, basisreg_identifier, formelenaam, bron, bron_tabel)  
  VALUES (new.geom, new.basisreg_identifier, new.formelenaam, new.bron, new.bron_tabel)
  RETURNING object.id,
    object.geom,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.basisreg_identifier,
    object.formelenaam,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    object.datum_geldig_tot,
    object.datum_geldig_vanaf,
    object.bron,
    object.bron_tabel,
    object.fotografie_id,
    object.bodemgesteldheid_type_id,
    (SELECT typeobject FROM historie o WHERE o.object_id = object.id LIMIT 1);

CREATE OR REPLACE VIEW object_label AS 
 SELECT l.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject,
    st.size,
    st.symbol_name
   FROM label l
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON l.object_id = o.id     
   INNER JOIN label_type st ON l.soort::text = st.naam;

CREATE OR REPLACE RULE object_label_del AS
    ON DELETE TO object_label DO INSTEAD  DELETE FROM label
  WHERE label.id = old.id;

CREATE OR REPLACE RULE object_label_upd AS
    ON UPDATE TO object_label DO INSTEAD  UPDATE label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, object_id = new.object_id
  WHERE label.id = new.id;

CREATE OR REPLACE RULE object_label_ins AS
    ON INSERT TO object_label DO INSTEAD  INSERT INTO label (geom, soort, omschrijving, rotatie, object_id)
  VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.object_id)
  RETURNING label.id,
    label.geom,
    label.datum_aangemaakt,
    label.datum_gewijzigd,
    label.omschrijving,
	  label.soort,    
    label.rotatie,
    label.bouwlaag_id,
    label.object_id,
    (SELECT formelenaam FROM object o WHERE o.id = label.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = label.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = label.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = label.object_id LIMIT 1),
    (SELECT size FROM algemeen.styles_symbols_type WHERE label.soort::TEXT = algemeen.styles_symbols_type.naam),
    (SELECT symbol_name FROM algemeen.styles_symbols_type WHERE label.soort::TEXT = algemeen.styles_symbols_type.naam);

CREATE OR REPLACE VIEW object_bereikbaarheid AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM bereikbaarheid b
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE object_bereikbaarheid_del AS
    ON DELETE TO object_bereikbaarheid DO INSTEAD  DELETE FROM bereikbaarheid
  WHERE bereikbaarheid.id = old.id;

CREATE OR REPLACE RULE object_bereikbaarheid_upd AS
    ON UPDATE TO object_bereikbaarheid DO INSTEAD  
    UPDATE bereikbaarheid SET geom = new.geom, obstakels = new.obstakels, wegafzetting = new.wegafzetting, soort = new.soort, object_id = new.object_id, fotografie_id = new.fotografie_id, label = new.label
  WHERE bereikbaarheid.id = new.id;

CREATE OR REPLACE RULE object_bereikbaarheid_ins AS
    ON INSERT TO object_bereikbaarheid DO INSTEAD  INSERT INTO bereikbaarheid (geom, obstakels, wegafzetting, soort, object_id, fotografie_id, label)
  VALUES (new.geom, new.obstakels, new.wegafzetting, new.soort, new.object_id, new.fotografie_id, new.label)
  RETURNING bereikbaarheid.id,
    bereikbaarheid.geom,
    bereikbaarheid.datum_aangemaakt,
    bereikbaarheid.datum_gewijzigd,
    bereikbaarheid.obstakels,
    bereikbaarheid.wegafzetting,
    bereikbaarheid.soort,     
    bereikbaarheid.object_id,
    bereikbaarheid.fotografie_id,
    bereikbaarheid.label,   
    (SELECT formelenaam FROM object o WHERE o.id = bereikbaarheid.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = bereikbaarheid.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = bereikbaarheid.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = bereikbaarheid.object_id LIMIT 1);

CREATE OR REPLACE VIEW object_sectoren AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM sectoren b
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE object_sectoren_del AS
    ON DELETE TO object_sectoren DO INSTEAD  DELETE FROM sectoren
  WHERE sectoren.id = old.id;

CREATE OR REPLACE RULE object_sectoren_upd AS
    ON UPDATE TO object_sectoren DO INSTEAD  
    UPDATE sectoren SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
  WHERE sectoren.id = new.id;

CREATE OR REPLACE RULE object_sectoren_ins AS
    ON INSERT TO object_sectoren DO INSTEAD  INSERT INTO sectoren (geom, soort, omschrijving, label, object_id, fotografie_id)
  VALUES (new.geom, new.soort, new.omschrijving, new.label, new.object_id, new.fotografie_id)
  RETURNING sectoren.id,
    sectoren.geom,
    sectoren.datum_aangemaakt,
    sectoren.datum_gewijzigd,
    sectoren.soort,    
    sectoren.omschrijving,
    sectoren.label,
    sectoren.object_id,
    sectoren.fotografie_id,
    (SELECT formelenaam FROM object o WHERE o.id = sectoren.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = sectoren.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = sectoren.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = sectoren.object_id LIMIT 1);

CREATE OR REPLACE VIEW object_isolijnen AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM isolijnen b
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE object_isolijnen_del AS
    ON DELETE TO object_isolijnen DO INSTEAD  DELETE FROM isolijnen
  WHERE isolijnen.id = old.id;

CREATE OR REPLACE RULE object_isolijnen_upd AS
    ON UPDATE TO object_isolijnen DO INSTEAD  
    UPDATE isolijnen SET geom = new.geom, hoogte = new.hoogte, omschrijving = new.omschrijving, object_id = new.object_id
  WHERE isolijnen.id = new.id;

CREATE OR REPLACE RULE object_isolijnen_ins AS
    ON INSERT TO object_isolijnen DO INSTEAD  INSERT INTO isolijnen (geom, hoogte, omschrijving, object_id)
  VALUES (new.geom, new.hoogte, new.omschrijving, new.object_id)
  RETURNING isolijnen.id,
    isolijnen.geom,
    isolijnen.datum_aangemaakt,
    isolijnen.datum_gewijzigd,
    isolijnen.hoogte,
    isolijnen.omschrijving,
     isolijnen.object_id,
    (SELECT formelenaam FROM object o WHERE o.id = isolijnen.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = isolijnen.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = isolijnen.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = isolijnen.object_id LIMIT 1);

CREATE OR REPLACE VIEW object_terrein AS 
 SELECT b.*,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM terrein b
   INNER JOIN ( SELECT object.formelenaam, object.datum_geldig_vanaf, object.datum_geldig_tot, object.id, historie.typeobject
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))) o ON b.object_id = o.id;

CREATE OR REPLACE RULE object_terrein_del AS
    ON DELETE TO object_terrein DO INSTEAD  DELETE FROM terrein
  WHERE terrein.id = old.id;

CREATE OR REPLACE RULE object_terrein_upd AS
    ON UPDATE TO object_terrein DO INSTEAD  
    UPDATE terrein SET geom = new.geom, omschrijving = new.omschrijving, object_id = new.object_id
  WHERE terrein.id = new.id;

CREATE OR REPLACE RULE object_terrein_ins AS
    ON INSERT TO object_terrein DO INSTEAD  INSERT INTO terrein (geom, omschrijving, object_id)
  VALUES (new.geom, new.omschrijving, new.object_id)
  RETURNING terrein.id,
    terrein.geom,
    terrein.datum_aangemaakt,
    terrein.datum_gewijzigd,
    terrein.omschrijving,
    terrein.object_id,
    (SELECT formelenaam FROM object o WHERE o.id = terrein.object_id),
    (SELECT datum_geldig_vanaf FROM object o WHERE o.id = terrein.object_id),
    (SELECT datum_geldig_tot FROM object o WHERE o.id = terrein.object_id),
    (SELECT typeobject FROM historie o WHERE o.object_id = terrein.object_id LIMIT 1);

CREATE OR REPLACE VIEW object_grid
AS SELECT b.id,
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
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    o.typeobject
   FROM objecten.grid b
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

CREATE RULE object_grid_del AS
    ON DELETE TO objecten.object_grid DO INSTEAD DELETE FROM objecten.grid
  WHERE (grid.id = old.id);

CREATE RULE object_grid_upd AS
    ON UPDATE TO objecten.object_grid DO INSTEAD  UPDATE objecten.grid SET geom = new.geom, x_as_label = new.x_as_label, y_as_label = new.y_as_label, object_id = new.object_id, afstand = new.afstand,
    			vaknummer = new.vaknummer, scale = new.scale, papersize = new.papersize, orientation = new.orientation, type = new.type, uuid = new.uuid
  WHERE (grid.id = new.id);

CREATE RULE object_grid_ins AS
    ON INSERT TO objecten.object_grid DO INSTEAD  INSERT INTO objecten.grid (geom, x_as_label, y_as_label, object_id, afstand, vaknummer, scale, papersize, orientation, type, uuid)
  VALUES (new.geom, new.x_as_label, new.y_as_label, new.object_id, new.afstand, new.vaknummer, new.scale, new.papersize, new.orientation, new.type, new.uuid)
  RETURNING grid.id,
    grid.geom,
    grid.datum_aangemaakt,
    grid.datum_gewijzigd,
    grid.y_as_label,
    grid.x_as_label,
    grid.object_id,
    grid.afstand,
    grid.vaknummer,
    grid.scale,
    grid.papersize,
    grid.orientation,
    grid.type,
    grid.uuid,
    ( SELECT o.formelenaam
           FROM objecten.object o
          WHERE (o.id = grid.object_id)) AS formelenaam,
    ( SELECT o.datum_geldig_vanaf
           FROM objecten.object o
          WHERE (o.id = grid.object_id)) AS datum_geldig_vanaf,
    ( SELECT o.datum_geldig_tot
           FROM objecten.object o
          WHERE (o.id = grid.object_id)) AS datum_geldig_tot,
    ( SELECT o.typeobject
           FROM objecten.historie o
          WHERE (o.object_id = grid.object_id)
         LIMIT 1) AS typeobject;

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



REVOKE ALL ON TABLE stavaza_status_gemeente FROM GROUP oiv_write;
REVOKE ALL ON TABLE stavaza_update_gemeente FROM GROUP oiv_write;
REVOKE ALL ON TABLE veiligh_bouwk_types     FROM GROUP oiv_write;