SELECT d.datname as "Name",
pg_catalog.pg_get_userbyid(d.datdba) as "Owner"
FROM pg_catalog.pg_database d
WHERE d.datname = 'oiv_test'
ORDER BY 1;

SELECT schema_name, schema_owner FROM information_schema.schemata
WHERE schema_name IN ('algemeen', 'bluswater', 'info_of_interest', 'mobiel', 'objecten');

select tablename, tableowner from pg_catalog.pg_tables
WHERE schemaname IN ('algemeen', 'bluswater', 'info_of_interest', 'mobiel', 'objecten');

select viewname, viewowner from pg_catalog.pg_views
WHERE schemaname IN ('algemeen', 'bluswater', 'info_of_interest', 'mobiel', 'objecten');