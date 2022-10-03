SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO sectoren_type (id, naam) VALUES (31, 'Werkingsgebied RBP');
INSERT INTO opstelplaats_type (id, naam, symbol_name, size) VALUES (31, 'Politie', 'politie', 10);

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_points_of_interest', 'id', 1, 'assigned');  
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_gebiedsgerichte_aanpak', 'id', 1, 'assigned');

CREATE OR REPLACE VIEW objecten.view_objectgegevens
AS SELECT object.id,
    object.formelenaam,
    object.geom,
    object.basisreg_identifier,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    object.bijzonderheden,
    object.pers_max,
    object.pers_nietz_max,
    object.datum_geldig_vanaf,
    object.datum_geldig_tot,
    object.bron,
    object.bron_tabel,
    object.fotografie_id,
    bg.naam AS bodemgesteldheid,
    gf.gebruiksfuncties,
    round(st_x(object.geom)) AS x,
    round(st_y(object.geom)) AS y,
    o.typeobject
   FROM objecten.object
     JOIN ( SELECT object_1.formelenaam,
            object_1.id AS object_id,
            historie.typeobject
           FROM objecten.object object_1
             LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id 
                   FROM objecten.historie historie_1
                  WHERE historie_1.object_id = object_1.id
                  ORDER BY historie_1.datum_aangemaakt DESC
                 LIMIT 1))
          WHERE historie.status::text = 'in gebruik'::text AND (object_1.datum_geldig_vanaf <= now() OR object_1.datum_geldig_vanaf IS NULL) AND (object_1.datum_geldig_tot > now() OR object_1.datum_geldig_tot IS NULL)) o ON object.id = o.object_id
     LEFT JOIN objecten.bodemgesteldheid_type bg ON object.bodemgesteldheid_type_id = bg.id
     LEFT JOIN ( SELECT DISTINCT g.object_id,
            string_agg(gt.naam, ', '::text) AS gebruiksfuncties
           FROM objecten.gebruiksfunctie g
             JOIN objecten.gebruiksfunctie_type gt ON g.gebruiksfunctie_type_id = gt.id
          GROUP BY g.object_id) gf ON object.id = gf.object_id;

CREATE OR REPLACE RULE object_upd AS
    ON UPDATE TO objecten.object_objecten DO INSTEAD  
		UPDATE objecten.object 
		SET geom = new.geom, basisreg_identifier = new.basisreg_identifier, formelenaam = new.formelenaam, 
			pers_max = new.pers_max, pers_nietz_max = new.pers_nietz_max, datum_geldig_tot = new.datum_geldig_tot, 
			datum_geldig_vanaf = new.datum_geldig_vanaf, bron = new.bron, bron_tabel = new.bron_tabel, fotografie_id = new.fotografie_id, 
			bodemgesteldheid_type_id = new.bodemgesteldheid_type_id, bijzonderheden = new.bijzonderheden
  WHERE object.id = new.id;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 3;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 330; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();