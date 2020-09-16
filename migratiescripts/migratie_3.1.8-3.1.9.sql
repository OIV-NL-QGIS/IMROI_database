SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO veiligh_install_type (id, naam, symbol_name, size) VALUES (1019, 'Schacht of kanaal', 'schacht_kanaal', 4);
-- Aanpassing aan de max lengte van het pand_id in de bouwlagen tabel, i.v.m. mogelijke koppeling aan een BGT object,
-- bijvoorbeeld tunnels. Deze identifier is een stuk langer als een BAG-ID.
ALTER TABLE bouwlagen ALTER COLUMN pand_id TYPE varchar(40);
ALTER TABLE aanwezig ADD COLUMN bijzonderheid TEXT;
ALTER TABLE veiligh_ruimtelijk ADD COLUMN bijzonderheid TEXT;
ALTER TABLE veiligh_install ADD COLUMN bijzonderheid TEXT;
ALTER TABLE bluswater.alternatieve ADD COLUMN opmerking TEXT;
ALTER TABLE dreiging ADD COLUMN omschrijving TEXT;

--LET OP VIEWS NOG AANPASSEN OP BASIS VAN TEBEL AANPASSINGEN

INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlagen', 'id', 1, 'assigned');
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_dreiging', 'id', 1, 'assigned');      
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_grid', 'id', 1, 'assigned');
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_ingang', 'id', 1, 'assigned');      
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_isolijnen', 'id', 1, 'assigned');
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_label', 'id', 1, 'assigned');      
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_objecten', 'id', 1, 'assigned');
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_opslag', 'id', 1, 'assigned');
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_opstelplaats', 'id', 1, 'assigned'); 
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_sectoren', 'id', 1, 'assigned'); 
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_sleutelkluis', 'id', 1, 'assigned'); 
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_terrein', 'id', 1, 'assigned');  
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_veiligh_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO objecten.gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_bereikbaarheid', 'id', 1, 'assigned');                               

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 1;
UPDATE algemeen.applicatie SET revisie = 9;
UPDATE algemeen.applicatie SET db_versie = 319; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
