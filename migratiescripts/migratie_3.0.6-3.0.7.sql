SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

ALTER TABLE veiligh_install_type ADD COLUMN symbol_name TEXT;
UPDATE veiligh_install_type SET symbol_name = 'afsluiter_cv' WHERE id = 7;
UPDATE veiligh_install_type SET symbol_name = 'afsluiter_elektra' WHERE id = 8;
UPDATE veiligh_install_type SET symbol_name = 'afsluiter_gas' WHERE id = 9;
UPDATE veiligh_install_type SET symbol_name = 'afsluiter_neon' WHERE id = 11;
UPDATE veiligh_install_type SET symbol_name = 'afsluiter_noodstop' WHERE id = 12;
UPDATE veiligh_install_type SET symbol_name = 'afsluiter_omloop' WHERE id = 13;
UPDATE veiligh_install_type SET symbol_name = 'afsluiter_rwa' WHERE id = 14;
UPDATE veiligh_install_type SET symbol_name = 'afsluiter_sprinkler' WHERE id = 15;
UPDATE veiligh_install_type SET symbol_name = 'afsluiter_water' WHERE id = 16;
UPDATE veiligh_install_type SET symbol_name = 'blussysteem_koolstofdioxide' WHERE id = 23;
UPDATE veiligh_install_type SET symbol_name = 'blussysteem_schuim' WHERE id = 25;
UPDATE veiligh_install_type SET symbol_name = 'blussysteem_water' WHERE id = 26;
UPDATE veiligh_install_type SET symbol_name = 'brandmeldpaneel' WHERE id = 30;
UPDATE veiligh_install_type SET symbol_name = 'rookwarmte_afvoer' WHERE id = 147;
UPDATE veiligh_install_type SET symbol_name = 'stijgleiding_ld_afnamepunt' WHERE id = 149;
UPDATE veiligh_install_type SET symbol_name = 'stijgleiding_ld_vulpunt' WHERE id = 150;
UPDATE veiligh_install_type SET symbol_name = 'stijgleiding_hd_afnamepunt' WHERE id = 151;
UPDATE veiligh_install_type SET symbol_name = 'stijgleiding_hd_vulpunt' WHERE id = 152;
UPDATE veiligh_install_type SET symbol_name = 'meterkast_e_g' WHERE id = 156;
UPDATE veiligh_install_type SET symbol_name = 'meterkast_e_w' WHERE id = 157;
UPDATE veiligh_install_type SET symbol_name = 'meterkast_g_w' WHERE id = 158;
UPDATE veiligh_install_type SET symbol_name = 'meterkast_e_g_w' WHERE id = 159;
UPDATE veiligh_install_type SET symbol_name = 'nevenpaneel' WHERE id = 161;
UPDATE veiligh_install_type SET symbol_name = 'brandmeldcentrale' WHERE id = 162;
UPDATE veiligh_install_type SET symbol_name = 'ontruimingspaneel' WHERE id = 163;
UPDATE veiligh_install_type SET symbol_name = 'afsluiter_luchtbehandeling' WHERE id = 164;
UPDATE veiligh_install_type SET symbol_name = 'blussysteem_hifog' WHERE id = 171;
UPDATE veiligh_install_type SET symbol_name = 'blussysteem_afff' WHERE id = 172;
UPDATE veiligh_install_type SET symbol_name = 'aed' WHERE id = 201;
UPDATE veiligh_install_type SET symbol_name = 'activering_blussysteem' WHERE id = 1001;
UPDATE veiligh_install_type SET symbol_name = 'brandblusser' WHERE id = 1002;
UPDATE veiligh_install_type SET symbol_name = 'brandslanghaspel' WHERE id = 1003;
UPDATE veiligh_install_type SET symbol_name = 'oogdouche' WHERE id = 1004;
UPDATE veiligh_install_type SET symbol_name = 'nooddouche' WHERE id = 1005;
UPDATE veiligh_install_type SET symbol_name = 'overdruk_ventilatie' WHERE id = 1006;
UPDATE veiligh_install_type SET symbol_name = 'blussysteem_stikstof' WHERE id = 1013;
UPDATE veiligh_install_type SET symbol_name = 'antidote_tegengif' WHERE id = 1021;
UPDATE veiligh_install_type SET symbol_name = 'calamiteiten_coördinatiecentrum' WHERE id = 1022;
UPDATE veiligh_install_type SET symbol_name = 'installatie_defect' WHERE id = 9999;

