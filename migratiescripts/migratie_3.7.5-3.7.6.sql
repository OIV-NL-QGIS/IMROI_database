SET ROLE oiv_admin;

DROP VIEW IF EXISTS objecten.bouwlaag_afw_binnendekking;

CREATE OR REPLACE VIEW objecten.bouwlaag_afw_binnendekking
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.bouwlaag_id,
    b.bouwlaag,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    v.label_positie,
    v.formaat_bouwlaag
   FROM objecten.afw_binnendekking v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.afw_binnendekking_type st ON v.soort::text = st.naam::text
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER afw_binnendekking_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_del();
CREATE TRIGGER afw_binnendekking_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_ins();
CREATE TRIGGER afw_binnendekking_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_afw_binnendekking FOR EACH ROW EXECUTE FUNCTION objecten.func_afw_binnendekking_upd();

DROP VIEW IF EXISTS objecten.bouwlaag_dreiging;
CREATE OR REPLACE VIEW objecten.bouwlaag_dreiging
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.fotografie_id,
    v.opmerking,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.dreiging v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.dreiging_type st ON v.soort::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER bouwlaag_dreiging_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_del();
CREATE TRIGGER bouwlaag_dreiging_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_ins();
CREATE TRIGGER bouwlaag_dreiging_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_upd();


DROP VIEW IF EXISTS objecten.bouwlaag_ingang;
CREATE OR REPLACE VIEW objecten.bouwlaag_ingang
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.ingang v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.ingang_type st ON v.soort::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER bouwlaag_ingang_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_del();
CREATE TRIGGER bouwlaag_ingang_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_ins();
CREATE TRIGGER bouwlaag_ingang_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_upd();


DROP VIEW IF EXISTS objecten.bouwlaag_label;
CREATE OR REPLACE VIEW objecten.bouwlaag_label
AS SELECT v.id,
    v.geom,
    v.soort,
    v.omschrijving,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    st.symbol_name,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    v.formaat_object,
    v.formaat_bouwlaag,
    v.opmerking
   FROM objecten.label v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.label_type st ON v.soort::text = st.naam::text
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER bouwlaag_label_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_del();
CREATE TRIGGER bouwlaag_label_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_ins();
CREATE TRIGGER bouwlaag_label_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_upd();


DROP VIEW IF EXISTS objecten.bouwlaag_opslag;
CREATE OR REPLACE VIEW objecten.bouwlaag_opslag
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.opmerking,
    v.bouwlaag_id,
    v.object_id,
    v.fotografie_id,
    v.rotatie,
    b.bouwlaag,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    v.self_deleted,
    v.label,
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object,
    v.soort
   FROM objecten.gevaarlijkestof_opslag v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON v.soort::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER bouwlaag_opslag_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_ins();
CREATE TRIGGER bouwlaag_opslag_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_del();
CREATE TRIGGER bouwlaag_opslag_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_upd();


DROP VIEW IF EXISTS objecten.bouwlaag_ruimten;
CREATE OR REPLACE VIEW objecten.bouwlaag_ruimten
AS SELECT v.id,
    v.geom,
    v.soort,
    v.opmerking,
    v.fotografie_id,
    v.bouwlaag_id,
    b.bouwlaag
   FROM objecten.ruimten v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER ruimten_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_ruimten FOR EACH ROW EXECUTE FUNCTION objecten.func_ruimten_del();
CREATE TRIGGER ruimten_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_ruimten FOR EACH ROW EXECUTE FUNCTION objecten.func_ruimten_ins();
CREATE TRIGGER ruimten_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_ruimten FOR EACH ROW EXECUTE FUNCTION objecten.func_ruimten_upd();


DROP VIEW IF EXISTS objecten.bouwlaag_scenario_locatie;
CREATE OR REPLACE VIEW objecten.bouwlaag_scenario_locatie
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.opmerking,
    v.bouwlaag_id,
    v.object_id,
    v.fotografie_id,
    v.rotatie,
    b.bouwlaag,
    st.symbol_name,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    v.label,
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object,
    v.soort
   FROM objecten.scenario_locatie v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.scenario_locatie_type st ON v.soort::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER bouwlaag_scenario_locatie_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_ins();
