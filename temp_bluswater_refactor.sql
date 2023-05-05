
SET ROLE mergin;
CREATE SCHEMA bluswater_mergin;

ALTER TABLE bluswater.inspectie ALTER COLUMN datum_deleted TYPE varchar;
ALTER TABLE bluswater.inspectie ALTER COLUMN datum_aangemaakt TYPE varchar;
ALTER TABLE bluswater.inspectie ALTER COLUMN datum_gewijzigd TYPE varchar;
-- bluswater.brandkraan_inspectie source

SET ROLE oiv_admin;
CREATE OR REPLACE VIEW bluswater.brandkraan_inspectie
AS SELECT brandkraan_huidig_plus.nen3610id AS id,
    inspectie.id AS inspectie_id,
    brandkraan_huidig_plus.nen3610id,
    brandkraan_huidig_plus.geom,
        CASE
            WHEN (to_timestamp(inspectie.datum_aangemaakt, 'YYYY-MM-DD HH:MI:SS') + brandkraan_huidig_plus.frequentie::double precision * '1 mon'::interval) < now() THEN 'inspecteren'::text
            WHEN (to_timestamp(inspectie.datum_aangemaakt, 'YYYY-MM-DD HH:MI:SS') + (brandkraan_huidig_plus.frequentie - 3)::double precision * '1 mon'::interval) < now() 
            	AND (to_timestamp(inspectie.datum_aangemaakt, 'YYYY-MM-DD HH:MI:SS') + brandkraan_huidig_plus.frequentie::double precision * '1 mon'::interval) > now() THEN 'binnenkort inspecteren'::text
            ELSE COALESCE(inspectie.conditie, 'inspecteren'::text)
        END AS conditie,
    inspectie.inspecteur,
    inspectie.plaatsaanduiding,
    inspectie.plaatsaanduiding_anders,
    inspectie.toegankelijkheid,
    inspectie.toegankelijkheid_anders,
    inspectie.klauw,
    inspectie.klauw_diepte,
    inspectie.klauw_anders,
    inspectie.werking,
    inspectie.werking_anders,
    inspectie.opmerking,
    inspectie.foto,
    inspectie.uitgezet_bij_pwn AS uit_gezet_bij_pwn,
    inspectie.uitgezet_bij_gemeente AS uit_gezet_bij_gemeente,
    inspectie.opmerking_beheerder,
    brandkraan_huidig_plus.inlognaam,
    brandkraan_huidig_plus.gemeentenaam
   FROM bluswater.brandkraan_huidig_plus
     LEFT JOIN bluswater.inspectie ON inspectie.id = (( SELECT leegfreq.id
           FROM bluswater.inspectie leegfreq
          WHERE leegfreq.nen3610id::text = brandkraan_huidig_plus.nen3610id::TEXT AND inspectie.datum_deleted IS NULL
          ORDER BY leegfreq.datum_aangemaakt DESC
         LIMIT 1))
  WHERE brandkraan_huidig_plus.verwijderd = false;
  

ALTER TABLE bluswater.inspectie_klauw_diepte_type ADD COLUMN id serial;
ALTER TABLE bluswater.inspectie_klauw_diepte_type  DROP CONSTRAINT inspectie_klauw_diepte_type_pkey;
ALTER TABLE bluswater.inspectie_klauw_diepte_type  ADD CONSTRAINT inspectie_klauw_diepte_type_pkey PRIMARY KEY (id);

ALTER TABLE bluswater.inspectie_klauw_type ADD COLUMN id serial;
ALTER TABLE bluswater.inspectie_klauw_type  DROP CONSTRAINT inspectie_klauw_type_pkey;
ALTER TABLE bluswater.inspectie_klauw_type  ADD CONSTRAINT inspectie_klauw_type_pkey PRIMARY KEY (id);

ALTER TABLE bluswater.inspectie_plaatsaanduiding_type ADD COLUMN id serial;
ALTER TABLE bluswater.inspectie_plaatsaanduiding_type  DROP CONSTRAINT inspectie_plaatsaanduiding_type_pkey;
ALTER TABLE bluswater.inspectie_plaatsaanduiding_type  ADD CONSTRAINT inspectie_plaatsaanduiding_type_pkey PRIMARY KEY (id);

ALTER TABLE bluswater.inspectie_toegankelijkheid_type ADD COLUMN id serial;
ALTER TABLE bluswater.inspectie_toegankelijkheid_type  DROP CONSTRAINT inspectie_toegankelijkheid_type_pkey;
ALTER TABLE bluswater.inspectie_toegankelijkheid_type  ADD CONSTRAINT inspectie_toegankelijkheid_type_pkey PRIMARY KEY (id);

ALTER TABLE bluswater.inspectie_werking_type ADD COLUMN id serial;
ALTER TABLE bluswater.inspectie_werking_type  DROP CONSTRAINT inspectie_werking_type_pkey;
ALTER TABLE bluswater.inspectie_werking_type  ADD CONSTRAINT inspectie_werking_type_pkey PRIMARY KEY (id);

SET ROLE oiv_admin;

