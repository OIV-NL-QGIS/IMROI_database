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
			EXECUTE format('DELETE FROM %I.%I WHERE $I = $1;', fk_table, fk_schema, identifier)
			USING OLD.id;
		END LOOP;
        RETURN OLD;
    END;
    $function$
;

CREATE TRIGGER bouwlagen_soft_del_cascade INSTEAD OF
	DELETE ON objecten.bouwlaag_bouwlagen FOR EACH ROW EXECUTE PROCEDURE objecten.func_soft_delete_cascade('objecten', 'bouwlagen', 'bouwlaag_id');

CREATE TRIGGER objecten_soft_del_cascade INSTEAD OF
	DELETE ON objecten.object_objecten FOR EACH ROW EXECUTE PROCEDURE objecten.func_soft_delete_cascade('objecten', 'object', 'object_id');

CREATE TRIGGER bouwlaag_opslag_soft_del_cascade INSTEAD OF
	DELETE ON objecten.bouwlaag_opslag FOR EACH ROW EXECUTE PROCEDURE objecten.func_soft_delete_cascade('objecten', 'gevaarlijkestof_opslag', 'opslag_id');

CREATE TRIGGER object_opslag_soft_del_cascade INSTEAD OF
	DELETE ON objecten.object_opslag FOR EACH ROW EXECUTE PROCEDURE objecten.func_soft_delete_cascade('objecten', 'gevaarlijkestof_opslag', 'opslag_id');

CREATE TRIGGER bouwlaag_dreiging_soft_del_cascade INSTEAD OF
	DELETE ON objecten.bouwlaag_dreiging FOR EACH ROW EXECUTE PROCEDURE objecten.func_soft_delete_cascade('objecten', 'dreiging', 'dreiging_id');

CREATE TRIGGER object_dreiging_soft_del_cascade INSTEAD OF
	DELETE ON objecten.object_dreiging FOR EACH ROW EXECUTE PROCEDURE objecten.func_soft_delete_cascade('objecten', 'dreiging', 'dreiging_id');

CREATE TRIGGER bouwlaag_ingang_soft_del_cascade INSTEAD OF
	DELETE ON objecten.bouwlaag_ingang FOR EACH ROW EXECUTE PROCEDURE objecten.func_soft_delete_cascade('objecten', 'ingang', 'ingang_id');

CREATE TRIGGER object_ingang_soft_del_cascade INSTEAD OF
	DELETE ON objecten.object_ingang FOR EACH ROW EXECUTE PROCEDURE objecten.func_soft_delete_cascade('objecten', 'ingang', 'ingang_id');

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 1;
UPDATE algemeen.applicatie SET db_versie = 341; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
