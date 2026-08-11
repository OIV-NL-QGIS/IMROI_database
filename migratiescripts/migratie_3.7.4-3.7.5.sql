SET ROLE oiv_admin;

CREATE SCHEMA IF NOT EXISTS mobiel_sync;

COMMENT ON SCHEMA mobiel_sync IS
'Procedures en metadata voor het opbouwen en onderhouden van de mobiele OIV database';

CREATE SEQUENCE mobiel_sync.log_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE mobiel_sync.log_werkvoorraad_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE mobiel_sync.werkvoorraad_label_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE mobiel_sync.werkvoorraad_lijn_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE mobiel_sync.werkvoorraad_symbool_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE mobiel_sync.werkvoorraad_vlak_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

CREATE TABLE mobiel_sync.log (
	id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	gestart_op timestamp DEFAULT clock_timestamp() NOT NULL,
	afgerond_op timestamp NULL,
	status varchar(20) NOT NULL,
	aantal_records int4 NULL,
	melding text NULL,
	CONSTRAINT log_pkey PRIMARY KEY (id)
);

CREATE TABLE mobiel_sync.log_werkvoorraad (
	id serial4 NOT NULL,
	datum_aangemaakt timestamp NULL,
	geom public.geometry(geometry, 28992) NULL,
	record jsonb NULL,
	CONSTRAINT log_werkvoorraad_pkey PRIMARY KEY (id)
);
CREATE INDEX log_werkvoorraad_geom_gist ON mobiel_sync.log_werkvoorraad USING gist (geom);

CREATE TRIGGER trg_set_insert BEFORE
INSERT
    ON
    mobiel_sync.log_werkvoorraad FOR EACH ROW EXECUTE FUNCTION objecten.set_timestamp('datum_aangemaakt');

CREATE TABLE mobiel_sync.sync_info (
	naam text NOT NULL,
	laatste_pull timestamptz NULL,
	laatste_push timestamptz NULL,
	CONSTRAINT sync_info_pkey PRIMARY KEY (naam)
);

CREATE TABLE mobiel_sync.werkvoorraad_label (
	id serial4 NOT NULL,
	mobiel_id int4 NULL,
	modified_at timestamptz DEFAULT now() NOT NULL,
	modified_by text NULL,
	operatie varchar(10) NOT NULL,
	brontabel varchar(50) NOT NULL,
	bron_id int4 NULL,
	geom public.geometry(point, 28992) NULL,
	object_id int4 NULL,
	bouwlaag_id int4 NULL,
	omschrijving text NULL,
	rotatie int4 NULL,
	"size" int4 NULL,
	symbol_name text NULL,
	bouwlaag int4 NULL,
	bouwlaag_object varchar(50) NULL,
	opmerking text NULL,
	formaat_bouwlaag algemeen.formaat NULL,
	formaat_object algemeen.formaat NULL,
	accepted bool DEFAULT false NOT NULL,
	status varchar(20) DEFAULT 'OPEN'::character varying NULL,
	conflict_data jsonb NULL,
	soort varchar NULL,
	CONSTRAINT werkvoorraad_label_operatie_check CHECK (((operatie)::text = ANY (ARRAY[('INSERT'::character varying)::text, ('UPDATE'::character varying)::text, ('DELETE'::character varying)::text]))),
	CONSTRAINT werkvoorraad_label_pkey PRIMARY KEY (id)
);
CREATE INDEX werkvoorraad_label_geom_gist ON mobiel_sync.werkvoorraad_label USING gist (geom);

CREATE TABLE mobiel_sync.werkvoorraad_lijn (
	id serial4 NOT NULL,
	mobiel_id int4 NULL,
	modified_at timestamptz DEFAULT now() NOT NULL,
	modified_by text NULL,
	operatie varchar(10) NOT NULL,
	brontabel varchar(50) NOT NULL,
	bron_id int4 NULL,
	geom public.geometry(multilinestring, 28992) NULL,
	object_id int4 NULL,
	bouwlaag_id int4 NULL,
	symbol_name text NULL,
	bouwlaag int4 NULL,
	bouwlaag_object varchar(50) NULL,
	opmerking text NULL,
	accepted bool DEFAULT false NOT NULL,
	status varchar(20) DEFAULT 'OPEN'::character varying NULL,
	conflict_data jsonb NULL,
	soort varchar NULL,
	CONSTRAINT werkvoorraad_lijn_operatie_check CHECK (((operatie)::text = ANY (ARRAY[('INSERT'::character varying)::text, ('UPDATE'::character varying)::text, ('DELETE'::character varying)::text]))),
	CONSTRAINT werkvoorraad_lijn_pkey PRIMARY KEY (id)
);
CREATE INDEX werkvoorraad_lijn_geom_gist ON mobiel_sync.werkvoorraad_lijn USING gist (geom);

CREATE TABLE mobiel_sync.werkvoorraad_symbool (
	id serial4 NOT NULL,
	mobiel_id int4 NULL,
	modified_at timestamptz DEFAULT now() NOT NULL,
	modified_by text NULL,
	operatie varchar(10) NOT NULL,
	brontabel varchar(50) NOT NULL,
	bron_id int4 NULL,
	geom public.geometry(point, 28992) NULL,
	object_id int4 NULL,
	bouwlaag_id int4 NULL,
	rotatie int4 NULL,
	"size" int4 NULL,
	symbol_name text NULL,
	fotografie_id int4 NULL,
	bouwlaag int4 NULL,
	bouwlaag_object varchar(50) NULL,
	"label" varchar(50) NULL,
	label_positie algemeen.labelposition DEFAULT 'onder - midden'::algemeen.labelposition NULL,
	formaat_bouwlaag algemeen.formaat NULL,
	formaat_object algemeen.formaat NULL,
	opmerking text NULL,
	accepted bool DEFAULT false NULL,
	status varchar(20) DEFAULT 'OPEN'::character varying NULL,
	conflict_data jsonb NULL,
	soort varchar NULL,
	CONSTRAINT werkvoorraad_symbool_operatie_check CHECK (((operatie)::text = ANY ((ARRAY['INSERT'::character varying, 'UPDATE'::character varying, 'DELETE'::character varying])::text[]))),
	CONSTRAINT werkvoorraad_symbool_pkey PRIMARY KEY (id)
);
CREATE INDEX werkvoorraad_symbool_geom_gist ON mobiel_sync.werkvoorraad_symbool USING gist (geom);

CREATE TABLE mobiel_sync.werkvoorraad_vlak (
	id serial4 NOT NULL,
	mobiel_id int4 NULL,
	modified_at timestamptz DEFAULT now() NOT NULL,
	modified_by text NULL,
	operatie varchar(10) NOT NULL,
	brontabel varchar(50) NOT NULL,
	bron_id int4 NULL,
	geom public.geometry(multipolygon, 28992) NULL,
	object_id int4 NULL,
	bouwlaag_id int4 NULL,
	symbol_name text NULL,
	bouwlaag int4 NULL,
	bouwlaag_object varchar(50) NULL,
	opmerking text NULL,
	accepted bool DEFAULT false NOT NULL,
	status varchar(20) DEFAULT 'OPEN'::character varying NULL,
	conflict_data jsonb NULL,
	soort varchar NULL,
	CONSTRAINT werkvoorraad_vlak_operatie_check CHECK (((operatie)::text = ANY (ARRAY[('INSERT'::character varying)::text, ('UPDATE'::character varying)::text, ('DELETE'::character varying)::text]))),
	CONSTRAINT werkvoorraad_vlak_pkey PRIMARY KEY (id)
);
CREATE INDEX werkvoorraad_vlak_geom_gist ON mobiel_sync.werkvoorraad_vlak USING gist (geom);

CREATE OR REPLACE VIEW mobiel_sync.annotaties
AS SELECT annotaties.id,
    annotaties.geom,
    annotaties.tekst,
    annotaties.plaatsing,
    annotaties.modified_at,
    annotaties.modified_by
   FROM mobiel.annotaties;

CREATE OR REPLACE VIEW mobiel_sync.bedrijfshulpverlening_source
AS SELECT bedrijfshulpverlening.id AS bron_id,
    bedrijfshulpverlening.datum_aangemaakt,
    bedrijfshulpverlening.datum_gewijzigd,
    bedrijfshulpverlening.dagen,
    bedrijfshulpverlening.tijdvakbegin,
    bedrijfshulpverlening.tijdvakeind,
    bedrijfshulpverlening.telefoonnummer,
    bedrijfshulpverlening.ademluchtdragend,
    bedrijfshulpverlening.object_id
   FROM objecten.bedrijfshulpverlening
  WHERE bedrijfshulpverlening.self_deleted = 'infinity'::timestamp with time zone AND bedrijfshulpverlening.parent_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW mobiel_sync.bouwlagen_binnen_object
AS SELECT DISTINCT sub.object_id,
    sub.bouwlaag
   FROM ( SELECT DISTINCT t.object_id,
            w.bouwlaag
           FROM mobiel_sync.werkvoorraad_symbool w
             JOIN objecten.terrein t ON st_intersects(w.geom, t.geom)
          WHERE w.object_id IS NULL
          GROUP BY t.object_id, w.bouwlaag
        UNION
         SELECT DISTINCT t.object_id,
            w.bouwlaag
           FROM mobiel_sync.werkvoorraad_label w
             JOIN objecten.terrein t ON st_intersects(w.geom, t.geom)
          WHERE w.object_id IS NULL
          GROUP BY t.object_id, w.bouwlaag
        UNION
         SELECT DISTINCT t.object_id,
            w.bouwlaag
           FROM mobiel_sync.werkvoorraad_lijn w
             JOIN objecten.terrein t ON st_intersects(w.geom, t.geom)
          WHERE w.object_id IS NULL
          GROUP BY t.object_id, w.bouwlaag
        UNION
         SELECT DISTINCT t.object_id,
            w.bouwlaag
           FROM mobiel_sync.werkvoorraad_vlak w
             JOIN objecten.terrein t ON st_intersects(w.geom, t.geom)
          WHERE w.object_id IS NULL
          GROUP BY t.object_id, w.bouwlaag) sub;

CREATE OR REPLACE VIEW mobiel_sync.bouwlagen_source
AS SELECT bouwlagen.id,
    bouwlagen.geom,
    bouwlagen.datum_aangemaakt,
    bouwlagen.datum_gewijzigd,
    bouwlagen.bouwlaag,
    bouwlagen.bouwdeel,
    bouwlagen.pand_id,
    bouwlagen.fotografie_id
   FROM objecten.bouwlagen
  WHERE bouwlagen.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW mobiel_sync.contactpersoon_source
AS SELECT contactpersoon.id AS bron_id,
    contactpersoon.datum_aangemaakt,
    contactpersoon.datum_gewijzigd,
    contactpersoon.soort,
    contactpersoon.dagen,
    contactpersoon.tijdvakbegin,
    contactpersoon.tijdvakeind,
    contactpersoon.telefoonnummer,
    contactpersoon.object_id
   FROM objecten.contactpersoon
  WHERE contactpersoon.self_deleted = 'infinity'::timestamp with time zone AND contactpersoon.parent_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW mobiel_sync.gebruiksfunctie_source
AS SELECT gebruiksfunctie.id AS bron_id,
    gebruiksfunctie.datum_aangemaakt,
    gebruiksfunctie.datum_gewijzigd,
    gebruiksfunctie.soort,
    gebruiksfunctie.object_id
   FROM objecten.gebruiksfunctie
  WHERE gebruiksfunctie.self_deleted = 'infinity'::timestamp with time zone AND gebruiksfunctie.parent_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW mobiel_sync.label_types_source
AS SELECT row_number() OVER (ORDER BY sub.naam) AS id,
    sub.naam,
    sub.symbol_name,
    sub.size_klein,
    sub.size_middel,
    sub.size_groot,
    sub.categorie,
    sub.bouwlaag_object,
    sub.brontabel
   FROM ( SELECT label_type.naam,
            label_type.symbol_name,
            label_type.size_bouwlaag_klein AS size_klein,
            label_type.size_bouwlaag_middel AS size_middel,
            label_type.size_bouwlaag_groot AS size_groot,
            'Label'::text AS categorie,
            'bouwlaag'::text AS bouwlaag_object,
            'label'::text AS brontabel
           FROM objecten.label_type
          WHERE label_type.actief_bouwlaag = true
        UNION ALL
         SELECT label_type.naam,
            label_type.symbol_name,
            label_type.size_object_klein,
            label_type.size_object_middel,
            label_type.size_object_groot,
            'Label'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'label'::text AS brontabel
           FROM objecten.label_type
          WHERE label_type.actief_ruimtelijk = true) sub;

CREATE OR REPLACE VIEW mobiel_sync.labels_source
AS SELECT row_number() OVER (ORDER BY sub.id) AS id,
    sub.geom,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.omschrijving,
    sub.rotatie,
    sub.size,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.datum_aangemaakt,
    sub.datum_gewijzigd,
    sub.bouwlaag_object,
    sub.opmerking,
    sub.formaat
   FROM ( SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'label'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.omschrijving,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.formaat_bouwlaag AS formaat,
            v.opmerking
           FROM objecten.label v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.label_type vt ON v.soort::text = vt.naam::text
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'label'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.omschrijving,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.formaat_object,
            v.opmerking
           FROM objecten.label v
             JOIN objecten.label_type vt ON v.soort::text = vt.naam::text
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone) sub;

CREATE OR REPLACE VIEW mobiel_sync.lijn_types_source
AS SELECT row_number() OVER (ORDER BY sub.naam) AS id,
    sub.naam,
    sub.categorie,
    sub.bouwlaag_object,
    sub.brontabel
   FROM ( SELECT bereikbaarheid_type.naam,
            'Bereikbaarheid'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'bereikbaarheid'::text AS brontabel
           FROM objecten.bereikbaarheid_type
          WHERE bereikbaarheid_type.actief_ruimtelijk = true
        UNION ALL
         SELECT gebiedsgerichte_aanpak_type.naam,
            'Gebiedsgerichte aanpak'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'gebiedsgerichte_aanpak'::text AS brontabel
           FROM objecten.gebiedsgerichte_aanpak_type
          WHERE gebiedsgerichte_aanpak_type.actief_ruimtelijk = true
        UNION ALL
         SELECT veiligh_bouwk_type.naam,
            'Veiligheidsvoorziening bouwkundig'::text AS categorie,
            'bouwlaag'::text AS bouwlaag_object,
            'veiligh_bouwk'::text AS brontabel
           FROM objecten.veiligh_bouwk_type
          WHERE veiligh_bouwk_type.actief_bouwlaag = true) sub;

CREATE OR REPLACE VIEW mobiel_sync.lijnen_source
AS SELECT row_number() OVER (ORDER BY sub.id) AS id,
    sub.geom,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.bouwlaag_object,
    sub.opmerking,
    sub.datum_aangemaakt,
    sub.datum_gewijzigd,
    sub.id AS orig_id
   FROM ( SELECT b.id,
            b.geom,
            ''::character varying AS operatie,
            'bereikbaarheid'::character varying AS brontabel,
            b.id AS bron_id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS bouwlaag_object,
            b.opmerking,
            b.datum_aangemaakt,
            b.datum_gewijzigd
           FROM objecten.bereikbaarheid b
             JOIN objecten.bereikbaarheid_type bt ON b.soort::text = bt.naam::text
          WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT b.id,
            b.geom,
            ''::character varying AS operatie,
            'gebiedsgerichte_aanpak'::character varying AS brontabel,
            b.id AS bron_id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS bouwlaag_object,
            b.opmerking,
            b.datum_aangemaakt,
            b.datum_gewijzigd
           FROM objecten.gebiedsgerichte_aanpak b
             JOIN objecten.gebiedsgerichte_aanpak_type bt ON b.soort::text = bt.naam::text
          WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT b.id,
            b.geom,
            ''::character varying AS operatie,
            'veiligh_bouwk'::character varying AS brontabel,
            b.id AS bron_id,
            NULL::integer AS object_id,
            b.bouwlaag_id,
            b.soort AS symbol_name,
            bl.bouwlaag,
            'oiv'::text AS bron,
            'bouwlaag'::text AS bouwlaag_object,
            b.opmerking,
            b.datum_aangemaakt,
            b.datum_gewijzigd
           FROM objecten.veiligh_bouwk b
             JOIN objecten.bouwlagen bl ON b.bouwlaag_id = bl.id
             JOIN objecten.veiligh_bouwk_type bt ON b.soort::text = bt.naam::text
          WHERE b.bouwlaag_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone) sub;

CREATE OR REPLACE VIEW mobiel_sync.object_binnen_bouwlaag
AS SELECT DISTINCT b.pand_id,
    t.object_id
   FROM objecten.bouwlagen b
     JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
  WHERE (t.object_id IN ( SELECT DISTINCT w.object_id
           FROM mobiel_sync.werkvoorraad_symbool w
        UNION
         SELECT DISTINCT lb.object_id
           FROM mobiel_sync.werkvoorraad_label lb
        UNION
         SELECT DISTINCT l.object_id
           FROM mobiel_sync.werkvoorraad_lijn l
        UNION
         SELECT DISTINCT v.object_id
           FROM mobiel_sync.werkvoorraad_vlak v));

CREATE OR REPLACE VIEW mobiel_sync.object_type_source
AS SELECT ot.id,
    ot.naam,
    ot.symbol_name,
    ot.size,
    ot.symbol_type,
    ot.actief_ruimtelijk,
    ot.symbol_svg_png
   FROM objecten.object_type ot
  WHERE ot.actief_ruimtelijk = true;

CREATE OR REPLACE VIEW mobiel_sync.objecten_source
AS SELECT DISTINCT b.id,
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
    part.typeobject,
    b.share,
    concat(ot.symbol_name, '_', ot.symbol_type) AS symbol_name,
    ot.size
   FROM objecten.object b
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
     LEFT JOIN objecten.object_type ot ON part.typeobject::text = ot.naam::text
  WHERE b.self_deleted = 'infinity'::timestamp with time zone;

