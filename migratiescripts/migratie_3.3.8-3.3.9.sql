SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- issue 146 - Terrein niet begaanbaar
INSERT INTO algemeen.styles ("laagnaam", "soortnaam", "lijndikte", "lijnkleur", "lijnstijl", "vulkleur", "vulstijl", "verbindingsstijl")
    VALUES ('Sectoren','terrein niet-begaanbaar', 1, '#fffc1e1c', 'solid', '#fffc1e1c', 'b_diagonal', 'bevel');

INSERT INTO objecten.sectoren_type (id, naam) VALUES (11, 'terrein niet-begaanbaar');

-- issue 144 - Afbrand scenario
INSERT INTO algemeen.styles ("laagnaam", "soortnaam", "lijndikte", "lijnkleur", "lijnstijl", "vulkleur", "vulstijl", "verbindingsstijl")
    VALUES ('Ruimten','afbrand scenario', 0.1, '#fffc1e1c', 'solid', '#fffc1e1c', 'b_diagonal', 'bevel');

INSERT INTO objecten.ruimten_type (id, naam) VALUES (11, 'afbrand scenario');

-- issue 196 - Slagboom op bouwlaag
INSERT INTO objecten.veiligh_bouwk_type (id,naam) VALUES (10,'slagboom_bouwlaag');
INSERT INTO algemeen.styles (laagnaam,soortnaam,lijndikte,lijnkleur,lijnstijl,vulkleur,vulstijl,verbindingsstijl,eindstijl) VALUES
	 ('Bouwkundige veiligheidsvoorzieningen','slagboom_bouwlaag_bottom',0.4,'#ff000000','solid',NULL,NULL,'bevel','round'),
	 ('Bouwkundige veiligheidsvoorzieningen','slagboom_bouwlaag_middle',0.3,'#ffffffff','solid',NULL,NULL,'bevel','round'),
	 ('Bouwkundige veiligheidsvoorzieningen','slagboom_bouwlaag_top',0.3,'#ffff0000','dot',NULL,NULL,'bevel','flat');

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

-- issue 143 - soft deleting
-- in plaats van delete wordt er een timestamp aan het record gegeven net als datum_aangemaakt en datum_gewijzigd

CREATE OR REPLACE FUNCTION set_delete_timestamp()  
  RETURNS trigger AS $$
    DECLARE
      command text := ' SET datum_deleted = now() WHERE id = $1';
    BEGIN
      EXECUTE 'UPDATE "' || TG_TABLE_SCHEMA || '"."' || TG_TABLE_NAME || '" ' || command USING OLD.id;
      RETURN NULL;
    END;
  $$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION set_delete_timestamp() TO public;
GRANT EXECUTE ON FUNCTION set_delete_timestamp() TO oiv_write;

-- objecten
ALTER TABLE aanwezig ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON aanwezig FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE afw_binnendekking ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON afw_binnendekking FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE bedrijfshulpverlening ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON bedrijfshulpverlening FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_deleted');

ALTER TABLE beheersmaatregelen ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON beheersmaatregelen FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE bereikbaarheid ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON bereikbaarheid FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE bouwlagen ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON bouwlagen FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE contactpersoon ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON contactpersoon FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE dreiging ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON dreiging FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE gebiedsgerichte_aanpak ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON gebiedsgerichte_aanpak FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE gebruiksfunctie ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON gebruiksfunctie FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE gevaarlijkestof ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON gevaarlijkestof FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE gevaarlijkestof_opslag ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON gevaarlijkestof_opslag FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE gevaarlijkestof_schade_cirkel ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON gevaarlijkestof_schade_cirkel FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE grid ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON grid FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE historie ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON historie FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE ingang ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON ingang FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE isolijnen ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON isolijnen FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE label ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON label FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE object ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON object FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE opstelplaats ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON opstelplaats FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE points_of_interest ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON points_of_interest FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE ruimten ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON ruimten FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE scenario ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON scenario FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE sectoren ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON sectoren FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE sleutelkluis ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON sleutelkluis FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE terrein ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON terrein FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE veiligh_bouwk ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON veiligh_bouwk FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE veiligh_install ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON veiligh_install FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE veiligh_ruimtelijk ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON veiligh_ruimtelijk FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE veilighv_org ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON veilighv_org FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