CREATE TRIGGER bouwlaag_scenario_locatie_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_del();
CREATE TRIGGER bouwlaag_scenario_locatie_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_upd();


DROP VIEW IF EXISTS objecten.bouwlaag_sleutelkluis;
CREATE OR REPLACE VIEW objecten.bouwlaag_sleutelkluis
AS SELECT v.id,
    v.geom,
    v.soort,
    v.label,
    v.opmerking,
    v.sleuteldoel,
    v.fotografie_id,
    v.bouwlaag_id,
    v.object_id,
    b.bouwlaag,
    v.rotatie,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.sleutelkluis v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.sleutelkluis_type st ON v.soort::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER bouwlaag_sleutelkluis_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_del();
CREATE TRIGGER bouwlaag_sleutelkluis_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_ins();
CREATE TRIGGER bouwlaag_sleutelkluis_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_upd();


DROP VIEW IF EXISTS objecten.bouwlaag_veiligh_bouwk;
CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_bouwk
AS SELECT v.id,
    v.geom,
    v.soort,
    v.fotografie_id,
    v.bouwlaag_id,
    v.opmerking,
    b.bouwlaag
   FROM objecten.veiligh_bouwk v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER veiligh_bouwk_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_bouwk_del();
CREATE TRIGGER veiligh_bouwk_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_bouwk_ins();
CREATE TRIGGER veiligh_bouwk_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_veiligh_bouwk FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_bouwk_upd();


DROP VIEW IF EXISTS objecten.bouwlaag_veiligh_install;
CREATE OR REPLACE VIEW objecten.bouwlaag_veiligh_install
AS SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.soort,
    v.label,
    v.opmerking,
    v.bouwlaag_id,
    v.object_id,
    v.rotatie,
    v.fotografie_id,
    b.bouwlaag,
        CASE
            WHEN v.formaat_bouwlaag = 'klein'::algemeen.formaat THEN st.size_bouwlaag_klein
            WHEN v.formaat_bouwlaag = 'middel'::algemeen.formaat THEN st.size_bouwlaag_middel
            WHEN v.formaat_bouwlaag = 'groot'::algemeen.formaat THEN st.size_bouwlaag_groot
            ELSE NULL::numeric
        END AS size,
    concat(st.symbol_name, '_', st.symbol_type) AS symbol_name,
    v.label_positie,
    v.formaat_bouwlaag,
    v.formaat_object
   FROM objecten.veiligh_install v
     JOIN objecten.bouwlagen b ON v.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type st ON v.soort::text = st.naam
  WHERE v.parent_deleted = 'infinity'::timestamp with time zone AND v.self_deleted = 'infinity'::timestamp with time zone;


CREATE TRIGGER veiligh_install_del INSTEAD OF
DELETE
    ON
    objecten.bouwlaag_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_del();
CREATE TRIGGER veiligh_install_ins INSTEAD OF
INSERT
    ON
    objecten.bouwlaag_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_ins();
CREATE TRIGGER veiligh_install_upd INSTEAD OF
UPDATE
    ON
    objecten.bouwlaag_veiligh_install FOR EACH ROW EXECUTE FUNCTION objecten.func_veiligh_install_upd();


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


CREATE TRIGGER bereikbaarheid_del INSTEAD OF
DELETE
    ON
    objecten.object_bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.func_bereikbaarheid_del();
CREATE TRIGGER bereikbaarheid_ins INSTEAD OF
INSERT
    ON
    objecten.object_bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.func_bereikbaarheid_ins();
CREATE TRIGGER bereikbaarheid_upd INSTEAD OF
UPDATE
    ON
    objecten.object_bereikbaarheid FOR EACH ROW EXECUTE FUNCTION objecten.func_bereikbaarheid_upd();


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


CREATE TRIGGER object_dreiging_del INSTEAD OF
DELETE
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_del();
CREATE TRIGGER object_dreiging_ins INSTEAD OF
INSERT
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_ins();
CREATE TRIGGER object_dreiging_upd INSTEAD OF
UPDATE
    ON
    objecten.object_dreiging FOR EACH ROW EXECUTE FUNCTION objecten.func_dreiging_upd();


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


