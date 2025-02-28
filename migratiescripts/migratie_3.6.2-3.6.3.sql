SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

UPDATE objecten.bereikbaarheid_type SET style_ids='75,76,77' WHERE naam='slagboom';



INSERT INTO algemeen.styles (id, laagnaam, soortnaam, lijndikte, lijnkleur, lijnstijl, vulkleur, vulstijl, verbindingsstijl, eindstijl) 
VALUES(79, 'Isolijnen', '-3', 1, '#ff0000ff', 'dash'::algemeen.lijnstijl_type, NULL, NULL, 'bevel'::algemeen.verbindingsstijl_type, 'square'::algemeen.eindstijl_type);



-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 6;
UPDATE algemeen.applicatie SET revisie = 3;
UPDATE algemeen.applicatie SET db_versie = 363; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET omschrijving = '';
UPDATE algemeen.applicatie SET datum = now();