ALTER TABLE veiligh_ruimtelijk_type ADD COLUMN symbol_name TEXT;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'activering_blussysteem' WHERE id = 1001;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'aed' WHERE id = 201;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'afsluiter_cv' WHERE id = 7;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'afsluiter_elektra' WHERE id = 8;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'afsluiter_gas' WHERE id = 9;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'afsluiter_luchtbehandeling' WHERE id = 164;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'afsluiter_neon' WHERE id = 11;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'afsluiter_noodstop' WHERE id = 12;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'afsluiter_omloop' WHERE id = 13;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'afsluiter_rwa' WHERE id = 14;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'afsluiter_sprinkler' WHERE id = 15;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'afsluiter_water' WHERE id = 16;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'antidote_tegengif' WHERE id = 1021;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'blussysteem_afff' WHERE id = 172;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'blussysteem_hifog' WHERE id = 171;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'blussysteem_koolstofdioxide' WHERE id = 23;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'blussysteem_schuim' WHERE id = 25;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'blussysteem_stikstof' WHERE id = 1013;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'blussysteem_water' WHERE id = 26;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'evenementen_eten' WHERE id = 205;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'evenementen_eten_gas' WHERE id = 204;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'brandbestrijdings_materiaal' WHERE id = 1018;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'brandbluspomp' WHERE id = 1014;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'brandblusser' WHERE id = 1002;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'brandslanghaspel' WHERE id = 1003;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'calamiteiten_coördinatiecentrum' WHERE id = 1022;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'ehbo' WHERE id = 202;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'generator' WHERE id = 203;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'heli_vmc' WHERE id = 1009;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'installatie_defect' WHERE id = 9999;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'kade_aansluiting' WHERE id = 1017;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'nooddouche' WHERE id = 1005;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'oilboom_afzet' WHERE id = 1007;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'oilboom_opstel' WHERE id = 1006;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'oogdouche' WHERE id = 1004;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'opstapplaats_rpa' WHERE id = 1010;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'parkeerplaats' WHERE id = 206;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'reduceer_drukbegerenzer' WHERE id = 1020;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'schacht_kanaal' WHERE id = 1019;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'schermenponton' WHERE id = 1008;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'stijgleiding_hd_afnamepunt' WHERE id = 151;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'stijgleiding_hd_vulpunt' WHERE id = 152;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'stijgleiding_ld_afnamepunt' WHERE id = 149;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'stijgleiding_ld_vulpunt' WHERE id = 150;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'verzamelplaats' WHERE id = 160;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'voedingspunt_schuim' WHERE id = 1016;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'waterkanon' WHERE id = 154;
UPDATE veiligh_ruimtelijk_type SET symbol_name = 'waterkanon_schuim' WHERE id = 1015;

