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