CREATE OR REPLACE VIEW mobiel_sync.symbol_types_source
AS SELECT row_number() OVER (ORDER BY sub.naam) AS id,
    sub.naam,
    sub.symbol_name,
    sub.size_klein,
    sub.size_middel,
    sub.size_groot,
    sub.symbol_type,
    sub.anchorpoint,
    sub.categorie,
    sub.bouwlaag_object,
    sub.brontabel,
    sub.symbol_svg_png
   FROM ( SELECT afw_binnendekking_type.naam,
            afw_binnendekking_type.symbol_name,
            afw_binnendekking_type.size_bouwlaag_klein AS size_klein,
            afw_binnendekking_type.size_bouwlaag_middel AS size_middel,
            afw_binnendekking_type.size_bouwlaag_groot AS size_groot,
            afw_binnendekking_type.symbol_type,
            afw_binnendekking_type.anchorpoint,
            'Bereikbaarheid'::text AS categorie,
            'bouwlaag'::text AS bouwlaag_object,
            'afw_binnendekking'::text AS brontabel,
            afw_binnendekking_type.symbol_svg_png
           FROM objecten.afw_binnendekking_type
          WHERE afw_binnendekking_type.actief_bouwlaag = true
        UNION ALL
         SELECT dreiging_type.naam,
            dreiging_type.symbol_name,
            dreiging_type.size_bouwlaag_klein,
            dreiging_type.size_bouwlaag_middel,
            dreiging_type.size_bouwlaag_groot,
            dreiging_type.symbol_type,
            dreiging_type.anchorpoint,
            'Dreiging'::text AS categorie,
            'bouwlaag'::text AS bouwlaag_object,
            'dreiging'::text AS brontabel,
            dreiging_type.symbol_svg_png
           FROM objecten.dreiging_type
          WHERE dreiging_type.actief_bouwlaag = true
        UNION ALL
         SELECT dreiging_type.naam,
            dreiging_type.symbol_name,
            dreiging_type.size_object_klein,
            dreiging_type.size_object_middel,
            dreiging_type.size_object_groot,
            dreiging_type.symbol_type,
            dreiging_type.anchorpoint,
            'Dreiging'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'dreiging'::text AS brontabel,
            dreiging_type.symbol_svg_png
           FROM objecten.dreiging_type
          WHERE dreiging_type.actief_ruimtelijk = true
        UNION ALL
         SELECT ingang_type.naam,
            ingang_type.symbol_name,
            ingang_type.size_bouwlaag_klein,
            ingang_type.size_bouwlaag_middel,
            ingang_type.size_bouwlaag_groot,
            ingang_type.symbol_type,
            ingang_type.anchorpoint,
            'Toegang'::text AS categorie,
            'bouwlaag'::text AS bouwlaag_object,
            'ingang'::text AS brontabel,
            ingang_type.symbol_svg_png
           FROM objecten.ingang_type
          WHERE ingang_type.actief_bouwlaag = true
        UNION ALL
         SELECT ingang_type.naam,
            ingang_type.symbol_name,
            ingang_type.size_object_klein,
            ingang_type.size_object_middel,
            ingang_type.size_object_groot,
            ingang_type.symbol_type,
            ingang_type.anchorpoint,
            'Toegang'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'ingang'::text AS brontabel,
            ingang_type.symbol_svg_png
           FROM objecten.ingang_type
          WHERE ingang_type.actief_ruimtelijk = true
        UNION ALL
         SELECT opstelplaats_type.naam,
            opstelplaats_type.symbol_name,
            opstelplaats_type.size_object_klein,
            opstelplaats_type.size_object_middel,
            opstelplaats_type.size_object_groot,
            opstelplaats_type.symbol_type,
            opstelplaats_type.anchorpoint,
            'Opstelplaats'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'opstelplaats'::text AS brontabel,
            opstelplaats_type.symbol_svg_png
           FROM objecten.opstelplaats_type
          WHERE opstelplaats_type.actief_ruimtelijk = true
        UNION ALL
         SELECT points_of_interest_type.naam,
            points_of_interest_type.symbol_name,
            points_of_interest_type.size_object_klein,
            points_of_interest_type.size_object_middel,
            points_of_interest_type.size_object_groot,
            points_of_interest_type.symbol_type,
            points_of_interest_type.anchorpoint,
            'Points of interest'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'points_of_interest'::text AS brontabel,
            points_of_interest_type.symbol_svg_png
           FROM objecten.points_of_interest_type
          WHERE points_of_interest_type.actief_ruimtelijk = true
        UNION ALL
         SELECT sleutelkluis_type.naam,
            sleutelkluis_type.symbol_name,
            sleutelkluis_type.size_bouwlaag_klein,
            sleutelkluis_type.size_bouwlaag_middel,
            sleutelkluis_type.size_bouwlaag_groot,
            sleutelkluis_type.symbol_type,
            sleutelkluis_type.anchorpoint,
            'Sleutelkluis'::text AS categorie,
            'bouwlaag'::text AS bouwlaag_object,
            'sleutelkluis'::text AS brontabel,
            sleutelkluis_type.symbol_svg_png
           FROM objecten.sleutelkluis_type
          WHERE sleutelkluis_type.actief_bouwlaag = true
        UNION ALL
         SELECT sleutelkluis_type.naam,
            sleutelkluis_type.symbol_name,
            sleutelkluis_type.size_object_klein,
            sleutelkluis_type.size_object_middel,
            sleutelkluis_type.size_object_groot,
            sleutelkluis_type.symbol_type,
            sleutelkluis_type.anchorpoint,
            'Sleutelkluis'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'sleutelkluis'::text AS brontabel,
            sleutelkluis_type.symbol_svg_png
           FROM objecten.sleutelkluis_type
          WHERE sleutelkluis_type.actief_ruimtelijk = true
        UNION ALL
         SELECT veiligh_install_type.naam,
            veiligh_install_type.symbol_name,
            veiligh_install_type.size_bouwlaag_klein,
            veiligh_install_type.size_bouwlaag_middel,
            veiligh_install_type.size_bouwlaag_groot,
            veiligh_install_type.symbol_type,
            veiligh_install_type.anchorpoint,
            'Veiligheidsvoorziening'::text AS categorie,
            'bouwlaag'::text AS bouwlaag_object,
            'veiligh_install'::text AS brontabel,
            veiligh_install_type.symbol_svg_png
           FROM objecten.veiligh_install_type
          WHERE veiligh_install_type.actief_bouwlaag = true
        UNION ALL
         SELECT veiligh_install_type.naam,
            veiligh_install_type.symbol_name,
            veiligh_install_type.size_object_klein,
            veiligh_install_type.size_object_middel,
            veiligh_install_type.size_object_groot,
            veiligh_install_type.symbol_type,
            veiligh_install_type.anchorpoint,
            'Veiligheidsvoorziening'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'veiligh_install'::text AS brontabel,
            veiligh_install_type.symbol_svg_png
           FROM objecten.veiligh_install_type
          WHERE veiligh_install_type.actief_ruimtelijk = true) sub;

CREATE OR REPLACE VIEW mobiel_sync.symbolen_source
AS SELECT row_number() OVER () AS fid,
    concat(sub.brontabel, '_', sub.id::character varying) AS id,
    sub.geom,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.rotatie,
    sub.size,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.bouwlaag_object,
    sub.id AS orig_id,
    sub.datum_aangemaakt,
    sub.datum_gewijzigd,
    sub.label,
    sub.label_positie,
    sub.formaat,
    sub.opmerking
   FROM ( SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'veiligh_install'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS size,
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag AS formaat,
            v.opmerking
           FROM objecten.veiligh_install v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.veiligh_install_type vt ON v.soort::text = vt.naam
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'veiligh_install'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object AS formaat,
            v.opmerking
           FROM objecten.veiligh_install v
             JOIN objecten.veiligh_install_type vt ON v.soort::text = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'dreiging'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag,
            v.opmerking
           FROM objecten.dreiging v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.dreiging_type vt ON v.soort::text = vt.naam
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'dreiging'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object,
            v.opmerking
           FROM objecten.dreiging v
             JOIN objecten.dreiging_type vt ON v.soort::text = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'afw_binnendekking'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag AS formaat,
            v.opmerking
           FROM objecten.afw_binnendekking v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.afw_binnendekking_type vt ON v.soort::text = vt.naam::text
          WHERE v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'ingang'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag,
            v.opmerking
           FROM objecten.ingang v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.ingang_type vt ON v.soort::text = vt.naam
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'ingang'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object,
            v.opmerking
           FROM objecten.ingang v
             JOIN objecten.ingang_type vt ON v.soort::text = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'opstelplaats'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object,
            v.opmerking
           FROM objecten.opstelplaats v
             JOIN objecten.opstelplaats_type vt ON v.soort::text = vt.naam::text
          WHERE v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            NULL::integer AS object_id,
            v.bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN vt.size_bouwlaag_klein
                    WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN vt.size_bouwlaag_middel
                    WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN vt.size_bouwlaag_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            b.bouwlaag,
            'bouwlaag'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_bouwlaag,
            v.opmerking
           FROM objecten.sleutelkluis v
             JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
             JOIN objecten.sleutelkluis_type vt ON v.soort::text = vt.naam
          WHERE v.bouwlaag_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'sleutelkluis'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object,
            v.opmerking
           FROM objecten.sleutelkluis v
             JOIN objecten.sleutelkluis_type vt ON v.soort::text = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT v.id,
            v.geom,
            ''::character varying AS operatie,
            'points_of_interest'::character varying AS brontabel,
            v.id AS bron_id,
            v.object_id,
            NULL::integer AS bouwlaag_id,
            v.rotatie,
                CASE
                    WHEN v.formaat_object = 'klein'::algemeen.formaat THEN vt.size_object_klein
                    WHEN v.formaat_object = 'middel'::algemeen.formaat THEN vt.size_object_middel
                    WHEN v.formaat_object = 'groot'::algemeen.formaat THEN vt.size_object_groot
                    ELSE NULL::numeric
                END AS "case",
            vt.symbol_name,
            NULL::integer AS bouwlaag,
            'object'::text AS bouwlaag_object,
            'oiv'::text AS bron,
            v.datum_aangemaakt,
            v.datum_gewijzigd,
            v.label,
            v.label_positie,
            v.formaat_object,
            v.opmerking
           FROM objecten.points_of_interest v
             JOIN objecten.points_of_interest_type vt ON v.soort::text = vt.naam
          WHERE v.object_id IS NOT NULL AND v.self_deleted = 'infinity'::timestamp with time zone) sub;

CREATE OR REPLACE VIEW mobiel_sync.vlak_types_source
AS SELECT row_number() OVER (ORDER BY sub.naam) AS id,
    sub.naam,
    sub.categorie,
    sub.bouwlaag_object,
    sub.brontabel
   FROM ( SELECT sectoren_type.naam,
            'Sectoren'::text AS categorie,
            'object'::text AS bouwlaag_object,
            'sectoren'::text AS brontabel
           FROM objecten.sectoren_type
          WHERE sectoren_type.actief_ruimtelijk = true
        UNION ALL
         SELECT ruimten_type.naam,
            'Ruimten'::text AS categorie,
            'bouwlaag'::text AS bouwlaag_object,
            'ruimten'::text AS brontabel
           FROM objecten.ruimten_type
          WHERE ruimten_type.actief_bouwlaag = true) sub;

CREATE OR REPLACE VIEW mobiel_sync.vlakken_source
AS SELECT row_number() OVER (ORDER BY sub.id) AS id,
    sub.geom,
    sub.operatie,
    sub.brontabel,
    sub.bron_id,
    sub.object_id,
    sub.bouwlaag_id,
    sub.symbol_name,
    sub.bouwlaag,
    sub.bron,
    sub.bouwlaag_object,
    sub.opmerking,
    sub.datum_aangemaakt,
    sub.datum_gewijzigd
   FROM ( SELECT b.id,
            b.geom,
            ''::character varying AS operatie,
            'sectoren'::character varying AS brontabel,
            b.id AS bron_id,
            b.object_id,
            NULL::integer AS bouwlaag_id,
            b.soort AS symbol_name,
            NULL::integer AS bouwlaag,
            'oiv'::text AS bron,
            'object'::text AS bouwlaag_object,
            b.opmerking,
            b.datum_aangemaakt,
            b.datum_gewijzigd
           FROM objecten.sectoren b
          WHERE b.object_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone
        UNION ALL
         SELECT b.id,
            b.geom,
            ''::character varying AS operatie,
            'ruimten'::character varying AS brontabel,
            b.id,
            NULL::integer AS object_id,
            b.bouwlaag_id,
            b.soort,
            bl.bouwlaag,
            'oiv'::text AS bron,
            'bouwlaag'::text AS bouwlaag_object,
            b.opmerking,
            b.datum_aangemaakt,
            b.datum_gewijzigd
           FROM objecten.ruimten b
             JOIN objecten.bouwlagen bl ON b.bouwlaag_id = bl.id
          WHERE b.bouwlaag_id IS NOT NULL AND b.self_deleted = 'infinity'::timestamp with time zone) sub;

CREATE OR REPLACE VIEW mobiel_sync.werkvoorraad_bouwlagen
AS SELECT DISTINCT b.id AS bouwlaag_id,
    b.pand_id
   FROM ( SELECT werkvoorraad_symbool.bouwlaag_id
           FROM mobiel_sync.werkvoorraad_symbool
          WHERE werkvoorraad_symbool.bouwlaag_id IS NOT NULL
        UNION ALL
         SELECT werkvoorraad_label.bouwlaag_id
           FROM mobiel_sync.werkvoorraad_label
          WHERE werkvoorraad_label.bouwlaag_id IS NOT NULL
        UNION ALL
         SELECT werkvoorraad_lijn.bouwlaag_id
           FROM mobiel_sync.werkvoorraad_lijn
          WHERE werkvoorraad_lijn.bouwlaag_id IS NOT NULL
        UNION ALL
         SELECT werkvoorraad_vlak.bouwlaag_id
           FROM mobiel_sync.werkvoorraad_vlak
          WHERE werkvoorraad_vlak.bouwlaag_id IS NOT NULL) w
     JOIN objecten.bouwlagen b ON b.id = w.bouwlaag_id;

CREATE OR REPLACE VIEW mobiel_sync.werkvoorraad_hulplijnen
AS SELECT sub.id,
    sub.objecttype,
    sub.werkvoorraad_id,
    sub.geom,
    sub.bouwlaag_id,
    sub.object_id,
    sub.bouwlaag
   FROM ( SELECT 'symbool_'::text || w.id AS id,
            'symbool'::text AS objecttype,
            w.id AS werkvoorraad_id,
            mobiel_sync.bepaal_hulplijn(s.geom, w.geom) AS geom,
            w.bouwlaag_id,
            w.object_id,
            w.bouwlaag
           FROM mobiel_sync.werkvoorraad_symbool w
             JOIN mobiel_sync.symbolen_source s ON s.brontabel::text = w.brontabel::text AND s.bron_id = w.bron_id
          WHERE w.operatie::text = 'UPDATE'::text
        UNION ALL
         SELECT 'lijn_'::text || w.id AS id,
            'lijn'::text AS objecttype,
            w.id AS werkvoorraad_id,
            mobiel_sync.bepaal_hulplijn(s.geom, w.geom) AS geom,
            w.bouwlaag_id,
            w.object_id,
            w.bouwlaag
           FROM mobiel_sync.werkvoorraad_lijn w
             JOIN mobiel_sync.lijnen_source s ON s.brontabel::text = w.brontabel::text AND s.bron_id = w.bron_id
          WHERE w.operatie::text = 'UPDATE'::text
        UNION ALL
         SELECT 'vlak_'::text || w.id AS id,
            'vlak'::text AS objecttype,
            w.id AS werkvoorraad_id,
            mobiel_sync.bepaal_hulplijn(s.geom, w.geom) AS geom,
            w.bouwlaag_id,
            w.object_id,
            w.bouwlaag
           FROM mobiel_sync.werkvoorraad_vlak w
             JOIN mobiel_sync.vlakken_source s ON s.brontabel::text = w.brontabel::text AND s.bron_id = w.bron_id
          WHERE w.operatie::text = 'UPDATE'::text
        UNION ALL
         SELECT 'label_'::text || w.id AS id,
            'label'::text AS objecttype,
            w.id AS werkvoorraad_id,
            mobiel_sync.bepaal_hulplijn(s.geom, w.geom) AS geom,
            w.bouwlaag_id,
            w.object_id,
            w.bouwlaag
           FROM mobiel_sync.werkvoorraad_label w
             JOIN mobiel_sync.labels_source s ON s.brontabel::text = w.brontabel::text AND s.bron_id = w.bron_id
          WHERE w.operatie::text = 'UPDATE'::text) sub
  WHERE sub.geom IS NOT NULL;

CREATE OR REPLACE VIEW mobiel_sync.werkvoorraad_objecten
AS SELECT DISTINCT o.id,
    o.geom,
    w.object_id,
    h.typeobject
   FROM ( SELECT werkvoorraad_symbool.object_id
           FROM mobiel_sync.werkvoorraad_symbool
          WHERE werkvoorraad_symbool.object_id IS NOT NULL
        UNION ALL
         SELECT werkvoorraad_label.object_id
           FROM mobiel_sync.werkvoorraad_label
          WHERE werkvoorraad_label.object_id IS NOT NULL
        UNION ALL
         SELECT werkvoorraad_lijn.object_id
           FROM mobiel_sync.werkvoorraad_lijn
          WHERE werkvoorraad_lijn.object_id IS NOT NULL
        UNION ALL
         SELECT werkvoorraad_vlak.object_id
           FROM mobiel_sync.werkvoorraad_vlak
          WHERE werkvoorraad_vlak.object_id IS NOT NULL
        UNION ALL
         SELECT t.object_id
           FROM mobiel_sync.werkvoorraad_symbool w_1
             JOIN objecten.bouwlagen b ON b.id = w_1.bouwlaag_id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w_1.bouwlaag_id IS NOT NULL
        UNION ALL
         SELECT t.object_id
           FROM mobiel_sync.werkvoorraad_label w_1
             JOIN objecten.bouwlagen b ON b.id = w_1.bouwlaag_id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w_1.bouwlaag_id IS NOT NULL
        UNION ALL
         SELECT t.object_id
           FROM mobiel_sync.werkvoorraad_lijn w_1
             JOIN objecten.bouwlagen b ON b.id = w_1.bouwlaag_id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w_1.bouwlaag_id IS NOT NULL
        UNION ALL
         SELECT t.object_id
           FROM mobiel_sync.werkvoorraad_vlak w_1
             JOIN objecten.bouwlagen b ON b.id = w_1.bouwlaag_id
             JOIN objecten.terrein t ON st_intersects(b.geom, t.geom)
          WHERE w_1.bouwlaag_id IS NOT NULL) w
     JOIN objecten.object o ON o.id = w.object_id AND o.self_deleted = 'infinity'::timestamp with time zone
     LEFT JOIN ( SELECT h_1.object_id,
            h_1.typeobject
           FROM objecten.historie h_1
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS datum_aangemaakt
                   FROM objecten.historie
                  GROUP BY historie.object_id) x ON x.object_id = h_1.object_id AND x.datum_aangemaakt = h_1.datum_aangemaakt) h ON h.object_id = o.id;

