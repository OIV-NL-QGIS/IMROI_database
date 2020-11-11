SET ROLE oiv_admin;
SET search_path = bluswater, pg_catalog, public;

ALTER VIEW stavaza_gemeente RENAME TO bluswater_stavaza_gemeente;

ALTER TABLE inspectie DROP CONSTRAINT inspectie_conditie_fkey;
ALTER TABLE enum_conditie DROP CONSTRAINT enum_conditie_pkey;
ALTER TABLE enum_conditie ADD COLUMN id serial PRIMARY KEY;
ALTER TABLE enum_conditie ADD COLUMN value_new text UNIQUE;

UPDATE enum_conditie SET value_new = value;
ALTER TABLE enum_conditie DROP COLUMN value;

ALTER TABLE enum_conditie RENAME value_new TO value;

ALTER TABLE inspectie ADD CONSTRAINT inspectie_conditie_fkey FOREIGN KEY (conditie)
      REFERENCES enum_conditie (value) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 322; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
