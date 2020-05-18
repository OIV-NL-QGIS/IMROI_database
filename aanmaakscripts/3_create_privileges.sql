-- Extensies
CREATE EXTENSION adminpack
  SCHEMA pg_catalog;
CREATE EXTENSION hstore
  SCHEMA public;
CREATE EXTENSION postgis
  SCHEMA public;

-- Inloggen in database oiv_prod
ALTER DEFAULT PRIVILEGES FOR ROLE oiv_admin
    GRANT INSERT, UPDATE, DELETE ON TABLES
    TO oiv_write;
ALTER DEFAULT PRIVILEGES FOR ROLE oiv_admin
    GRANT UPDATE ON SEQUENCES
    TO oiv_write;
ALTER DEFAULT PRIVILEGES FOR ROLE oiv_admin
    GRANT SELECT ON TABLES
    TO oiv_read;
ALTER DEFAULT PRIVILEGES FOR ROLE oiv_admin
    GRANT USAGE, SELECT ON SEQUENCES
    TO oiv_read;

GRANT SELECT ON TABLE public.geometry_columns TO public;
GRANT SELECT ON TABLE public.geography_columns TO public;