CREATE TYPE mobiel_sync.koppeling AS (
	bouwlaag_id int4,
	object_id int4);

CREATE OR REPLACE FUNCTION mobiel_sync.bepaal_koppeling(p_geom geometry, p_bouwlaag_object text, p_bouwlaag integer DEFAULT NULL::integer, p_max_afstand_bouwlaag numeric DEFAULT 50, p_max_afstand_object numeric DEFAULT 100)
 RETURNS mobiel_sync.koppeling
 LANGUAGE plpgsql
AS $function$
DECLARE
    resultaat mobiel_sync.koppeling;
    p_ref geometry(Point);
BEGIN

    -- Gebruik altijd één representatief punt
    p_ref := mobiel_sync.referentiepunt(p_geom);

    IF p_bouwlaag_object = 'bouwlaag' THEN

        SELECT
            b.id,
            NULL::integer
        INTO resultaat
        FROM objecten.bouwlagen b
        WHERE b.self_deleted = 'infinity'
          AND b.bouwlaag = p_bouwlaag
          AND ST_DWithin(b.geom, p_ref, p_max_afstand_bouwlaag)
        ORDER BY b.geom <-> p_ref
        LIMIT 1;

    ELSIF p_bouwlaag_object = 'object' THEN

        SELECT
            NULL::integer,
            t.object_id
        INTO resultaat
        FROM objecten.terrein t
        WHERE t.parent_deleted = 'infinity'
          AND t.self_deleted = 'infinity'
          AND ST_DWithin(t.geom, p_ref, p_max_afstand_object)
        ORDER BY t.geom <-> p_ref
        LIMIT 1;

    END IF;

    RETURN resultaat;

END;
$function$
;


CREATE OR REPLACE FUNCTION mobiel_sync.bepaal_type(p_brontabel text, p_symbol_name text)
 RETURNS text
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE
    v_sql text;
    v_soort text;
BEGIN

    IF p_symbol_name IS NULL THEN
        RETURN NULL;
    END IF;

    v_sql := format(
        'SELECT naam
         FROM objecten.%I_type
         WHERE symbol_name = $1
         LIMIT 1',
        p_brontabel
    );

    EXECUTE v_sql
        INTO v_soort
        USING p_symbol_name;

    RETURN v_soort;

EXCEPTION
    WHEN undefined_table THEN
        RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.context()
 RETURNS text
 LANGUAGE plpgsql
 STABLE
AS $function$
BEGIN
    RETURN current_setting('mobiel.context', true);
END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.controleer_conflict(p_old_datum timestamp with time zone, p_new_datum timestamp with time zone)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
BEGIN

    IF p_old_datum IS DISTINCT FROM p_new_datum THEN
        RETURN 'CONFLICT';
    END IF;

    RETURN 'OPEN';

END;
$function$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.fix_sequences()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    r record;
    v_max_id bigint;
BEGIN
    FOR r IN
        SELECT
            n.nspname AS schema_name,
            c.relname AS table_name,
            a.attname AS column_name,
            pg_get_serial_sequence(
                format('%I.%I', n.nspname, c.relname),
                a.attname
            ) AS sequence_name
        FROM pg_class c
        JOIN pg_namespace n 
            ON n.oid = c.relnamespace
        JOIN pg_attribute a 
            ON a.attrelid = c.oid
        WHERE n.nspname = 'mobiel'
          AND a.attnum > 0
          AND NOT a.attisdropped
          AND pg_get_serial_sequence(
                format('%I.%I', n.nspname, c.relname),
                a.attname
              ) IS NOT NULL
    LOOP
        EXECUTE format(
            'SELECT max(%I) FROM %I.%I',
            r.column_name,
            r.schema_name,
            r.table_name
        )
        INTO v_max_id;

        IF v_max_id IS NOT NULL THEN
            EXECUTE format(
                'SELECT setval(%L, %s, true)',
                r.sequence_name,
                v_max_id
            );
        END IF;
    END LOOP;
END;
$procedure$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_label_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_status text := 'OPEN';
    v_wv_id integer;
	v_soort varchar;
	v_operatie varchar;
BEGIN

    IF pg_trigger_depth() > 1 THEN
        RETURN OLD;
    END IF;

    --------------------------------------------------------------------------
    -- Nieuw mobiel object
    -- Geen OIV-identiteit, dus mag nooit door een OIV-pull verdwijnen
    --------------------------------------------------------------------------
    IF OLD.bron_id IS NULL THEN
        RETURN NULL;
    END IF;

    --------------------------------------------------------------------------
    -- OIV verwijdert een object
    -- Alleen conflict wanneer mobiel nog wijzigingen bevat
    --------------------------------------------------------------------------
    IF mobiel_sync.context() = 'PULL' THEN

        IF OLD.sync_status = 1 THEN
            v_status := 'CONFLICT';
        END IF;

    END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad zoeken
    --------------------------------------------------------------------------
    SELECT id
    INTO v_wv_id
    FROM mobiel_sync.werkvoorraad_label
    WHERE brontabel = OLD.brontabel
      AND bron_id = OLD.bron_id
    LIMIT 1;

    --------------------------------------------------------------------------
    -- soort symbool ophalen voor naamgeving
    --------------------------------------------------------------------------
	v_soort := mobiel_sync.bepaal_type(
	    OLD.brontabel,
	    OLD.symbol_name
	);

    --------------------------------------------------------------------------
    -- Conflictversies bewaren
    --------------------------------------------------------------------------
	IF v_status = 'CONFLICT' AND v_wv_id IS NOT NULL THEN
	
	    SELECT operatie
	    INTO v_operatie
	    FROM mobiel_sync.werkvoorraad_label
	    WHERE id = v_wv_id;
	
	
	    PERFORM mobiel_sync.registreer_conflict(
			'mobiel_sync.werkvoorraad_label'::regclass,
	        v_wv_id,
	        jsonb_build_object(
			    'oiv',
			    to_jsonb(OLD) || jsonb_build_object(
			        'operatie', 'DELETE',
			        'soort', v_soort
			    ),
	            'mobiel',
	            to_jsonb(OLD) || jsonb_build_object(
	                'operatie', v_operatie,
	                'soort', v_soort
	            )
	        )
	    );
	
	END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad bijwerken
    --------------------------------------------------------------------------
    IF v_wv_id IS NOT NULL THEN

        UPDATE mobiel_sync.werkvoorraad_label
        SET
            modified_at = clock_timestamp(),
            modified_by = OLD.modified_by,
            operatie = 'DELETE',
            status = v_status,
            geom = OLD.geom,
            object_id = OLD.object_id,
            bouwlaag_id = OLD.bouwlaag_id,
			symbol_name = OLD.symbol_name,
			soort = v_soort
        WHERE id = v_wv_id;


    --------------------------------------------------------------------------
    -- Nieuwe DELETE werkvoorraad toevoegen
    --------------------------------------------------------------------------
    ELSE

        INSERT INTO mobiel_sync.werkvoorraad_label
        (
            mobiel_id,
            modified_at,
            modified_by,
            operatie,
            status,
            brontabel,
            bron_id,
            geom,
            object_id,
            bouwlaag_id,
			symbol_name,
			soort,
            conflict_data
        )
        VALUES
        (
            OLD.id,
            clock_timestamp(),
            OLD.modified_by,
            'DELETE',
            v_status,
            OLD.brontabel,
            OLD.bron_id,
            OLD.geom,
            OLD.object_id,
            OLD.bouwlaag_id,
			OLD.symbol_name,
			v_soort
        );

    END IF;

    RETURN OLD;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_label_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_object_id integer;
    v_bouwlaag_id integer;
	v_soort varchar;
BEGIN
	IF pg_trigger_depth() > 1 THEN
    	RETURN NEW;
	END IF;

	IF mobiel_sync.context() = 'PULL' THEN
	    RETURN NEW;
	END IF;	

    --------------------------------------------------------------------------
    -- soort symbool ophalen voor naamgeving
    --------------------------------------------------------------------------
	v_soort := mobiel_sync.bepaal_type(
	    NEW.brontabel,
	    NEW.symbol_name
	);

    SELECT object_id, bouwlaag_id
    INTO v_object_id, v_bouwlaag_id
    FROM mobiel_sync.bepaal_koppeling(NEW.geom, NEW.bouwlaag_object, NEW.bouwlaag);

    INSERT INTO mobiel_sync.werkvoorraad_label (mobiel_id,
        modified_at, modified_by, operatie, brontabel, bron_id, geom, object_id, bouwlaag_id,
        omschrijving, rotatie, size, symbol_name, bouwlaag, bouwlaag_object,
		formaat_bouwlaag, formaat_object, opmerking, soort)
    VALUES (NEW.id,
        clock_timestamp(), NEW.modified_by, TG_OP, NEW.brontabel, NEW.bron_id, NEW.geom, v_object_id, v_bouwlaag_id,
        NEW.omschrijving, NEW.rotatie, NEW.size, NEW.symbol_name, NEW.bouwlaag, NEW.bouwlaag_object,
        COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
        COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
        NEW.opmerking, v_soort
    );

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_label_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_status text := 'OPEN';
    v_object_id integer;
    v_bouwlaag_id integer;
    v_wv_id integer;
    v_koppeling mobiel_sync.koppeling;
	v_soort varchar;
	v_operatie varchar;
BEGIN

    --------------------------------------------------------------------------
    -- Recursie voorkomen
    --------------------------------------------------------------------------
    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    --------------------------------------------------------------------------
    -- Contextafhandeling
    --------------------------------------------------------------------------
    CASE mobiel_sync.context()
        ----------------------------------------------------------------------
        -- OIV-plugin verwerkt werkvoorraad
        ----------------------------------------------------------------------
        WHEN 'WERKVOORRAAD' THEN
            RETURN NEW;
        ----------------------------------------------------------------------
        -- Pull vanuit OIV
        ----------------------------------------------------------------------
        WHEN 'PULL' THEN
            -- Geen mobiele wijziging aanwezig
            IF OLD.sync_status = 0 THEN
                RETURN NEW;
            END IF;

            -- Mobiel gewijzigd en OIV heeft nieuwe versie
            IF OLD.oiv_datum_gewijzigd IS DISTINCT FROM NEW.oiv_datum_gewijzigd THEN
                v_status := 'CONFLICT';
            ELSE
                RETURN NEW;
            END IF;
        ----------------------------------------------------------------------
        -- Wijziging vanuit Mergin
        ----------------------------------------------------------------------
        ELSE
            NEW.sync_status := 1;

    END CASE;


    --------------------------------------------------------------------------
    -- Koppeling bepalen indien ruimtelijke relatie gewijzigd kan zijn
    --------------------------------------------------------------------------
    IF NEW.bouwlaag_object IS DISTINCT FROM OLD.bouwlaag_object
       OR (NEW.bouwlaag_object = 'bouwlaag' AND NEW.bouwlaag_id IS NULL)
       OR (NEW.bouwlaag_object = 'object' AND NEW.object_id IS NULL)
    THEN

        v_koppeling :=
            mobiel_sync.bepaal_koppeling(
                NEW.geom,
                NEW.bouwlaag_object,
                NEW.bouwlaag
            );

        v_bouwlaag_id := v_koppeling.bouwlaag_id;
        v_object_id := v_koppeling.object_id;

    ELSE

        v_bouwlaag_id := NEW.bouwlaag_id;
        v_object_id := NEW.object_id;

    END IF;


    --------------------------------------------------------------------------
    -- Bestaande werkvoorraadregel zoeken
    --------------------------------------------------------------------------
    IF NEW.bron_id IS NULL THEN

        SELECT id
        INTO v_wv_id
        FROM mobiel_sync.werkvoorraad_label
        WHERE mobiel_id = NEW.id
          AND operatie = 'INSERT';

    ELSE

        SELECT id
        INTO v_wv_id
        FROM mobiel_sync.werkvoorraad_label
        WHERE brontabel = NEW.brontabel
          AND bron_id = NEW.bron_id;

    END IF;

    --------------------------------------------------------------------------
    -- soort symbool ophalen voor naamgeving
    --------------------------------------------------------------------------
	v_soort := mobiel_sync.bepaal_type(
	    NEW.brontabel,
	    NEW.symbol_name
	);

    --------------------------------------------------------------------------
    -- Conflictversies bewaren
    --------------------------------------------------------------------------
	IF v_status = 'CONFLICT' AND v_wv_id IS NOT NULL THEN
	
	    SELECT operatie
	    INTO v_operatie
	    FROM mobiel_sync.werkvoorraad_label
	    WHERE id = v_wv_id;
	
	
	    PERFORM mobiel_sync.registreer_conflict(
			'mobiel_sync.werkvoorraad_label'::regclass,
	        v_wv_id,
	        jsonb_build_object(
	            'oiv',
	            to_jsonb(NEW) || jsonb_build_object(
	                'operatie', TG_OP,
	                'soort',
	                v_soort
	            ),
	            'mobiel',
	            to_jsonb(OLD) || jsonb_build_object(
	                'operatie', v_operatie,
	                'soort',
	                mobiel_sync.bepaal_type(
	                    OLD.brontabel,
	                    OLD.symbol_name
	                )
	            )
	        )
	    );
	
	END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad bijwerken
    --------------------------------------------------------------------------
    IF v_wv_id IS NOT NULL THEN

        UPDATE mobiel_sync.werkvoorraad_label
        SET
            modified_at = clock_timestamp(),
            modified_by = NEW.modified_by,
            status = v_status,
            geom = NEW.geom,
            object_id = v_object_id,
            bouwlaag_id = v_bouwlaag_id,
			omschrijving = NEW.omschrijving,
            rotatie = NEW.rotatie,
            size = NEW.size,
            symbol_name = NEW.symbol_name,
            bouwlaag = NEW.bouwlaag,
            bouwlaag_object = NEW.bouwlaag_object,
            formaat_bouwlaag = COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
            formaat_object = COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
            opmerking = NEW.opmerking,
			soort = v_soort
        WHERE id = v_wv_id;

    --------------------------------------------------------------------------
    -- Nieuwe werkvoorraadregel toevoegen
    --------------------------------------------------------------------------
    ELSE

        INSERT INTO mobiel_sync.werkvoorraad_label
        (
            mobiel_id,
            modified_at,
            modified_by,
            operatie,
            status,
            brontabel,
            bron_id,
            geom,
            object_id,
            bouwlaag_id,
			omschrijving,
            rotatie,
            size,
            symbol_name,
            bouwlaag,
            bouwlaag_object,
            formaat_bouwlaag,
            formaat_object,
            opmerking,
			soort
        )
        VALUES
        (
            NEW.id,
            clock_timestamp(),
            NEW.modified_by,
            CASE
                WHEN NEW.bron_id IS NULL THEN 'INSERT'
                ELSE 'UPDATE'
            END,
            v_status,
            NEW.brontabel,
            NEW.bron_id,
            NEW.geom,
            v_object_id,
            v_bouwlaag_id,
			NEW.omschrijving,
            NEW.rotatie,
            NEW.size,
            NEW.symbol_name,
            NEW.bouwlaag,
            NEW.bouwlaag_object,
            COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
            COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
            NEW.opmerking,
			v_soort
        );
    END IF;

    RETURN NEW;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_lijn_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_status text := 'OPEN';
    v_wv_id integer;
	v_soort varchar;
	v_operatie varchar;
BEGIN

    IF pg_trigger_depth() > 1 THEN
        RETURN OLD;
    END IF;

    --------------------------------------------------------------------------
    -- Nieuw mobiel object
    -- Geen OIV-identiteit, dus mag nooit door een OIV-pull verdwijnen
    --------------------------------------------------------------------------
    IF OLD.bron_id IS NULL THEN
        RETURN NULL;
    END IF;

    --------------------------------------------------------------------------
    -- OIV verwijdert een object
    -- Alleen conflict wanneer mobiel nog wijzigingen bevat
    --------------------------------------------------------------------------
    IF mobiel_sync.context() = 'PULL' THEN

        IF OLD.sync_status = 1 THEN
            v_status := 'CONFLICT';
        END IF;

    END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad zoeken
    --------------------------------------------------------------------------
    SELECT id
    INTO v_wv_id
    FROM mobiel_sync.werkvoorraad_lijn
    WHERE brontabel = OLD.brontabel
      AND bron_id = OLD.bron_id
    LIMIT 1;

    --------------------------------------------------------------------------
    -- soort symbool ophalen voor naamgeving
    --------------------------------------------------------------------------
	v_soort := OLD.symbol_name;

    --------------------------------------------------------------------------
    -- Conflictversies bewaren
    --------------------------------------------------------------------------
	IF v_status = 'CONFLICT' AND v_wv_id IS NOT NULL THEN
	
	    SELECT operatie
	    INTO v_operatie
	    FROM mobiel_sync.werkvoorraad_label
	    WHERE id = v_wv_id;
	
	
	    PERFORM mobiel_sync.registreer_conflict(
			'mobiel_sync.werkvoorraad_lijn'::regclass,
	        v_wv_id,
	        jsonb_build_object(
			    'oiv',
			    to_jsonb(OLD) || jsonb_build_object(
			        'operatie', 'DELETE',
			        'soort', v_soort
			    ),
	            'mobiel',
	            to_jsonb(OLD) || jsonb_build_object(
	                'operatie', v_operatie,
	                'soort', v_soort
	            )
	        )
	    );
	
	END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad bijwerken
    --------------------------------------------------------------------------
    IF v_wv_id IS NOT NULL THEN

        UPDATE mobiel_sync.werkvoorraad_lijn
        SET
            modified_at = clock_timestamp(),
            modified_by = OLD.modified_by,
            operatie = 'DELETE',
            status = v_status,
            geom = OLD.geom,
            object_id = OLD.object_id,
            bouwlaag_id = OLD.bouwlaag_id,
			symbol_name = OLD.symbol_name,
			soort = v_soort
        WHERE id = v_wv_id;

    --------------------------------------------------------------------------
    -- Nieuwe DELETE werkvoorraad toevoegen
    --------------------------------------------------------------------------
    ELSE

        INSERT INTO mobiel_sync.werkvoorraad_lijn
        (
            mobiel_id,
            modified_at,
            modified_by,
            operatie,
            status,
            brontabel,
            bron_id,
            geom,
            object_id,
            bouwlaag_id,
			symbol_name,
			soort
        )
        VALUES
        (
            OLD.id,
            clock_timestamp(),
            OLD.modified_by,
            'DELETE',
            v_status,
            OLD.brontabel,
            OLD.bron_id,
            OLD.geom,
            OLD.object_id,
            OLD.bouwlaag_id,
			OLD.symbol_name,
			v_soort
        );

    END IF;

    RETURN OLD;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_lijn_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_object_id integer;
    v_bouwlaag_id integer;
