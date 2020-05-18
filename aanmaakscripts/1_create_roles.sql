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
