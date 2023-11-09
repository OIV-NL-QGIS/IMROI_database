SET ROLE oiv_admin;

ALTER TABLE bluswater.brandkranen RENAME TO brandkranen_oud;
ALTER TABLE bluswater.brandkranen_landelijk RENAME TO brandkranen;

DROP VIEW bluswater.leidingen_huidig;

UPDATE algemeen.veiligheidsregio_watergrenzen
SET code = CASE WHEN LENGTH(code) = 1 THEN CONCAT('VR0', code)
                WHEN LENGTH(code) = 2 THEN CONCAT('VR', code)
                ELSE code
            END;

INSERT INTO bluswater.enum_conditie (id, value) VALUES (5, 'vervallen');
INSERT INTO bluswater.enum_conditie (id, value) VALUES (6, 'reparatie uitgevoerd');

CREATE OR REPLACE VIEW bluswater.brandkraan_inspectie
AS SELECT brandkranen.id::character varying AS id,
    inspectie.id AS inspectie_id,
    brandkranen.volgnummer AS nummer,
    brandkranen.geom,
    inspectie.datum_aangemaakt,
    inspectie.datum_gewijzigd,
        CASE
            WHEN (inspectie.datum_aangemaakt + 24::double precision * '1 mon'::interval) < now() THEN 'inspecteren'::text
            WHEN (inspectie.datum_aangemaakt + (24 - 3)::double precision * '1 mon'::interval) < now() AND (inspectie.datum_aangemaakt + 24::double precision * '1 mon'::interval) > now() THEN 'binnenkort inspecteren'::text
            ELSE COALESCE(inspectie.conditie, 'inspecteren'::text)
        END AS conditie,
    inspectie.inspecteur,
    inspectie.plaatsaanduiding,
    inspectie.plaatsaanduiding_anders,
    inspectie.toegankelijkheid,
    inspectie.toegankelijkheid_anders,
    inspectie.klauw,
    inspectie.klauw_diepte,
    inspectie.klauw_anders,
    inspectie.werking,
    inspectie.werking_anders,
    inspectie.opmerking,
    inspectie.foto,
    inspectie.uitgezet_bij_pwn AS uit_gezet_bij_pwn,
    inspectie.uitgezet_bij_gemeente AS uit_gezet_bij_gemeente,
    inspectie.opmerking_beheerder,
    NULL::text AS inlognaam,
    brandkranen.gemeentenaam
   FROM bluswater.brandkranen
     LEFT JOIN bluswater.inspectie ON inspectie.id = (( SELECT leegfreq.id
           FROM bluswater.inspectie leegfreq
          WHERE leegfreq.brandkraan_nummer::text = brandkranen.volgnummer::text
          ORDER BY leegfreq.datum_aangemaakt DESC
         LIMIT 1))
     JOIN algemeen.veiligheidsregio_watergrenzen vw ON ST_INTERSECTS(brandkranen.geom, vw.geom)
     JOIN algemeen.veiligheidsregio_huidig vh ON vw.code = vh.statcode
     WHERE brandkranen.status IN ('In bedrijf');

CREATE OR REPLACE VIEW bluswater.brandkraan_kavels
AS SELECT b.volgnummer AS nummer,
    concat(lower(k.post::text), '@vrnhn.nl') AS inlognaam,
    k.kavel
   FROM bluswater.brandkranen b
     JOIN bluswater.kavels k ON st_intersects(b.geom, k.geom);

CREATE OR REPLACE VIEW bluswater.afgekeurd_binnen_straal
AS SELECT row_number() OVER (ORDER BY tot.bk_nummer) AS gid,
    tot.bk_nummer,
    tot.count,
    bk.geom
   FROM ( SELECT nearest.bk_nummer,
            count(nearest.bk_nummer) AS count
           FROM ( SELECT i.id AS bk_nummer,
                    i.b_gid,
                    st_distance(i.geom, i.b_geom) AS dist,
                    i.geom
                   FROM ( SELECT a.id,
                            b.id AS b_gid,
                            a.geom,
                            b.geom AS b_geom,
                            rank() OVER (PARTITION BY a.id ORDER BY (st_distance(a.geom, b.geom))) AS pos
                           FROM ( SELECT brandkraan_inspectie.id,
                                    brandkraan_inspectie.geom
                                   FROM bluswater.brandkraan_inspectie
                                  WHERE brandkraan_inspectie.conditie = 'afgekeurd'::text) a,
                            ( SELECT brandkraan_inspectie.id,
                                    brandkraan_inspectie.geom
                                   FROM bluswater.brandkraan_inspectie
                                  WHERE brandkraan_inspectie.conditie = 'afgekeurd'::text) b
                          WHERE a.id::text <> b.id::text) i
                  WHERE i.pos <= 5) nearest
          WHERE nearest.dist <= 120::double precision
          GROUP BY nearest.bk_nummer) tot
     JOIN bluswater.brandkranen bk ON tot.bk_nummer::text = bk.volgnummer::TEXT
     JOIN algemeen.veiligheidsregio_watergrenzen vw ON ST_INTERSECTS(bk.geom, vw.geom)
     JOIN algemeen.veiligheidsregio_huidig vh ON vw.code = vh.statcode
     WHERE bk.status IN ('In bedrijf');

