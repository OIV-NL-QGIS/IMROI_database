SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

CREATE OR REPLACE FUNCTION objecten.func_soft_delete_cascade()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
       fk_table TEXT;
       fk_schema TEXT;
       schemaname TEXT := TG_ARGV[0]::TEXT;
       tablename TEXT := TG_ARGV[1]::TEXT;
       identifier TEXT := TG_ARGV[2]::TEXT;
    BEGIN
		FOR fk_table, fk_schema IN
			SELECT 
			       fk_tco.table_schema as fk_table,
			       fk_tco.table_name AS fk_schema
			FROM information_schema.referential_constraints rco
			JOIN information_schema.table_constraints fk_tco ON rco.constraint_name = fk_tco.constraint_name AND rco.constraint_schema = fk_tco.table_schema
			JOIN information_schema.table_constraints pk_tco ON rco.unique_constraint_name = pk_tco.constraint_name AND rco.unique_constraint_schema = pk_tco.table_schema
			WHERE pk_tco.table_name = tablename AND pk_tco.table_schema = schemaname
		LOOP
			EXECUTE format('DELETE FROM %I.%I WHERE %I = %s;', fk_table, fk_schema, identifier, OLD.id);

		END LOOP;
        RETURN OLD;
    END;
    $function$
;

CREATE OR REPLACE TRIGGER bouwlagen_soft_del_cascade BEFORE
DELETE
    ON
    objecten.bouwlagen FOR EACH ROW EXECUTE FUNCTION objecten.func_soft_delete_cascade('objecten', 'bouwlagen', 'bouwlaag_id')

CREATE OR REPLACE TRIGGER ingang_soft_del_cascade BEFORE
DELETE
    ON
    objecten.ingang FOR EACH ROW EXECUTE FUNCTION objecten.func_soft_delete_cascade('objecten', 'ingang', 'ingang_id');
    
CREATE OR REPLACE TRIGGER gevaarlijke_soft_del_cascade BEFORE
DELETE
    ON
    objecten.gevaarlijkestof_opslag FOR EACH ROW EXECUTE FUNCTION objecten.func_soft_delete_cascade('objecten', 'gevaarlijkestof_opslag', 'opslag_id');
    
CREATE OR REPLACE TRIGGER schade_cirkel_soft_del_cascade BEFORE
DELETE
    ON
    objecten.gevaarlijkestof_schade_cirkel FOR EACH ROW EXECUTE FUNCTION objecten.func_soft_delete_cascade('objecten', 'gevaarlijkestof_schade_cirkel', 'gevaarlijkestof_id');

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 342; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
