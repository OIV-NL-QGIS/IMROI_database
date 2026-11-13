SET ROLE oiv_admin;

DROP VIEW IF EXISTS objecten.object_bereikbaarheid;
CREATE OR REPLACE VIEW objecten.object_bereikbaarheid
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.opmerking,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot
   FROM objecten.bereikbaarheid l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_dreiging;
CREATE OR REPLACE VIEW objecten.object_dreiging
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.fotografie_id,
    v.opmerking,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN v.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN v.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    v.label_positie,
    v.formaat_object,
    v.formaat_bouwlaag
   FROM objecten.dreiging v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.dreiging_type st ON v.soort::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_gebiedsgerichte_aanpak;
CREATE OR REPLACE VIEW objecten.object_gebiedsgerichte_aanpak
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.opmerking,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    part.typeobject,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot
   FROM objecten.gebiedsgerichte_aanpak l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_grid;
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
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_ingang;
CREATE OR REPLACE VIEW objecten.object_ingang
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN v.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN v.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    v.label_positie,
    v.formaat_object,
    v.formaat_bouwlaag
   FROM objecten.ingang v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.ingang_type st ON v.soort::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_isolijnen;
CREATE OR REPLACE VIEW objecten.object_isolijnen
AS SELECT l.id,
    l.geom,
    l.hoogte,
    l.opmerking,
    l.object_id,
    b.formelenaam,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.isolijnen l
     LEFT JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_label;
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
        CASE
            WHEN l.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN l.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN l.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    l.formaat_object,
    l.formaat_bouwlaag,
    l.opmerking
   FROM objecten.label l
     JOIN objecten.object b ON l.object_id = b.id
     JOIN objecten.label_type st ON l.soort::text = st.naam::text
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_opslag;
CREATE OR REPLACE VIEW objecten.object_opslag
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.opmerking,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    b.formelenaam,
    o.rotatie,
        CASE
            WHEN o.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN o.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN o.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    o.label,
    o.label_positie,
    o.formaat_object,
    o.formaat_bouwlaag,
    o.soort
   FROM objecten.gevaarlijkestof_opslag o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON o.soort::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.parent_deleted = 'infinity'::timestamp with time zone AND o.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_opstelplaats;
CREATE OR REPLACE VIEW objecten.object_opstelplaats
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.fotografie_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN v.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN v.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    v.label_positie,
    v.formaat_object
   FROM objecten.opstelplaats v
     JOIN objecten.object b ON v.object_id = b.id
     JOIN objecten.opstelplaats_type st ON v.soort::text = st.naam::text
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_points_of_interest;
CREATE OR REPLACE VIEW objecten.object_points_of_interest
AS SELECT b.id,
    b.geom,
    b.soort,
    b.label,
    b.opmerking,
    b.fotografie_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject,
    b.label_positie,
    b.formaat_object
   FROM objecten.points_of_interest b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.points_of_interest_type st ON b.soort::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_scenario_locatie;
CREATE OR REPLACE VIEW objecten.object_scenario_locatie
AS SELECT o.id,
    o.geom,
    o.datum_aangemaakt,
    o.datum_gewijzigd,
    o.opmerking,
    o.bouwlaag_id,
    o.object_id,
    o.fotografie_id,
    o.rotatie,
        CASE
            WHEN o.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN o.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN o.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    st.symbol_name,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    o.label,
    o.label_positie,
    o.formaat_object,
    o.formaat_bouwlaag,
    o.soort
   FROM objecten.scenario_locatie o
     JOIN objecten.object b ON o.object_id = b.id
     JOIN objecten.scenario_locatie_type st ON o.soort::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE o.parent_deleted = 'infinity'::timestamp with time zone AND o.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_sectoren;
CREATE OR REPLACE VIEW objecten.object_sectoren
AS SELECT l.id,
    l.geom,
    l.soort,
    l.label,
    l.opmerking,
    l.fotografie_id,
    l.object_id,
    b.formelenaam,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject
   FROM objecten.sectoren l
     JOIN objecten.object b ON l.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE l.parent_deleted = 'infinity'::timestamp with time zone AND l.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_sleutelkluis;
CREATE OR REPLACE VIEW objecten.object_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.sleuteldoel,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.formelenaam,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN v.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN v.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    b.datum_geldig_vanaf,
    b.datum_geldig_tot,
    part.typeobject,
    v.label_positie,
    v.formaat_object,
    v.formaat_bouwlaag
   FROM objecten.sleutelkluis v
     JOIN objecten.sleutelkluis_type st ON v.soort::text = st.naam
     JOIN objecten.object b ON v.object_id = b.id
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON b.id = part.object_id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;

DROP VIEW IF EXISTS objecten.object_terrein;
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
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;


DROP VIEW IF EXISTS objecten.object_veiligh_install;
CREATE OR REPLACE VIEW objecten.object_veiligh_install
AS SELECT b.id,
    b.geom,
    b.soort,
    b.label,
    b.opmerking,
    b.fotografie_id,
    b.bouwlaag_id,
    b.object_id,
    o.formelenaam,
    b.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN b.formaat_object = 'klein'::algemeen.formaat THEN st.size_object_klein
            WHEN b.formaat_object = 'middel'::algemeen.formaat THEN st.size_object_middel
            WHEN b.formaat_object = 'groot'::algemeen.formaat THEN st.size_object_groot
            ELSE NULL::numeric
        END AS size,
    o.datum_geldig_vanaf,
    o.datum_geldig_tot,
    part.typeobject,
    b.label_positie,
    b.formaat_object,
    b.formaat_bouwlaag
   FROM objecten.veiligh_install b
     JOIN objecten.object o ON b.object_id = o.id
     JOIN objecten.veiligh_install_type st ON b.soort::text = st.naam
     LEFT JOIN ( SELECT h.object_id,
            h.typeobject
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
  WHERE b.parent_deleted = 'infinity'::timestamp with time zone AND b.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER veiligh_ruimtelijk_del INSTEAD OF
DELETE
    ON
    objecten.object_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_del();
CREATE TRIGGER veiligh_ruimtelijk_ins INSTEAD OF
INSERT
    ON
    objecten.object_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_ins();
CREATE TRIGGER veiligh_ruimtelijk_upd INSTEAD OF
UPDATE
    ON
    objecten.object_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_upd();


DROP VIEW IF EXISTS objecten.object_veiligh_ruimtelijk;
DROP FUNCTION IF EXISTS objecten.func_veiligh_ruimtelijk_del();
DROP FUNCTION IF EXISTS objecten.func_veiligh_ruimtelijk_ins();
DROP FUNCTION IF EXISTS objecten.func_veiligh_ruimtelijk_upd();

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 7;
UPDATE algemeen.applicatie SET revisie = 6;
UPDATE algemeen.applicatie SET db_versie = 3706; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();