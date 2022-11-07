CREATE ROLE oiv_admin
  NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

CREATE ROLE oiv_read
  NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

CREATE ROLE oiv_write
  NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

--vraag de gebruikers naam en wachtwoorden op via reeds deelnemende regio's

--admin
CREATE USER ... WITH PASSWORD 'xxx';
COMMENT ON ROLE ...
  IS 'OIV admin';
GRANT oiv_admin TO ...;

--tekenaar
CREATE USER ... WITH PASSWORD 'xxx';
COMMENT ON ROLE ...
  IS 'Standaard OIV tekenaar';
GRANT oiv_read TO ...;
GRANT oiv_write TO ...;

--lezer
CREATE USER ... WITH PASSWORD 'xxx';
COMMENT ON ROLE ...
  IS 'OIV alleen-lezen gebruiker';
GRANT oiv_read TO ...;

-- Database maken
CREATE DATABASE oiv_prod
  WITH OWNER = oiv_admin
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       --LC_COLLATE = 'en_US.utf-8'
       --LC_CTYPE = 'en_US.utf-8'
       CONNECTION LIMIT = -1
       TEMPLATE=template0;

ALTER DATABASE oiv_prod
  SET search_path = "$user", public;
GRANT CONNECT, TEMPORARY ON DATABASE oiv_prod TO public;
--REVOKE ALL ON DATABASE oiv_prod FROM public;

COMMENT ON DATABASE oiv_prod
  IS 'Operationele Informatie Voorziening';

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