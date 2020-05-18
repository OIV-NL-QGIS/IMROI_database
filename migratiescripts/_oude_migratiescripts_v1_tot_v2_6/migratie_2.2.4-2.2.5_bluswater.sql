SET role oiv_admin;
SET search_path = bluswater, pg_catalog, public;

DROP VIEW IF EXISTS rapport_inspectie CASCADE;

CREATE OR REPLACE VIEW bluswater.rapport_inspectie AS 
 SELECT brandkraan_huidig_plus.nummer AS id,
    inspectie.id AS inspectie_id,
    brandkraan_huidig_plus.nummer,
    brandkraan_huidig_plus.geom,
    brandkraan_huidig_plus.type,
    brandkraan_huidig_plus.diameter,
    brandkraan_huidig_plus.postcode,
    brandkraan_huidig_plus.straat,
    brandkraan_huidig_plus.huisnummer,
    brandkraan_huidig_plus.capaciteit,
    brandkraan_huidig_plus.plaats,
    brandkraan_huidig_plus.gemeentenaam,
    inspectie.datum_aangemaakt,
    inspectie.datum_gewijzigd,
    datum_aangemaakt AS mutatie,
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
   FROM bluswater.brandkraan_huidig_plus
     LEFT JOIN bluswater.inspectie ON inspectie.id = (( SELECT leegfreq.id
           FROM bluswater.inspectie leegfreq
          WHERE leegfreq.brandkraan_nummer::text = brandkraan_huidig_plus.nummer::text
          ORDER BY leegfreq.datum_aangemaakt DESC
         LIMIT 1))
  WHERE brandkraan_huidig_plus.verwijderd = false;
COMMENT ON VIEW bluswater.rapport_inspectie
  IS 'Algemene view voor weergave in rapporten';

CREATE OR REPLACE VIEW bluswater.rapport_inspectie_defect AS 
 SELECT rapport_inspectie.id,
    rapport_inspectie.inspectie_id,
    rapport_inspectie.nummer,
    rapport_inspectie.geom,
    rapport_inspectie.type,
    rapport_inspectie.diameter,
    rapport_inspectie.postcode,
    rapport_inspectie.straat,
    rapport_inspectie.huisnummer,
    rapport_inspectie.capaciteit,
    rapport_inspectie.plaats,
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
COMMENT ON VIEW bluswater.rapport_inspectie_defect
  IS 'View voor afgekeurd en werkbaar, basis voor rapport vandaag pwn en gemeente';

CREATE OR REPLACE VIEW bluswater.rapport_inspectie_vandaag_gemeente AS 
 SELECT rapport_inspectie_defect.id,
    rapport_inspectie_defect.inspectie_id,
    rapport_inspectie_defect.nummer,
    rapport_inspectie_defect.geom,
    rapport_inspectie_defect.type,
    rapport_inspectie_defect.diameter,
    rapport_inspectie_defect.postcode,
    rapport_inspectie_defect.straat,
    rapport_inspectie_defect.huisnummer,
    rapport_inspectie_defect.capaciteit,
    rapport_inspectie_defect.plaats,
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

CREATE OR REPLACE VIEW bluswater.rapport_inspectie_vandaag_pwn AS 
 SELECT rapport_inspectie_defect.id,
    rapport_inspectie_defect.inspectie_id,
    rapport_inspectie_defect.nummer,
    rapport_inspectie_defect.geom,
    rapport_inspectie_defect.type,
    rapport_inspectie_defect.diameter,
    rapport_inspectie_defect.postcode,
    rapport_inspectie_defect.straat,
    rapport_inspectie_defect.huisnummer,
    rapport_inspectie_defect.capaciteit,
    rapport_inspectie_defect.plaats,
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

CREATE OR REPLACE VIEW bluswater.rapport_weekoverzicht AS 
 SELECT rapport_inspectie.id,
    rapport_inspectie.inspectie_id,
    rapport_inspectie.nummer,
    rapport_inspectie.geom,
    rapport_inspectie.type,
    rapport_inspectie.diameter,
    rapport_inspectie.postcode,
    rapport_inspectie.straat,
    rapport_inspectie.huisnummer,
    rapport_inspectie.capaciteit,
    rapport_inspectie.plaats,
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

-- Create management laag t.b.v. voortgang controle
CREATE OR REPLACE VIEW bluswater.stavaza_gemeente AS 
 SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.conditie) FILTER (WHERE s.conditie = 'inspecteren'::text) AS inspecteren,
    count(s.conditie) FILTER (WHERE s.conditie = 'goedgekeurd'::text) AS goedgekeurd,
    count(s.conditie) FILTER (WHERE s.conditie = 'werkbaar'::text) AS reparatie_gemeente,
    count(s.conditie) FILTER (WHERE s.conditie = 'afgekeurd'::text) AS reparatie_pwn,
    count(s.conditie) FILTER (WHERE s.conditie = 'binnenkort inspecteren'::text) AS binnekort_inspecteren,
    g.geom
   FROM bluswater.brandkraan_inspectie s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;
  
  
-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 4;
UPDATE algemeen.applicatie SET db_versie = 15;
UPDATE algemeen.applicatie SET datum = now();