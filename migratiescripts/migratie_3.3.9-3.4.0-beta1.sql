SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

UPDATE objecten.sleutelkuis_type SET naam = 'Sleutelkuis Havenbedrijf', symbol_name = 'sleutelkluis_havenbedrijf'
WHERE id = 10;

UPDATE bluswater.alternatieve_type SET naam = 'Voorziening defect', symbol_name = 'bluswater_defect'
WHERE id = 9999;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 340; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();