CREATE OR REPLACE VIEW view_veiligh_install AS 
 SELECT v.id,
    v.geom,
    v.datum_aangemaakt,
    v.datum_gewijzigd,
    v.veiligh_install_type_id,
    v.label,
    v.bouwlaag_id,
    v.rotatie,
    v.fotografie_id,
    t.naam AS soort,
    o.formelenaam,
    o.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(v.geom)) AS x,
    round(st_y(v.geom)) AS y,
    t.symbol_name
   FROM veiligh_install v
     JOIN veiligh_install_type t ON v.veiligh_install_type_id = t.id
     JOIN bouwlagen b ON v.bouwlaag_id = b.id
     JOIN ( SELECT object.formelenaam,
            object.id AS object_id,
            object.geovlak
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON st_intersects(v.geom, o.geovlak);

CREATE OR REPLACE VIEW view_veiligh_ruimtelijk AS 
 SELECT b.id,
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
    vt.symbol_name
   FROM veiligh_ruimtelijk b
     JOIN ( SELECT object.formelenaam,
            object.id
           FROM object
             LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                   FROM historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON b.object_id = o.id
     JOIN veiligh_ruimtelijk_type vt ON b.veiligh_ruimtelijk_type_id = vt.id;

ALTER TABLE ingang_type ADD COLUMN symbol_name TEXT;
UPDATE ingang_type SET symbol_name = REPLACE(LOWER(naam), ' ', '_');

CREATE OR REPLACE VIEW view_ingang_bouwlaag AS 
 SELECT i.id,
    i.geom,
    i.datum_aangemaakt,
    i.datum_gewijzigd,
    i.ingang_type_id,
    i.rotatie,
    i.label,
    i.bouwlaag_id,
    i.fotografie_id,
    t.naam AS soort,
    o.formelenaam,
    o.object_id,
    b.bouwlaag,
    b.bouwdeel,
    round(st_x(i.geom)) AS x,
    round(st_y(i.geom)) AS y,
    t.symbol_name    
   FROM objecten.ingang i
     JOIN objecten.ingang_type t ON i.ingang_type_id = t.id
     JOIN objecten.bouwlagen b ON i.bouwlaag_id = b.id
     JOIN ( SELECT object.formelenaam,
            object.id AS object_id,
            object.geovlak
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON st_intersects(i.geom, o.geovlak);

CREATE OR REPLACE VIEW view_ingang_ruimtelijk AS 
 SELECT b.id,
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
    vt.symbol_name 
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

ALTER TABLE dreiging_type ADD COLUMN symbol_name TEXT;

UPDATE dreiging_type SET symbol_name = 'aanrijding' WHERE id = 1;
UPDATE dreiging_type SET symbol_name = 'agressie' WHERE id = 2;
UPDATE dreiging_type SET symbol_name = 'beknelling' WHERE id = 3;
UPDATE dreiging_type SET symbol_name = 'beschadiging' WHERE id = 4;
UPDATE dreiging_type SET symbol_name = 'besmetting' WHERE id = 5;
UPDATE dreiging_type SET symbol_name = 'bijtgevaar' WHERE id = 6;
UPDATE dreiging_type SET symbol_name = 'brand' WHERE id = 7;
UPDATE dreiging_type SET symbol_name = 'desorientatie' WHERE id = 8;
UPDATE dreiging_type SET symbol_name = 'drukgolf' WHERE id = 9;
UPDATE dreiging_type SET symbol_name = 'elektrisering' WHERE id = 10;
UPDATE dreiging_type SET symbol_name = 'elektrocutie' WHERE id = 11;
UPDATE dreiging_type SET symbol_name = 'explosie' WHERE id = 12;
UPDATE dreiging_type SET symbol_name = 'implosie' WHERE id = 13;
UPDATE dreiging_type SET symbol_name = 'insluiting' WHERE id = 14;
UPDATE dreiging_type SET symbol_name = 'instorting' WHERE id = 15;
UPDATE dreiging_type SET symbol_name = 'kortsluiting' WHERE id = 16;
UPDATE dreiging_type SET symbol_name = 'onderkoeling' WHERE id = 17;
UPDATE dreiging_type SET symbol_name = 'straling' WHERE id = 18;
UPDATE dreiging_type SET symbol_name = 'uitglijden' WHERE id = 19;
UPDATE dreiging_type SET symbol_name = 'uitval' WHERE id = 20;
UPDATE dreiging_type SET symbol_name = 'verdrinking' WHERE id = 21;
UPDATE dreiging_type SET symbol_name = 'vergiftiging' WHERE id = 22;
UPDATE dreiging_type SET symbol_name = 'verlies' WHERE id = 23;
UPDATE dreiging_type SET symbol_name = 'verstikking' WHERE id = 24;
UPDATE dreiging_type SET symbol_name = 'vervuiling' WHERE id = 25;
UPDATE dreiging_type SET symbol_name = 'verwonding' WHERE id = 26;
UPDATE dreiging_type SET symbol_name = 'biologische_agentia' WHERE id = 101;
UPDATE dreiging_type SET symbol_name = 'bijtende_stoffen' WHERE id = 102;
UPDATE dreiging_type SET symbol_name = 'oxiderende_stoffen' WHERE id = 103;
UPDATE dreiging_type SET symbol_name = 'niet_blussen_met_water' WHERE id = 104;
UPDATE dreiging_type SET symbol_name = 'ontvlambare_stoffen' WHERE id = 105;
UPDATE dreiging_type SET symbol_name = 'giftige_stoffen' WHERE id = 106;
UPDATE dreiging_type SET symbol_name = 'explosieve_stoffen' WHERE id = 107;
UPDATE dreiging_type SET symbol_name = 'elektrische_spanning' WHERE id = 108;
UPDATE dreiging_type SET symbol_name = 'magnetisch_veld' WHERE id = 109;
UPDATE dreiging_type SET symbol_name = 'niet_ioniserende_straling' WHERE id = 110;
UPDATE dreiging_type SET symbol_name = 'radioactief_materiaal' WHERE id = 111;
UPDATE dreiging_type SET symbol_name = 'lage_temperatuur_of_bevriezing' WHERE id = 112;
UPDATE dreiging_type SET symbol_name = 'asbest' WHERE id = 113;
UPDATE dreiging_type SET symbol_name = 'laserstralen' WHERE id = 114;
UPDATE dreiging_type SET symbol_name = 'val_gevaar' WHERE id = 115;
UPDATE dreiging_type SET symbol_name = 'bijt_gevaar' WHERE id = 116;
UPDATE dreiging_type SET symbol_name = 'klein_chemisch' WHERE id = 117;
UPDATE dreiging_type SET symbol_name = 'explosieve_atmosfeer' WHERE id = 118;
UPDATE dreiging_type SET symbol_name = 'lithiumhoudende_batterijen' WHERE id = 119;
UPDATE dreiging_type SET symbol_name = 'exotische_dieren' WHERE id = 120;
UPDATE dreiging_type SET symbol_name = 'schadelijk_voor_milieu' WHERE id = 121;
UPDATE dreiging_type SET symbol_name = 'glad_oppervlak' WHERE id = 122;
UPDATE dreiging_type SET symbol_name = 'hangende_lasten' WHERE id = 123;
UPDATE dreiging_type SET symbol_name = 'heet_oppervlak' WHERE id = 124;
UPDATE dreiging_type SET symbol_name = 'houder_onder_druk' WHERE id = 125;
UPDATE dreiging_type SET symbol_name = 'op_afstand_bestuurde_machines' WHERE id = 126;
UPDATE dreiging_type SET symbol_name = 'helling' WHERE id = 127;
UPDATE dreiging_type SET symbol_name = 'langetermijn_gezondheidsschade' WHERE id = 128;
UPDATE dreiging_type SET symbol_name = 'algemeen_gevaar_1' WHERE id = 129;
UPDATE dreiging_type SET symbol_name = 'algemeen_gevaar_2' WHERE id = 129;
UPDATE dreiging_type SET symbol_name = 'stroming' WHERE id = 130;
UPDATE dreiging_type SET symbol_name = 'ontvlambare_stoffen_ghs' WHERE id = 201;
UPDATE dreiging_type SET symbol_name = 'oxiderende_stoffen_ghs' WHERE id = 202;
UPDATE dreiging_type SET symbol_name = 'ontplofbare_stoffen_ghs' WHERE id = 203;
UPDATE dreiging_type SET symbol_name = 'corrosieve_stoffen_ghs' WHERE id = 204;
UPDATE dreiging_type SET symbol_name = 'giftige_stoffen_ghs' WHERE id = 205;
UPDATE dreiging_type SET symbol_name = 'accuut_gevaar_ghs' WHERE id = 206;
UPDATE dreiging_type SET symbol_name = 'gassen_onder_druk_ghs' WHERE id = 207;
UPDATE dreiging_type SET symbol_name = 'gevaar_aquatisch_milieu_ghs' WHERE id = 208;
UPDATE dreiging_type SET symbol_name = 'gevaar_gezondheid_ghs' WHERE id = 209;

CREATE OR REPLACE VIEW view_dreiging_bouwlaag AS 
 SELECT d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.dreiging_type_id,
    d.rotatie,
    d.label,
    d.bouwlaag_id,
    d.fotografie_id,
    t.naam AS soort,
    o.formelenaam,
    o.object_id,
    b.bouwlaag,
    b.bouwdeel,    
    round(st_x(d.geom)) AS x,
    round(st_y(d.geom)) AS y,
    t.symbol_name
   FROM objecten.dreiging d
     JOIN objecten.dreiging_type t ON d.dreiging_type_id = t.id
     JOIN objecten.bouwlagen b ON d.bouwlaag_id = b.id
     JOIN ( SELECT object.formelenaam,
            object.id AS object_id,
            object.geovlak
           FROM objecten.object
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object.datum_geldig_vanaf <= now() OR object.datum_geldig_vanaf IS NULL) AND (object.datum_geldig_tot > now() OR object.datum_geldig_tot IS NULL)) o ON st_intersects(d.geom, o.geovlak);

CREATE OR REPLACE VIEW view_dreiging_ruimtelijk AS 
 SELECT b.id,
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
    vt.symbol_name
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


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 0;
UPDATE algemeen.applicatie SET revisie = 7;
UPDATE algemeen.applicatie SET db_versie = 307; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();