-- info of interest
ALTER TABLE info_of_interest.labels_of_interest ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON info_of_interest.labels_of_interest FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE info_of_interest.lines_of_interest ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON info_of_interest.lines_of_interest FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE info_of_interest.points_of_interest ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON info_of_interest.points_of_interest FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

-- bluswater
ALTER TABLE bluswater.alternatieve ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON bluswater.alternatieve FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE bluswater.brandkranen ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON bluswater.brandkranen FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE bluswater.inspectie ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON bluswater.inspectie FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE bluswater.leidingen ADD COLUMN datum_deleted TIMESTAMP WITH TIME ZONE;
CREATE TRIGGER trg_set_delete BEFORE DELETE ON bluswater.leidingen FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

--recreate view to take datum_deleted in account
--bouwlagen
CREATE OR REPLACE VIEW objecten.bouwlaag_afw_binnendekking
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.handelingsaanwijzing,
    v.bouwlaag_id,
    b.bouwlaag,
    v.rotatie,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM objecten.afw_binnendekking v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.afw_binnendekking_type st ON v.soort::text = st.naam::text
   WHERE v.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.bouwlaag_dreiging
AS SELECT v.id,
    v.geom,
    v.dreiging_type_id,
    v.label,
    v.fotografie_id,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM objecten.dreiging v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.dreiging_type st ON v.dreiging_type_id = st.id
   WHERE v.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.bouwlaag_ingang
AS SELECT v.id,
    v.geom,
    v.ingang_type_id,
    v.label,
    v.belemmering,
    v.voorzieningen,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    it.symbol_name,
    it.size,
    ''::text AS applicatie
   FROM objecten.ingang v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.ingang_type it ON v.ingang_type_id = it.id
   WHERE v.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.bouwlaag_label
AS SELECT l.id,
    l.geom,
    l.soort,
    l.omschrijving,
    l.bouwlaag_id,
    l.object_id,
    b.bouwlaag,
    l.rotatie,
    st.symbol_name,
    st.size,
    ''::text AS applicatie
   FROM objecten.label l
     JOIN objecten.bouwlagen b ON l.bouwlaag_id = b.id
     JOIN objecten.label_type st ON l.soort::text = st.naam::text
   WHERE l.datum_deleted IS NULL;

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
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
   WHERE o.datum_deleted IS NULL;     

CREATE OR REPLACE VIEW objecten.bouwlaag_ruimten
AS SELECT v.id,
    v.geom,
    v.ruimten_type_id,
    v.omschrijving,
    v.fotografie_id,
    v.bouwlaag_id,
    b.bouwlaag,
    ''::text AS applicatie
   FROM objecten.ruimten v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
   WHERE v.datum_deleted IS NULL; 

CREATE OR REPLACE VIEW objecten.bouwlaag_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.sleutelkluis_type_id,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.fotografie_id,
    v.ingang_id,
    part.bouwlaag,
    v.rotatie,
    it.symbol_name,
    it.size,
    ''::text AS applicatie
   FROM objecten.sleutelkluis v
     JOIN ( SELECT b.bouwlaag,
            ib.id,
            ib.bouwlaag_id
           FROM objecten.ingang ib
             JOIN objecten.bouwlagen b ON ib.bouwlaag_id = b.id) part ON v.ingang_id = part.id
     JOIN objecten.sleutelkluis_type it ON v.sleutelkluis_type_id = it.id
   WHERE v.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_bouwk
AS SELECT v.id,
    v.geom,
    v.soort,
    v.fotografie_id,
    v.bouwlaag_id,
    b.bouwlaag,
    ''::text AS applicatie
   FROM objecten.veiligh_bouwk v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
   WHERE v.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_install
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.veiligh_install_type_id,
    v.label,
    v.bijzonderheid,
    v.bouwlaag_id,
    v.rotatie,
    v.fotografie_id,
    b.bouwlaag,
    vt.size,
    vt.symbol_name,
    ''::text AS applicatie
   FROM objecten.veiligh_install v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type vt ON v.veiligh_install_type_id = vt.id
   WHERE v.datum_deleted IS NULL;

--objecten
CREATE OR REPLACE VIEW objecten.object_bereikbaarheid
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.obstakels,
    l.wegafzetting,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    part.typeobject
   FROM objecten.bereikbaarheid l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE l.datum_deleted IS NULL;