BEGIN
	IF pg_trigger_depth() > 1 THEN
    	RETURN NEW;
	END IF;

	IF mobiel_sync.context() = 'PULL' THEN
	    RETURN NEW;
	END IF;	

    SELECT object_id, bouwlaag_id
    INTO v_object_id, v_bouwlaag_id
    FROM mobiel_sync.bepaal_koppeling(NEW.geom, NEW.bouwlaag_object, NEW.bouwlaag);

    INSERT INTO mobiel_sync.werkvoorraad_lijn (mobiel_id,
        modified_at, modified_by, operatie, brontabel, bron_id, geom, object_id, bouwlaag_id,
        symbol_name, bouwlaag, bouwlaag_object, opmerking, soort)
    VALUES (NEW.id,
        clock_timestamp(), NEW.modified_by, TG_OP, NEW.brontabel, NEW.bron_id, NEW.geom, v_object_id, v_bouwlaag_id,
        NEW.symbol_name, NEW.bouwlaag, NEW.bouwlaag_object, NEW.opmerking, NEW.symbol_name);

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_lijn_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_status text := 'OPEN';
    v_object_id integer;
    v_bouwlaag_id integer;
    v_wv_id integer;
    v_koppeling mobiel_sync.koppeling;
	v_soort varchar;
	v_operatie varchar;
BEGIN

    --------------------------------------------------------------------------
    -- Recursie voorkomen
    --------------------------------------------------------------------------
    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    --------------------------------------------------------------------------
    -- Contextafhandeling
    --------------------------------------------------------------------------
    CASE mobiel_sync.context()
        ----------------------------------------------------------------------
        -- OIV-plugin verwerkt werkvoorraad
        ----------------------------------------------------------------------
        WHEN 'WERKVOORRAAD' THEN
            RETURN NEW;
        ----------------------------------------------------------------------
        -- Pull vanuit OIV
        ----------------------------------------------------------------------
        WHEN 'PULL' THEN
            -- Geen mobiele wijziging aanwezig
            IF OLD.sync_status = 0 THEN
                RETURN NEW;
            END IF;

            -- Mobiel gewijzigd en OIV heeft nieuwe versie
            IF OLD.oiv_datum_gewijzigd IS DISTINCT FROM NEW.oiv_datum_gewijzigd THEN
                v_status := 'CONFLICT';
            ELSE
                RETURN NEW;
            END IF;
        ----------------------------------------------------------------------
        -- Wijziging vanuit Mergin
        ----------------------------------------------------------------------
        ELSE
            NEW.sync_status := 1;

    END CASE;


    --------------------------------------------------------------------------
    -- Koppeling bepalen indien ruimtelijke relatie gewijzigd kan zijn
    --------------------------------------------------------------------------
    IF NEW.bouwlaag_object IS DISTINCT FROM OLD.bouwlaag_object
       OR (NEW.bouwlaag_object = 'bouwlaag' AND NEW.bouwlaag_id IS NULL)
       OR (NEW.bouwlaag_object = 'object' AND NEW.object_id IS NULL)
    THEN

        v_koppeling :=
            mobiel_sync.bepaal_koppeling(
                NEW.geom,
                NEW.bouwlaag_object,
                NEW.bouwlaag
            );

        v_bouwlaag_id := v_koppeling.bouwlaag_id;
        v_object_id := v_koppeling.object_id;

    ELSE

        v_bouwlaag_id := NEW.bouwlaag_id;
        v_object_id := NEW.object_id;

    END IF;


    --------------------------------------------------------------------------
    -- Bestaande werkvoorraadregel zoeken
    --------------------------------------------------------------------------
    IF NEW.bron_id IS NULL THEN

        SELECT id
        INTO v_wv_id
        FROM mobiel_sync.werkvoorraad_lijn
        WHERE mobiel_id = NEW.id
          AND operatie = 'INSERT';

    ELSE

        SELECT id
        INTO v_wv_id
        FROM mobiel_sync.werkvoorraad_lijn
        WHERE brontabel = NEW.brontabel
          AND bron_id = NEW.bron_id;

    END IF;

    --------------------------------------------------------------------------
    -- soort symbool ophalen voor naamgeving
    --------------------------------------------------------------------------
	v_soort := NEW.symbol_name;

    --------------------------------------------------------------------------
    -- Conflictversies bewaren
    --------------------------------------------------------------------------
	IF v_status = 'CONFLICT' AND v_wv_id IS NOT NULL THEN
	
	    SELECT operatie
	    INTO v_operatie
	    FROM mobiel_sync.werkvoorraad_lijn
	    WHERE id = v_wv_id;
	
	
	    PERFORM mobiel_sync.registreer_conflict(
			'mobiel_sync.werkvoorraad_lijn'::regclass,
	        v_wv_id,
	        jsonb_build_object(
	            'oiv',
	            to_jsonb(NEW) || jsonb_build_object(
	                'operatie', TG_OP,
	                'soort', v_soort
	            ),
	            'mobiel',
	            to_jsonb(OLD) || jsonb_build_object(
	                'operatie', v_operatie,
	                'soort', OLD.symbol_name
	            )
	        )
	    );
	
	END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad bijwerken
    --------------------------------------------------------------------------
    IF v_wv_id IS NOT NULL THEN

        UPDATE mobiel_sync.werkvoorraad_lijn
        SET
            modified_at = clock_timestamp(),
            modified_by = NEW.modified_by,
            status = v_status,
            geom = NEW.geom,
            object_id = v_object_id,
            bouwlaag_id = v_bouwlaag_id,
            symbol_name = NEW.symbol_name,
            bouwlaag = NEW.bouwlaag,
            bouwlaag_object = NEW.bouwlaag_object,
            opmerking = NEW.opmerking,
			soort = v_soort
        WHERE id = v_wv_id;

    --------------------------------------------------------------------------
    -- Nieuwe werkvoorraadregel toevoegen
    --------------------------------------------------------------------------
    ELSE

        INSERT INTO mobiel_sync.werkvoorraad_lijn
        (
            mobiel_id,
            modified_at,
            modified_by,
            operatie,
            status,
            brontabel,
            bron_id,
            geom,
            object_id,
            bouwlaag_id,
            symbol_name,
            bouwlaag,
            bouwlaag_object,
            opmerking,
			soort
        )
        VALUES
        (
            NEW.id,
            clock_timestamp(),
            NEW.modified_by,
            CASE
                WHEN NEW.bron_id IS NULL THEN 'INSERT'
                ELSE 'UPDATE'
            END,
            v_status,
            NEW.brontabel,
            NEW.bron_id,
            NEW.geom,
            v_object_id,
            v_bouwlaag_id,
            NEW.symbol_name,
            NEW.bouwlaag,
            NEW.bouwlaag_object,
            NEW.opmerking,
			v_soort
        );
    END IF;

    RETURN NEW;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_symbool_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_status text := 'OPEN';
    v_wv_id integer;
	v_soort varchar;
	v_operatie varchar;
BEGIN

    IF pg_trigger_depth() > 1 THEN
        RETURN OLD;
    END IF;

    --------------------------------------------------------------------------
    -- Nieuw mobiel object
    -- Geen OIV-identiteit, dus mag nooit door een OIV-pull verdwijnen
    --------------------------------------------------------------------------
    IF OLD.bron_id IS NULL THEN
        RETURN NULL;
    END IF;


    --------------------------------------------------------------------------
    -- OIV verwijdert een object
    -- Alleen conflict wanneer mobiel nog wijzigingen bevat
    --------------------------------------------------------------------------
    IF mobiel_sync.context() = 'PULL' THEN

        IF OLD.sync_status = 1 THEN
            v_status := 'CONFLICT';
        END IF;

    END IF;


    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad zoeken
    --------------------------------------------------------------------------
    SELECT id
    INTO v_wv_id
    FROM mobiel_sync.werkvoorraad_symbool
    WHERE brontabel = OLD.brontabel
      AND bron_id = OLD.bron_id
    LIMIT 1;

    --------------------------------------------------------------------------
    -- soort symbool ophalen voor naamgeving
    --------------------------------------------------------------------------
	v_soort := mobiel_sync.bepaal_type(
	    OLD.brontabel,
	    OLD.symbol_name
	);

    --------------------------------------------------------------------------
    -- Conflictversies bewaren
    --------------------------------------------------------------------------
	IF v_status = 'CONFLICT' AND v_wv_id IS NOT NULL THEN
	
	    SELECT operatie
	    INTO v_operatie
	    FROM mobiel_sync.werkvoorraad_label
	    WHERE id = v_wv_id;
	
	
	    PERFORM mobiel_sync.registreer_conflict(
			'mobiel_sync.werkvoorraad_symbool'::regclass,
	        v_wv_id,
	        jsonb_build_object(
			    'oiv',
			    to_jsonb(OLD) || jsonb_build_object(
			        'operatie', 'DELETE',
			        'soort', v_soort
			    ),
	            'mobiel',
	            to_jsonb(OLD) || jsonb_build_object(
	                'operatie', v_operatie,
	                'soort', v_soort
	            )
	        )
	    );
	
	END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad bijwerken
    --------------------------------------------------------------------------
    IF v_wv_id IS NOT NULL THEN

        UPDATE mobiel_sync.werkvoorraad_symbool
        SET
            modified_at = clock_timestamp(),
            modified_by = OLD.modified_by,
            operatie = 'DELETE',
            status = v_status,
            geom = OLD.geom,
            object_id = OLD.object_id,
            bouwlaag_id = OLD.bouwlaag_id,
			symbol_name = OLD.symbol_name,
			soort = v_soort
        WHERE id = v_wv_id;

    --------------------------------------------------------------------------
    -- Nieuwe DELETE werkvoorraad toevoegen
    --------------------------------------------------------------------------
    ELSE

        INSERT INTO mobiel_sync.werkvoorraad_symbool
        (
            mobiel_id,
            modified_at,
            modified_by,
            operatie,
            status,
            brontabel,
            bron_id,
            geom,
            object_id,
            bouwlaag_id,
			symbol_name,
			soort
        )
        VALUES
        (
            OLD.id,
            clock_timestamp(),
            OLD.modified_by,
            'DELETE',
            v_status,
            OLD.brontabel,
            OLD.bron_id,
            OLD.geom,
            OLD.object_id,
            OLD.bouwlaag_id,
			OLD.symbol_name,
			v_soort
        );

    END IF;


    RETURN OLD;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_symbool_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_object_id integer;
    v_bouwlaag_id integer;
	v_soort varchar;
BEGIN
	IF pg_trigger_depth() > 1 THEN
    	RETURN NEW;
	END IF;

	IF mobiel_sync.context() = 'PULL' THEN
	    RETURN NEW;
	END IF;

	v_soort := mobiel_sync.bepaal_type(
	    NEW.brontabel,
	    NEW.symbol_name
	);

    SELECT object_id, bouwlaag_id
    INTO v_object_id, v_bouwlaag_id
    FROM mobiel_sync.bepaal_koppeling(NEW.geom, NEW.bouwlaag_object, NEW.bouwlaag);

    INSERT INTO mobiel_sync.werkvoorraad_symbool (mobiel_id,
        modified_at, modified_by, operatie, brontabel, bron_id, geom, object_id, bouwlaag_id,
        rotatie, size, symbol_name, bouwlaag, bouwlaag_object, label,
        label_positie, formaat_bouwlaag, formaat_object, opmerking, soort)
    VALUES (NEW.id,
        clock_timestamp(), NEW.modified_by, TG_OP, NEW.brontabel, NEW.bron_id, NEW.geom, v_object_id, v_bouwlaag_id,
        NEW.rotatie, NEW.size, NEW.symbol_name, NEW.bouwlaag, NEW.bouwlaag_object, NEW.label,
        COALESCE(NEW.label_positie, 'onder - midden')::algemeen.labelposition,
        COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
        COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
        NEW.opmerking, v_soort
    );

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_symbool_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_status text := 'OPEN';
    v_object_id integer;
    v_bouwlaag_id integer;
    v_wv_id integer;
    v_koppeling mobiel_sync.koppeling;
	v_soort varchar;
	v_operatie varchar;
BEGIN

    --------------------------------------------------------------------------
    -- Recursie voorkomen
    --------------------------------------------------------------------------
    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;


    --------------------------------------------------------------------------
    -- Contextafhandeling
    --------------------------------------------------------------------------
    CASE mobiel_sync.context()

        ----------------------------------------------------------------------
        -- OIV-plugin verwerkt werkvoorraad
        ----------------------------------------------------------------------
        WHEN 'WERKVOORRAAD' THEN
            RETURN NEW;
        ----------------------------------------------------------------------
        -- Pull vanuit OIV
        ----------------------------------------------------------------------
        WHEN 'PULL' THEN

            -- Geen mobiele wijziging aanwezig
            IF OLD.sync_status = 0 THEN
                RETURN NEW;
            END IF;

            -- Mobiel gewijzigd en OIV heeft nieuwe versie
            IF OLD.oiv_datum_gewijzigd IS DISTINCT FROM NEW.oiv_datum_gewijzigd THEN
                v_status := 'CONFLICT';
            ELSE
                RETURN NEW;
            END IF;
        ----------------------------------------------------------------------
        -- Wijziging vanuit Mergin
        ----------------------------------------------------------------------
        ELSE
            NEW.sync_status := 1;

    END CASE;


    --------------------------------------------------------------------------
    -- Koppeling bepalen indien ruimtelijke relatie gewijzigd kan zijn
    --------------------------------------------------------------------------
    IF NEW.bouwlaag_object IS DISTINCT FROM OLD.bouwlaag_object
       OR (NEW.bouwlaag_object = 'bouwlaag' AND NEW.bouwlaag_id IS NULL)
       OR (NEW.bouwlaag_object = 'object' AND NEW.object_id IS NULL)
    THEN

        v_koppeling :=
            mobiel_sync.bepaal_koppeling(
                NEW.geom,
                NEW.bouwlaag_object,
                NEW.bouwlaag
            );

        v_bouwlaag_id := v_koppeling.bouwlaag_id;
        v_object_id := v_koppeling.object_id;

    ELSE

        v_bouwlaag_id := NEW.bouwlaag_id;
        v_object_id := NEW.object_id;

    END IF;


    --------------------------------------------------------------------------
    -- Bestaande werkvoorraadregel zoeken
    --------------------------------------------------------------------------
    IF NEW.bron_id IS NULL THEN

        SELECT id
        INTO v_wv_id
        FROM mobiel_sync.werkvoorraad_symbool
        WHERE mobiel_id = NEW.id
          AND operatie = 'INSERT';

    ELSE

        SELECT id
        INTO v_wv_id
        FROM mobiel_sync.werkvoorraad_symbool
        WHERE brontabel = NEW.brontabel
          AND bron_id = NEW.bron_id;

    END IF;

    --------------------------------------------------------------------------
    -- soort symbool ophalen voor naamgeving
    --------------------------------------------------------------------------
	v_soort := mobiel_sync.bepaal_type(
	    NEW.brontabel,
	    NEW.symbol_name
	);

    --------------------------------------------------------------------------
    -- Conflictversies bewaren
    --------------------------------------------------------------------------
	IF v_status = 'CONFLICT' AND v_wv_id IS NOT NULL THEN
	
	    SELECT operatie
	    INTO v_operatie
	    FROM mobiel_sync.werkvoorraad_symbool
	    WHERE id = v_wv_id;
	
	
	    PERFORM mobiel_sync.registreer_conflict(
			'mobiel_sync.werkvoorraad_symbool'::regclass,
	        v_wv_id,
	        jsonb_build_object(
	            'oiv',
	            to_jsonb(NEW) || jsonb_build_object(
	                'operatie', TG_OP,
	                'soort',
	                v_soort
	            ),
	            'mobiel',
	            to_jsonb(OLD) || jsonb_build_object(
	                'operatie', v_operatie,
	                'soort',
	                mobiel_sync.bepaal_type(
	                    OLD.brontabel,
	                    OLD.symbol_name
	                )
	            )
	        )
	    );
	
	END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad bijwerken
    --------------------------------------------------------------------------
    IF v_wv_id IS NOT NULL THEN

        UPDATE mobiel_sync.werkvoorraad_symbool
        SET
            modified_at = clock_timestamp(),
            modified_by = NEW.modified_by,
            status = v_status,
            geom = NEW.geom,
            object_id = v_object_id,
            bouwlaag_id = v_bouwlaag_id,
            rotatie = NEW.rotatie,
            size = NEW.size,
            symbol_name = NEW.symbol_name,
            bouwlaag = NEW.bouwlaag,
            bouwlaag_object = NEW.bouwlaag_object,
            label = NEW.label,
            label_positie = NEW.label_positie::algemeen.labelposition,
            formaat_bouwlaag = COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
            formaat_object = COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
            opmerking = NEW.opmerking,
			soort = v_soort
        WHERE id = v_wv_id;


    --------------------------------------------------------------------------
    -- Nieuwe werkvoorraadregel toevoegen
    --------------------------------------------------------------------------
    ELSE

        INSERT INTO mobiel_sync.werkvoorraad_symbool
        (
            mobiel_id,
            modified_at,
            modified_by,
            operatie,
            status,
            brontabel,
            bron_id,
            geom,
            object_id,
            bouwlaag_id,
            rotatie,
            size,
            symbol_name,
            bouwlaag,
            bouwlaag_object,
            label,
            label_positie,
            formaat_bouwlaag,
            formaat_object,
            opmerking,
			soort
        )
        VALUES
        (
            NEW.id,
            clock_timestamp(),
            NEW.modified_by,
            CASE
                WHEN NEW.bron_id IS NULL THEN 'INSERT'
                ELSE 'UPDATE'
            END,
            v_status,
            NEW.brontabel,
            NEW.bron_id,
            NEW.geom,
            v_object_id,
            v_bouwlaag_id,
            NEW.rotatie,
            NEW.size,
            NEW.symbol_name,
            NEW.bouwlaag,
            NEW.bouwlaag_object,
            NEW.label,
            COALESCE(NEW.label_positie, 'onder - midden')::algemeen.labelposition,
            COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
            COALESCE(NEW.formaat, 'middel')::algemeen.formaat,
            NEW.opmerking,
			v_soort
        );

    END IF;


    RETURN NEW;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_vlak_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_status text := 'OPEN';
    v_wv_id integer;
	v_soort varchar;
	v_operatie varchar;
