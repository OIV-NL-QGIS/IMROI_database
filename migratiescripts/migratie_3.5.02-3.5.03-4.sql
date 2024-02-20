SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

DROP VIEW objecten.bouwlaag_bouwlagen;
CREATE OR REPLACE VIEW objecten.bouwlaag_bouwlagen
AS SELECT b.id,
    b.geom,
    b.datum_aangemaakt,
    b.datum_gewijzigd,
    b.bouwlaag,
    b.bouwdeel,
    b.pand_id,
    b.self_deleted AS datum_deleted
   FROM objecten.bouwlagen b
  WHERE b.self_deleted = 'infinity'::timestamp with time zone;
 
CREATE RULE bouwlagen_del AS
    ON DELETE TO objecten.bouwlaag_bouwlagen DO INSTEAD  DELETE FROM objecten.bouwlagen
  WHERE (bouwlagen.id = old.id);
 
CREATE RULE bouwlagen_ins AS
    ON INSERT TO objecten.bouwlaag_bouwlagen DO INSTEAD  INSERT INTO objecten.bouwlagen (geom, bouwlaag, bouwdeel, pand_id)
  VALUES (new.geom, new.bouwlaag, new.bouwdeel, new.pand_id)
  RETURNING bouwlagen.id,
    bouwlagen.geom,
    bouwlagen.datum_aangemaakt,
    bouwlagen.datum_gewijzigd,
    bouwlagen.bouwlaag,
    bouwlagen.bouwdeel,
    bouwlagen.pand_id,
    bouwlagen.self_deleted AS datum_deleted;
 
CREATE RULE bouwlagen_upd AS
    ON UPDATE TO objecten.bouwlaag_bouwlagen DO INSTEAD  UPDATE objecten.bouwlagen SET geom = new.geom, bouwlaag = new.bouwlaag, bouwdeel = new.bouwdeel, pand_id = new.pand_id
  WHERE (bouwlagen.id = new.id);

UPDATE aanwezig SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE afw_binnendekking SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE bedrijfshulpverlening SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE beheersmaatregelen SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE bereikbaarheid SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE contactpersoon SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE dreiging SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE gebiedsgerichte_aanpak SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE gebruiksfunctie SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE gevaarlijkestof SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE gevaarlijkestof_opslag SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE gevaarlijkestof_schade_cirkel SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE grid SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE historie SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE ingang SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE isolijnen SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE "label" SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE opstelplaats SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE points_of_interest SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE ruimten SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE scenario SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE scenario_locatie SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE sectoren SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE sleutelkluis SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE terrein SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE veiligh_bouwk SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE veiligh_install SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE veiligh_ruimtelijk SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';
UPDATE veilighv_org SET self_deleted = parent_deleted WHERE parent_deleted != 'infinity';

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 5;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 353; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = 'v4';
UPDATE algemeen.applicatie SET datum = now();