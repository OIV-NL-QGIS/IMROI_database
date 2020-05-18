SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

--Drop view i.v.m. concat van categorie en pictogram in OIV project
DROP VIEW view_voorziening_pictogram;

--Herstructureren van alle tabellen door te hernoemen.
--Verwijzing in views gaat automatisch mee.
--Rename alle voorzieningen tabllen naar pictogrammen ivm naams consistency
--Denk erom!: Pas de naam ook aan in je geoserver en gerelateerde producten
ALTER VIEW  volgende_update                 RENAME TO stavaza_volgende_update;
ALTER TABLE voorziening                     RENAME TO pictogram;
ALTER TABLE voorziening_pictogram           RENAME TO pictogram_type;
ALTER VIEW  view_voorzieningen              RENAME TO view_pictogrammen;
ALTER TABLE voorziening_zonder_object       RENAME TO pictogram_zonder_object;
ALTER TABLE voorziening_lijst_zonder_object RENAME TO pictogram_zonder_object_type;
ALTER VIEW  view_voorz_zonder_object        RENAME TO view_pictogram_zonder_object;
ALTER TABLE object_labels                   RENAME TO label;
ALTER TABLE opslag                          RENAME TO gevaarlijkestof_opslag;
ALTER TABLE schade_cirkel                   RENAME TO gevaarlijkestof_schade_cirkel;
ALTER TABLE schade_cirkel_soort             RENAME TO gevaarlijkestof_schade_cirkel_type;
ALTER TABLE matrix_code			            RENAME TO historie_matrix_code;

CREATE TRIGGER trg_set_mutatie BEFORE UPDATE ON gevaarlijkestof_schade_cirkel FOR EACH ROW EXECUTE PROCEDURE set_timestamp('datum_gewijzigd');

--JOIN met cirkel soort
DROP VIEW view_schade_cirkel;
CREATE OR REPLACE VIEW view_schade_cirkel AS 
 SELECT b.formelenaam, b.bouwlaag, sc.id,
    sc.datum_aangemaakt,
    sc.datum_gewijzigd,
    sc.straal,
    sc.soort_cirkel,
    scs.naam AS cirkel_type,
    sc.opslag_id,
    st_buffer(ops.geom, sc.straal::double precision) AS geom_cirkel
   FROM gevaarlijkestof_schade_cirkel sc
     LEFT JOIN gevaarlijkestof_opslag ops ON sc.opslag_id = ops.id
     LEFT JOIN gevaarlijkestof_schade_cirkel_type scs ON sc.soort_cirkel = scs.id
     INNER JOIN (SELECT o.*, bouwlagen.id AS bouwlaag_id, bouwlagen.bouwlaag, bouwlagen.bouwdeel FROM (SELECT formelenaam, object.id, geom FROM object
		LEFT JOIN historie ON historie.id = 
		((SELECT id FROM historie WHERE historie.object_id = object.id 
		ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
		WHERE historie_status_id = 2) o INNER JOIN bouwlagen ON o.id = bouwlagen.object_id) b ON ops.bouwlaag_id = b.bouwlaag_id;

DROP VIEW bluswater.stavaza_gemeente;
CREATE OR REPLACE VIEW bluswater.stavaza_gemeente AS 
 SELECT row_number() OVER (ORDER BY g.gemeentena) AS gid,
    g.gemeentena,
    count(s.conditie) FILTER (WHERE s.conditie = 'inspecteren'::text) AS inspecteren,
    count(s.conditie) FILTER (WHERE s.conditie = 'goedgekeurd'::text) AS goedgekeurd,
    count(s.conditie) FILTER (WHERE s.conditie = 'werkbaar'::text) AS werkbaar,
    count(s.conditie) FILTER (WHERE s.conditie = 'afgekeurd'::text) AS afgekeurd,
    count(s.conditie) FILTER (WHERE s.conditie = 'binnenkort inspecteren'::text) AS binnenkort_inspecteren,
    g.geom
   FROM bluswater.brandkraan_inspectie s
     LEFT JOIN algemeen.gemeente_zonder_wtr g ON st_intersects(s.geom, g.geom)
  GROUP BY g.gemeentena, g.geom;
        
-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 6;
UPDATE algemeen.applicatie SET db_versie = 246; -- db versie == versie_sub_revisie
UPDATE algemeen.applicatie SET datum = now();