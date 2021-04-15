SET ROLE oiv_admin;
SET search_path = waterongevallen, pg_catalog, public;

--conversie van historie
INSERT INTO objecten.historie_matrix_code (id, matrix_code, omschrijving, actualisatie, prio_prod) VALUES (998, 998, 'Waterongevallen', 'X', 998);

CREATE TABLE wo_historie AS
SELECT
  h.id,
  h.wo_gegevens_id,
  h.datum_aangemaakt,
  h.datum_gewijzigd,
  h.teamlid_behandeld_id,
  h.teamlid_behandeld_id AS teamlid_afgehandeld_id,
  998 AS matrix_code_id,
  hs.naam::objecten.historie_status_type AS status,
  ha.naam::objecten.historie_aanpassing_type AS aanpassing
FROM historie h
LEFT JOIN historie_status hs ON h.historie_status_id = hs.id
LEFT JOIN historie_aanpassing ha ON h.historie_aanpassing_id = ha.id;

INSERT INTO objecten.historie (object_id, datum_aangemaakt, datum_gewijzigd, teamlid_behandeld_id, teamlid_afgehandeld_id, matrix_code_id, status, aanpassing)
SELECT
  c.id,
  h.datum_aangemaakt,
  h.datum_gewijzigd,
  h.teamlid_behandeld_id,
  h.teamlid_afgehandeld_id,
  h.matrix_code_id,
  h.status,
  h.aanpassing
FROM wo_historie h
INNER JOIN 
 (SELECT wi.*, w.gegevens_id FROM wo_id_conversie wi
	INNER JOIN wo_lokatiegegevens w ON wi.wo_lokatie_id = w.id) c ON h.wo_gegevens_id = c.gegevens_id;

CREATE TABLE waterongevallen_backup.wo_historie AS
SELECT * FROM wo_historie;

DROP TABLE historie;
DROP TABLE historie_aanpassing;
DROP TABLE historie_status;

--conversie van labels
INSERT INTO objecten.label (geom, datum_aangemaakt, datum_gewijzigd, omschrijving, soort, rotatie, object_id)
SELECT
  l.geom,
  l.datum_aangemaakt,
  l.datum_gewijzigd,
  l.omschrijving,
  lt.type_label::objecten.labels_type,
  l.rotatie,
  c.id
FROM labels_wo l
INNER JOIN wo_id_conversie c ON l.wo_lokatie_id = c.wo_lokatie_id
INNER JOIN label_type lt ON l.type_label = lt.id;

CREATE TABLE waterongevallen_backup.wo_labels AS
SELECT
  l.geom,
  l.datum_aangemaakt,
  l.datum_gewijzigd,
  l.omschrijving,
  lt.type_label,
  l.rotatie,
  l.wo_lokatie_id
FROM labels_wo l
INNER JOIN label_type lt ON l.type_label = lt.id;

DROP TABLE labels_wo;
DROP TABLE label_type;

--conversie van contactpersoon
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'beheerder';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'brugwachter';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'eigenaar';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'gebruiker';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'gemeente';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'havendienst';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'hoogheemraadschap';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'kantine';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'kustwachtcentrum';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'provincie';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'PWN';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'receptie';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'reddingsbrigade';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'sluiswachter';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'staatsbosbeheer';
ALTER TYPE objecten.contactpersoon_type ADD VALUE 'zwemwatertelefoon';

INSERT INTO objecten.contactpersoon (datum_aangemaakt, datum_gewijzigd, soort, telefoonnummer, object_id)
SELECT
  c.datum_aangemaakt,
  c.datum_gewijzigd,
  cn.naam::objecten.contactpersoon_type,
  c.tel_nr,
  cid.id
FROM contactpersonen c
INNER JOIN contactp_naam cn ON c.contactpers_id = cn.id
INNER JOIN 
 (SELECT wi.*, w.gegevens_id FROM wo_id_conversie wi
	INNER JOIN wo_lokatiegegevens w ON wi.wo_lokatie_id = w.id) cid ON c.wo_gegevens_id = cid.gegevens_id;

CREATE TABLE waterongevallen_backup.wo_contactpersonen AS
SELECT c.*, cn.naam
FROM contactpersonen c
INNER JOIN contactp_naam cn ON c.contactpers_id = cn.id;

DROP TABLE contactpersonen;
DROP TABLE contactp_naam;

--conversie te_water_laat_plaatsen
ALTER TABLE objecten.opstelplaats ADD COLUMN label character varying(50);
ALTER TYPE objecten.opstelplaats_type ADD VALUE 'Boot te water laat plaats';

INSERT INTO objecten.opstelplaats (geom, datum_aangemaakt, datum_gewijzigd, soort, label, object_id)
SELECT
  p.geom,
  p.datum_aangemaakt,
  p.datum_gewijzigd,
  pt.naam::objecten.opstelplaats_type,
  p.opmerking,
  c.id
FROM pictogrammen p
INNER JOIN wo_id_conversie c ON p.wo_lokatie_id = c.wo_lokatie_id
INNER JOIN pictogrammen_lijst pt ON p.pictogrammen_id = pt.id
WHERE pt.id = 19;

CREATE TABLE waterongevallen_backup.wo_pictogrammen AS
SELECT c.*, cn.naam
FROM pictogrammen c
INNER JOIN pictogrammen_lijst cn ON c.pictogrammen_id = cn.id;

DELETE FROM pictogrammen WHERE pictogrammen_id = 19;

--conversie gevaar uit pictogrammen
INSERT INTO objecten.dreiging_type (id, naam) VALUES (129, 'Algemeen gevaar');

INSERT INTO objecten.dreiging (geom, datum_aangemaakt, datum_gewijzigd, dreiging_type_id, label, object_id)
SELECT
  p.geom,
  p.datum_aangemaakt,
  p.datum_gewijzigd,
  129,
  p.opmerking,
  c.id
FROM pictogrammen p
INNER JOIN wo_id_conversie c ON p.wo_lokatie_id = c.wo_lokatie_id
INNER JOIN pictogrammen_lijst pt ON p.pictogrammen_id = pt.id
WHERE pt.id = 17;

DELETE FROM pictogrammen WHERE pictogrammen_id = 17;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 0;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 303; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
  
  