-- bluswater.rapport_inspectie source
DROP VIEW bluswater.rapport_weekoverzicht;
DROP VIEW bluswater.rapport_inspectie_vandaag_pwn;
DROP VIEW bluswater.rapport_inspectie_vandaag_gemeente;
DROP VIEW bluswater.rapport_inspectie_defect;
DROP VIEW bluswater.rapport_inspectie;

CREATE OR REPLACE VIEW bluswater.rapport_inspectie
AS SELECT brandkranen.id::character varying AS id,
    inspectie.id AS inspectie_id,
    brandkranen.volgnummer AS nummer,
    brandkranen.geom,
    brandkranen.kraantype AS type,
    brandkranen.diameter::smallint AS diameter,
    brandkranen.adres,
    brandkranen.capaciteit::smallint AS capaciteit,
    brandkranen.gemeentenaam,
    inspectie.datum_aangemaakt,
    inspectie.datum_gewijzigd,
    GREATEST(inspectie.datum_aangemaakt, inspectie.datum_gewijzigd) AS mutatie,
    inspectie.conditie,
    inspectie.inspecteur,
    inspectie.plaatsaanduiding,
    inspectie.plaatsaanduiding_anders,
    inspectie.toegankelijkheid,
    inspectie.toegankelijkheid_anders,
    inspectie.klauw,
    inspectie.klauw_diepte,
    inspectie.klauw_anders,
    inspectie.werking,
    inspectie.werking_anders,
    inspectie.opmerking,
    inspectie.foto,
    inspectie.uitgezet_bij_pwn,
    inspectie.uitgezet_bij_gemeente,
    inspectie.opmerking_beheerder
   FROM bluswater.brandkranen
     LEFT JOIN bluswater.inspectie ON inspectie.id = (( SELECT leegfreq.id
           FROM bluswater.inspectie leegfreq
          WHERE leegfreq.brandkraan_nummer::text = brandkranen.volgnummer::text
          ORDER BY leegfreq.datum_aangemaakt DESC
         LIMIT 1))
     JOIN algemeen.veiligheidsregio_watergrenzen vw ON ST_INTERSECTS(brandkranen.geom, vw.geom)
     JOIN algemeen.veiligheidsregio_huidig vh ON vw.code = vh.statcode
     WHERE brandkranen.status IN ('In bedrijf');

CREATE OR REPLACE VIEW bluswater.rapport_inspectie_defect
AS SELECT rapport_inspectie.id,
    rapport_inspectie.inspectie_id,
    rapport_inspectie.nummer,
    rapport_inspectie.geom,
    rapport_inspectie.type,
    rapport_inspectie.diameter,
    rapport_inspectie.adres,
    rapport_inspectie.capaciteit,
    rapport_inspectie.gemeentenaam,
    rapport_inspectie.datum_aangemaakt,
    rapport_inspectie.datum_gewijzigd,
    rapport_inspectie.mutatie,
    rapport_inspectie.conditie,
    rapport_inspectie.inspecteur,
    rapport_inspectie.plaatsaanduiding,
    rapport_inspectie.plaatsaanduiding_anders,
    rapport_inspectie.toegankelijkheid,
    rapport_inspectie.toegankelijkheid_anders,
    rapport_inspectie.klauw,
    rapport_inspectie.klauw_diepte,
    rapport_inspectie.klauw_anders,
    rapport_inspectie.werking,
    rapport_inspectie.werking_anders,
    rapport_inspectie.opmerking,
    rapport_inspectie.foto,
    rapport_inspectie.uitgezet_bij_pwn,
    rapport_inspectie.uitgezet_bij_gemeente,
    rapport_inspectie.opmerking_beheerder
   FROM bluswater.rapport_inspectie
  WHERE rapport_inspectie.conditie ~~* 'afgekeurd'::text OR rapport_inspectie.conditie ~~* 'werkbaar'::text;