BEGIN

    IF pg_trigger_depth() > 1 THEN
        RETURN OLD;
    END IF;

    --------------------------------------------------------------------------
    -- Nieuw mobiel object
    -- Geen OIV-identiteit, dus mag nooit door een OIV-pull verdwijnen
    --------------------------------------------------------------------------
    IF OLD.bron_id IS NULL THEN
        RETURN NULL;
    END IF;

    --------------------------------------------------------------------------
    -- OIV verwijdert een object
    -- Alleen conflict wanneer mobiel nog wijzigingen bevat
    --------------------------------------------------------------------------
    IF mobiel_sync.context() = 'PULL' THEN

        IF OLD.sync_status = 1 THEN
            v_status := 'CONFLICT';
        END IF;

    END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad zoeken
    --------------------------------------------------------------------------
    SELECT id
    INTO v_wv_id
    FROM mobiel_sync.werkvoorraad_vlak
    WHERE brontabel = OLD.brontabel
      AND bron_id = OLD.bron_id
    LIMIT 1;

    --------------------------------------------------------------------------
    -- soort symbool ophalen voor naamgeving
    --------------------------------------------------------------------------
	v_soort :=  OLD.symbol_name;

    --------------------------------------------------------------------------
    -- Conflictversies bewaren
    --------------------------------------------------------------------------
	IF v_status = 'CONFLICT' AND v_wv_id IS NOT NULL THEN
	
	    SELECT operatie
	    INTO v_operatie
	    FROM mobiel_sync.werkvoorraad_label
	    WHERE id = v_wv_id;
	
	
	    PERFORM mobiel_sync.registreer_conflict(
			'mobiel_sync.werkvoorraad_vlak'::regclass,
	        v_wv_id,
	        jsonb_build_object(
			    'oiv',
			    to_jsonb(OLD) || jsonb_build_object(
			        'operatie', 'DELETE',
			        'soort', v_soort
			    ),
	            'mobiel',
	            to_jsonb(OLD) || jsonb_build_object(
	                'operatie', v_operatie,
	                'soort', v_soort
	            )
	        )
	    );
	
	END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad bijwerken
    --------------------------------------------------------------------------
    IF v_wv_id IS NOT NULL THEN

        UPDATE mobiel_sync.werkvoorraad_vlak
        SET
            modified_at = clock_timestamp(),
            modified_by = OLD.modified_by,
            operatie = 'DELETE',
            status = v_status,
            geom = OLD.geom,
            object_id = OLD.object_id,
            bouwlaag_id = OLD.bouwlaag_id,
			symbol_name = OLD.symbol_name,
			soort = v_soort
        WHERE id = v_wv_id;

    --------------------------------------------------------------------------
    -- Nieuwe DELETE werkvoorraad toevoegen
    --------------------------------------------------------------------------
    ELSE

        INSERT INTO mobiel_sync.werkvoorraad_vlak
        (
            mobiel_id,
            modified_at,
            modified_by,
            operatie,
            status,
            brontabel,
            bron_id,
            geom,
            object_id,
            bouwlaag_id,
			symbol_name,
			soort
        )
        VALUES
        (
            OLD.id,
            clock_timestamp(),
            OLD.modified_by,
            'DELETE',
            v_status,
            OLD.brontabel,
            OLD.bron_id,
            OLD.geom,
            OLD.object_id,
            OLD.bouwlaag_id,
			OLD.symbol_name,
			v_soort
        );

    END IF;

    RETURN OLD;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_vlak_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_object_id integer;
    v_bouwlaag_id integer;
BEGIN
	IF pg_trigger_depth() > 1 THEN
    	RETURN NEW;
	END IF;

	IF mobiel_sync.context() = 'PULL' THEN
	    RETURN NEW;
	END IF;	

    SELECT object_id, bouwlaag_id
    INTO v_object_id, v_bouwlaag_id
    FROM mobiel_sync.bepaal_koppeling(NEW.geom, NEW.bouwlaag_object, NEW.bouwlaag);

    INSERT INTO mobiel_sync.werkvoorraad_vlak (mobiel_id,
        modified_at, modified_by, operatie, brontabel, bron_id, geom, object_id, bouwlaag_id,
        symbol_name, bouwlaag, bouwlaag_object, opmerking, soort)
    VALUES (NEW.id,
        clock_timestamp(), NEW.modified_by, TG_OP, NEW.brontabel, NEW.bron_id, NEW.geom, v_object_id, v_bouwlaag_id,
        NEW.symbol_name, NEW.bouwlaag, NEW.bouwlaag_object, NEW.opmerking, NEW.symbol_name);

    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.func_werkvoorraad_vlak_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_status text := 'OPEN';
    v_object_id integer;
    v_bouwlaag_id integer;
    v_wv_id integer;
    v_koppeling mobiel_sync.koppeling;
	v_soort varchar;
	v_operatie varchar;
BEGIN

    --------------------------------------------------------------------------
    -- Recursie voorkomen
    --------------------------------------------------------------------------
    IF pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    --------------------------------------------------------------------------
    -- Contextafhandeling
    --------------------------------------------------------------------------
    CASE mobiel_sync.context()
        ----------------------------------------------------------------------
        -- OIV-plugin verwerkt werkvoorraad
        ----------------------------------------------------------------------
        WHEN 'WERKVOORRAAD' THEN
            RETURN NEW;
        ----------------------------------------------------------------------
        -- Pull vanuit OIV
        ----------------------------------------------------------------------
        WHEN 'PULL' THEN
            -- Geen mobiele wijziging aanwezig
            IF OLD.sync_status = 0 THEN
                RETURN NEW;
            END IF;

            -- Mobiel gewijzigd en OIV heeft nieuwe versie
            IF OLD.oiv_datum_gewijzigd IS DISTINCT FROM NEW.oiv_datum_gewijzigd THEN
                v_status := 'CONFLICT';
            ELSE
                RETURN NEW;
            END IF;
        ----------------------------------------------------------------------
        -- Wijziging vanuit Mergin
        ----------------------------------------------------------------------
        ELSE
            NEW.sync_status := 1;

    END CASE;


    --------------------------------------------------------------------------
    -- Koppeling bepalen indien ruimtelijke relatie gewijzigd kan zijn
    --------------------------------------------------------------------------
    IF NEW.bouwlaag_object IS DISTINCT FROM OLD.bouwlaag_object
       OR (NEW.bouwlaag_object = 'bouwlaag' AND NEW.bouwlaag_id IS NULL)
       OR (NEW.bouwlaag_object = 'object' AND NEW.object_id IS NULL)
    THEN

        v_koppeling :=
            mobiel_sync.bepaal_koppeling(
                NEW.geom,
                NEW.bouwlaag_object,
                NEW.bouwlaag
            );

        v_bouwlaag_id := v_koppeling.bouwlaag_id;
        v_object_id := v_koppeling.object_id;

    ELSE

        v_bouwlaag_id := NEW.bouwlaag_id;
        v_object_id := NEW.object_id;

    END IF;


    --------------------------------------------------------------------------
    -- Bestaande werkvoorraadregel zoeken
    --------------------------------------------------------------------------
    IF NEW.bron_id IS NULL THEN

        SELECT id
        INTO v_wv_id
        FROM mobiel_sync.werkvoorraad_vlak
        WHERE mobiel_id = NEW.id
          AND operatie = 'INSERT';

    ELSE

        SELECT id
        INTO v_wv_id
        FROM mobiel_sync.werkvoorraad_vlak
        WHERE brontabel = NEW.brontabel
          AND bron_id = NEW.bron_id;

    END IF;

    --------------------------------------------------------------------------
    -- soort symbool ophalen voor naamgeving
    --------------------------------------------------------------------------
	v_soort := NEW.symbol_name;

    --------------------------------------------------------------------------
    -- Conflictversies bewaren
    --------------------------------------------------------------------------
	IF v_status = 'CONFLICT' AND v_wv_id IS NOT NULL THEN
	
	    SELECT operatie
	    INTO v_operatie
	    FROM mobiel_sync.werkvoorraad_vlak
	    WHERE id = v_wv_id;
	
	
	    PERFORM mobiel_sync.registreer_conflict(
			'mobiel_sync.werkvoorraad_vlak'::regclass,
	        v_wv_id,
	        jsonb_build_object(
	            'oiv',
	            to_jsonb(NEW) || jsonb_build_object(
	                'operatie', TG_OP,
	                'soort',
	                v_soort
	            ),
	            'mobiel',
	            to_jsonb(OLD) || jsonb_build_object(
	                'operatie', v_operatie,
	                'soort', OLD.symbol_name
	            )
	        )
	    );
	
	END IF;

    --------------------------------------------------------------------------
    -- Bestaande werkvoorraad bijwerken
    --------------------------------------------------------------------------
    IF v_wv_id IS NOT NULL THEN

        UPDATE mobiel_sync.werkvoorraad_vlak
        SET
            modified_at = clock_timestamp(),
            modified_by = NEW.modified_by,
            status = v_status,
            geom = NEW.geom,
            object_id = v_object_id,
            bouwlaag_id = v_bouwlaag_id,
            symbol_name = NEW.symbol_name,
            bouwlaag = NEW.bouwlaag,
            bouwlaag_object = NEW.bouwlaag_object,
            opmerking = NEW.opmerking,
			soort = v_soort
        WHERE id = v_wv_id;

    --------------------------------------------------------------------------
    -- Nieuwe werkvoorraadregel toevoegen
    --------------------------------------------------------------------------
    ELSE

        INSERT INTO mobiel_sync.werkvoorraad_vlak
        (
            mobiel_id,
            modified_at,
            modified_by,
            operatie,
            status,
            brontabel,
            bron_id,
            geom,
            object_id,
            bouwlaag_id,
            symbol_name,
            bouwlaag,
            bouwlaag_object,
            opmerking,
			soort
        )
        VALUES
        (
            NEW.id,
            clock_timestamp(),
            NEW.modified_by,
            CASE
                WHEN NEW.bron_id IS NULL THEN 'INSERT'
                ELSE 'UPDATE'
            END,
            v_status,
            NEW.brontabel,
            NEW.bron_id,
            NEW.geom,
            v_object_id,
            v_bouwlaag_id,
            NEW.symbol_name,
            NEW.bouwlaag,
            NEW.bouwlaag_object,
            NEW.opmerking,
			v_soort
        );
    END IF;

    RETURN NEW;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.log_werkvoorraad(p_record jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

    INSERT INTO mobiel_sync.log_werkvoorraad
    (
        geom,
        record
    )
    VALUES
    (
        ST_SetSRID(
            ST_GeomFromGeoJSON(p_record->>'geom'),
            28992
        ),
        p_record
    );

END;
$function$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_bedrijfshulpverlening()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
     * Nieuwe records vanuit OIV toevoegen
     */
    INSERT INTO mobiel.bedrijfshulpverlening
    (
        bron_id,
        datum_aangemaakt,
        datum_gewijzigd,
        dagen,
        tijdvakbegin,
        tijdvakeind,
        telefoonnummer,
        ademluchtdragend,
        object_id,
        modified_at,
        sync_status
    )
    SELECT
        s.bron_id,
        s.datum_aangemaakt,
        s.datum_gewijzigd,
        s.dagen,
        s.tijdvakbegin,
        s.tijdvakeind,
        s.telefoonnummer,
        s.ademluchtdragend,
        s.object_id,
        NULL,
        0
    FROM mobiel_sync.bedrijfshulpverlening_source s
    LEFT JOIN mobiel.bedrijfshulpverlening m
        ON m.bron_id = s.bron_id
    WHERE m.id IS NULL;
    /*
     * Bestaande records bijwerken vanuit OIV
     * Alleen als mobiel geen wijzigingen bevat
     */
    UPDATE mobiel.bedrijfshulpverlening m
    SET
        datum_aangemaakt = s.datum_aangemaakt,
        datum_gewijzigd = s.datum_gewijzigd,
        dagen = s.dagen,
        tijdvakbegin = s.tijdvakbegin,
        tijdvakeind = s.tijdvakeind,
        telefoonnummer = s.telefoonnummer,
        ademluchtdragend = s.ademluchtdragend,
        object_id = s.object_id
    FROM mobiel_sync.bedrijfshulpverlening_source s
    WHERE m.bron_id = s.bron_id
      AND m.sync_status = 0
      AND (
          m.datum_gewijzigd IS DISTINCT FROM s.datum_gewijzigd
          OR m.dagen IS DISTINCT FROM s.dagen
          OR m.tijdvakbegin IS DISTINCT FROM s.tijdvakbegin
          OR m.tijdvakeind IS DISTINCT FROM s.tijdvakeind
          OR m.telefoonnummer IS DISTINCT FROM s.telefoonnummer
          OR m.ademluchtdragend IS DISTINCT FROM s.ademluchtdragend
          OR m.object_id IS DISTINCT FROM s.object_id
      );
END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_categorie_tabel(p_doeltabel text, p_brontabel text)
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    EXECUTE format(
        'TRUNCATE TABLE mobiel.%I',
        p_doeltabel
    );


    EXECUTE format(
    '
    INSERT INTO mobiel.%I
    (
        id,
        categorie,
        brontabel,
        bouwlaag_object
    )
    SELECT
        row_number() OVER (ORDER BY categorie)::integer,
        categorie,
        brontabel,
        bouwlaag_object
    FROM
    (
        SELECT DISTINCT
            categorie,
            brontabel,
            bouwlaag_object
        FROM mobiel.%I
    ) x
    ',
    p_doeltabel,
    p_brontabel
    );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_categorie_tabellen()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    CALL mobiel_sync.pull_categorie_tabel(
        'categorie_lijnen',
        'lijn_types'
    );

    CALL mobiel_sync.pull_categorie_tabel(
        'categorie_labels',
        'label_types'
    );

    CALL mobiel_sync.pull_categorie_tabel(
        'categorie_symbols',
        'symbol_types'
    );

    CALL mobiel_sync.pull_categorie_tabel(
        'categorie_vlakken',
        'vlak_types'
    );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_contactpersoon()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
     * Nieuwe records vanuit OIV toevoegen
     */
    INSERT INTO mobiel.contactpersoon
    (
        bron_id,
        datum_aangemaakt,
        datum_gewijzigd,
        soort,
        dagen,
        tijdvakbegin,
        tijdvakeind,
        telefoonnummer,
        object_id,
        modified_at,
        sync_status
    )
    SELECT
        s.bron_id,
        s.datum_aangemaakt,
        s.datum_gewijzigd,
        s.soort,
        s.dagen,
        s.tijdvakbegin,
        s.tijdvakeind,
        s.telefoonnummer,
        s.object_id,
        NULL,
        0
    FROM mobiel_sync.contactpersoon_source s
    LEFT JOIN mobiel.contactpersoon m
        ON m.bron_id = s.bron_id
    WHERE m.id IS NULL;

    /*
     * Bestaande records vanuit OIV bijwerken
     * Alleen als mobiel geen wijzigingen heeft
     */
    UPDATE mobiel.contactpersoon m
    SET
        datum_aangemaakt = s.datum_aangemaakt,
        datum_gewijzigd = s.datum_gewijzigd,
        soort = s.soort,
        dagen = s.dagen,
        tijdvakbegin = s.tijdvakbegin,
        tijdvakeind = s.tijdvakeind,
        telefoonnummer = s.telefoonnummer,
        object_id = s.object_id
    FROM mobiel_sync.contactpersoon_source s
    WHERE m.bron_id = s.bron_id
      AND m.sync_status = 0
      AND (
          m.datum_gewijzigd IS DISTINCT FROM s.datum_gewijzigd
          OR m.object_id IS DISTINCT FROM s.object_id
          OR m.soort IS DISTINCT FROM s.soort
          OR m.dagen IS DISTINCT FROM s.dagen
          OR m.tijdvakbegin IS DISTINCT FROM s.tijdvakbegin
          OR m.tijdvakeind IS DISTINCT FROM s.tijdvakeind
          OR m.telefoonnummer IS DISTINCT FROM s.telefoonnummer
      );
END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_gebruiksfunctie()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    /*
     * Nieuwe records vanuit OIV toevoegen
     */
    INSERT INTO mobiel.gebruiksfunctie
    (
        bron_id,
        datum_aangemaakt,
        datum_gewijzigd,
        soort,
        object_id,
        modified_at,
        sync_status
    )
    SELECT
        s.bron_id,
        s.datum_aangemaakt,
        s.datum_gewijzigd,
        s.soort,
        s.object_id,
        NULL,
        0
    FROM mobiel_sync.gebruiksfunctie_source s
    LEFT JOIN mobiel.gebruiksfunctie m
        ON m.bron_id = s.bron_id
    WHERE m.id IS NULL;
    /*
     * Bestaande records bijwerken vanuit OIV
     * Alleen als mobiel geen wijzigingen bevat
     */
    UPDATE mobiel.gebruiksfunctie m
    SET
        datum_aangemaakt = s.datum_aangemaakt,
        datum_gewijzigd = s.datum_gewijzigd,
        soort = s.soort,
        object_id = s.object_id
    FROM mobiel_sync.gebruiksfunctie_source s
    WHERE m.bron_id = s.bron_id
      AND m.sync_status = 0
      AND (
          m.datum_gewijzigd IS DISTINCT FROM s.datum_gewijzigd
          OR m.soort IS DISTINCT FROM s.soort
          OR m.object_id IS DISTINCT FROM s.object_id
      );
END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_labels()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    ----------------------------------------------------------------------------
    -- 1. Nieuwe labels toevoegen
    ----------------------------------------------------------------------------
    INSERT INTO mobiel.labels
    (
        geom,
        brontabel,
        bron_id,
        object_id,
        bouwlaag_id,
		omschrijving,
        symbol_name,
        rotatie,
		size,
        bouwlaag,
        bouwlaag_object,
        bron,
        oiv_datum_aangemaakt,
        oiv_datum_gewijzigd,
        opmerking,
        formaat,
		sync_status
    )
    SELECT
        s.geom,
        s.brontabel,
        s.bron_id,
        s.object_id,
        s.bouwlaag_id,
		s.omschrijving,
        s.symbol_name,
        s.rotatie,
		s.size,
        s.bouwlaag,
        s.bouwlaag_object,
        s.bron,
        s.datum_aangemaakt,
        s.datum_gewijzigd,
        s.opmerking,
        s.formaat,
		0 as sync_status
    FROM mobiel_sync.labels_source s
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM mobiel.labels m
        WHERE m.bron_id = s.bron_id
          AND m.brontabel = s.brontabel
    );

    ----------------------------------------------------------------------------
    -- 2. Bestaande labels bijwerken
    -- Alleen records zonder mobiele wijzigingen
    ----------------------------------------------------------------------------
    UPDATE mobiel.labels m
       SET geom                   = s.geom,
           object_id              = s.object_id,
           bouwlaag_id            = s.bouwlaag_id,
		   omschrijving			  = s.omschrijving,
           symbol_name            = s.symbol_name,
           rotatie                = s.rotatie,
           size					  = s.size,
		   bouwlaag               = s.bouwlaag,
           bouwlaag_object        = s.bouwlaag_object,
           bron                   = s.bron,
           oiv_datum_aangemaakt   = s.datum_aangemaakt,
           oiv_datum_gewijzigd    = s.datum_gewijzigd,
           opmerking              = s.opmerking,
           formaat       		  = s.formaat
    FROM mobiel_sync.labels_source s
    WHERE m.brontabel = s.brontabel
      AND m.bron_id   = s.bron_id
      AND m.sync_status = 0;

    ----------------------------------------------------------------------------
    -- 3. Verwijderde OIV-labels verwijderen
    -- Alleen wanneer mobiel niet gewijzigd is
    ----------------------------------------------------------------------------
    DELETE FROM mobiel.labels m
    WHERE m.sync_status = 0
      AND NOT EXISTS
      (
          SELECT 1
          FROM mobiel_sync.labels_source s
          WHERE s.brontabel = m.brontabel
            AND s.bron_id   = m.bron_id
      );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_lijnen()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    ----------------------------------------------------------------------------
    -- 1. Nieuwe lijnen toevoegen
    ----------------------------------------------------------------------------
    INSERT INTO mobiel.lijnen
    (
        geom,
        brontabel,
        bron_id,
        object_id,
        bouwlaag_id,
        symbol_name,
        bouwlaag,
        bouwlaag_object,
        bron,
        oiv_datum_aangemaakt,
        oiv_datum_gewijzigd,
        opmerking,
		sync_status
    )
    SELECT
        s.geom,
        s.brontabel,
        s.bron_id,
        s.object_id,
        s.bouwlaag_id,
        s.symbol_name,
        s.bouwlaag,
        s.bouwlaag_object,
        s.bron,
        s.datum_aangemaakt,
        s.datum_gewijzigd,
        s.opmerking,
		0 as sync_status
    FROM mobiel_sync.lijnen_source s
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM mobiel.lijnen m
        WHERE m.bron_id = s.bron_id
          AND m.brontabel = s.brontabel
    );

    ----------------------------------------------------------------------------
    -- 2. Bestaande lijnen bijwerken
    -- Alleen records zonder mobiele wijzigingen
    ----------------------------------------------------------------------------
    UPDATE mobiel.lijnen m
       SET geom                   = s.geom,
           object_id              = s.object_id,
           bouwlaag_id            = s.bouwlaag_id,
           symbol_name            = s.symbol_name,
		   bouwlaag               = s.bouwlaag,
           bouwlaag_object        = s.bouwlaag_object,
           bron                   = s.bron,
           oiv_datum_aangemaakt   = s.datum_aangemaakt,
           oiv_datum_gewijzigd    = s.datum_gewijzigd,
           opmerking              = s.opmerking
    FROM mobiel_sync.lijnen_source s
    WHERE m.brontabel = s.brontabel
      AND m.bron_id   = s.bron_id
      AND m.sync_status = 0;

    ----------------------------------------------------------------------------
    -- 3. Verwijderde OIV-lijnen verwijderen
    -- Alleen wanneer mobiel niet gewijzigd is
    ----------------------------------------------------------------------------
    DELETE FROM mobiel.lijnen m
    WHERE m.sync_status = 0
      AND NOT EXISTS
      (
          SELECT 1
          FROM mobiel_sync.lijnen_source s
          WHERE s.brontabel = m.brontabel
            AND s.bron_id   = m.bron_id
      );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_oiv()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_log_id bigint;