DROP VIEW objecten.object_bgt;
CREATE OR REPLACE VIEW objecten.object_bgt
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.basisreg_identifier,
    b.formelenaam,
    b.bijzonderheden,
    b.pers_max,
    b.pers_nietz_max,
    b.datum_geldig_tot,
    b.datum_geldig_vanaf,
    b.bron,
    b.bron_tabel,
    b.fotografie_id,
    b.bodemgesteldheid_type_id,
    part.typeobject
   FROM objecten.object b
     LEFT JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE b.bron::text = 'BGT'::text AND b.datum_deleted IS NULL;

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
    st.size_object AS size,
    ''::text AS applicatie,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot
   FROM objecten.dreiging v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.dreiging_type st ON v.dreiging_type_id = st.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE v.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.object_gebiedsgerichte_aanpak
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.bijzonderheden,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot
   FROM objecten.gebiedsgerichte_aanpak l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE l.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.object_grid
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
    part.typeobject
   FROM objecten.grid b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
   WHERE b.datum_deleted IS NULL;

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
    it.size_object AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.ingang v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.ingang_type it ON v.ingang_type_id = it.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE v.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.object_isolijnen
AS SELECT l.id,
    l.geom,
    l.hoogte,
    l.omschrijving,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.isolijnen l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE l.datum_deleted IS NULL;

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
    st.size_object AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.label l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN objecten.label_type st ON l.soort::text = st.naam::text
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE l.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.object_objecten
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.basisreg_identifier,
    b.formelenaam,
    b.bijzonderheden,
    b.pers_max,
    b.pers_nietz_max,
    b.datum_geldig_tot,
    b.datum_geldig_vanaf,
    b.bron,
    b.bron_tabel,
    b.fotografie_id,
    b.bodemgesteldheid_type_id,
    b.min_bouwlaag,
    b.max_bouwlaag,
    part.typeobject
   FROM objecten.object b
    LEFT JOIN ( SELECT h.object_id, h.typeobject
          FROM objecten.historie h
            JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                  FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE b.datum_deleted IS NULL;

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
    st.size_object AS size,
    st.symbol_name,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.gevaarlijkestof_opslag o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE o.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.object_opstelplaats
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    l.rotatie,
    st.symbol_name,
    st.size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.opstelplaats l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN objecten.opstelplaats_type st ON l.soort::text = st.naam::text
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE l.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.object_points_of_interest
AS SELECT b.id,
    b.geom,
    b.points_of_interest_type_id,
    b.label,
    b.bijzonderheid,
    b.fotografie_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    vt.symbol_name,
    vt.size,
    ''::text AS applicatie,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM objecten.points_of_interest b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.points_of_interest_type vt ON b.points_of_interest_type_id = vt.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
   WHERE b.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.object_sectoren
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.omschrijving,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.sectoren l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE l.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.object_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.sleutelkluis_type_id,
    v.label,
    v.aanduiding_locatie,
    v.sleuteldoel_type_id,
    v.fotografie_id,
    v.ingang_id,
    b.formelenaam,
    v.rotatie,
    it.symbol_name,
    it.size_object AS size,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.sleutelkluis v
     JOIN objecten.ingang i ON v.ingang_id = i.id
     JOIN objecten.sleutelkluis_type it ON v.sleutelkluis_type_id = it.id
     JOIN objecten.object b ON i.object_id = b.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
   WHERE v.datum_deleted IS NULL;

DROP VIEW objecten.object_terrein;
CREATE OR REPLACE VIEW objecten.object_terrein
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.object_id,
    o.formelenaam,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM objecten.terrein b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
   WHERE b.datum_deleted IS NULL;

CREATE OR REPLACE RULE object_terrein_del AS
    ON DELETE TO objecten.object_terrein DO INSTEAD  DELETE FROM objecten.terrein
  WHERE terrein.id = old.id;

CREATE OR REPLACE RULE object_terrein_upd AS
    ON UPDATE TO objecten.object_terrein DO INSTEAD  
    UPDATE objecten.terrein SET geom = new.geom, omschrijving = new.omschrijving, object_id = new.object_id
  WHERE terrein.id = new.id;

CREATE OR REPLACE RULE object_terrein_ins AS
    ON INSERT TO objecten.object_terrein DO INSTEAD  INSERT INTO objecten.terrein (geom, omschrijving, object_id)
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

CREATE OR REPLACE VIEW objecten.object_veiligh_ruimtelijk
AS SELECT b.id,
    b.geom,
    b.veiligh_ruimtelijk_type_id,
    b.label,
    b.bijzonderheid,
    b.fotografie_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    vt.symbol_name,
    vt.size,
    ''::text AS applicatie,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject
   FROM objecten.veiligh_ruimtelijk b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id
     JOIN ( SELECT h.object_id, h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime
                    FROM objecten.historie
                    GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
   WHERE b.datum_deleted IS NULL;

--management lagen
CREATE OR REPLACE VIEW objecten.status_objectgegevens
AS SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    historie.status
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT h.id
           FROM objecten.historie h
          WHERE h.object_id = object.id
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1))
   WHERE object.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.stavaza_objecten
