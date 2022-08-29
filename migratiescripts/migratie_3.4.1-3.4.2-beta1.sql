SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

INSERT INTO objecten.object_type (id, naam, symbol_name, "size") VALUES(5, 'Recreatiegebied', '', 0);

ALTER TABLE algemeen.teamlid ADD COLUMN actief boolean;
UPDATE algemeen.teamlid SET actief = True;

CREATE OR REPLACE FUNCTION objecten.func_sleutelkluis_upd()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    DECLARE
        bouwlaag integer := NULL;
        size integer;
        symbol_name TEXT;
        jsonstring JSON;
        bouwlaag_object TEXT := TG_ARGV[0]::TEXT;
    BEGIN 
        IF NEW.applicatie = 'OIV' THEN 
            UPDATE objecten.sleutelkluis SET geom = new.geom, sleutelkluis_type_id = new.sleutelkluis_type_id, rotatie = new.rotatie, label = new.label, aanduiding_locatie = new.aanduiding_locatie, sleuteldoel_type_id = new.sleuteldoel_type_id, 
                    ingang_id = new.ingang_id, fotografie_id = new.fotografie_id
            WHERE (sleutelkluis.id = new.id);
        ELSE
            symbol_name := (SELECT st.symbol_name FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            jsonstring := row_to_json((SELECT d FROM (SELECT new.label, new.aanduiding_locatie, new.sleuteldoel_type_id) d));

            IF bouwlaag_object = 'bouwlaag'::text THEN
                size := (SELECT st."size" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
                bouwlaag := new.bouwlaag;
            ELSE
                size := (SELECT st."size_object" FROM objecten.sleutelkluis_type st WHERE st.id = new.sleutelkluis_type_id);
            END IF;

            INSERT INTO mobiel.werkvoorraad_punt (geom, waarden_new, operatie, brontabel, bron_id, bouwlaag_id, rotatie, SIZE, symbol_name, bouwlaag, fotografie_id, accepted)
            VALUES (new.geom, jsonstring, 'UPDATE', 'sleutelkluis', old.id, new.ingang_id, NEW.rotatie, size, symbol_name, bouwlaag, new.fotografie_id, false);

            IF NOT ST_Equals(new.geom, old.geom) THEN
                INSERT INTO mobiel.werkvoorraad_hulplijnen (geom, bron_id, brontabel, bouwlaag) VALUES (ST_MakeLine(old.geom, new.geom), old.id, 'sleutelkluis', bouwlaag);
            END IF;
        END IF;
        RETURN NEW;
    END;
    $function$
;

CREATE OR REPLACE VIEW objecten.view_bouwlagen
AS 
SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.geom,
    d.datum_aangemaakt,
    d.datum_gewijzigd,
    d.bouwlaag,
    d.bouwdeel,
    d.pand_id,
    part.formelenaam,
    part.object_id,
    part.min_bouwlaag,
    part.max_bouwlaag,
    sub.hoogste_bouwlaag,
    sub.laagste_bouwlaag
   FROM objecten.bouwlagen d
	INNER JOIN 
	  (
	   SELECT DISTINCT formelenaam, o.id AS object_id, ST_MULTI(ST_UNION(t.geom)) as geovlak, min_bouwlaag, max_bouwlaag
	   FROM object o
	    LEFT JOIN historie ON historie.id = ((SELECT id FROM historie WHERE historie.object_id = o.id ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
	    LEFT JOIN terrein t on o.id = t.object_id
	    WHERE status = 'in gebruik' AND (datum_geldig_vanaf <= NOW() OR datum_geldig_vanaf IS NULL) AND (datum_geldig_tot > NOW() OR datum_geldig_tot IS NULL) AND t.datum_deleted IS NULL
	    GROUP BY formelenaam, o.id
	    ) part ON ST_INTERSECTS(d.geom, part.geovlak)
 	INNER JOIN ( SELECT bouwlagen.pand_id, max(bouwlagen.bouwlaag) AS hoogste_bouwlaag, min(bouwlagen.bouwlaag) AS laagste_bouwlaag 
 				 FROM objecten.bouwlagen GROUP BY bouwlagen.pand_id
 			   ) sub ON d.pand_id = sub.pand_id
	WHERE d.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_bouwlaag
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    b.bouwlaag,
    b.bouwdeel,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    op.bouwlaag_id,
    st.symbol_name,
    st.size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.terrein t ON o.id = t.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON st_intersects(t.geom, op.geom)
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
     JOIN objecten.bouwlagen b ON op.bouwlaag_id = b.id
     LEFT OUTER JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND t.datum_deleted IS NULL AND d.datum_deleted IS NULL;

CREATE OR REPLACE VIEW objecten.view_gevaarlijkestof_ruimtelijk
AS SELECT row_number() OVER (ORDER BY d.id) AS gid,
    d.id,
    d.opslag_id,
    d.omschrijving,
    vnnr.vn_nr,
    vnnr.gevi_nr,
    vnnr.eric_kaart,
    d.hoeveelheid,
    d.eenheid,
    d.toestand,
    o.id AS object_id,
    o.formelenaam,
    op.geom,
    op.locatie,
    op.rotatie,
    round(st_x(op.geom)) AS x,
    round(st_y(op.geom)) AS y,
    st.symbol_name,
    st.size_object AS size
   FROM objecten.object o
     JOIN ( SELECT h.object_id
           FROM objecten.historie h
             JOIN ( SELECT historie.object_id,
                    max(historie.datum_aangemaakt) AS maxdatetime
                   FROM objecten.historie
                  WHERE historie.status::text = 'in gebruik'::text
                  GROUP BY historie.object_id) hist ON h.object_id = hist.object_id AND h.datum_aangemaakt = hist.maxdatetime) part ON o.id = part.object_id
     JOIN objecten.gevaarlijkestof_opslag op ON o.id = op.object_id
     JOIN objecten.gevaarlijkestof d ON op.id = d.opslag_id
     LEFT OUTER JOIN objecten.gevaarlijkestof_vnnr vnnr ON d.gevaarlijkestof_vnnr_id = vnnr.id
     JOIN objecten.gevaarlijkestof_opslag_type st ON 'Opslag stoffen'::text = st.naam
  WHERE (o.datum_geldig_vanaf <= now() OR o.datum_geldig_vanaf IS NULL) AND (o.datum_geldig_tot > now() OR o.datum_geldig_tot IS NULL) AND op.datum_deleted IS NULL AND o.datum_deleted IS NULL AND d.datum_deleted IS NULL;

-- public."Brandkranen-landelijk" definition

-- Drop table

-- DROP TABLE public."Brandkranen-landelijk";

CREATE TABLE bluswater.brandkranen_landelijk (
	id              serial4 NOT NULL,
	geom            geometry(point, 28992) NULL,
	bronhouder      varchar NULL,
	nen3610id       varchar NULL,
	volgnummer      varchar NULL,
	kraantype       varchar NULL,
	x               float8 NULL,
	y               float8 NULL,
	status          varchar NULL,
	ligging         varchar NULL,
	spindeltype     varchar NULL,
	diameter        varchar NULL,
	leidingmateriaal varchar NULL,
	datum_aanleg    varchar NULL,
	datum_laatste_inspectie varchar NULL,
	einddatum       varchar NULL,
	adres           varchar NULL,
	beveiligd       varchar NULL,
	gemeentecode    varchar NULL,
	gemeentenaam    varchar NULL,
	soortleiding    varchar NULL,
	mutatiedatum    varchar NULL,
	CONSTRAINT brandkranen_landelijk_pkey PRIMARY KEY (id)
);


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 2;
UPDATE algemeen.applicatie SET db_versie = 342; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();