BEGIN

    PERFORM mobiel_sync.set_context('PULL');

    INSERT INTO mobiel_sync.log(status)
    VALUES ('RUNNING')
    RETURNING id INTO v_log_id;

    BEGIN

        CALL mobiel_sync.pull_type_tabellen();
        CALL mobiel_sync.pull_categorie_tabellen();

        -- Bewerkbare objecttabellen richting mobiel
        CALL mobiel_sync.pull_symbolen();
        CALL mobiel_sync.pull_lijnen();
        CALL mobiel_sync.pull_vlakken();
        CALL mobiel_sync.pull_labels();

        -- Overige 2-weg tabellen zonder geometrie
        CALL mobiel_sync.pull_contactpersoon();
        CALL mobiel_sync.pull_bedrijfshulpverlening();
        CALL mobiel_sync.pull_gebruiksfunctie();

	    CALL mobiel_sync.push_contactpersoon();
	    CALL mobiel_sync.push_bedrijfshulpverlening();
	    CALL mobiel_sync.push_gebruiksfunctie();

        UPDATE mobiel_sync.log
        SET
            afgerond_op = clock_timestamp(),
            status = 'SUCCESS'
        WHERE id = v_log_id;

    EXCEPTION
    WHEN OTHERS THEN

        UPDATE mobiel_sync.log
        SET
            afgerond_op = clock_timestamp(),
            status = 'ERROR',
            melding = SQLERRM
        WHERE id = v_log_id;

        RAISE;
    END;

    -- Context altijd opruimen bij succes
    PERFORM mobiel_sync.set_context('');

EXCEPTION
WHEN OTHERS THEN

    -- Context ook opruimen bij fouten
    PERFORM mobiel_sync.set_context('');

    RAISE;

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_symbolen()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    ----------------------------------------------------------------------------
    -- 1. Nieuwe symbolen toevoegen
    ----------------------------------------------------------------------------
    INSERT INTO mobiel.symbolen
    (
        geom,
        brontabel,
        bron_id,
        object_id,
        bouwlaag_id,
        symbol_name,
        rotatie,
		size,
        bouwlaag,
        bouwlaag_object,
        bron,
        oiv_datum_aangemaakt,
        oiv_datum_gewijzigd,
        opmerking,
        formaat,
        label,
        label_positie,
		sync_status
    )
    SELECT
        s.geom,
        s.brontabel,
        s.bron_id,
        s.object_id,
        s.bouwlaag_id,
        s.symbol_name,
        s.rotatie,
		s.size,
        s.bouwlaag,
        s.bouwlaag_object,
        s.bron,
        s.datum_aangemaakt,
        s.datum_gewijzigd,
        s.opmerking,
        s.formaat,
        s.label,
        s.label_positie,
		0 as sync_status
    FROM mobiel_sync.symbolen_source s
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM mobiel.symbolen m
        WHERE m.bron_id = s.bron_id
          AND m.brontabel = s.brontabel
    );

    ----------------------------------------------------------------------------
    -- 2. Bestaande symbolen bijwerken
    -- Alleen records zonder mobiele wijzigingen
    ----------------------------------------------------------------------------
    UPDATE mobiel.symbolen m
       SET geom                   = s.geom,
           object_id              = s.object_id,
           bouwlaag_id            = s.bouwlaag_id,
           symbol_name            = s.symbol_name,
           rotatie                = s.rotatie,
		   size					  = s.size,
           bouwlaag               = s.bouwlaag,
           bouwlaag_object        = s.bouwlaag_object,
           bron                   = s.bron,
           oiv_datum_aangemaakt   = s.datum_aangemaakt,
           oiv_datum_gewijzigd    = s.datum_gewijzigd,
           opmerking              = s.opmerking,
           formaat       		  = s.formaat::text,
           label                  = s.label,
           label_positie          = s.label_positie::text
    FROM mobiel_sync.symbolen_source s
    WHERE m.brontabel = s.brontabel
      AND m.bron_id   = s.bron_id
	  AND (
	        m.sync_status = 0
	     OR m.oiv_datum_gewijzigd IS DISTINCT FROM s.datum_gewijzigd
	  );

    ----------------------------------------------------------------------------
    -- 3. Verwijderde OIV-symbolen verwijderen
    -- Alleen wanneer mobiel niet gewijzigd is
    ----------------------------------------------------------------------------
    DELETE FROM mobiel.symbolen m
    WHERE NOT EXISTS
      (
          SELECT 1
          FROM mobiel_sync.symbolen_source s
          WHERE s.brontabel = m.brontabel
            AND s.bron_id   = m.bron_id
      );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_type_tabellen()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    CALL mobiel_sync.pull_type_table(
        'mobiel_sync',
        'symbol_types_source',
        'mobiel',
        'symbol_types'
    );

    CALL mobiel_sync.pull_type_table(
        'mobiel_sync',
        'lijn_types_source',
        'mobiel',
        'lijn_types'
    );

    CALL mobiel_sync.pull_type_table(
        'mobiel_sync',
        'vlak_types_source',
        'mobiel',
        'vlak_types'
    );

    CALL mobiel_sync.pull_type_table(
        'mobiel_sync',
        'label_types_source',
        'mobiel',
        'label_types'
    );
    CALL mobiel_sync.pull_type_table(
        'objecten',
        'contactpersoon_type',
        'mobiel',
        'contactpersoon_type'
    );

    CALL mobiel_sync.pull_type_table(
        'objecten',
        'gebruiksfunctie_type',
        'mobiel',
        'gebruiksfunctie_type'
    );

    CALL mobiel_sync.pull_type_table(
        'objecten',
        'bodemgesteldheid_type',
        'mobiel',
        'bodemgesteldheid_type'
    );

    CALL mobiel_sync.pull_type_table(
        'mobiel_sync',
        'object_type_source',
        'mobiel',
        'object_type'
    );

    CALL mobiel_sync.pull_type_table(
        'algemeen',
        'styles',
        'mobiel',
        'styles'
    );

    CALL mobiel_sync.pull_type_table(
        'mobiel_sync',
        'bouwlagen_source',
        'mobiel',
        'bouwlagen'
    );

    CALL mobiel_sync.pull_type_table(
        'mobiel_sync',
        'objecten_source',
        'mobiel',
        'objecten'
    );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_type_table(p_bron_schema text, p_bron_tabel text, p_doel_schema text, p_doel_tabel text)
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    EXECUTE format(
        'TRUNCATE TABLE %I.%I',
        p_doel_schema,
        p_doel_tabel
    );


    EXECUTE format(
        'INSERT INTO %I.%I SELECT * FROM %I.%I',
        p_doel_schema,
        p_doel_tabel,
        p_bron_schema,
        p_bron_tabel
    );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.pull_vlakken()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    ----------------------------------------------------------------------------
    -- 1. Nieuwe vlakken toevoegen
    ----------------------------------------------------------------------------
    INSERT INTO mobiel.vlakken
    (
        geom,
        brontabel,
        bron_id,
        object_id,
        bouwlaag_id,
        symbol_name,
        bouwlaag,
        bouwlaag_object,
        bron,
        oiv_datum_aangemaakt,
        oiv_datum_gewijzigd,
        opmerking,
		sync_status
    )
    SELECT
        s.geom,
        s.brontabel,
        s.bron_id,
        s.object_id,
        s.bouwlaag_id,
        s.symbol_name,
        s.bouwlaag,
        s.bouwlaag_object,
        s.bron,
        s.datum_aangemaakt,
        s.datum_gewijzigd,
        s.opmerking,
		0 as sync_status
    FROM mobiel_sync.vlakken_source s
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM mobiel.vlakken m
        WHERE m.bron_id = s.bron_id
          AND m.brontabel = s.brontabel
    );

    ----------------------------------------------------------------------------
    -- 2. Bestaande vlakken bijwerken
    -- Alleen records zonder mobiele wijzigingen
    ----------------------------------------------------------------------------
    UPDATE mobiel.vlakken m
       SET geom                   = s.geom,
           object_id              = s.object_id,
           bouwlaag_id            = s.bouwlaag_id,
           symbol_name            = s.symbol_name,
		   bouwlaag               = s.bouwlaag,
           bouwlaag_object        = s.bouwlaag_object,
           bron                   = s.bron,
           oiv_datum_aangemaakt   = s.datum_aangemaakt,
           oiv_datum_gewijzigd    = s.datum_gewijzigd,
           opmerking              = s.opmerking
    FROM mobiel_sync.vlakken_source s
    WHERE m.brontabel = s.brontabel
      AND m.bron_id   = s.bron_id
      AND m.sync_status = 0;

    ----------------------------------------------------------------------------
    -- 3. Verwijderde OIV-vlakken verwijderen
    -- Alleen wanneer mobiel niet gewijzigd is
    ----------------------------------------------------------------------------
    DELETE FROM mobiel.vlakken m
    WHERE m.sync_status = 0
      AND NOT EXISTS
      (
          SELECT 1
          FROM mobiel_sync.vlakken_source s
          WHERE s.brontabel = m.brontabel
            AND s.bron_id   = m.bron_id
      );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.push_bedrijfshulpverlening()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    r record;
    v_id integer;
BEGIN

    --------------------------------------------------------------------------
    -- Nieuwe mobiele records toevoegen aan OIV
    --------------------------------------------------------------------------
    FOR r IN
        SELECT *
        FROM mobiel.bedrijfshulpverlening
        WHERE bron_id IS NULL
    LOOP

        INSERT INTO objecten.bedrijfshulpverlening
        (
            datum_aangemaakt,
            datum_gewijzigd,
            dagen,
            tijdvakbegin,
            tijdvakeind,
            telefoonnummer,
            ademluchtdragend,
            object_id
        )
        VALUES
        (
            r.datum_aangemaakt,
            r.datum_gewijzigd,
            r.dagen,
            r.tijdvakbegin,
            r.tijdvakeind,
            r.telefoonnummer,
            r.ademluchtdragend,
            r.object_id
        )
        RETURNING id INTO v_id;


        UPDATE mobiel.bedrijfshulpverlening
        SET
            bron_id = v_id,
            sync_status = 0
        WHERE id = r.id;

    END LOOP;


    --------------------------------------------------------------------------
    -- Gewijzigde mobiele records bijwerken in OIV
    --------------------------------------------------------------------------
    UPDATE objecten.bedrijfshulpverlening o
    SET
        datum_gewijzigd = clock_timestamp(),
        dagen = m.dagen,
        tijdvakbegin = m.tijdvakbegin,
        tijdvakeind = m.tijdvakeind,
        telefoonnummer = m.telefoonnummer,
        ademluchtdragend = m.ademluchtdragend
    FROM mobiel.bedrijfshulpverlening m
    WHERE o.id = m.bron_id
      AND m.sync_status = 1;


    --------------------------------------------------------------------------
    -- Mobiele wijzigingen verwerkt
    --------------------------------------------------------------------------
    UPDATE mobiel.bedrijfshulpverlening
    SET sync_status = 0
    WHERE sync_status = 1;


    --------------------------------------------------------------------------
    -- Mobiele verwijderingen verwerken
    --------------------------------------------------------------------------
    DELETE FROM objecten.bedrijfshulpverlening o
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM mobiel.bedrijfshulpverlening m
        WHERE m.bron_id = o.id
    );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.push_contactpersoon()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    r record;
    v_id integer;
BEGIN

    --------------------------------------------------------------------------
    -- Nieuwe mobiele records toevoegen aan OIV
    --------------------------------------------------------------------------
    FOR r IN
        SELECT *
        FROM mobiel.contactpersoon
        WHERE bron_id IS NULL
    LOOP

        INSERT INTO objecten.contactpersoon
        (
            datum_aangemaakt,
            datum_gewijzigd,
            soort,
            dagen,
            tijdvakbegin,
            tijdvakeind,
            telefoonnummer,
            object_id
        )
        VALUES
        (
            r.datum_aangemaakt,
            r.datum_gewijzigd,
            r.soort,
            r.dagen,
            r.tijdvakbegin,
            r.tijdvakeind,
            r.telefoonnummer,
            r.object_id
        )
        RETURNING id INTO v_id;


        UPDATE mobiel.contactpersoon
        SET
            bron_id = v_id,
            sync_status = 0
        WHERE id = r.id;

    END LOOP;


    --------------------------------------------------------------------------
    -- Gewijzigde mobiele records bijwerken in OIV
    --------------------------------------------------------------------------
    UPDATE objecten.contactpersoon o
    SET
        datum_gewijzigd = clock_timestamp(),
        soort = m.soort,
        dagen = m.dagen,
        tijdvakbegin = m.tijdvakbegin,
        tijdvakeind = m.tijdvakeind,
        telefoonnummer = m.telefoonnummer
    FROM mobiel.contactpersoon m
    WHERE o.id = m.bron_id
      AND m.sync_status = 1;


    --------------------------------------------------------------------------
    -- Mobiele wijzigingen zijn verwerkt
    --------------------------------------------------------------------------
    UPDATE mobiel.contactpersoon
    SET
        sync_status = 0
    WHERE sync_status = 1;


    --------------------------------------------------------------------------
    -- Mobiele deletes detecteren
    -- Eerst pull heeft de bestaande koppeling gezet.
    -- Ontbrekende bron_id betekent dat mobiel verwijderd is.
    --------------------------------------------------------------------------
    DELETE FROM objecten.contactpersoon o
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM mobiel.contactpersoon m
        WHERE m.bron_id = o.id
    );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.push_gebruiksfunctie()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    r record;
    v_id integer;
BEGIN

    --------------------------------------------------------------------------
    -- Nieuwe mobiele records toevoegen aan OIV
    --------------------------------------------------------------------------
    FOR r IN
        SELECT *
        FROM mobiel.gebruiksfunctie
        WHERE bron_id IS NULL
    LOOP

        INSERT INTO objecten.gebruiksfunctie
        (
            datum_aangemaakt,
            datum_gewijzigd,
            object_id,
            soort
        )
        VALUES
        (
            r.datum_aangemaakt,
            r.datum_gewijzigd,
            r.object_id,
            r.soort
        )
        RETURNING id INTO v_id;


        UPDATE mobiel.gebruiksfunctie
        SET
            bron_id = v_id,
            sync_status = 0
        WHERE id = r.id;

    END LOOP;


    --------------------------------------------------------------------------
    -- Gewijzigde mobiele records bijwerken in OIV
    --------------------------------------------------------------------------
    UPDATE objecten.gebruiksfunctie o
    SET
        datum_gewijzigd = clock_timestamp(),
        soort = m.soort
    FROM mobiel.gebruiksfunctie m
    WHERE o.id = m.bron_id
      AND m.sync_status = 1;


    --------------------------------------------------------------------------
    -- Mobiele wijzigingen verwerkt
    --------------------------------------------------------------------------
    UPDATE mobiel.gebruiksfunctie
    SET sync_status = 0
    WHERE sync_status = 1;


    --------------------------------------------------------------------------
    -- Mobiele verwijderingen verwerken
    --------------------------------------------------------------------------
    DELETE FROM objecten.gebruiksfunctie o
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM mobiel.gebruiksfunctie m
        WHERE m.bron_id = o.id
    );