AS SELECT obj.team,
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
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text) AS totaal_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text) AS totaal_in_concept,
            count(o.status) FILTER (WHERE o.status::text = 'archief'::text) AS totaal_in_archief,
            sum(
                CASE
                    WHEN o.status IS NULL THEN 1
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
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 1) AS prio_1_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 2) AS prio_2_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 3) AS prio_3_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'in gebruik'::text AND mc.prio_prod = 4) AS prio_4_in_gebruik,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 1) AS prio_1_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 2) AS prio_2_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 3) AS prio_3_concept,
            count(o.status) FILTER (WHERE o.status::text = 'concept'::text AND mc.prio_prod = 4) AS prio_4_concept,
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
                   FROM objecten.object
                     LEFT JOIN objecten.historie ON historie.id = (( SELECT h.id
                           FROM objecten.historie h
                          WHERE h.object_id = object.id
                          ORDER BY h.datum_aangemaakt DESC
                         LIMIT 1))
                     LEFT JOIN algemeen.team tg ON st_intersects(object.geom, tg.geom)
                  WHERE object.datum_deleted IS NULL
                  ORDER BY historie.status) o
             LEFT JOIN objecten.historie_matrix_code mc ON o.matrix_code_id = mc.id
          GROUP BY o.team, o.team_geom) obj;

CREATE OR REPLACE VIEW objecten.stavaza_volgende_update
AS SELECT object.id,
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
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT h.id
           FROM objecten.historie h
          WHERE h.object_id = object.id AND h.aanpassing::text <> 'aanpassing'::text
          ORDER BY h.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN objecten.historie_matrix_code ON historie.matrix_code_id = historie_matrix_code.id
     WHERE object.datum_deleted IS NULL;