CREATE OR REPLACE VIEW bluswater.rapport_weekoverzicht
AS SELECT rapport_inspectie.id,
    rapport_inspectie.inspectie_id,
    rapport_inspectie.nummer,
    rapport_inspectie.geom,
    rapport_inspectie.type,
    rapport_inspectie.diameter,
    rapport_inspectie.adres,
    rapport_inspectie.capaciteit,
    rapport_inspectie.gemeentenaam,
    rapport_inspectie.datum_aangemaakt,
    rapport_inspectie.datum_gewijzigd,
    rapport_inspectie.mutatie,
    rapport_inspectie.conditie,
    rapport_inspectie.inspecteur,
    rapport_inspectie.plaatsaanduiding,
    rapport_inspectie.plaatsaanduiding_anders,
    rapport_inspectie.toegankelijkheid,
    rapport_inspectie.toegankelijkheid_anders,
    rapport_inspectie.klauw,
    rapport_inspectie.klauw_diepte,
    rapport_inspectie.klauw_anders,
    rapport_inspectie.werking,
    rapport_inspectie.werking_anders,
    rapport_inspectie.opmerking,
    rapport_inspectie.foto,
    rapport_inspectie.uitgezet_bij_pwn,
    rapport_inspectie.uitgezet_bij_gemeente,
    rapport_inspectie.opmerking_beheerder,
    btrim(concat(rapport_inspectie.plaatsaanduiding, ' ', rapport_inspectie.plaatsaanduiding_anders, ' ', rapport_inspectie.toegankelijkheid, ' ', rapport_inspectie.toegankelijkheid_anders, ' ', rapport_inspectie.klauw, ' ', rapport_inspectie.klauw_diepte, ' ', rapport_inspectie.klauw_anders, ' ', rapport_inspectie.werking, ' ', rapport_inspectie.werking_anders)) AS resultaat
   FROM bluswater.rapport_inspectie
  WHERE date_part('week'::text, rapport_inspectie.mutatie) = date_part('week'::text, now())
  ORDER BY rapport_inspectie.mutatie;

CREATE OR REPLACE VIEW bluswater.rapport_inspectie_vandaag_pwn
AS SELECT rapport_inspectie_defect.id,
    rapport_inspectie_defect.inspectie_id,
    rapport_inspectie_defect.nummer,
    rapport_inspectie_defect.geom,
    rapport_inspectie_defect.type,
    rapport_inspectie_defect.diameter,
    rapport_inspectie_defect.adres,
    rapport_inspectie_defect.capaciteit,
    rapport_inspectie_defect.gemeentenaam,
    rapport_inspectie_defect.datum_aangemaakt,
    rapport_inspectie_defect.datum_gewijzigd,
    rapport_inspectie_defect.mutatie,
    rapport_inspectie_defect.conditie,
    rapport_inspectie_defect.inspecteur,
    rapport_inspectie_defect.plaatsaanduiding,
    rapport_inspectie_defect.plaatsaanduiding_anders,
    rapport_inspectie_defect.toegankelijkheid,
    rapport_inspectie_defect.toegankelijkheid_anders,
    rapport_inspectie_defect.klauw,
    rapport_inspectie_defect.klauw_diepte,
    rapport_inspectie_defect.klauw_anders,
    rapport_inspectie_defect.werking,
    rapport_inspectie_defect.werking_anders,
    rapport_inspectie_defect.opmerking,
    rapport_inspectie_defect.foto,
    rapport_inspectie_defect.uitgezet_bij_pwn,
    rapport_inspectie_defect.uitgezet_bij_gemeente,
    rapport_inspectie_defect.opmerking_beheerder
   FROM bluswater.rapport_inspectie_defect
 WHERE rapport_inspectie_defect.mutatie::date = now()::date AND (rapport_inspectie_defect.klauw IS NOT NULL OR rapport_inspectie_defect.klauw_anders IS NOT NULL OR rapport_inspectie_defect.werking IS NOT NULL OR rapport_inspectie_defect.werking_anders IS NOT NULL);

CREATE OR REPLACE VIEW bluswater.rapport_inspectie_vandaag_gemeente
AS SELECT rapport_inspectie_defect.id,
    rapport_inspectie_defect.inspectie_id,
    rapport_inspectie_defect.nummer,
    rapport_inspectie_defect.geom,
    rapport_inspectie_defect.type,
    rapport_inspectie_defect.diameter,
    rapport_inspectie_defect.adres,
    rapport_inspectie_defect.capaciteit,
    rapport_inspectie_defect.gemeentenaam,
    rapport_inspectie_defect.datum_aangemaakt,
    rapport_inspectie_defect.datum_gewijzigd,
    rapport_inspectie_defect.mutatie,
    rapport_inspectie_defect.conditie,
    rapport_inspectie_defect.inspecteur,
    rapport_inspectie_defect.plaatsaanduiding,
    rapport_inspectie_defect.plaatsaanduiding_anders,
    rapport_inspectie_defect.toegankelijkheid,
    rapport_inspectie_defect.toegankelijkheid_anders,
    rapport_inspectie_defect.klauw,
    rapport_inspectie_defect.klauw_diepte,
    rapport_inspectie_defect.klauw_anders,
    rapport_inspectie_defect.werking,
    rapport_inspectie_defect.werking_anders,
    rapport_inspectie_defect.opmerking,
    rapport_inspectie_defect.foto,
    rapport_inspectie_defect.uitgezet_bij_pwn,
    rapport_inspectie_defect.uitgezet_bij_gemeente,
    rapport_inspectie_defect.opmerking_beheerder
   FROM bluswater.rapport_inspectie_defect
  WHERE rapport_inspectie_defect.mutatie::date = now()::date AND (rapport_inspectie_defect.plaatsaanduiding IS NOT NULL OR rapport_inspectie_defect.plaatsaanduiding_anders IS NOT NULL OR rapport_inspectie_defect.toegankelijkheid IS NOT NULL OR rapport_inspectie_defect.toegankelijkheid_anders IS NOT NULL);

DROP TABLE blustwater.brandkranen_oud;