--Voer dit uit als "superuser", vermoedelijk mag oiv_admin geen rol aanmaken
CREATE ROLE oiv_beheer;
GRANT oiv_read, oiv_write TO oiv_beheer;

SET ROLE oiv_admin;

INSERT INTO objecten.object_type (id, naam, symbol_name, "size", symbol_type, actief_ruimtelijk, symbol_svg_png) VALUES (7, 'Infrastructuur', 'ter005', 8, 'a'::algemeen.symb_type, true, 'svg');

INSERT INTO objecten.dreiging_type
(id, naam, symbol_name, size_bouwlaag_klein, size_bouwlaag_middel, size_bouwlaag_groot, size_object_klein, size_object_middel, size_object_groot, symbol_type, tabbladen, volgnummer, actief_bouwlaag, actief_ruimtelijk, snap, anchorpoint, symbol_svg_png)
VALUES(70, 'Zonnepanelen', 'drg061', 2.0, 6.0, 6.0, 6.0, 8.0, 10.0, 'a'::algemeen.symb_type, '{"Water": 0, "Gebouw": 0, "Natuur": 0, "Algemeen": 1, "Bouwlaag": 1, "Evenement": 0, "Infrastructuur": 0}'::json, 70, true, true, NULL, 'center'::algemeen.anchorpoint, 'svg')
ON CONFLICT (naam) DO NOTHING;

UPDATE objecten.contactpersoon SET self_deleted = 'infinity' WHERE self_deleted IS NULL;
UPDATE objecten.bedrijfshulpverlening SET self_deleted = 'infinity' WHERE self_deleted IS NULL;

CREATE OR REPLACE FUNCTION objecten.set_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE nextValFn text; newId INTEGER;
BEGIN
    IF (TG_OP = 'DELETE') THEN
        RAISE NOTICE 'Delete not supported';
    ELSIF (TG_OP = 'UPDATE') THEN
        IF NEW.datum_gewijzigd IS NULL THEN NEW.datum_gewijzigd = now(); END IF;
    ELSIF (TG_OP = 'INSERT') THEN
        IF NEW.datum_aangemaakt IS NULL THEN NEW.datum_aangemaakt = now(); END IF;
        IF NEW.self_deleted IS NULL THEN NEW.self_deleted = 'infinity'; END IF;
        BEGIN
            NEW.parent_deleted := COALESCE(NEW.parent_deleted, 'infinity');
        EXCEPTION
            WHEN undefined_column THEN
                NULL;
        END;
        IF NEW.id IS NULL THEN 
        nextValFn := (SELECT column_default
            FROM  information_schema.columns
            WHERE (table_schema, table_name, column_name) = (quote_ident(TG_TABLE_SCHEMA), quote_ident(TG_TABLE_NAME), 'id'));
        EXECUTE 'SELECT ' || nextValFn INTO newId;
        NEW.id = newId; 
        END IF;
    END IF;
    RETURN NEW;   
END
$function$
;

CREATE OR REPLACE FUNCTION objecten.func_opslag_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        symbol_name TEXT;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
        mobielAan boolean;
    BEGIN
        mobielAan := (SELECT mobiel FROM algemeen.applicatie WHERE id = 1);
        IF (new.applicatie = 'OIV') OR (mobielAan = False) THEN
            UPDATE objecten.gevaarlijkestof_opslag SET geom = new.geom, opmerking = new.opmerking, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, rotatie = new.rotatie, soort = new.soort, 
					fotografie_id = new.fotografie_id, label = new.label, label_positie = new.label_positie, formaat_bouwlaag= new.formaat_bouwlaag, formaat_object=new.formaat_object
            WHERE (gevaarlijkestof_opslag.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.gevaarlijkestof_opslag_type st WHERE st.naam = new.soort);

            IF bouwlaag_object = 'bouwlaag'::text THEN
                bouwlaag := new.bouwlaag;
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, operatie, brontabel, bron_id, bouwlaag_id, object_id, rotatie, symbol_name, bouwlaag, 
													fotografie_id, accepted, label, opmerking, label_positie, formaat_bouwlaag, formaat_object)
            VALUES (new.geom, 'UPDATE', 'gevaarlijkestof_opslag', old.id, new.bouwlaag_id, NEW.object_id, NEW.rotatie, symbol_name, bouwlaag, 
						new.fotografie_id, false, new.label, new.opmerking, new.label_positie, new.formaat_bouwlaag, new.formaat_object);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'gevaarlijkestof_opslag', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

DROP VIEW IF EXISTS bluswater.view_alternatieve;
CREATE OR REPLACE VIEW bluswater.view_alternatieve
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.liters_per,
    d.label,
    d.opmerking,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    concat_ws('_', dt.symbol_name, dt.symbol_type) AS symbol_name,
    CASE
        WHEN d.formaat_object = 'klein'::algemeen.formaat THEN dt.size_object_klein
        WHEN d.formaat_object = 'middel'::algemeen.formaat THEN dt.size_object_middel
        WHEN d.formaat_object = 'groot'::algemeen.formaat THEN dt.size_object_groot
        ELSE NULL::numeric
    END AS size,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    dt.symbol_svg_png
   FROM bluswater.alternatieve d
    JOIN bluswater.alternatieve_type dt ON d.soort::text = dt.naam
  WHERE d.self_deleted = 'infinity'::timestamp with time ZONE;