--view_ 's 
CREATE OR REPLACE VIEW objecten.view_afw_binnendekking
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.rotatie,
    d.label,
    d.handelingsaanwijzing,
    d.bouwlaag_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.symbol_name,
    dt.size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.afw_binnendekking d ON st_intersects(t.geom, d.geom)
     JOIN objecten.afw_binnendekking_type dt ON d.soort::text = dt.naam::text
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_bedrijfshulpverlening
AS SELECT b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.ademluchtdragend,
    b.object_id,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.bedrijfshulpverlening b ON o.id = b.object_id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_bereikbaarheid
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.obstakels,
    b.wegafzetting,
    b.object_id,
    b.fotografie_id,
    b.label,
    b.soort,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.bereikbaarheid b ON o.id = b.object_id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

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
    sub.hoogste_bouwlaag,
    sub.laagste_bouwlaag
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.bouwlagen d ON st_intersects(t.geom, d.geom)
     JOIN ( SELECT bouwlagen.pand_id,
            max(bouwlagen.bouwlaag) AS hoogste_bouwlaag,
            min(bouwlagen.bouwlaag) AS laagste_bouwlaag
           FROM objecten.bouwlagen
          GROUP BY bouwlagen.pand_id) sub ON d.pand_id::text = sub.pand_id::text
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_contactpersoon
AS SELECT b.id,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.dagen,
    b.tijdvakbegin,
    b.tijdvakeind,
    b.telefoonnummer,
    b.object_id,
    b.soort,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.contactpersoon b ON o.id = b.object_id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_dreiging_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.dreiging_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.dreiging d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.dreiging_type dt ON d.dreiging_type_id = dt.id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

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
    vt.size_object AS size
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
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_gebiedsgerichte_aanpak
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.soort,
    b.label,
    b.bijzonderheden,
    b.object_id,
    b.fotografie_id,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.gebiedsgerichte_aanpak b ON o.id = b.object_id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

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
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND op.datum_deleted IS NULL AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

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
    st.size_object AS size
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
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND op.datum_deleted IS NULL AND o.datum_deleted IS NULL AND d.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_grid
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
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.grid b ON o.id = b.object_id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_ingang_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.ingang_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.ingang d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.ingang_type dt ON d.ingang_type_id = dt.id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

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
    vt.size_object AS size
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
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_isolijnen
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.hoogte,
    b.omschrijving,
    b.object_id,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.isolijnen b ON o.id = b.object_id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_label_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.omschrijving,
    d.soort,
    d.rotatie,
    d.bouwlaag_id,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    vt.size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.label d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.label_type vt ON d.soort::text = vt.naam::text
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

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
    vt.size_object AS size
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
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_objectgegevens
AS SELECT o.id,
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
    part.typeobject
   FROM objecten.object o
     LEFT JOIN objecten.bodemgesteldheid_type bg ON o.bodemgesteldheid_type_id = bg.id
     LEFT JOIN ( SELECT DISTINCT g.object_id,
            string_agg(gt.naam, ', '::text) AS gebruiksfuncties
           FROM objecten.gebruiksfunctie g
             JOIN objecten.gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
          GROUP BY g.object_id) gf ON o.id = gf.object_id
     JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND o.datum_deleted IS NULL;

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
   FROM objecten.object o
     JOIN objecten.opstelplaats b ON o.id = b.object_id
     JOIN objecten.opstelplaats_type vt ON b.soort::text = vt.naam::text
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_points_of_interest
AS SELECT b.id,
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
    round(st_x(b.geom)) AS x,
    round(st_y(b.geom)) AS y,
    vt.symbol_name,
    vt.size
   FROM objecten.object o
     JOIN objecten.points_of_interest b ON o.id = b.object_id
     JOIN objecten.points_of_interest_type vt ON b.points_of_interest_type_id = vt.id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_ruimten
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.ruimten_type_id,
    d.omschrijving,
    d.bouwlaag_id,
    d.fotografie_id,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.ruimten d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

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
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    gsc.soort
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
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND gsc.datum_deleted IS NULL AND t.datum_deleted IS NULL AND op.datum_deleted IS NULL;

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
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    gsc.soort
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
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND gsc.datum_deleted IS NULL AND o.datum_deleted IS NULL AND op.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_sectoren
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.omschrijving,
    b.label,
    b.object_id,
    b.fotografie_id,
    b.soort,
    o.formelenaam
   FROM objecten.object o
     JOIN objecten.sectoren b ON o.id = b.object_id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_sleutelkluis_bouwlaag
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
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    i.bouwlaag_id,
    dd.naam AS doel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.sleutelkluis d ON st_intersects(t.geom, d.geom)
     JOIN objecten.ingang i ON d.ingang_id = i.id
     JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
     JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL AND i.datum_deleted IS NULL;

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
    dt.size_object AS size
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
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND o.datum_deleted IS NULL AND d.datum_deleted IS NULL AND i.datum_deleted IS NULL;

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
    b.bouwdeel
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.veiligh_bouwk d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_veiligh_install
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.veiligh_install_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    d.bijzonderheid,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    o.formelenaam,
    o.id AS object_id,
    b.bouwlaag,
    b.bouwdeel,
    dt.naam AS soort,
    dt.symbol_name,
    dt.size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.veiligh_install d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type dt ON d.veiligh_install_type_id = dt.id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

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
   FROM objecten.object o
     JOIN objecten.veiligh_ruimtelijk b ON o.id = b.object_id
     JOIN objecten.veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE 
    (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) 
    AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL)
    AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;


-- issue 211 - scenario's naar punt-locaties
DROP TABLE IF EXISTS objecten.scenario_locatie_type;
CREATE TABLE objecten.scenario_locatie_type (
	id int4 NOT NULL,
	naam text NOT NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	size_object int4 NULL,
	CONSTRAINT scenario_locatie_type_naam_key UNIQUE (naam),
	CONSTRAINT scenario_locatie_type_pkey PRIMARY KEY (id)
);

INSERT INTO objecten.scenario_locatie_type VALUES (1, 'Scenario locatie', 'scenario_locatie', 3, 6);