CREATE TRIGGER gebiedsgerichte_aanpak_del INSTEAD OF
DELETE
    ON
    objecten.object_gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.func_gebiedsgerichte_aanpak_del();
CREATE TRIGGER gebiedsgerichte_aanpak_ins INSTEAD OF
INSERT
    ON
    objecten.object_gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.func_gebiedsgerichte_aanpak_ins();
CREATE TRIGGER gebiedsgerichte_aanpak_upd INSTEAD OF
UPDATE
    ON
    objecten.object_gebiedsgerichte_aanpak FOR EACH ROW EXECUTE FUNCTION objecten.func_gebiedsgerichte_aanpak_upd();


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


CREATE TRIGGER object_ingang_del INSTEAD OF
DELETE
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_del();
CREATE TRIGGER object_ingang_ins INSTEAD OF
INSERT
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_ins();
CREATE TRIGGER object_ingang_upd INSTEAD OF
UPDATE
    ON
    objecten.object_ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_ingang_upd();


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


CREATE TRIGGER isolijnen_del INSTEAD OF
DELETE
    ON
    objecten.object_isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.func_isolijnen_del();
CREATE TRIGGER isolijnen_ins INSTEAD OF
INSERT
    ON
    objecten.object_isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.func_isolijnen_ins();
CREATE TRIGGER isolijnen_upd INSTEAD OF
UPDATE
    ON
    objecten.object_isolijnen FOR EACH ROW EXECUTE FUNCTION objecten.func_isolijnen_upd();


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


CREATE TRIGGER object_label_del INSTEAD OF
DELETE
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_del();
CREATE TRIGGER object_label_ins INSTEAD OF
INSERT
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_ins();
CREATE TRIGGER object_label_upd INSTEAD OF
UPDATE
    ON
    objecten.object_label FOR EACH ROW EXECUTE FUNCTION objecten.func_label_upd();


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


CREATE TRIGGER object_opslag_ins INSTEAD OF
INSERT
    ON
    objecten.object_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_ins();
CREATE TRIGGER object_opslag_del INSTEAD OF
DELETE
    ON
    objecten.object_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_del();
CREATE TRIGGER object_opslag_upd INSTEAD OF
UPDATE
    ON
    objecten.object_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_opslag_upd();


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


CREATE TRIGGER opstelplaats_del INSTEAD OF
DELETE
    ON
    objecten.object_opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.func_opstelplaats_del();
CREATE TRIGGER opstelplaats_ins INSTEAD OF
INSERT
    ON
    objecten.object_opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.func_opstelplaats_ins();
CREATE TRIGGER opstelplaats_upd INSTEAD OF
UPDATE
    ON
    objecten.object_opstelplaats FOR EACH ROW EXECUTE FUNCTION objecten.func_opstelplaats_upd();


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


CREATE TRIGGER points_of_interest_del INSTEAD OF
DELETE
    ON
    objecten.object_points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.func_points_of_interest_del();
CREATE TRIGGER points_of_interest_ins INSTEAD OF
INSERT
    ON
    objecten.object_points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.func_points_of_interest_ins();
CREATE TRIGGER points_of_interest_upd INSTEAD OF
UPDATE
    ON
    objecten.object_points_of_interest FOR EACH ROW EXECUTE FUNCTION objecten.func_points_of_interest_upd();


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


CREATE TRIGGER object_scenario_locatie_ins INSTEAD OF
INSERT
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_ins();
CREATE TRIGGER object_scenario_locatie_del INSTEAD OF
DELETE
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_del();
CREATE TRIGGER object_scenario_locatie_upd INSTEAD OF
UPDATE
    ON
    objecten.object_scenario_locatie FOR EACH ROW EXECUTE FUNCTION objecten.func_scenario_locatie_upd();


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


CREATE TRIGGER sectoren_del INSTEAD OF
DELETE
    ON
    objecten.object_sectoren FOR EACH ROW EXECUTE FUNCTION objecten.func_sectoren_del();
CREATE TRIGGER sectoren_ins INSTEAD OF
INSERT
    ON
    objecten.object_sectoren FOR EACH ROW EXECUTE FUNCTION objecten.func_sectoren_ins();
CREATE TRIGGER sectoren_upd INSTEAD OF
UPDATE
    ON
    objecten.object_sectoren FOR EACH ROW EXECUTE FUNCTION objecten.func_sectoren_upd();


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


