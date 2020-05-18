SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

-- Aanpassing t.b.v. eventuele typo in schade_cirkel
DROP VIEW IF EXISTS schade_cirkel_calc;
CREATE OR REPLACE VIEW schade_cirkel_calc AS
	SELECT sc.*, ST_BUFFER(ops.geom, straal) AS geom_cirkel FROM schade_cirkel sc
	LEFT JOIN opslag ops ON sc.opslag_id = ops.id;

REVOKE ALL ON schade_cirkel_calc FROM oiv_write;

-- Aanpassingen aan views t.b.v. koppelen teams op basis van geo ipv invullen als invulveld
DROP VIEW IF EXISTS stavaza_objecten;
DROP VIEW IF EXISTS algemeen.team_geo;
DROP VIEW IF EXISTS stavaza_update_gemeente;
DROP VIEW IF EXISTS view_objectgegevens CASCADE;
DROP VIEW IF EXISTS stavaza_status_gemeente;
DROP VIEW IF EXISTS status_objectgegevens;
DROP VIEW IF EXISTS volgende_update;
DROP VIEW IF EXISTS print_objectgegevens;
DROP VIEW IF EXISTS objecten.bag_gebruikstype;
DROP VIEW IF EXISTS print_bouwlagen;
DROP VIEW IF EXISTS print_bouwlaag_aanwezig;
DROP VIEW IF EXISTS print_bouwlaag_gev_stoffen;

ALTER TABLE object DROP COLUMN tmo_dekking CASCADE;
ALTER TABLE object DROP COLUMN dmo_dekking CASCADE;
ALTER TABLE object ALTER COLUMN pand_id TYPE numeric(16,0);

-- View: objecten.print_objectgegevens aangepast (zonder adres) werkt traag bij het laden van print omgeving
-- View: objecten.bag_gebruikstype

CREATE OR REPLACE VIEW objecten.print_bouwlagen AS 
 SELECT b.id,
    o.formelenaam,
    o.pand_id,
    b.bouwlaag,
    b.bouwdeel
   FROM objecten.bouwlagen b
     LEFT JOIN objecten.object o ON b.object_id = o.id;

CREATE OR REPLACE VIEW objecten.print_bouwlaag_aanwezig AS 
 SELECT a.id,
    o.formelenaam,
    o.pand_id,
    b.bouwlaag,
    b.bouwdeel,
    ag.naam AS aanwezig_groep,
    a.dagen,
    a.tijdvakbegin,
    a.tijdvakeind,
    a.aantal,
    a.aantalniet
   FROM objecten.aanwezig a
     LEFT JOIN objecten.aanwezig_groep ag ON a.aanwezig_groep_id = ag.id
     LEFT JOIN objecten.bouwlagen b ON a.bouwlaag_id = b.id
     LEFT JOIN objecten.object o ON b.object_id = o.id;

CREATE OR REPLACE VIEW objecten.print_bouwlaag_gev_stoffen AS 
 SELECT g.id,
    o.formelenaam,
    o.pand_id,
    b.bouwlaag,
    b.bouwdeel,
    op.locatie,
    g.omschrijving AS stof_omschrijving,
    gv.vn_nr,
    gv.gevi_nr,
    gv.eric_kaart,
    g.hoeveelheid,
    ge.naam AS eenheid,
    gt.naam AS toestand
   FROM objecten.gevaarlijkestof g
     LEFT JOIN objecten.gevaarlijkestof_vnnr gv ON g.gevaarlijkestof_vnnr_id = gv.id
     LEFT JOIN objecten.gevaarlijkestof_eenheid ge ON g.gevaarlijkestof_eenheid_id = ge.id
     LEFT JOIN objecten.gevaarlijkestof_toestand gt ON g.gevaarlijkestof_toestand_id = gt.id
     LEFT JOIN objecten.opslag op ON g.opslag_id = op.id
     LEFT JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     LEFT JOIN objecten.object o ON b.object_id = o.id;     