CREATE TABLE bluswater.inspectie_laatste (
	id serial4 NOT NULL,
	geom public.geometry(point, 28992) NULL,
	nen3610id varchar NOT NULL,
	datum_aangemaakt varchar NULL DEFAULT now()::text,
	datum_gewijzigd varchar NULL,
	conditie text NOT NULL DEFAULT 'inspecteren'::text,
	inspecteur text NULL,
	plaatsaanduiding text NULL,
	plaatsaanduiding_anders text NULL,
	toegankelijkheid text NULL,
	toegankelijkheid_anders text NULL,
	klauw text NULL,
	klauw_diepte int2 NULL,
	klauw_anders text NULL,
	werking text NULL,
	werking_anders text NULL,
	opmerking text NULL,
	foto text NULL,
	uitgezet_bij_pwn bool NULL DEFAULT false,
	uitgezet_bij_gemeente bool NULL DEFAULT false,
	opmerking_beheerder text NULL,
	inlognaam text NULL,
	CONSTRAINT inspectie_laatste_pkey PRIMARY KEY (id),
	CONSTRAINT inspectie_laatste_conditie_fkey FOREIGN KEY (conditie) REFERENCES bluswater.enum_conditie(value) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX inspectie_laatste_nen3610id_uindex ON bluswater.inspectie_laatste USING btree (nen3610id);

INSERT INTO bluswater.inspectie_laatste
(geom, nen3610id, conditie, inspecteur, plaatsaanduiding, plaatsaanduiding_anders, toegankelijkheid, toegankelijkheid_anders, klauw, 
	klauw_diepte, klauw_anders, werking, werking_anders, opmerking, foto, uitgezet_bij_pwn, uitgezet_bij_gemeente, opmerking_beheerder, inlognaam)
SELECT brandkraan_huidig_plus.geom,
    brandkraan_huidig_plus.nen3610id,
        CASE
            WHEN (to_timestamp(inspectie.datum_aangemaakt::text, 'YYYY-MM-DD HH24:MI:SS'::text) + brandkraan_huidig_plus.frequentie::double precision * '1 mon'::interval) < now() THEN 'inspecteren'::text
            WHEN (to_timestamp(inspectie.datum_aangemaakt::text, 'YYYY-MM-DD HH24:MI:SS'::text) + (brandkraan_huidig_plus.frequentie - 3)::double precision * '1 mon'::interval) < now() AND (to_timestamp(inspectie.datum_aangemaakt::text, 'YYYY-MM-DD HH24:MI:SS'::text) + brandkraan_huidig_plus.frequentie::double precision * '1 mon'::interval) > now() THEN 'binnenkort inspecteren'::text
            ELSE COALESCE(inspectie.conditie, 'inspecteren'::text)
        END AS conditie,
    inspectie.inspecteur,
    inspectie.plaatsaanduiding,
    inspectie.plaatsaanduiding_anders,
    inspectie.toegankelijkheid,
    inspectie.toegankelijkheid_anders,
    inspectie.klauw,
    inspectie.klauw_diepte,
    inspectie.klauw_anders,
    inspectie.werking,
    inspectie.werking_anders,
    inspectie.opmerking,
    inspectie.foto,
    inspectie.uitgezet_bij_pwn AS uit_gezet_bij_pwn,
    inspectie.uitgezet_bij_gemeente AS uit_gezet_bij_gemeente,
    inspectie.opmerking_beheerder,
    brandkraan_huidig_plus.inlognaam
   FROM bluswater.brandkraan_huidig_plus
     LEFT JOIN bluswater.inspectie ON inspectie.id = (( SELECT leegfreq.id
           FROM bluswater.inspectie leegfreq
          WHERE leegfreq.nen3610id::text = brandkraan_huidig_plus.nen3610id::text AND inspectie.datum_deleted IS NULL
          ORDER BY leegfreq.datum_aangemaakt DESC
         LIMIT 1))
  WHERE brandkraan_huidig_plus.verwijderd = false;

DROP RULE brandkraan_inspectie_ins ON bluswater.inspectie_laatste
CREATE OR REPLACE RULE inspectie_laatste_del AS
ON DELETE TO bluswater.inspectie_laatste DO INSTEAD NOTHING;

CREATE OR REPLACE RULE inspectie_laatste_ins AS
ON INSERT TO bluswater.inspectie_laatste DO INSTEAD NOTHING;

CREATE OR REPLACE RULE inspectie_laatste_upd AS
    ON UPDATE TO bluswater.inspectie_laatste DO ALSO  
    INSERT INTO bluswater.inspectie (nen3610id, conditie, inspecteur, plaatsaanduiding, plaatsaanduiding_anders, toegankelijkheid, toegankelijkheid_anders, klauw, klauw_diepte, klauw_anders, werking, werking_anders, opmerking, foto, uitgezet_bij_pwn, uitgezet_bij_gemeente, opmerking_beheerder, inlognaam)
  	VALUES (new.nen3610id, new.conditie, new.inspecteur, new.plaatsaanduiding, new.plaatsaanduiding_anders, new.toegankelijkheid, new.toegankelijkheid_anders, new.klauw, new.klauw_diepte, new.klauw_anders, new.werking, new.werking_anders, new.opmerking, new.foto, new.uitgezet_bij_pwn, new.uitgezet_bij_gemeente, new.opmerking_beheerder, new.inlognaam);
 
 