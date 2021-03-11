SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

UPDATE objecten.veiligh_ruimtelijk_type SET symbol_name = 'reduceer_drukbegrenzer' WHERE symbol_name = 'reduceer_drukbegerenzer';
UPDATE dreiging_type SET symbol_name = 'algemeen_gevaar' WHERE id = 129;

INSERT INTO bluswater.alternatieve_type (id, naam, symbol_name, size)
    VALUES (9999, 'Voorziening defect', 'bluswater_defect', 6) ON CONFLICT DO NOTHING;

INSERT INTO objecten.sleutelkluis_type (id, naam, symbol_name, size)
    VALUES (10, 'Sleutelkuis Havenbedrijf', 'sleutelkluis_hbr', 4) ON CONFLICT DO NOTHING;

UPDATE algemeen.styles SET soortnaam = 'bijzondere ruimte_top' WHERE soortnaam = 'bijzondere ruimte';

SELECT setval('algemeen.styles_id_seq', (SELECT max(id) + 1 FROM algemeen.styles));
INSERT INTO algemeen.styles(laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl)
	VALUES ('Ruimten', 'bijzondere ruimte_bottom', 0.26, '#ff33a02c', 'solid', '#fffff97a', 'solid', 'bevel');

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 330; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();