END;
$procedure$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.push_mobiel()
 LANGUAGE plpgsql
AS $procedure$
BEGIN

    CALL mobiel_sync.push_contactpersoon();
    CALL mobiel_sync.push_bedrijfshulpverlening();
    CALL mobiel_sync.push_gebruiksfunctie();

END;
$procedure$
;

-- DROP FUNCTION mobiel_sync.referentiepunt(geometry);

CREATE OR REPLACE FUNCTION mobiel_sync.referentiepunt(p_geom geometry)
 RETURNS geometry
 LANGUAGE plpgsql
 IMMUTABLE
AS $function$
BEGIN

    CASE GeometryType(p_geom)

        WHEN 'POINT' THEN
            RETURN p_geom;

        WHEN 'MULTIPOINT' THEN
            RETURN ST_Centroid(p_geom);

        WHEN 'LINESTRING' THEN
            RETURN ST_LineInterpolatePoint(p_geom, 0.5);

        WHEN 'MULTILINESTRING' THEN
            RETURN ST_LineInterpolatePoint(
                ST_LineMerge(p_geom),
                0.5
            );

        WHEN 'POLYGON' THEN
            RETURN ST_Centroid(p_geom);

        WHEN 'MULTIPOLYGON' THEN
            RETURN ST_Centroid(p_geom);

        ELSE
            RETURN ST_Centroid(p_geom);

    END CASE;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.registreer_conflict(p_tabel regclass, p_werkvoorraad_id integer, p_oiv jsonb DEFAULT NULL::jsonb, p_mobiel jsonb DEFAULT NULL::jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_conflict jsonb;
BEGIN

    EXECUTE format(
        'SELECT COALESCE(conflict_data, ''{}''::jsonb)
         FROM %s
         WHERE id = $1',
         p_tabel
    )
    INTO v_conflict
    USING p_werkvoorraad_id;


    IF p_oiv IS NOT NULL THEN
        v_conflict := jsonb_set(
            v_conflict,
            '{oiv}',
            p_oiv,
            true
        );
    END IF;


    IF p_mobiel IS NOT NULL THEN
        v_conflict := jsonb_set(
            v_conflict,
            '{mobiel}',
            p_mobiel,
            true
        );
    END IF;


    EXECUTE format(
        'UPDATE %s
         SET status = ''CONFLICT'',
             conflict_data = $1
         WHERE id = $2',
         p_tabel
    )
    USING v_conflict, p_werkvoorraad_id;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.set_context(p_context text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    PERFORM set_config('mobiel.context', upper(p_context), true);
END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_werkvoorraad_automatisch_check(p_typeobject text, p_brontabel text, p_datum_geldig_vanaf timestamp with time zone, p_datum_geldig_tot timestamp with time zone)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN

    RETURN EXISTS (
        SELECT 1
        FROM mobiel_sync.werkvoorraad_automatisch r
        WHERE r.actief

          -- Typeobject moet altijd specifiek matchen
          AND r.typeobject = p_typeobject

          -- Brontabel specifiek of ALL
          AND (r.brontabel = 'ALL' OR r.brontabel = p_brontabel)

          -- Geldig vanaf
          AND (r.geldig_vanaf_dagen IS NULL OR p_datum_geldig_vanaf IS NULL OR p_datum_geldig_vanaf <= CURRENT_DATE + r.geldig_vanaf_dagen)

          -- Geldig tot
          AND (r.geldig_tot_dagen IS NULL OR p_datum_geldig_tot IS NULL OR p_datum_geldig_tot >= CURRENT_DATE - r.geldig_tot_dagen)
    );

END;
$function$
;

CREATE OR REPLACE PROCEDURE mobiel_sync.verwerk_werkvoorraad_automatisch()
LANGUAGE plpgsql
AS $procedure$
DECLARE
    r record;
BEGIN

    -- Symbolen
    FOR r IN
        SELECT w.id
        FROM mobiel_sync.werkvoorraad_symbool w
        JOIN mobiel_sync.objecten_source o ON o.id = w.object_id
        WHERE w.status = 'OPEN'
          AND mobiel_sync.verwerk_werkvoorraad_automatisch_check(
                o.typeobject, w.brontabel, o.datum_geldig_vanaf, o.datum_geldig_tot)
    LOOP
        CALL mobiel_sync.verwerk_werkvoorraad('mobiel_sync.werkvoorraad_symbool', r.id, true);
    END LOOP;

    -- Labels
    FOR r IN
        SELECT w.id
        FROM mobiel_sync.werkvoorraad_label w
        JOIN mobiel_sync.objecten_source o ON o.id = w.object_id
        WHERE w.status = 'OPEN'
          AND mobiel_sync.verwerk_werkvoorraad_automatisch_check(
                o.typeobject, w.brontabel, o.datum_geldig_vanaf, o.datum_geldig_tot)
    LOOP
        CALL mobiel_sync.verwerk_werkvoorraad('mobiel_sync.werkvoorraad_label', r.id, true);
    END LOOP;

    -- Lijnen
    FOR r IN
        SELECT w.id
        FROM mobiel_sync.werkvoorraad_lijn w
        JOIN mobiel_sync.objecten_source o ON o.id = w.object_id
        WHERE w.status = 'OPEN'
          AND mobiel_sync.verwerk_werkvoorraad_automatisch_check(
                o.typeobject, w.brontabel, o.datum_geldig_vanaf, o.datum_geldig_tot)
    LOOP
        CALL mobiel_sync.verwerk_werkvoorraad('mobiel_sync.werkvoorraad_lijn', r.id, true);
    END LOOP;

    -- Vlakken
    FOR r IN
        SELECT w.id
        FROM mobiel_sync.werkvoorraad_vlak w
        JOIN mobiel_sync.objecten_source o ON o.id = w.object_id
        WHERE w.status = 'OPEN'
          AND mobiel_sync.verwerk_werkvoorraad_automatisch_check(
                o.typeobject, w.brontabel, o.datum_geldig_vanaf, o.datum_geldig_tot)
    LOOP
        CALL mobiel_sync.verwerk_werkvoorraad('mobiel_sync.werkvoorraad_vlak', r.id, true);
    END LOOP;

END;
$procedure$;

CREATE OR REPLACE PROCEDURE mobiel_sync.sync()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_log_id bigint;
BEGIN

    PERFORM mobiel_sync.set_context('PULL');

    INSERT INTO mobiel_sync.log(status)
    VALUES ('RUNNING')
    RETURNING id INTO v_log_id;

    BEGIN

        CALL mobiel_sync.pull_type_tabellen();
        CALL mobiel_sync.pull_categorie_tabellen();

		CALL mobiel_sync.fix_sequences();

        -- Bewerkbare objecttabellen richting mobiel
        CALL mobiel_sync.pull_symbolen();
        CALL mobiel_sync.pull_lijnen();
        CALL mobiel_sync.pull_vlakken();
        CALL mobiel_sync.pull_labels();

        -- Overige 2-weg tabellen zonder geometrie
        CALL mobiel_sync.pull_contactpersoon();
        CALL mobiel_sync.pull_bedrijfshulpverlening();
        CALL mobiel_sync.pull_gebruiksfunctie();

		-- Automatisch toegestane werkvoorraad verwerken 
		CALL mobiel_sync.verwerk_werkvoorraad_automatisch();

        UPDATE mobiel_sync.log
        SET
            afgerond_op = clock_timestamp(),
            status = 'SUCCESS'
        WHERE id = v_log_id;

    EXCEPTION
    WHEN OTHERS THEN

        UPDATE mobiel_sync.log
        SET
            afgerond_op = clock_timestamp(),
            status = 'ERROR',
            melding = SQLERRM
        WHERE id = v_log_id;

        RAISE;
    END;

    -- Context altijd opruimen bij succes
    PERFORM mobiel_sync.set_context('');

EXCEPTION
WHEN OTHERS THEN

    -- Context ook opruimen bij fouten
    PERFORM mobiel_sync.set_context('');

    RAISE;

END;
$procedure$
;


CREATE OR REPLACE FUNCTION mobiel_sync.bepaal_koppeling_sql(p_brontabel text, p_bouwlaag_object text, p_bouwlaag_id integer, p_object_id integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_heeft_bouwlaag boolean;
    v_heeft_object boolean;
BEGIN

    SELECT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'objecten'
          AND table_name = p_brontabel
          AND column_name = 'bouwlaag_id'
    )
    INTO v_heeft_bouwlaag;

    SELECT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'objecten'
          AND table_name = p_brontabel
          AND column_name = 'object_id'
    )
    INTO v_heeft_object;


    IF p_bouwlaag_object = 'bouwlaag' THEN

        IF NOT v_heeft_bouwlaag THEN
            RAISE EXCEPTION
                'Tabel objecten.% heeft geen bouwlaag_id',
                p_brontabel;
        END IF;

        IF v_heeft_object THEN
            RETURN format(
                'bouwlaag_id = %L, object_id = NULL',
                p_bouwlaag_id
            );
        ELSE
            RETURN format(
                'bouwlaag_id = %L',
                p_bouwlaag_id
            );
        END IF;


    ELSIF p_bouwlaag_object = 'object' THEN

        IF NOT v_heeft_object THEN
            RAISE EXCEPTION
                'Tabel objecten.% heeft geen object_id',
                p_brontabel;
        END IF;

        IF v_heeft_bouwlaag THEN
            RETURN format(
                'bouwlaag_id = NULL, object_id = %L',
                p_object_id
            );
        ELSE
            RETURN format(
                'object_id = %L',
                p_object_id
            );
        END IF;


    ELSE

        RAISE EXCEPTION
            'Ongeldige waarde bouwlaag_object voor %: %',
            p_brontabel,
            p_bouwlaag_object;

    END IF;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_label_delete(p_brontabel text, p_data jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

    EXECUTE format('DELETE FROM objecten.%I WHERE id = $1', p_brontabel)
    USING (p_data->>'bron_id')::integer;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_label_insert(p_brontabel text, p_data jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_sql text;
    v_type_tabel text;
BEGIN
	v_sql := format($sql$
	    INSERT INTO objecten.%I
	    (
	        geom,
	        soort,
	        rotatie,
	        omschrijving,
	        bouwlaag_id,
	        object_id,
	        opmerking,
	        formaat_bouwlaag,
	        formaat_object
	    )
	    VALUES
	    (
	        ST_SetSRID(ST_GeomFromGeoJSON($1),28992),
	        (SELECT naam FROM objecten.%I_type WHERE symbol_name = $2),
	        $3,$4,$5,$6,$7,$8,$9
	    )
	$sql$,
	p_brontabel,
	p_brontabel);

    EXECUTE v_sql
    USING
        p_data->>'geom',
        p_data->>'symbol_name',
        (p_data->>'rotatie')::integer,
        p_data->>'omschrijving',
        (p_data->>'bouwlaag_id')::integer,
        (p_data->>'object_id')::integer,
        p_data->>'opmerking',
        (p_data->>'formaat_bouwlaag')::algemeen.formaat,
        (p_data->>'formaat_object')::algemeen.formaat;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_label_update(
    p_brontabel text,
    p_data jsonb
)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
    v_sql text;
    v_koppeling text;
BEGIN

    v_koppeling := mobiel_sync.bepaal_koppeling_sql(
        p_brontabel,
        p_data->>'bouwlaag_object',
        (p_data->>'bouwlaag_id')::integer,
        (p_data->>'object_id')::integer
    );

    v_sql := format($sql$
        UPDATE objecten.%I
        SET
            geom = ST_SetSRID(ST_GeomFromGeoJSON($1), 28992),
            %s,
            label = $2,
            rotatie = $3,
            opmerking = $4,
            label_positie = $5,
            formaat_bouwlaag = $6,
            formaat_object = $7
        WHERE id = $8
    $sql$,
        p_brontabel,
        v_koppeling
    );

    EXECUTE v_sql
    USING
        p_data->>'geom',
        p_data->>'label',
        (p_data->>'rotatie')::integer,
        p_data->>'opmerking',
        (p_data->>'label_positie')::algemeen.labelposition,
        (p_data->>'formaat_bouwlaag')::algemeen.formaat,
        (p_data->>'formaat_object')::algemeen.formaat,
        (p_data->>'bron_id')::integer;

END;
$function$;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_lijn_delete(p_brontabel text, p_data jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

    EXECUTE format('DELETE FROM objecten.%I WHERE id = $1', p_brontabel)
    USING (p_data->>'bron_id')::integer;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_lijn_insert(
    p_brontabel text,
    p_data jsonb
)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
    v_sql text;
BEGIN

    IF p_data->>'bouwlaag_object' = 'bouwlaag' THEN

        v_sql := format($sql$
            INSERT INTO objecten.%I
            (geom, soort, bouwlaag_id, opmerking)
            VALUES
            (ST_SetSRID(ST_GeomFromGeoJSON($1), 28992), $2, $3, $4)
        $sql$,
            p_brontabel
        );

        EXECUTE v_sql
        USING
            p_data->>'geom',
            p_data->>'soort',
            (p_data->>'bouwlaag_id')::integer,
            p_data->>'opmerking';

    ELSIF p_data->>'bouwlaag_object' = 'object' THEN

        v_sql := format($sql$
            INSERT INTO objecten.%I
            (geom, soort, object_id, opmerking)
            VALUES
            (ST_SetSRID(ST_GeomFromGeoJSON($1), 28992), $2, $3, $4)
        $sql$,
            p_brontabel
        );

        EXECUTE v_sql
        USING
            p_data->>'geom',
            p_data->>'soort',
            (p_data->>'object_id')::integer,
            p_data->>'opmerking';

    ELSE

        RAISE EXCEPTION
            'Ongeldige waarde bouwlaag_object voor %: %',
            p_brontabel,
            p_data->>'bouwlaag_object';
    END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_lijn_update(
    p_brontabel text,
    p_data jsonb
)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
    v_sql text;
    v_koppeling text;
BEGIN

    v_koppeling := mobiel_sync.bepaal_koppeling_sql(
        p_brontabel,
        p_data->>'bouwlaag_object',
        (p_data->>'bouwlaag_id')::integer,
        (p_data->>'object_id')::integer
    );

    v_sql := format($sql$
        UPDATE objecten.%I
        SET
            geom = ST_SetSRID(ST_GeomFromGeoJSON($1), 28992),
            soort = $2,
            %s,
            opmerking = $3
        WHERE id = $4
    $sql$,
        p_brontabel,
        v_koppeling
    );

    EXECUTE v_sql
    USING
        p_data->>'geom',
        p_data->>'soort',
        p_data->>'opmerking',
        (p_data->>'bron_id')::integer;

END;
$function$;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_symbool_delete(p_brontabel text, p_data jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

    EXECUTE format('DELETE FROM objecten.%I WHERE id = $1', p_brontabel)
    USING (p_data->>'bron_id')::integer;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_symbool_insert(
    p_brontabel text,
    p_data jsonb
)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
    v_sql text;
BEGIN

    IF p_data->>'bouwlaag_object' = 'bouwlaag' THEN

        v_sql := format($sql$
            INSERT INTO objecten.%I
            (geom, soort, rotatie, label, bouwlaag_id, opmerking, label_positie, formaat_bouwlaag)
            VALUES
            (ST_SetSRID(ST_GeomFromGeoJSON($1), 28992), $2, $3, $4, $5, $6, $7, $8)
        $sql$,
            p_brontabel,
            p_brontabel
        );

        EXECUTE v_sql
        USING
            p_data->>'geom',
            p_data->>'soort',
            (p_data->>'rotatie')::integer,
            p_data->>'label',
            (p_data->>'bouwlaag_id')::integer,
            p_data->>'opmerking',
            (p_data->>'label_positie')::algemeen.labelposition,
            (p_data->>'formaat_bouwlaag')::algemeen.formaat;


    ELSIF p_data->>'bouwlaag_object' = 'object' THEN

        v_sql := format($sql$
            INSERT INTO objecten.%I
            (geom, soort, rotatie, label, object_id, opmerking, label_positie, formaat_object)
            VALUES
            (ST_SetSRID(ST_GeomFromGeoJSON($1), 28992), $2, $3, $4, $5, $6, $7, $8)
        $sql$,
            p_brontabel,
            p_brontabel
        );

        EXECUTE v_sql
        USING
            p_data->>'geom',
            p_data->>'soort',
            (p_data->>'rotatie')::integer,
            p_data->>'label',
            (p_data->>'object_id')::integer,
            p_data->>'opmerking',
            (p_data->>'label_positie')::algemeen.labelposition,
            (p_data->>'formaat_object')::algemeen.formaat;

    ELSE

        RAISE EXCEPTION
            'Ongeldige waarde bouwlaag_object voor %: %',
            p_brontabel,
            p_data->>'bouwlaag_object';

    END IF;

END;
$function$;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_symbool_update(
    p_brontabel text,
    p_data jsonb
)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
    v_sql text;
    v_koppeling text;
BEGIN

    v_koppeling := mobiel_sync.bepaal_koppeling_sql(
        p_brontabel,
        p_data->>'bouwlaag_object',
        (p_data->>'bouwlaag_id')::integer,
        (p_data->>'object_id')::integer
    );

    IF p_data->>'bouwlaag_object' = 'bouwlaag' THEN

        v_sql := format($sql$
            UPDATE objecten.%I
            SET
                geom = ST_SetSRID(ST_GeomFromGeoJSON($1), 28992),
                soort = $2,
                rotatie = $3,
                label = $4,
                %s,
                opmerking = $5,
                label_positie = $6,
                formaat_bouwlaag = $7
            WHERE id = $8
        $sql$,
            p_brontabel,
            v_koppeling
        );

        EXECUTE v_sql
        USING
            p_data->>'geom',
            p_data->>'soort',
            (p_data->>'rotatie')::integer,
            p_data->>'label',
            p_data->>'opmerking',
            (p_data->>'label_positie')::algemeen.labelposition,
            (p_data->>'formaat_bouwlaag')::algemeen.formaat,
            (p_data->>'bron_id')::integer;


    ELSIF p_data->>'bouwlaag_object' = 'object' THEN

        v_sql := format($sql$
            UPDATE objecten.%I
            SET
                geom = ST_SetSRID(ST_GeomFromGeoJSON($1), 28992),
                soort = $2,
                rotatie = $3,
                label = $4,
                %s,
                opmerking = $5,
                label_positie = $6,
                formaat_object = $7
            WHERE id = $8
        $sql$,
            p_brontabel,
            v_koppeling
        );

        EXECUTE v_sql
        USING
            p_data->>'geom',
            p_data->>'soort',
            (p_data->>'rotatie')::integer,
            p_data->>'label',
            p_data->>'opmerking',
            (p_data->>'label_positie')::algemeen.labelposition,
            (p_data->>'formaat_object')::algemeen.formaat,
            (p_data->>'bron_id')::integer;


    ELSE

        RAISE EXCEPTION
            'Ongeldige waarde bouwlaag_object voor %: %',
            p_brontabel,
            p_data->>'bouwlaag_object';

    END IF;

END;
$function$;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_vlak_delete(p_brontabel text, p_data jsonb)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

    EXECUTE format('DELETE FROM objecten.%I WHERE id = $1', p_brontabel)
    USING (p_data->>'bron_id')::integer;

END;
$function$
;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_vlak_insert(p_brontabel text, p_data jsonb)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
    v_sql text;
BEGIN

    IF p_data->>'bouwlaag_object' = 'bouwlaag' THEN

        v_sql := format($sql$
            INSERT INTO objecten.%I
            (geom, soort, bouwlaag_id, opmerking)
            VALUES
            (ST_SetSRID(ST_GeomFromGeoJSON($1), 28992), $2, $3, $4)
        $sql$,
            p_brontabel
        );

        EXECUTE v_sql
        USING
            p_data->>'geom',
            p_data->>'soort',
            (p_data->>'bouwlaag_id')::integer,
            p_data->>'opmerking';

    ELSIF p_data->>'bouwlaag_object' = 'object' THEN

        v_sql := format($sql$
            INSERT INTO objecten.%I
            (geom, soort, object_id, opmerking)
            VALUES
            (ST_SetSRID(ST_GeomFromGeoJSON($1), 28992), $2, $3, $4)
        $sql$,
            p_brontabel
        );

        EXECUTE v_sql
        USING
            p_data->>'geom',
            p_data->>'soort',
            (p_data->>'object_id')::integer,
            p_data->>'opmerking';

    ELSE

        RAISE EXCEPTION
            'Ongeldige waarde bouwlaag_object voor %: %',
            p_brontabel,
            p_data->>'bouwlaag_object';
    END IF;
END;
$function$;

CREATE OR REPLACE FUNCTION mobiel_sync.verwerk_vlak_update(
    p_brontabel text,
    p_data jsonb
)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
    v_sql text;
    v_koppeling text;
BEGIN

    v_koppeling := mobiel_sync.bepaal_koppeling_sql(
        p_brontabel,
        p_data->>'bouwlaag_object',
        (p_data->>'bouwlaag_id')::integer,
        (p_data->>'object_id')::integer
    );

    v_sql := format($sql$
        UPDATE objecten.%I
        SET
            geom = ST_SetSRID(ST_GeomFromGeoJSON($1), 28992),
            soort = $2,
            %s,
            opmerking = $3
        WHERE id = $4
    $sql$,
        p_brontabel,
        v_koppeling
    );

    EXECUTE v_sql
    USING
        p_data->>'geom',
        p_data->>'soort',
        p_data->>'opmerking',
        (p_data->>'bron_id')::integer;

END;
$function$;

CREATE OR REPLACE PROCEDURE mobiel_sync.verwerk_werkvoorraad(p_werkvoorraad_tabel regclass, p_id integer, p_accepted boolean, p_conflict_actie text DEFAULT NULL::text)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_record record;
    v_data jsonb;
    v_type text;
    v_operatie text;
	v_mobiel_tabel text;
BEGIN

    EXECUTE format('SELECT * FROM %s WHERE id = $1', p_werkvoorraad_tabel)
    INTO v_record
    USING p_id;

    IF v_record IS NULL THEN
        RAISE EXCEPTION 'Werkvoorraad record % niet gevonden', p_id;
    END IF;

    IF v_record.status = 'OPEN' THEN
        v_data := to_jsonb(v_record);
    ELSIF v_record.status = 'CONFLICT' THEN

        CASE p_conflict_actie
            WHEN 'OIV' THEN
                v_data := v_record.conflict_data->'oiv'->'oiv';
            WHEN 'MOBIEL' THEN
                v_data := v_record.conflict_data->'oiv'->'mobiel';
            ELSE
                RAISE EXCEPTION 'Geen geldige conflict actie';
        END CASE;
    ELSE
        RAISE EXCEPTION 'Onbekende status %', v_record.status;
    END IF;

    v_type := CASE p_werkvoorraad_tabel::text
        WHEN 'werkvoorraad_symbool' THEN 'symbool'
        WHEN 'werkvoorraad_label'   THEN 'label'
        WHEN 'werkvoorraad_lijn'    THEN 'lijn'
        WHEN 'werkvoorraad_vlak'    THEN 'vlak'
        ELSE NULL
    END;

    IF v_type IS NULL THEN
        RAISE EXCEPTION 'Onbekend werkvoorraad type %', p_werkvoorraad_tabel;
    END IF;

    v_operatie := v_data->>'operatie';

	IF p_accepted THEN

	    CASE v_type
	
	        WHEN 'symbool' THEN
	            CASE v_operatie
	                WHEN 'INSERT' THEN
	                    PERFORM mobiel_sync.verwerk_symbool_insert(v_data->>'brontabel', v_data);
	                WHEN 'UPDATE' THEN
	                    PERFORM mobiel_sync.verwerk_symbool_update(v_data->>'brontabel', v_data);
	                WHEN 'DELETE' THEN
	                    PERFORM mobiel_sync.verwerk_symbool_delete(v_data->>'brontabel', v_data);
	            END CASE;
	
	
	        WHEN 'label' THEN
	            CASE v_operatie
	                WHEN 'INSERT' THEN
	                    PERFORM mobiel_sync.verwerk_label_insert(v_data->>'brontabel', v_data);
	                WHEN 'UPDATE' THEN
	                    PERFORM mobiel_sync.verwerk_label_update(v_data->>'brontabel', v_data);
	                WHEN 'DELETE' THEN
	                    PERFORM mobiel_sync.verwerk_label_delete(v_data->>'brontabel', v_data);
	            END CASE;
	
	
	        WHEN 'lijn' THEN
	            CASE v_operatie
	                WHEN 'INSERT' THEN
	                    PERFORM mobiel_sync.verwerk_lijn_insert(v_data->>'brontabel', v_data);
	                WHEN 'UPDATE' THEN
	                    PERFORM mobiel_sync.verwerk_lijn_update(v_data->>'brontabel', v_data);
	                WHEN 'DELETE' THEN
	                    PERFORM mobiel_sync.verwerk_lijn_delete(v_data->>'brontabel', v_data);
	            END CASE;
	
	
	        WHEN 'vlak' THEN
	            CASE v_operatie
	                WHEN 'INSERT' THEN
	                    PERFORM mobiel_sync.verwerk_vlak_insert(v_data->>'brontabel', v_data);
	                WHEN 'UPDATE' THEN
	                    PERFORM mobiel_sync.verwerk_vlak_update(v_data->>'brontabel', v_data);
	                WHEN 'DELETE' THEN
	                    PERFORM mobiel_sync.verwerk_vlak_delete(v_data->>'brontabel', v_data);
	            END CASE;
	
	    END CASE;
	END IF;

	v_mobiel_tabel := CASE v_type
	    WHEN 'symbool' THEN 'symbolen'
	    WHEN 'label'   THEN 'labels'
	    WHEN 'lijn'    THEN 'lijnen'
	    WHEN 'vlak'    THEN 'vlakken'
	END;
	-- altijd mobiele status herstellen
	IF v_operatie <> 'DELETE' THEN
	
		PERFORM mobiel_sync.set_context('PULL');
	    EXECUTE format(
	        'UPDATE mobiel.%I
	         SET sync_status = 0
	         WHERE id = $1',
	        v_mobiel_tabel
	    )
	    USING (v_data->>'mobiel_id')::integer;
		PERFORM mobiel_sync.clear_context();

	END IF;

    PERFORM mobiel_sync.log_werkvoorraad(v_data);
    PERFORM mobiel_sync.verwijder_werkvoorraad(p_werkvoorraad_tabel, p_id);

END;
$procedure$
;

CREATE OR REPLACE FUNCTION mobiel_sync.verwijder_werkvoorraad(p_werkvoorraad_tabel regclass, p_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_sql text;
BEGIN

    v_sql := format(
        'DELETE FROM %s WHERE id = $1',
        p_werkvoorraad_tabel
    );

    EXECUTE v_sql
    USING p_id;

END;
$function$
;

CREATE TRIGGER trg_werkvoorraad_label_ins BEFORE
INSERT
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_label_ins();
CREATE TRIGGER trg_werkvoorraad_label_upd BEFORE
UPDATE
    ON
    mobiel.labels FOR EACH ROW
    WHEN ((old.* IS DISTINCT
FROM
    new.*)) EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_label_upd();
CREATE TRIGGER trg_werkvoorraad_label_del BEFORE
DELETE
    ON
    mobiel.labels FOR EACH ROW EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_label_del();

CREATE TABLE mobiel.lijn_types (
	id int4 NOT NULL,
	naam text NOT NULL,
	categorie text NOT NULL,
	bouwlaag_object text NOT NULL,
	brontabel text NOT NULL,
	CONSTRAINT lijn_types_pkey PRIMARY KEY (id)
);

CREATE TABLE mobiel.lijnen (
	id int8 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	geom public.geometry(multilinestring, 28992) NULL,
	brontabel text NOT NULL,
	bron_id int8 NULL,
	object_id int8 NULL,
	bouwlaag_id int8 NULL,
	symbol_name text NULL,
	bouwlaag int4 NULL,
	bouwlaag_object text NULL,
	bron text DEFAULT 'oiv'::text NULL,
	oiv_datum_aangemaakt timestamp NULL,
	oiv_datum_gewijzigd timestamp NULL,
	opmerking text NULL,
	sync_status int2 DEFAULT 0 NOT NULL,
	modified_at timestamp NULL,
	modified_by text NULL,
	CONSTRAINT lijnen_pkey PRIMARY KEY (id)
);
CREATE INDEX lijnen_bouwlaag_id_idx ON mobiel.lijnen USING btree (bouwlaag_id);
CREATE INDEX lijnen_bron_id_idx ON mobiel.lijnen USING btree (bron_id);
CREATE INDEX lijnen_object_id_idx ON mobiel.lijnen USING btree (object_id);
CREATE INDEX lijnen_sync_status_idx ON mobiel.lijnen USING btree (sync_status);

CREATE TRIGGER trg_werkvoorraad_lijn_ins BEFORE
INSERT
    ON
    mobiel.lijnen FOR EACH ROW EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_lijn_ins();
CREATE TRIGGER trg_werkvoorraad_lijn_upd BEFORE
UPDATE
    ON
    mobiel.lijnen FOR EACH ROW
    WHEN ((old.* IS DISTINCT
FROM
    new.*)) EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_lijn_upd();
CREATE TRIGGER trg_werkvoorraad_lijn_del BEFORE
DELETE
    ON
    mobiel.lijnen FOR EACH ROW EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_lijn_del();

CREATE TABLE mobiel.object_type (
	id int2 NOT NULL,
	naam varchar(100) NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	symbol_type text DEFAULT 'c'::algemeen.symb_type NULL,
	actief_ruimtelijk bool DEFAULT true NULL,
	symbol_svg_png varchar(5) NULL,
	CONSTRAINT object_type_naam_key UNIQUE (naam),
	CONSTRAINT object_type_pkey PRIMARY KEY (id)
);

CREATE TABLE mobiel.objecten (
	id int4 NOT NULL,
	geom public.geometry(point, 28992) NULL,
	datum_aangemaakt timestamp NULL,
	datum_gewijzigd timestamp NULL,
	basisreg_identifier varchar(254) NULL,
	formelenaam varchar(255) NULL,
	bijzonderheden text NULL,
	pers_max int4 NULL,
	pers_nietz_max int4 NULL,
	datum_geldig_tot timestamp NULL,
	datum_geldig_vanaf timestamp NULL,
	bron varchar(3) NULL,
	bron_tabel varchar(25) NULL,
	fotografie_id int4 NULL,
	bodemgesteldheid_type_id int4 NULL,
	min_bouwlaag int4 NULL,
	max_bouwlaag int4 NULL,
	typeobject text NULL,
	"share" bool NULL,
	symbol_name text NULL,
	"size" int4 NULL,
	CONSTRAINT objecten_pkey PRIMARY KEY (id)
);

CREATE TABLE mobiel.styles (
	id int4 NOT NULL,
	laagnaam varchar(100) NULL,
	soortnaam varchar(100) NULL,
	lijndikte numeric(5, 2) NULL,
	lijnkleur varchar(9) NULL,
	lijnstijl text NULL,
	vulkleur varchar(9) NULL,
	vulstijl text NULL,
	verbindingsstijl text NULL,
	eindstijl text NULL,
	CONSTRAINT styles_pkey PRIMARY KEY (id),
	CONSTRAINT styles_soortnaam_key UNIQUE (soortnaam)
);

CREATE TABLE mobiel.symbol_types (
	id int4 NOT NULL,
	naam text NOT NULL,
	symbol_name text NULL,
	size_klein numeric NULL,
	size_middel numeric NULL,
	size_groot numeric NULL,
	symbol_type text NULL,
	anchorpoint text NULL,
	categorie text NOT NULL,
	bouwlaag_object text NOT NULL,
	brontabel text NOT NULL,
	symbol_svg_png text NULL,
	CONSTRAINT symbol_types_pkey PRIMARY KEY (id)
);

CREATE TABLE mobiel.symbolen (
	id int8 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	orig_id int8 NULL,
	geom public.geometry(point, 28992) NULL,
	brontabel text NOT NULL,
	bron_id int8 NULL,
	object_id int8 NULL,
	bouwlaag_id int8 NULL,
	symbol_name text NULL,
	rotatie numeric NULL,
	"size" numeric NULL,
	bouwlaag int4 NULL,
	bouwlaag_object text NULL,
	bron text DEFAULT 'oiv'::text NULL,
	oiv_datum_aangemaakt timestamp NULL,
	oiv_datum_gewijzigd timestamp NULL,
	opmerking text NULL,
	formaat text NULL,
	"label" text NULL,
	label_positie text NULL,
	sync_status int2 DEFAULT 0 NOT NULL,
	modified_at timestamp NULL,
	modified_by text NULL,
	CONSTRAINT symbolen_pkey PRIMARY KEY (id)
);
CREATE INDEX symbolen_bouwlaag_id_idx ON mobiel.symbolen USING btree (bouwlaag_id);
CREATE INDEX symbolen_bron_id_idx ON mobiel.symbolen USING btree (bron_id);
CREATE INDEX symbolen_object_id_idx ON mobiel.symbolen USING btree (object_id);
CREATE INDEX symbolen_sync_status_idx ON mobiel.symbolen USING btree (sync_status);

CREATE TRIGGER trg_werkvoorraad_symbool_ins BEFORE
INSERT
    ON
    mobiel.symbolen FOR EACH ROW EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_symbool_ins();
CREATE TRIGGER trg_werkvoorraad_symbool_upd BEFORE
UPDATE
    ON
    mobiel.symbolen FOR EACH ROW
    WHEN ((old.* IS DISTINCT
FROM
    new.*)) EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_symbool_upd();
CREATE TRIGGER trg_werkvoorraad_symbool_del BEFORE
DELETE
    ON
    mobiel.symbolen FOR EACH ROW EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_symbool_del();

CREATE TABLE mobiel.vlak_types (
	id int4 NOT NULL,
	naam text NOT NULL,
	categorie text NOT NULL,
	bouwlaag_object text NOT NULL,
	brontabel text NOT NULL,
	CONSTRAINT vlak_types_pkey PRIMARY KEY (id)
);

CREATE TABLE mobiel.vlakken (
	id int8 GENERATED BY DEFAULT AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	geom public.geometry(multipolygon, 28992) NULL,
	brontabel text NOT NULL,
	bron_id int8 NULL,
	object_id int8 NULL,
	bouwlaag_id int8 NULL,
	symbol_name text NULL,
	bouwlaag int4 NULL,
	bouwlaag_object text NULL,
	bron text DEFAULT 'oiv'::text NULL,
	oiv_datum_aangemaakt timestamp NULL,
	oiv_datum_gewijzigd timestamp NULL,
	opmerking text NULL,
	sync_status int2 DEFAULT 0 NOT NULL,
	modified_at timestamp NULL,
	modified_by text NULL,
	CONSTRAINT vlakken_pkey PRIMARY KEY (id)
);
CREATE INDEX vlakken_bouwlaag_id_idx ON mobiel.vlakken USING btree (bouwlaag_id);
CREATE INDEX vlakken_bron_id_idx ON mobiel.vlakken USING btree (bron_id);
CREATE INDEX vlakken_object_id_idx ON mobiel.vlakken USING btree (object_id);
CREATE INDEX vlakken_sync_status_idx ON mobiel.vlakken USING btree (sync_status);

CREATE TRIGGER trg_werkvoorraad_vlak_ins BEFORE
INSERT
    ON
    mobiel.vlakken FOR EACH ROW EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_vlak_ins();
CREATE TRIGGER trg_werkvoorraad_vlak_upd BEFORE
UPDATE
    ON
    mobiel.vlakken FOR EACH ROW
    WHEN ((old.* IS DISTINCT
FROM
    new.*)) EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_vlak_upd();
CREATE TRIGGER trg_werkvoorraad_vlak_del BEFORE
DELETE
    ON
    mobiel.vlakken FOR EACH ROW EXECUTE FUNCTION mobiel_sync.func_werkvoorraad_vlak_del();

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 7;
UPDATE algemeen.applicatie SET revisie = 5;
UPDATE algemeen.applicatie SET db_versie = 3705; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();