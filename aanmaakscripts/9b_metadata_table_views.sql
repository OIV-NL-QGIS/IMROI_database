SET ROLE oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_afw_binnendekking', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_bereikbaarheid', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_bouwlagen', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_dreiging_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_dreiging_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_gevaarlijkestof_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_gevaarlijkestof_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_ingang_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_ingang_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_label_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_label_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_objectgegevens', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_opstelplaats', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_pictogram_zonder_object', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_schade_cirkel_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_schade_cirkel_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_ruimten', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_sectoren', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_sleutelkluis_bouwlaag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_sleutelkluis_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_veiligh_install', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_veiligh_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'view_veiligh_bouwk', 'id', 1, 'assigned');

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_afw_binnendekking', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_veiligh_install', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_ingang', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_sleutelkluis', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_opslag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_dreiging', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_label', 'id', 1, 'assigned');

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_veiligh_bouwk', 'id', 1, 'assigned');

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_bgt', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'schade_cirkel_calc', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'veiligh_bouwk_types', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'ruimtelijk_sleutelkluis', 'id', 1, 'assigned');

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlaag_ruimten', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'stavaza_objecten', 'team', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'stavaza_status_gemeente', 'gid', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'stavaza_update_gemeente', 'gid', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'stavaza_volgende_update', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'status_objectgegevens', 'id', 1, 'assigned');

INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'bouwlagen', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_dreiging', 'id', 1, 'assigned');      
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_grid', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_ingang', 'id', 1, 'assigned');      
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_isolijnen', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_label', 'id', 1, 'assigned');      
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_objecten', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_opslag', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_opstelplaats', 'id', 1, 'assigned'); 
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_sectoren', 'id', 1, 'assigned'); 
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_sleutelkluis', 'id', 1, 'assigned'); 
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_terrein', 'id', 1, 'assigned');  
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_veiligh_ruimtelijk', 'id', 1, 'assigned');
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_bereikbaarheid', 'id', 1, 'assigned');  
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_points_of_interest', 'id', 1, 'assigned');  
INSERT INTO gt_pk_metadata_table (table_schema, table_name, pk_column, pk_column_idx, pk_policy)
        VALUES ('objecten', 'object_gebiedsgerichte_aanpak', 'id', 1, 'assigned');