DROP MATERIALIZED VIEW IF EXISTS bluswater.mview_alternatieve;
CREATE MATERIALIZED VIEW bluswater.mview_alternatieve
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.soort,
    d.liters_per,
    d.label,
    d.opmerking,
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    concat_ws('_', dt.symbol_name, dt.symbol_type) AS symbol_name,
    CASE
        WHEN d.formaat_object = 'klein'::algemeen.formaat THEN dt.size_object_klein
        WHEN d.formaat_object = 'middel'::algemeen.formaat THEN dt.size_object_middel
        WHEN d.formaat_object = 'groot'::algemeen.formaat THEN dt.size_object_groot
        ELSE NULL::numeric
    END AS size,
    COALESCE(d.label_positie, 'onder - midden'::algemeen.labelposition) AS label_positie,
    CASE
        WHEN label_positie::varchar LIKE '%rechts%' THEN  0.6
        WHEN label_positie::varchar LIKE '%links%'  THEN -0.6
        ELSE 0
    END AS dx_factor,
    CASE
        WHEN label_positie::varchar LIKE 'boven%' THEN 0.6
        WHEN label_positie::varchar LIKE 'onder%' THEN -0.6
        ELSE 0
    END AS dy_factor,
    CASE
        WHEN label_positie::character varying::text ~~ '%rechts%'::text THEN 0::numeric
        WHEN label_positie::character varying::text ~~ '%links%'::text THEN 1::numeric
        ELSE 0.5
    END AS anch_x,
    dt.symbol_svg_png
   FROM bluswater.alternatieve d
    JOIN bluswater.alternatieve_type dt ON d.soort::text = dt.naam
  WHERE d.self_deleted = 'infinity'::timestamp with time ZONE
WITH DATA;

CREATE INDEX mview_alternatieve_geom_idx ON bluswater.mview_alternatieve USING gist (geom);
CREATE UNIQUE INDEX mview_alternatieve_gid_idx ON bluswater.mview_alternatieve USING btree (gid);

REVOKE ALL ON bluswater.alternatieve_type FROM oiv_write;
REVOKE ALL ON info_of_interest.labels_of_interest_type FROM oiv_write;
REVOKE ALL ON info_of_interest.lines_of_interest_type FROM oiv_write;
REVOKE ALL ON info_of_interest.points_of_interest_type FROM oiv_write;
REVOKE ALL ON objecten.aanwezig_type FROM oiv_write;
REVOKE ALL ON objecten.afw_binnendekking_type FROM oiv_write;
REVOKE ALL ON objecten.bereikbaarheid_type FROM oiv_write;
REVOKE ALL ON objecten.bodemgesteldheid_type FROM oiv_write;
REVOKE ALL ON objecten.contactpersoon_type FROM oiv_write;
REVOKE ALL ON objecten.dreiging_type FROM oiv_write;
REVOKE ALL ON objecten.gebiedsgerichte_aanpak_type FROM oiv_write;
REVOKE ALL ON objecten.gebruiksfunctie_type FROM oiv_write;
REVOKE ALL ON objecten.gevaarlijkestof_opslag_type FROM oiv_write;
REVOKE ALL ON objecten.gevaarlijkestof_schade_cirkel_type FROM oiv_write;
REVOKE ALL ON objecten.historie_aanpassing_type FROM oiv_write;
REVOKE ALL ON objecten.historie_status_type FROM oiv_write;
REVOKE ALL ON objecten.ingang_type FROM oiv_write;
REVOKE ALL ON objecten.isolijnen_type FROM oiv_write;
REVOKE ALL ON objecten.label_type FROM oiv_write;
REVOKE ALL ON objecten.maatregel_type FROM oiv_write;
REVOKE ALL ON objecten.object_type FROM oiv_write;
REVOKE ALL ON objecten.opstelplaats_type FROM oiv_write;
REVOKE ALL ON objecten.pictogram_zonder_object_type FROM oiv_write;
REVOKE ALL ON objecten.points_of_interest_type FROM oiv_write;
REVOKE ALL ON objecten.ruimten_type FROM oiv_write;
REVOKE ALL ON objecten.scenario_locatie_type FROM oiv_write;
REVOKE ALL ON objecten.scenario_type FROM oiv_write;
REVOKE ALL ON objecten.sectoren_type FROM oiv_write;
REVOKE ALL ON objecten.sleuteldoel_type FROM oiv_write;
REVOKE ALL ON objecten.sleutelkluis_type FROM oiv_write;
REVOKE ALL ON objecten.veiligh_bouwk_type FROM oiv_write;
REVOKE ALL ON objecten.veiligh_install_type FROM oiv_write;
REVOKE ALL ON objecten.veiligh_ruimtelijk_type FROM oiv_write;
REVOKE ALL ON objecten.veilighv_org_type FROM oiv_write;
REVOKE ALL ON algemeen.teamlid FROM oiv_write;
REVOKE ALL ON algemeen.styles FROM oiv_write;

GRANT INSERT, UPDATE, DELETE ON bluswater.alternatieve_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON info_of_interest.labels_of_interest_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON info_of_interest.lines_of_interest_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON info_of_interest.points_of_interest_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.aanwezig_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.afw_binnendekking_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.bereikbaarheid_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.bodemgesteldheid_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.contactpersoon_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.dreiging_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.gebiedsgerichte_aanpak_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.gebruiksfunctie_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.gevaarlijkestof_opslag_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.gevaarlijkestof_schade_cirkel_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.historie_aanpassing_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.historie_status_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.ingang_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.isolijnen_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.label_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.maatregel_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.object_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.opstelplaats_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.pictogram_zonder_object_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.points_of_interest_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.ruimten_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.scenario_locatie_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.scenario_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.sectoren_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.sleuteldoel_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.sleutelkluis_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.veiligh_bouwk_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.veiligh_install_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.veiligh_ruimtelijk_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON objecten.veilighv_org_type TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON algemeen.teamlid TO oiv_beheer;
GRANT INSERT, UPDATE, DELETE ON algemeen.styles TO oiv_beheer;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 7;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 3721; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();

