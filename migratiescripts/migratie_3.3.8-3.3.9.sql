SET role oiv_admin;
SET search_path = info_of_interest, pg_catalog, public;

-- issue 146 - Terrein niet begaanbaar
INSERT INTO algemeen.styles ("laagnaam", "soortnaam", "lijndikte", "lijnkleur", "lijnstijl", "vulkleur", "vulstijl", "verbindingsstijl")
    VALUES ('Sectoren','terrein niet-begaanbaar', 1, '#fffc1e1c', 'solid', '#fffc1e1c', 'b_diagonal', 'bevel');

INSERT INTO objecten.sectoren_type (id, naam) VALUES (11, 'terrein niet-begaanbaar');

-- issue 144 - Afbrand scenario
INSERT INTO algemeen.styles ("laagnaam", "soortnaam", "lijndikte", "lijnkleur", "lijnstijl", "vulkleur", "vulstijl", "verbindingsstijl")
    VALUES ('Ruimten','afbrand scenario', 0.1, '#fffc1e1c', 'solid', '#fffc1e1c', 'b_diagonal', 'bevel');

INSERT INTO objecten.ruimten_type (id, naam) VALUES (11, 'afbrand scenario');

-- issue 145 - Symboolgrootte object splitsen van bouwlaag grootte
ALTER TABLE objecten.dreiging_type ADD COLUMN size_object INTEGER;
ALTER TABLE objecten.ingang_type ADD COLUMN size_object INTEGER;
ALTER TABLE objecten.label_type ADD COLUMN size_object NUMERIC;
ALTER TABLE objecten.sleutelkluis_type ADD COLUMN size_object INTEGER;

CREATE TABLE objecten.gevaarlijkestof_opslag_type (
  id INTEGER NOT NULL,
  naam text NOT NULL UNIQUE,
  symbol_name text NULL,
  "size" int4 NULL,
  size_object INTEGER,
  CONSTRAINT gevaarlijkestof_opslag_type_pkey PRIMARY KEY (id)
);

INSERT INTO objecten.gevaarlijkestof_opslag_type(id, naam, symbol_name, "size", size_object) VALUES (1, 'Opslag stoffen', 'opslag_stoffen', 3, 6);

-- !!!! LET OP: de grootte wordt ingesteld op 2x de groote van het symbool op de bouwlaag. Dit was ook zo tot en met nu.
-- Vanaf nu kan de grootte voor de "object" symbolen zelf worden ingesteld via size_object !!!!
UPDATE objecten.dreiging_type SET size_object = size * 2;
UPDATE objecten.ingang_type SET size_object = size * 2;
UPDATE objecten.label_type SET size_object = size * 2;
UPDATE objecten.sleutelkluis_type SET size_object = size * 2;

CREATE OR REPLACE VIEW objecten.object_dreiging
AS SELECT v.id,
    v.geom,
    v.dreiging_type_id,
    v.label,
    v.fotografie_id,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    st.symbol_name,
    st.size_object as size,
    ''::text AS applicatie
   FROM objecten.dreiging v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.dreiging_type st ON v.dreiging_type_id = st.id;

CREATE OR REPLACE VIEW objecten.object_ingang
AS SELECT v.id,
    v.geom,
    v.ingang_type_id,
    v.label,
    v.belemmering,
    v.voorzieningen,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    it.symbol_name,
    it.size_object as size,
    ''::text AS applicatie
   FROM objecten.ingang v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.ingang_type it ON v.ingang_type_id = it.id;

CREATE OR REPLACE VIEW objecten.object_label
AS SELECT l.id,
    l.geom,
    l.soort,
    l.omschrijving,
    l.bouwlaag_id,
    l.object_id,
    b.formelenaam,
    l.rotatie,
    st.symbol_name,
    st.size_object as size,
    ''::text AS applicatie
   FROM objecten.label l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN objecten.label_type st ON l.soort::text = st.naam::text;

CREATE OR REPLACE VIEW objecten.object_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.sleutelkluis_type_id,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.fotografie_id,
    v.ingang_id,
    part.formelenaam,
    v.rotatie,
    it.symbol_name,
    it.size_object as size,
    ''::text AS applicatie
   FROM objecten.sleutelkluis v
     JOIN ( SELECT b.formelenaam,
            ib.id,
            ib.object_id
           FROM objecten.ingang ib
             JOIN objecten.object b ON ib.object_id = b.id) part ON v.ingang_id = part.id
     JOIN objecten.sleutelkluis_type it ON v.sleutelkluis_type_id = it.id;

CREATE OR REPLACE VIEW objecten.bouwlaag_opslag
AS SELECT o.id,
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
    st.size,
    ''::text AS applicatie
   FROM objecten.gevaarlijkestof_opslag o
     JOIN objecten.bouwlagen b ON o.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam;

CREATE OR REPLACE VIEW objecten.object_opslag
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    b.formelenaam,
    o.rotatie,
    st.size_object as size,
    st.symbol_name,
    ''::text AS applicatie
   FROM objecten.gevaarlijkestof_opslag o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam;

-- !!!! LET OP: onderstaande scripts hebben effect op de verbeelding (grootte) naar de voertuigen!!!!
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
    vt.size_object as size
   FROM objecten.object o
     JOIN objecten.dreiging b ON o.id = b.object_id
     JOIN objecten.dreiging_type vt ON b.dreiging_type_id = vt.id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

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
    b.object_id,
    b.fotografie_id,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.naam AS soort,
    vt.symbol_name,
    vt.size_object as size
   FROM objecten.object o
     JOIN objecten.ingang b ON o.id = b.object_id
     JOIN objecten.ingang_type vt ON b.ingang_type_id = vt.id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

CREATE OR REPLACE VIEW objecten.view_label_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.rotatie,
    b.bouwlaag_id,
    b.object_id,
    b.soort,
    o.formelenaam,
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.size_object as size
   FROM objecten.object o
     JOIN objecten.label b ON o.id = b.object_id
     JOIN objecten.label_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

CREATE OR REPLACE VIEW objecten.view_sleutelkluis_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.sleutelkluis_type_id,
    d.aanduiding_locatie,
    d.sleuteldoel_type_id,
    d.rotatie,
    d.label,
    d.ingang_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    i.object_id,
    dd.naam AS doel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size_object as size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.ingang i ON o.id = i.object_id
     JOIN objecten.sleutelkluis d ON i.id = d.ingang_id
     JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

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
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    st.symbol_name,
    st.size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

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
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    st.symbol_name,
    st.size_object as size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL);

DROP TABLE algemeen.styles_symbols_type;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 9;
UPDATE algemeen.applicatie SET db_versie = 339; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();