CREATE OR REPLACE VIEW objecten.bag_gebruikstype AS 
 SELECT tbl.identificatie,
    string_agg(tbl.gebruiksdoelverblijfsobject::text, ', '::text) AS gebruikstype
   FROM ( SELECT DISTINCT p.identificatie,
            vo.gebruiksdoelverblijfsobject
           FROM bagactueel.pandactueelbestaand p
             JOIN ( SELECT vop.gid,
                    vop.identificatie,
                    vop.aanduidingrecordinactief,
                    vop.aanduidingrecordcorrectie,
                    vop.begindatumtijdvakgeldigheid,
                    vop.einddatumtijdvakgeldigheid,
                    vop.gerelateerdpand,
                    vop.verblijfsobjectstatus,
                    vop.geom_valid,
                    vog.gid,
                    vog.identificatie,
                    vog.aanduidingrecordinactief,
                    vog.aanduidingrecordcorrectie,
                    vog.begindatumtijdvakgeldigheid,
                    vog.einddatumtijdvakgeldigheid,
                    vog.gebruiksdoelverblijfsobject,
                    vog.verblijfsobjectstatus,
                    vog.geom_valid
                   FROM bagactueel.verblijfsobjectpandactueelbestaand vop
                     JOIN bagactueel.verblijfsobjectgebruiksdoelactueelbestaand vog ON vop.identificatie = vog.identificatie) vo(gid, identificatie, aanduidingrecordinactief, aanduidingrecordcorrectie, begindatumtijdvakgeldigheid, einddatumtijdvakgeldigheid, gerelateerdpand, verblijfsobjectstatus, geom_valid, gid_1, identificatie_1, aanduidingrecordinactief_1, aanduidingrecordcorrectie_1, begindatumtijdvakgeldigheid_1, einddatumtijdvakgeldigheid_1, gebruiksdoelverblijfsobject, verblijfsobjectstatus_1, geom_valid_1) ON p.identificatie = vo.gerelateerdpand
             JOIN objecten.object o ON p.identificatie = o.pand_id::numeric) tbl
  GROUP BY tbl.identificatie;

CREATE OR REPLACE VIEW print_objectgegevens AS 
 SELECT obj.id, obj.geom, obj.datum_aangemaakt, obj.datum_gewijzigd, obj.pand_id, obj.object_bouwconstructie_id, obj.laagstebouw,
    obj.hoogstebouw, obj.formelenaam, obj.bhvaanwezig, obj.bijzonderheden, obj.pers_max, obj.pers_nietz_max,
    bg.gebruikstype, ob.naam AS gebouwconstructie
   FROM object obj
     LEFT JOIN bag_gebruikstype bg ON obj.pand_id::numeric = bg.identificatie
     LEFT JOIN object_bouwconstructie ob ON obj.object_bouwconstructie_id = ob.id;
 
CREATE OR REPLACE VIEW status_objectgegevens AS 
 SELECT object.id,
    object.formelenaam,
    object.geom,
    object.pand_id,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    historie_status.naam AS status
   FROM object
     LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
           FROM historie historie_1
          WHERE historie_1.object_id = object.id
          ORDER BY historie_1.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN historie_status ON historie.historie_status_id = historie_status.id;

CREATE OR REPLACE VIEW objecten.volgende_update AS 
 SELECT object.id,
    object.formelenaam,
    object.geom,
    object.pand_id,
    historie.datum_aangemaakt,
    object.datum_gewijzigd,
    historie_status.naam AS status,
    historie_aanpassing.naam AS aanpassing,
    matrix_code.matrix_code,
    matrix_code.actualisatie,
    historie.datum_aangemaakt::date + '1 year'::interval *
        CASE
            WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
            WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
            WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
            WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
            ELSE NULL::integer
        END::double precision AS volgende_update,
        CASE
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) >= now() THEN 'up-to-date'::text
            WHEN (historie.datum_aangemaakt::date + '1 year'::interval *
            CASE
                WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) < now() THEN 'updaten'::text
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) IS NULL THEN 'nog niet gemaakt'::text
            ELSE 'updaten binnen 3 maanden'::text
        END AS conditie
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
           FROM objecten.historie historie_1
          WHERE historie_1.object_id = object.id AND historie_1.historie_aanpassing_id <> 1
          ORDER BY historie_1.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN objecten.historie_status ON historie.historie_status_id = historie_status.id
     LEFT JOIN objecten.historie_aanpassing ON historie.historie_aanpassing_id = historie_aanpassing.id
     LEFT JOIN objecten.matrix_code ON historie.matrix_code_id = matrix_code.id;
	 
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
    team_geom
   FROM ( SELECT o.team,
            count(o.team) AS totaal,
            count(hs.naam) FILTER (WHERE hs.naam = 'in gebruik'::text) AS totaal_in_gebruik,
            count(hs.naam) FILTER (WHERE hs.naam = 'concept'::text) AS totaal_in_concept,
            count(hs.naam) FILTER (WHERE hs.naam = 'archief'::text) AS totaal_in_archief,
            sum(
                CASE
                    WHEN hs.naam IS NULL THEN 1
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
            count(hs.naam) FILTER (WHERE hs.naam = 'in gebruik'::text AND mc.prio_prod = 1) AS prio_1_in_gebruik,
            count(hs.naam) FILTER (WHERE hs.naam = 'in gebruik'::text AND mc.prio_prod = 2) AS prio_2_in_gebruik,
            count(hs.naam) FILTER (WHERE hs.naam = 'in gebruik'::text AND mc.prio_prod = 3) AS prio_3_in_gebruik,
            count(hs.naam) FILTER (WHERE hs.naam = 'in gebruik'::text AND mc.prio_prod = 4) AS prio_4_in_gebruik,
            count(hs.naam) FILTER (WHERE hs.naam = 'concept'::text AND mc.prio_prod = 1) AS prio_1_concept,
            count(hs.naam) FILTER (WHERE hs.naam = 'concept'::text AND mc.prio_prod = 2) AS prio_2_concept,
            count(hs.naam) FILTER (WHERE hs.naam = 'concept'::text AND mc.prio_prod = 3) AS prio_3_concept,
            count(hs.naam) FILTER (WHERE hs.naam = 'concept'::text AND mc.prio_prod = 4) AS prio_4_concept,
            team_geom
           FROM ( SELECT object.formelenaam,
                    object.pand_id,
                    object.geom,
                    object.id AS object_id,
                    historie.datum_aangemaakt,
                    historie.historie_aanpassing_id,
                    historie.historie_status_id,
                    historie.matrix_code_id,
                    tg.naam AS team,
                    tg.geom AS team_geom
                   FROM object
                     LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
                           FROM historie historie_1
                          WHERE historie_1.object_id = object.id
                          ORDER BY historie_1.datum_aangemaakt DESC
                         LIMIT 1))
                     LEFT JOIN algemeen.team tg ON ST_INTERSECTS(object.geom, tg.geom)
                  ORDER BY historie.historie_status_id) o
             LEFT JOIN historie_aanpassing ha ON o.historie_aanpassing_id = ha.id
             LEFT JOIN historie_status hs ON o.historie_status_id = hs.id
             LEFT JOIN matrix_code mc ON o.matrix_code_id = mc.id
          GROUP BY o.team, o.team_geom) obj;

