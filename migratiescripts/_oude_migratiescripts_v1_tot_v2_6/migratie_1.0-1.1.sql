-- Opzoektabellen vullen
set role oiv_admin;
ALTER SCHEMA algemeen
  RENAME TO algemeen_oud;
ALTER SCHEMA objecten
  RENAME TO objecten_oud;

-- Maak nu de nieuwe schema's aan....

-- Conversie van data
set role oiv_admin;
--SELECT * FROM objecten_oud.object WHERE pand_id IS NULL OR geom IS NULL;
--DELETE FROM objecten_oud.object WHERE pand_id IS NULL OR geom IS NULL;

INSERT INTO objecten.object (id, geom, datum_aangemaakt, datum_gewijzigd, pand_id, object_gebruiktype_id, object_bouwconstructie_id, laagstebouw, hoogstebouw, formelenaam, straatnaam, bhvaanwezig, tmo_dekking, dmo_dekking, huisnummer, team_id, plaats, bijzonderheden)
SELECT distinct on (pand_id)
  id,
  geom,
  datum_aangemaakt,
  datum_gewijzigd,
  pand_id,
  gebruiktype_id,
  bouwconstructie_id,
  laagstebouw,
  hoogstebouw,
  formelenaam,
  straatnaam,
  bhvaanwezig,
  tmo_dekking,
  dmo_dekking,
  huisnummer,
  team_id,
  plaats,
  bijzonderheden
FROM objecten_oud.object
WHERE pand_id IS NOT NULL AND geom IS NOT NULL;

INSERT INTO objecten.voorziening (id, object_id, geom, datum_aangemaakt, datum_gewijzigd, voorziening_pictogram_id, rotatie)
SELECT 
id, 
object_id, 
geom, 
datum_aangemaakt, 
datum_gewijzigd, 
(SELECT lkp.id
     FROM objecten.voorziening_pictogram AS lkp
     WHERE naam ILIKE symbool.wat
     LIMIT 1) as voorziening_pictogram_id,
rotatie
FROM objecten_oud.symbool
WHERE geom IS NOT NULL;

ALTER TABLE objecten.voorziening DISABLE TRIGGER trg_set_mutatie;
UPDATE objecten.voorziening SET voorziening_pictogram_id = 155 WHERE voorziening_pictogram_id IS NULL;

INSERT INTO objecten.scheiding (id, object_id, geom, datum_aangemaakt, datum_gewijzigd, scheiding_type_id)
SELECT 
id, 
object_id, 
geom, 
datum_aangemaakt, 
datum_gewijzigd, 
CASE WHEN type='30 min brandwerende scheiding' THEN 1
     WHEN type='60 min brandwerende scheiding' THEN 2
     WHEN type='bouwdeelscheiding' THEN 3
     WHEN type='rookwerendescheiding' THEN 4
     ELSE 1
END as scheiding_type_id
FROM objecten_oud.scheiding
WHERE object_id NOT IN (2,5,13,28,29);

INSERT INTO objecten.opslag SELECT
  id,
  object_id,
  geom, 
  datum_aangemaakt, 
  datum_gewijzigd,
  omschrijving
FROM objecten_oud.gevaarlijkestof;

INSERT INTO objecten.gevaarlijkestof(opslag_id, datum_aangemaakt, datum_gewijzigd, omschrijving, gevaarlijkestof_gevi_id, un_nummer, erickaart, locatie, hoeveelheid, gevaarlijkestof_eenheid_id, gevaarlijkestof_toestand_id) 
SELECT
  id,
  datum_aangemaakt, 
  datum_gewijzigd,
  omschrijving,
  gevaarlijkestof_gevi_id,
  un_nummer,
  erickaart,
  locatie,
  hoeveelheid,
  gevaarlijkestof_eenheid_id,
  11
FROM objecten_oud.gevaarlijkestof;

INSERT INTO objecten.historie SELECT 
  id,
  object_id,
  datum_aangemaakt,
  datum_gewijzigd,
  laatste_controle,
  volgende_controle,
  teamlid_behandeld_id,
  teamlid_afgehandeld_id,
  1,
  1,
  code,
  concept
FROM objecten_oud.historie;

INSERT INTO objecten.aanwezig SELECT 
  id,
  object_id,
  datum_aangemaakt,
  datum_gewijzigd,
  (SELECT lkp.id
     FROM objecten.aanwezig_groep AS lkp
     WHERE naam ILIKE (SELECT lkp_oud.omschrijving FROM objecten_oud.aanwezig_groep AS lkp_oud WHERE lkp_oud.id = aanwezig.aanwezig_groep_id LIMIT 1)
     LIMIT 1) as aanwezig_groep_id,
  dagen,
  tijdvakbegin,
  tijdvakeind,
  aantal,
  aantalniet
FROM objecten_oud.aanwezig
WHERE object_id NOT IN (2,5,13,28,29);

SELECT SETVAL('objecten.gevaarlijkestof_id_seq', COALESCE(MAX(id), 1) ) FROM objecten.gevaarlijkestof;
SELECT SETVAL('objecten.aanwezig_id_seq', COALESCE(MAX(id), 1) ) FROM objecten.aanwezig;
SELECT SETVAL('objecten.historie_id_seq', COALESCE(MAX(id), 1) ) FROM objecten.historie;
SELECT SETVAL('objecten.object_id_seq', COALESCE(MAX(id), 1) ) FROM objecten.object;
SELECT SETVAL('objecten.opslag_id_seq', COALESCE(MAX(id), 1) ) FROM objecten.opslag;
SELECT SETVAL('objecten.scheiding_id_seq', COALESCE(MAX(id), 1) ) FROM objecten.scheiding;
SELECT SETVAL('objecten.voorziening_id_seq', COALESCE(MAX(id), 1) ) FROM objecten.voorziening;