DROP TABLE IF EXISTS objecten.scenario_locatie;
CREATE TABLE objecten.scenario_locatie
(
  id               SERIAL PRIMARY KEY NOT NULL,
  geom             GEOMETRY(POINT, 28992),
  datum_aangemaakt TIMESTAMP WITH TIME ZONE DEFAULT now(),
  datum_gewijzigd  TIMESTAMP WITH TIME ZONE,
  datum_deleted    TIMESTAMP WITH TIME ZONE,
  locatie          TEXT,
  bouwlaag_id 	   INTEGER,
  object_id        INTEGER,
  fotografie_id    INTEGER,
  rotatie          INTEGER DEFAULT 0,
  CONSTRAINT scenario_locatie_bouwlaag_id_fk FOREIGN KEY (bouwlaag_id) REFERENCES objecten.bouwlagen (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT scenario_locatie_object_id_fk FOREIGN KEY (object_id) REFERENCES objecten.object (id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT scenario_locatie_fk_check CHECK  (bouwlaag_id IS NOT NULL OR object_id IS NOT NULL),
  CONSTRAINT scenario_locatie_fotografie_id_fk FOREIGN KEY (fotografie_id) REFERENCES algemeen.fotografie (id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX scenario_locatie_gist ON objecten.scenario_locatie (geom);
COMMENT ON TABLE gevaarlijkestof_opslag IS 'Lokaties waar scenarios kunnen plaatsvinden';

CREATE TRIGGER trg_set_mutatie BEFORE UPDATE ON objecten.scenario_locatie FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');
CREATE TRIGGER trg_set_insert BEFORE INSERT ON objecten.scenario_locatie FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_aangemaakt');
CREATE TRIGGER trg_set_delete BEFORE DELETE ON objecten.scenario_locatie FOR EACH ROW EXECUTE PROCEDURE set_delete_timestamp();

ALTER TABLE objecten.scenario ADD COLUMN scenario_locatie_id INTEGER;
ALTER TABLE objecten.scenario_type ADD COLUMN file_name TEXT;

--LET OP: bestaande scenario's worden naast het bestaande i-tje geplaatst
INSERT INTO objecten.scenario_locatie (geom, object_id)
SELECT ST_Translate(o.geom, 5, 0), object_id FROM objecten.scenario s
INNER JOIN objecten.object o ON s.object_id = o.id;

UPDATE objecten.scenario SET scenario_locatie_id = sub.id
FROM
(SELECT id, object_id FROM objecten.scenario_locatie) sub
WHERE scenario.object_id = sub.object_id;

ALTER TABLE objecten.scenario ADD CONSTRAINT scenario_locatie_id_fk FOREIGN KEY (scenario_locatie_id) REFERENCES objecten.scenario_locatie (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE objecten.scenario DROP COLUMN object_id;

DROP TABLE IF EXISTS algemeen.settings;
CREATE TABLE algemeen.settings (id SERIAL PRIMARY KEY, setting_key VARCHAR(100), setting_value TEXT);
REVOKE ALL ON TABLE algemeen.settings FROM GROUP oiv_write;
INSERT INTO algemeen.settings (setting_key, setting_value) VALUES ('scenario_base_url', 'http://localhost/geoserver/');

CREATE OR REPLACE VIEW objecten.object_scenario_locatie
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.locatie,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
    st.size_object AS size,
    st.symbol_name,
    ''::text AS applicatie,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.scenario_locatie o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.scenario_locatie_type st ON 'Scenario locatie'::text = st.naam
     JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.bouwlaag_scenario_locatie
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
   FROM objecten.scenario_locatie o
     JOIN objecten.bouwlagen b ON o.bouwlaag_id = b.id
     JOIN objecten.scenario_locatie_type st ON 'Scenario locatie'::text = st.naam
  WHERE o.datum_deleted IS NULL;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.scenario_locatie (geom, locatie, bouwlaag_id, object_id, fotografie_id, rotatie)
            VALUES (new.geom, new.locatie, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT st."size_object" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'scenario_locatie', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.scenario_locatie WHERE (scenario_locatie.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'scenario_locatie', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.scenario_locatie SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (scenario_locatie.id = new.id);
        ELSE
            
            symbol_name := (SELECT st.symbol_name FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT st."size_object" FROM objecten.scenario_locatie_type st WHERE st.naam = 'Scenario locatie'::text);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'scenario_locatie', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'scenario_locatie', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE TRIGGER bouwlaag_scenario_locatie_ins
    INSTEAD OF INSERT ON objecten.bouwlaag_scenario_locatie
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_scenario_locatie_ins('bouwlaag');

CREATE TRIGGER object_scenario_locatie_ins
    INSTEAD OF INSERT ON objecten.object_scenario_locatie
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_scenario_locatie_ins('object');

CREATE TRIGGER bouwlaag_scenario_locatie_del
    INSTEAD OF DELETE ON objecten.bouwlaag_scenario_locatie
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_scenario_locatie_del('bouwlaag');

CREATE TRIGGER object_scenario_locatie_del
    INSTEAD OF DELETE ON objecten.object_scenario_locatie
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_scenario_locatie_del('object');

CREATE TRIGGER bouwlaag_scenario_locatie_upd
    INSTEAD OF UPDATE ON objecten.bouwlaag_scenario_locatie
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_scenario_locatie_upd('bouwlaag');

CREATE TRIGGER object_scenario_locatie_upd
    INSTEAD OF UPDATE ON objecten.object_scenario_locatie
    FOR EACH ROW EXECUTE PROCEDURE objecten.func_scenario_locatie_upd('object');

ALTER TABLE objecten.scenario ADD COLUMN file_name TEXT;

CREATE OR REPLACE VIEW objecten.view_scenario_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.scenario_locatie_id,
    d.omschrijving,
    d.scenario_type_id,
    COALESCE(d.file_name, st.file_name) as file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    slt.symbol_name,
    slt.size_object AS size,
    CONCAT(s.setting_value, COALESCE(d.file_name, st.file_name)) as scenario_url
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.scenario_locatie op ON o.id = op.object_id
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id
     JOIN objecten.scenario_locatie_type slt ON 'Scenario locatie'::text = slt.naam
     LEFT OUTER JOIN objecten.scenario_type st ON d.scenario_type_id = st.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND o.datum_deleted IS NULL AND d.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_scenario_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.scenario_locatie_id,
    d.omschrijving,
    d.scenario_type_id,
    COALESCE(d.file_name, st.file_name) as file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    slt.symbol_name,
    slt.size_object AS size,
    CONCAT(s.setting_value, COALESCE(d.file_name, st.file_name)) as scenario_url
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.scenario_locatie op ON st_intersects(t.geom, op.geom)
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id
     JOIN objecten.scenario_locatie_type slt ON 'Scenario locatie'::text = slt.naam
     LEFT OUTER JOIN objecten.scenario_type st ON d.scenario_type_id = st.id
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

-- update functions if object then size -> size_object
CREATE OR REPLACE FUNCTION objecten.func_opslag_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.gevaarlijkestof_opslag (geom, locatie, bouwlaag_id, object_id, fotografie_id, rotatie)
            VALUES (new.geom, new.locatie, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT st."size_object" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'gevaarlijkestof_opslag', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_opslag_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.gevaarlijkestof_opslag WHERE (gevaarlijkestof_opslag.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'gevaarlijkestof_opslag', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_opslag_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.gevaarlijkestof_opslag SET geom = new.geom, locatie = new.locatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (gevaarlijkestof_opslag.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.locatie) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
                size := (SELECT st."size" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            ELSE
                size := (SELECT st."size_object" FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = 'Opslag stoffen'::text);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'gevaarlijkestof_opslag', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'gevaarlijkestof_opslag', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_label_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.label (geom, soort, omschrijving, rotatie, bouwlaag_id, object_id)
            VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id, new.object_id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.label_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.label_type dt WHERE dt.naam = new.soort);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.label_type dt WHERE dt.naam = new.soort);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'label', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_label_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.label WHERE (label.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.omschrijving) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'label', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_label_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id
            WHERE (label.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.label_type dt WHERE dt.naam = new.soort);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.omschrijving) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
                size := (SELECT dt."size" FROM objecten.label_type dt WHERE dt.naam = new.soort);
            ELSE
                size := (SELECT dt."size_object" FROM objecten.label_type dt WHERE dt.naam = new.soort);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'label', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, size, symbol_name, bouwlaag, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'label', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.dreiging (geom, dreiging_type_id, label, rotatie, bouwlaag_id, object_id, fotografie_id)
            VALUES (new.geom, new.dreiging_type_id, new.label, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.omschrijving) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'dreiging', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.dreiging WHERE (dreiging.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.omschrijving) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'dreiging', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.dreiging SET geom = new.geom, dreiging_type_id = new.dreiging_type_id, rotatie = new.rotatie, label = new.label, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (dreiging.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.omschrijving) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
                size := (SELECT dt."size" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            ELSE
                size := (SELECT dt."size_object" FROM objecten.dreiging_type dt WHERE dt.id = new.dreiging_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'dreiging', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag , new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'dreiging', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_ingang_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaagid integer := NULL;
        objectid integer := NULL;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.ingang (geom, ingang_type_id, label, rotatie, belemmering, voorzieningen, bouwlaag_id, object_id, fotografie_id)
            VALUES (new.geom, new.ingang_type_id, new.label, new.rotatie, new.belemmering, new.voorzieningen, new.bouwlaag_id, new.object_id, new.fotografie_id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.belemmering, new.voorzieningen) d));

            IF bouwlaag_object = 'object'::text THEN
                size := (SELECT dt."size_object" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
                objectid := (SELECT b.object_id FROM (SELECT b.object_id, b.geom <-> new.geom AS dist FROM objecten.terrein b ORDER BY dist LIMIT 1) b);
            ELSEIF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
                bouwlaagid := (SELECT b.bouwlaag_id FROM (SELECT b.id AS bouwlaag_id, b.geom <-> new.geom AS dist FROM objecten.bouwlagen b WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) b);
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'INSERT', 'ingang', NULL, bouwlaagid, objectid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_ingang_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.ingang WHERE (ingang.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.belemmering, old.voorzieningen) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'ingang', OLD.id, OLD.bouwlaag_id, OLD.object_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, old.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_ingang_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, 
                    bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (ingang.id = new.id);
        ELSE
            symbol_name := (SELECT dt.symbol_name FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.belemmering, new.voorzieningen) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT dt."size" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT dt."size_object" FROM objecten.ingang_type dt WHERE dt.id = new.ingang_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'ingang', old.id, new.bouwlaag_id, new.object_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'ingang', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_ins()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        ingangid integer;
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN
        IF NEW.applicatie = 'OIV' THEN
            INSERT INTO objecten.sleutelkluis (geom, sleutelkluis_type_id, label, rotatie, aanduiding_locatie, sleuteldoel_type_id, ingang_id, fotografie_id)
            VALUES (new.geom, new.sleutelkluis_type_id, new.label, new.rotatie, new.aanduiding_locatie, new.sleuteldoel_type_id, new.ingang_id, new.fotografie_id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                ingangid := (SELECT i.ingang_id FROM (SELECT i.id AS ingang_id, b.geom <-> new.geom AS dist FROM objecten.ingang i
                                INNER JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id WHERE b.bouwlaag = new.bouwlaag ORDER BY dist LIMIT 1) i);
                bouwlaag = new.bouwlaag;
            ELSEIF bouwlaag_object = 'object'::text THEN
                size := (SELECT st."size_object" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                ingangid := (SELECT b.ingang_id FROM (SELECT b.id AS ingang_id, b.geom <-> new.geom AS dist FROM objecten.ingang b ORDER BY dist LIMIT 1) b);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, row_to_json(NEW.*), 'INSERT', 'sleutelkluis', NULL, ingangid, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

        END IF;
        RETURN NEW;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_del()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        jsonstring JSON;
        bouwlaag integer := NULL;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF OLD.applicatie = 'OIV' THEN 
            DELETE FROM objecten.sleutelkluis WHERE (sleutelkluis.id = old.id);
        ELSE
            jsonstring := row_to_json((SELECT d FROM (SELECT old.label, old.aanduiding_locatie, old.sleuteldoel_type_id) d));
            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := old.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (OLD.geom, jsonstring, 'DELETE', 'sleutelkluis', OLD.id, OLD.ingang_id, OLD.rotatie, OLD.SIZE, OLD.symbol_name, bouwlaag, OLD.fotografie_id, false);
        END IF;
        RETURN OLD;
    END;
    $$;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_upd()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS 
    $$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.ingang SET geom = new.geom, ingang_type_id = new.ingang_type_id, rotatie = new.rotatie, label = new.label, belemmering = new.belemmering, voorzieningen = new.voorzieningen, 
                    bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id
            WHERE (ingang.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT st."size_object" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'sleutelkluis', old.id, new.ingang_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'sleutelkluis', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $$;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 9;
UPDATE algemeen.applicatie SET db_versie = 339; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();