SET role oiv_admin;
SET search_path = bluswater, pg_catalog, public;

DROP VIEW IF EXISTS afgekeurd_binnen_straal;
DROP VIEW IF EXISTS brandkraan_inspectie;

-- aanpassen van view inspectie, conditie veranderd naar "volgende controle"
CREATE OR REPLACE VIEW brandkraan_inspectie AS 
 SELECT brandkraan_huidig_plus.nummer AS id,
    inspectie.id AS inspectie_id,
    brandkraan_huidig_plus.nummer,
    brandkraan_huidig_plus.geom,
    inspectie.datum_aangemaakt,
    inspectie.datum_gewijzigd,
        CASE
            WHEN (inspectie.datum_aangemaakt + brandkraan_huidig_plus.frequentie::double precision * '1 mon'::interval) < now() THEN 'inspecteren'::text
            WHEN (inspectie.datum_aangemaakt + (brandkraan_huidig_plus.frequentie - 3)::double precision * '1 mon'::interval) < now() AND (inspectie.datum_aangemaakt + brandkraan_huidig_plus.frequentie::double precision * '1 mon'::interval) > now() THEN 'binnenkort inspecteren'::text
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
    brandkraan_huidig_plus.inlognaam
   FROM brandkraan_huidig_plus
     LEFT JOIN inspectie ON inspectie.id = (( SELECT leegfreq.id
           FROM inspectie leegfreq
          WHERE leegfreq.brandkraan_nummer::text = brandkraan_huidig_plus.nummer::text
          ORDER BY leegfreq.datum_aangemaakt DESC
         LIMIT 1))
  WHERE brandkraan_huidig_plus.verwijderd = false;

CREATE OR REPLACE RULE brandkraan_inspectie_del AS
    ON DELETE TO brandkraan_inspectie DO INSTEAD NOTHING;

CREATE OR REPLACE RULE brandkraan_inspectie_ins AS
    ON INSERT TO brandkraan_inspectie DO INSTEAD NOTHING;

CREATE OR REPLACE RULE brandkraan_inspectie_upd AS
    ON UPDATE TO brandkraan_inspectie DO INSTEAD  INSERT INTO inspectie (brandkraan_nummer, conditie, inspecteur, plaatsaanduiding, plaatsaanduiding_anders, toegankelijkheid, toegankelijkheid_anders, klauw, klauw_diepte, klauw_anders, werking, werking_anders, opmerking, foto)
  VALUES (old.nummer, new.conditie, new.inspecteur, new.plaatsaanduiding, new.plaatsaanduiding_anders, new.toegankelijkheid, new.toegankelijkheid_anders, new.klauw, new.klauw_diepte, new.klauw_anders, new.werking, new.werking_anders, new.opmerking, new.foto);

CREATE OR REPLACE VIEW afgekeurd_binnen_straal AS 
 SELECT row_number() OVER (ORDER BY tot.bk_nummer) AS gid,
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
                                   FROM brandkraan_inspectie
                                  WHERE brandkraan_inspectie.conditie = 'afgekeurd'::text) a,
                            ( SELECT brandkraan_inspectie.id,
                                    brandkraan_inspectie.geom
                                   FROM brandkraan_inspectie
                                  WHERE brandkraan_inspectie.conditie = 'afgekeurd'::text) b
                          WHERE a.id::text <> b.id::text) i
                  WHERE i.pos <= 5) nearest
          WHERE nearest.dist <= 120::double precision
          GROUP BY nearest.bk_nummer) tot
     JOIN brandkraan_2017_1 bk ON tot.bk_nummer::text = bk.nummer::text;