-- View: objecten.view_objectgegevens
CREATE OR REPLACE VIEW objecten.view_objectgegevens AS 
 SELECT object.id,
    object.formelenaam,
    object.geom,
    object.pand_id,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.laagstebouw,
    object.hoogstebouw,
    object.bhvaanwezig,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    bg.gebruikstype,
    ob.naam AS bouwconstructie,
    round(st_x(object.geom)) AS x,
    round(st_y(object.geom)) AS y
   FROM objecten.object
     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
           FROM objecten.historie historie_1
          WHERE historie_1.object_id = object.id
          ORDER BY historie_1.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN objecten.bag_gebruikstype bg ON object.pand_id::numeric = bg.identificatie
     LEFT JOIN objecten.object_bouwconstructie ob ON object.object_bouwconstructie_id = ob.id
  WHERE historie.historie_status_id = 2;
  
CREATE OR REPLACE VIEW objecten.stavaza_update_gemeente AS 
 SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.conditie) FILTER (WHERE s.conditie = 'up-to-date'::text) AS up_to_date,
    count(s.conditie) FILTER (WHERE s.conditie = 'updaten binnen 3 maanden'::text) AS binnen_3_maanden,
    count(s.conditie) FILTER (WHERE s.conditie = 'updaten'::text) AS updaten,
    count(s.conditie) FILTER (WHERE s.conditie = 'nog niet gemaakt'::text) AS nog_maken,
    g.geom
   FROM objecten.volgende_update s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;
  
CREATE OR REPLACE VIEW objecten.stavaza_status_gemeente AS 
 SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.status) FILTER (WHERE s.status = 'in gebruik'::text) AS totaal_in_gebruik,
    count(s.status) FILTER (WHERE s.status = 'concept'::text) AS totaal_in_concept,
    count(s.status) FILTER (WHERE s.status = 'archief'::text) AS totaal_in_archief,
    sum(
        CASE
            WHEN s.status IS NULL THEN 1
            ELSE 0
        END) AS totaal_geen_status,
    g.geom
   FROM objecten.status_objectgegevens s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;
  
-- verwijderen van registratie gebruiktype
ALTER TABLE object DROP CONSTRAINT object_gebruiktype_id_fk;
ALTER TABLE object DROP COLUMN object_gebruiktype_id;
DROP TABLE object_gebruiktype;

-- Loslaten van 1 op 1 relatie met BAG. Meerdere i-tjes per BAG object
ALTER TABLE object DROP CONSTRAINT object_pand_id_key;

-- verwijderen van registratie gebruiktype
ALTER TABLE object DROP CONSTRAINT object_team_id_fk;
ALTER TABLE object DROP COLUMN team_id;
		  
-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 12;
UPDATE algemeen.applicatie SET datum = now();