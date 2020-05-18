-- missende scripts in het migratie_scipt_1.1.0-1.1.2

-- Opzoektabellen vullen
SET role oiv_admin;

SET search_path = objecten, pg_catalog, public;

-- Nieuwe opzoek waarden scheidingen tabel
INSERT INTO scheiding_type (id, naam) VALUES (5, '120 min brandwerende scheiding'), (6, 'hekwerk');

-- Drop not null constraint rotatie tabel label
ALTER TABLE object_labels ALTER COLUMN rotatie DROP NOT NULL;

-- dubbele vraag in historie betreffende concept
ALTER TABLE historie DROP COLUMN concept;

-- Db versie bijwerken
UPDATE algemeen.applicatie SET id = 2, versie = 0, sub = 0, datum = now();
