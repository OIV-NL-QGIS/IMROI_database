SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.afw_binnendekking d ON st_intersects(t.geom, d.geom)
     JOIN objecten.afw_binnendekking_type dt ON d.soort::text = dt.naam::text
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

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
    o.min_bouwlaag,
    o.max_bouwlaag,
    sub.hoogste_bouwlaag,
    sub.laagste_bouwlaag
   FROM objecten.object o
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.bouwlagen d ON st_intersects(t.geom, d.geom)
     JOIN ( SELECT bouwlagen.pand_id, max(bouwlagen.bouwlaag) AS hoogste_bouwlaag, min(bouwlagen.bouwlaag) AS laagste_bouwlaag
           FROM objecten.bouwlagen
          GROUP BY bouwlagen.pand_id) sub ON d.pand_id::text = sub.pand_id::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.dreiging d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.dreiging_type dt ON d.dreiging_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND b.datum_deleted IS NULL AND o.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND o.datum_deleted IS NULL AND d.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.ingang d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.ingang_type dt ON d.ingang_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.label d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.label_type vt ON d.soort::text = vt.naam::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime, typeobject FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id, typeobject) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.ruimten d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND d.datum_deleted IS NULL AND t.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_scenario_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.scenario_locatie_id,
    d.omschrijving,
    d.scenario_type_id,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    slt.symbol_name,
    slt.size_object AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url
   FROM objecten.object o
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.scenario_locatie op ON st_intersects(t.geom, op.geom)
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id
     JOIN objecten.scenario_locatie_type slt ON 'Scenario locatie'::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.scenario_type_id = st.id
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_scenario_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.scenario_locatie_id,
    d.omschrijving,
    d.scenario_type_id,
    COALESCE(d.file_name, st.file_name) AS file_name,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    slt.symbol_name,
    slt.size_object AS size,
    concat(s.setting_value, COALESCE(d.file_name, st.file_name)) AS scenario_url
   FROM objecten.object o
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.scenario_locatie op ON o.id = op.object_id
     JOIN objecten.scenario d ON op.id = d.scenario_locatie_id
     JOIN objecten.scenario_locatie_type slt ON 'Scenario locatie'::text = slt.naam
     LEFT JOIN objecten.scenario_type st ON d.scenario_type_id = st.id
     JOIN algemeen.settings s ON 'scenario_base_url'::text = s.setting_key::text
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND o.datum_deleted IS NULL AND d.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND gsc.datum_deleted IS NULL AND t.datum_deleted IS NULL AND op.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_schade_cirkel gsc ON d.id = gsc.gevaarlijkestof_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND gsc.datum_deleted IS NULL AND o.datum_deleted IS NULL AND op.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.sleutelkluis d ON st_intersects(t.geom, d.geom)
     JOIN objecten.ingang i ON d.ingang_id = i.id
     JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
     JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     LEFT JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL AND i.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.ingang i ON o.id = i.object_id
     JOIN objecten.sleutelkluis d ON i.id = d.ingang_id
     JOIN objecten.sleutelkluis_type dt ON d.sleutelkluis_type_id = dt.id
     LEFT JOIN objecten.sleuteldoel_type dd ON d.sleuteldoel_type_id = dd.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND d.datum_deleted IS NULL AND i.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.veiligh_bouwk d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.veiligh_install d ON st_intersects(t.geom, d.geom)
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN objecten.veiligh_install_type dt ON d.veiligh_install_type_id = dt.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

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
     JOIN (SELECT DISTINCT historie.object_id, max(historie.datum_aangemaakt) AS maxdatetime FROM objecten.historie 
     		WHERE historie.status::text = 'in gebruik'::text AND historie.datum_deleted IS NULL
  			GROUP BY historie.object_id) part ON o.id = part.object_id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND o.datum_deleted IS NULL AND b.datum_deleted IS NULL;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 342; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();