DO $$
DECLARE
i TEXT;
BEGIN
    FOR i IN (select table_name from information_schema.tables 
              where 
                table_catalog='oiv_test' 
                and table_schema='objecten' 
                and table_type = 'BASE TABLE' 
			    and "table_name" not like '%_type'
			    and "table_name" not in ('beheersmaatregelen_inzetfase','gevaarlijkestof_eenheid','gevaarlijkestof_toestand','gevaarlijkestof_vnnr','gt_pk_metadata_table','historie_matrix_code') ) LOOP
    EXECUTE 'Select setval(''objecten.'||i||'_id_seq'', (SELECT max(id) as a FROM objecten.' || i ||')+1);';
    END LOOP;
END$$;