CREATE TRIGGER object_sleutelkluis_del INSTEAD OF
DELETE
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_del();
CREATE TRIGGER object_sleutelkluis_ins INSTEAD OF
INSERT
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_ins();
CREATE TRIGGER object_sleutelkluis_upd INSTEAD OF
UPDATE
    ON
    objecten.object_sleutelkluis FOR EACH ROW EXECUTE FUNCTION objecten.func_sleutelkluis_upd();


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


CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.afw_binnendekking WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.afw_binnendekking (geom, soort, label, rotatie, opmerking, bouwlaag_id, label_positie, formaat_bouwlaag)
    VALUES (new.geom, new.soort, new.label, new.rotatie, new.opmerking, new.bouwlaag_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition), COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat));
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_afw_binnendekking_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.afw_binnendekking SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, opmerking = new.opmerking, 
            bouwlaag_id = new.bouwlaag_id, label_positie= new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.bereikbaarheid WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.bereikbaarheid (geom, opmerking, soort, object_id, fotografie_id, label)
    VALUES (new.geom, new.opmerking, new.soort, new.object_id, new.fotografie_id, new.label);
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_bereikbaarheid_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.bereikbaarheid SET geom = new.geom, opmerking = new.opmerking, soort = new.soort, object_id = new.object_id, fotografie_id = new.fotografie_id, label = new.label
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_dreiging_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.dreiging WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.dreiging (geom, soort, label, opmerking, rotatie, bouwlaag_id, object_id, fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
    VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_dreiging_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.dreiging SET geom = new.geom, soort = new.soort, opmerking = new.opmerking, rotatie = new.rotatie, label = new.label, 
                bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie,
                formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.gebiedsgerichte_aanpak WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.gebiedsgerichte_aanpak (geom, soort, label, opmerking, object_id, fotografie_id)
    VALUES (new.geom, new.soort, new.label, new.opmerking, new.object_id, new.fotografie_id);        
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_gebiedsgerichte_aanpak_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.gebiedsgerichte_aanpak SET geom = new.geom, soort = new.soort, label = new.label, opmerking = new.opmerking, object_id = new.object_id, fotografie_id = new.fotografie_id
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_ingang_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.ingang WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_ingang_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.ingang (geom, soort, label, opmerking, rotatie, bouwlaag_id, object_id, fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
    VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));    
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_ingang_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.ingang SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, opmerking = new.opmerking, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id,
                                    fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_isolijnen_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.isolijnen WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.isolijnen (geom, hoogte, opmerking, object_id)
    VALUES (new.geom, new.hoogte, new.opmerking, new.object_id);  
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_isolijnen_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.isolijnen SET geom = new.geom, hoogte = new.hoogte, opmerking = new.opmerking, object_id = new.object_id
    WHERE isolijnen.id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_label_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.label WHERE id = old;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_label_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.label (geom, soort, omschrijving, rotatie, bouwlaag_id, object_id, opmerking, formaat_bouwlaag, formaat_object)
    VALUES (new.geom, new.soort, new.omschrijving, new.rotatie, new.bouwlaag_id, new.object_id, new.opmerking,
            COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));  
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_label_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.label SET geom = new.geom, soort = new.soort, omschrijving = new.omschrijving, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id,
            formaat_bouwlaag = new.formaat_bouwlaag, formaat_object = new.formaat_object, opmerking = new.opmerking
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_opslag_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.gevaarlijkestof_opslag WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_opslag_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.gevaarlijkestof_opslag (geom, opmerking, bouwlaag_id, object_id, fotografie_id, rotatie, label, soort, label_positie, formaat_bouwlaag, formaat_object)
    VALUES (new.geom, new.opmerking, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie, new.label, new.soort, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat)); 
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_opslag_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.gevaarlijkestof_opslag SET geom = new.geom, opmerking = new.opmerking, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, rotatie = new.rotatie, soort = new.soort, 
            fotografie_id = new.fotografie_id, label = new.label, label_positie = new.label_positie, formaat_bouwlaag= new.formaat_bouwlaag, formaat_object=new.formaat_object
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.opstelplaats WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.opstelplaats (geom, soort, label, opmerking, rotatie, object_id, fotografie_id, label_positie, formaat_object)
    VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_opstelplaats_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.opstelplaats SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, opmerking = new.opmerking, object_id = new.object_id, 
                                        fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_object=new.formaat_object
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.points_of_interest WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.points_of_interest (geom, soort, label, opmerking, rotatie, object_id, fotografie_id, label_positie, formaat_object)
    VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_points_of_interest_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.points_of_interest SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, opmerking = new.opmerking, 
            label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_object=new.formaat_object
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_ruimten_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.ruimten WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.ruimten (geom, soort, opmerking, bouwlaag_id, fotografie_id)
    VALUES (new.geom, new.soort, new.opmerking, new.bouwlaag_id, new.fotografie_id);
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_ruimten_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.ruimten SET geom = new.geom, soort = new.soort, opmerking = new.opmerking, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.scenario_locatie WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.scenario_locatie (geom, opmerking, bouwlaag_id, object_id, fotografie_id, rotatie, label, label_positie, soort, formaat_bouwlaag, formaat_object)
    VALUES (new.geom, new.opmerking, new.bouwlaag_id, new.object_id, new.fotografie_id, new.rotatie, new.label, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition), new.soort,
            COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_scenario_locatie_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.scenario_locatie SET geom = new.geom, opmerking = new.opmerking, rotatie = new.rotatie, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id,
                        label = new.label, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object, soort = new.soort
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_sectoren_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.sectoren WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.sectoren (geom, soort, opmerking, label, object_id, fotografie_id)
    VALUES (new.geom, new.soort, new.opmerking, new.label, new.object_id, new.fotografie_id);
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_sectoren_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.sectoren SET geom = new.geom, soort = new.soort, opmerking = new.opmerking, label = new.label, object_id = new.object_id, fotografie_id = new.fotografie_id
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.sleutelkluis WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.sleutelkluis (geom, soort, label, rotatie, opmerking, sleuteldoel, bouwlaag_id, object_id, 
                                        fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
    VALUES (new.geom, new.soort, new.label, new.rotatie, new.opmerking, new.sleuteldoel, new.bouwlaag_id, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));            
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.sleutelkluis SET geom = new.geom, soort = new.soort, rotatie = new.rotatie, label = new.label, opmerking = new.opmerking, sleuteldoel = new.sleuteldoel, 
            bouwlaag_id = new.bouwlaag_id, object_id = new.object_id, fotografie_id = new.fotografie_id, label_positie = new.label_positie, formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.veiligh_bouwk WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.veiligh_bouwk (geom, soort, bouwlaag_id, fotografie_id, opmerking)
    VALUES (new.geom, new.soort, new.bouwlaag_id, new.fotografie_id, new.opmerking);
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_bouwk_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.veiligh_bouwk SET geom = new.geom, soort = new.soort, bouwlaag_id = new.bouwlaag_id, fotografie_id = new.fotografie_id, opmerking = new.opmerking
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;


CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_del()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM objecten.veiligh_install WHERE id = old.id;
    RETURN OLD;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_ins()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    INSERT INTO objecten.veiligh_install (geom, soort, label, opmerking, rotatie, bouwlaag_id, object_id, fotografie_id, label_positie, formaat_bouwlaag, formaat_object)
    VALUES (new.geom, new.soort, new.label, new.opmerking, new.rotatie, new.bouwlaag_id, new.object_id, new.fotografie_id, COALESCE(new.label_positie, 'onder - midden'::algemeen.labelposition),
            COALESCE(new.formaat_bouwlaag, 'middel'::algemeen.formaat), COALESCE(new.formaat_object, 'middel'::algemeen.formaat));
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION objecten.func_veiligh_install_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    UPDATE objecten.veiligh_install SET geom = new.geom, soort = new.soort, bouwlaag_id = new.bouwlaag_id, object_id = new.object_id,
            label = new.label, opmerking = new.opmerking, rotatie = new.rotatie, fotografie_id = new.fotografie_id, label_positie = new.label_positie, 
            formaat_bouwlaag=new.formaat_bouwlaag, formaat_object=new.formaat_object
    WHERE id = old.id;
    RETURN NEW;
END;
$function$;

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