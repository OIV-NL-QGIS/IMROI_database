SET role oiv_admin;
SET search_path = objecten, pg_catalog, public;

<<<<<<< HEAD
-- create view t.b.v. de laatste status van de objecten
CREATE OR REPLACE VIEW status_objectgegevens AS 
 SELECT     
    object.id,
    object.formelenaam,
    object.geom,
    object.pand_id,
    object.datum_aangemaakt,
    object.datum_gewijzigd,
    team.naam AS team,
    historie_status.naam AS status
   FROM object
     LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
			FROM historie historie_1
			WHERE historie_1.object_id = object.id
			ORDER BY historie_1.datum_aangemaakt DESC
			LIMIT 1))
     LEFT JOIN algemeen.team ON object.team_id = team.id
     LEFT JOIN historie_status ON historie.historie_status_id = historie_status.id;

-- extract gebruikstype from BAG
CREATE OR REPLACE VIEW bag_gebruikstype AS
	SELECT identificatie, string_agg(gebruiksdoelverblijfsobject::TEXT, ', ') AS gebruikstype 
		FROM 
			(SELECT DISTINCT p.identificatie, vo.gebruiksdoelverblijfsobject FROM bagactueel.pandactueelbestaand p
				INNER JOIN 
					(SELECT * FROM bagactueel.verblijfsobjectpandactueelbestaand vop
						INNER JOIN bagactueel.verblijfsobjectgebruiksdoelactueelbestaand vog ON vop.identificatie = vog.identificatie) vo ON p.identificatie = vo.gerelateerdpand
				INNER JOIN object o ON p.identificatie = o.pand_id) tbl
GROUP BY identificatie;
REVOKE ALL ON TABLE bag_gebruikstype FROM GROUP oiv_write;

-- Vervang gebruikstype in de view objectgegevens
DROP VIEW IF EXISTS view_objectgegevens;

CREATE OR REPLACE VIEW view_objectgegevens AS
	SELECT object.id, formelenaam, object.geom, pand_id, object.datum_aangemaakt, object.datum_gewijzigd, laagstebouw, hoogstebouw, bhvaanwezig, tmo_dekking, dmo_dekking, bijzonderheden, pers_max, pers_nietz_max, bg.gebruikstype, ob.naam AS bouwconstructie, algemeen.team.naam, ROUND(ST_X(object.geom)) AS X, ROUND(ST_Y(object.geom)) AS Y FROM object
		LEFT JOIN historie ON historie.id = 
		((SELECT id FROM historie WHERE historie.object_id = object.id 
		ORDER BY historie.datum_aangemaakt DESC LIMIT 1))
	LEFT JOIN bag_gebruikstype bg ON object.pand_id = bg.identificatie
	LEFT JOIN object_bouwconstructie ob ON object.object_bouwconstructie_id = ob.id
	LEFT JOIN algemeen.team ON object.team_id = algemeen.team.id
	WHERE historie_status_id = 2;
	
-- Vervang gebruikstype in print_objectgegevens
DROP VIEW IF EXISTS print_objectgegevens;

CREATE OR REPLACE VIEW print_objectgegevens AS
SELECT obj.*, bg.gebruikstype, ob.naam AS gebouwconstructie, a.openbareruimtenaam, a.huisnummer, a.huisnummertoevoeging, a.woonplaatsnaam FROM bagactueel.adres a
	INNER JOIN (SELECT object_id, min(gid) AS gid FROM
			(SELECT object_id, a.* FROM bagactueel.adres a 
				INNER JOIN (SELECT b.*, o.id AS object_id FROM object o 
				INNER JOIN bagactueel.verblijfsobjectpandactueelbestaand b ON o.pand_id = b.gerelateerdpand) p 
			ON a.adresseerbaarobject = p.identificatie) adr
			GROUP BY object_id) adr	ON a.gid = adr.gid
	INNER JOIN object obj ON object_id = obj.id
	LEFT JOIN bag_gebruikstype bg ON obj.pand_id = bg.identificatie
	LEFT JOIN object_bouwconstructie ob ON object_bouwconstructie_id = ob.id;
	

REVOKE ALL ON TABLE status_objectgegevens FROM GROUP oiv_write;

-- toevoegen van schadecirkels deze worden gekoppeld aan een gevaarlijke stof
CREATE TABLE schade_cikel_soort
(
	id		SMALLINT PRIMARY KEY NOT NULL,
	naam	TEXT
);
COMMENT ON TABLE schade_cikel_soort IS 'Opzoeklijst voor soort schadecirkel';

-- soorten cirkels vanuit scenarioboek externe veiligheid
INSERT INTO schade_cikel_soort (id, naam) VALUES (1, 'onherstelbare schade en branden');
INSERT INTO schade_cikel_soort (id, naam) VALUES (2, 'zware schade en secundaire branden');
INSERT INTO schade_cikel_soort (id, naam) VALUES (3, 'secundaire branden treden op');
INSERT INTO schade_cikel_soort (id, naam) VALUES (4, 'geen of lichte schade');

CREATE TABLE schade_cirkel 
(
	id 						SERIAL PRIMARY KEY, 
	datum_aangemaakt 		TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
	datum_gewijzigd 		TIMESTAMP WITH TIME ZONE, 
	straal 					INTEGER NOT NULL, 
	soort_cirkel 			INTEGER NOT NULL, 
	opslag_id 				INTEGER NOT NULL,
	CONSTRAINT schade_cirkel_opslag_id_fk FOREIGN KEY (opslag_id) REFERENCES opslag (id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT schade_cirkel_id_fk FOREIGN KEY (soort_cirkel) REFERENCES schade_cikel_soort (id)
);

CREATE OR REPLACE VIEW schade_cirkel_calc AS
	SELECT sc.*, ST_BUFFER(ops.geom, straal) AS geom_cirkel FROM schade_cirkel sc
	LEFT JOIN opslag ops ON sc.opslag_id = ops.id;

REVOKE ALL ON schade_cirkel_calc FROM oiv_write;

-- create view t.b.v. de controle status van de objecten
CREATE OR REPLACE VIEW volgende_update AS 
 SELECT object.id,
    object.formelenaam,
    object.geom,
    object.pand_id,
    historie.datum_aangemaakt,
    object.datum_gewijzigd,
    team.naam AS team,
    historie_status.naam AS status,
    historie_aanpassing.naam AS aanpassing,
    matrix_code,
    actualisatie,
	    historie.datum_aangemaakt::date + '1 year'::interval *
        CASE
            WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
            WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
            WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
            WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
            ELSE NULL::integer
        END::double precision AS volgende_update,
        CASE
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) >= now() THEN 'up-to-date'::text
            WHEN (historie.datum_aangemaakt::date + '1 year'::interval *
            CASE
                WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) < now() THEN 'updaten'::text
            WHEN (historie.datum_aangemaakt::date - '1 mon'::interval * 3::double precision + '1 year'::interval *
            CASE
                WHEN matrix_code.actualisatie::text = 'A'::text THEN 1
                WHEN matrix_code.actualisatie::text = 'B'::text THEN 2
                WHEN matrix_code.actualisatie::text = 'C'::text THEN 4
                WHEN matrix_code.actualisatie::text = 'X'::text OR matrix_code.actualisatie IS NULL THEN 0
                ELSE NULL::integer
            END::double precision) IS NULL THEN 'nog niet gemaakt'::text
            ELSE 'updaten binnen 3 maanden'::text
        END AS conditie
   FROM object
     LEFT JOIN historie ON historie.id = (( SELECT historie_1.id
           FROM historie historie_1
          WHERE historie_1.object_id = object.id AND historie_1.historie_aanpassing_id <> 1
          ORDER BY historie_1.datum_aangemaakt DESC
         LIMIT 1))
     LEFT JOIN algemeen.team ON object.team_id = team.id
     LEFT JOIN historie_status ON historie.historie_status_id = historie_status.id
     LEFT JOIN historie_aanpassing ON historie.historie_aanpassing_id = historie_aanpassing.id
     LEFT JOIN matrix_code ON historie.matrix_code_id = matrix_code.id;

REVOKE ALL ON volgende_update FROM oiv_write;

CREATE OR REPLACE VIEW stavaza_objecten AS 
 SELECT obj.team, obj.totaal, obj.totaal_in_gebruik, obj.totaal_in_concept, obj.totaal_in_archief, obj.totaal_geen_status, obj.totaal_prio_1,
    obj.totaal_prio_2, obj.totaal_prio_3, obj.totaal_prio_4, obj.totaal_zonder_prio, obj.prio_1_in_gebruik, obj.prio_2_in_gebruik,
    obj.prio_3_in_gebruik, obj.prio_4_in_gebruik, obj.prio_1_concept, obj.prio_2_concept, obj.prio_3_concept, obj.prio_4_concept, tg.geom
   FROM ( SELECT o.team,
            count(o.team) AS totaal,
            count(hs.naam) FILTER (WHERE hs.naam = 'in gebruik'::text) AS totaal_in_gebruik,
            count(hs.naam) FILTER (WHERE hs.naam = 'concept'::text) AS totaal_in_concept,
            count(hs.naam) FILTER (WHERE hs.naam = 'archief'::text) AS totaal_in_archief,
            sum(
                CASE
                    WHEN hs.naam IS NULL THEN 1
                    ELSE 0
                END) AS totaal_geen_status,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 1) AS totaal_prio_1,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 2) AS totaal_prio_2,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 3) AS totaal_prio_3,
            count(mc.prio_prod) FILTER (WHERE mc.prio_prod = 4) AS totaal_prio_4,
            sum(
                CASE
                    WHEN mc.prio_prod IS NULL OR mc.matrix_code::text = '999'::text THEN 1
                    ELSE 0
                END) AS totaal_zonder_prio,
            count(hs.naam) FILTER (WHERE hs.naam = 'in gebruik'::text AND mc.prio_prod = 1) AS prio_1_in_gebruik,
            count(hs.naam) FILTER (WHERE hs.naam = 'in gebruik'::text AND mc.prio_prod = 2) AS prio_2_in_gebruik,
            count(hs.naam) FILTER (WHERE hs.naam = 'in gebruik'::text AND mc.prio_prod = 3) AS prio_3_in_gebruik,
            count(hs.naam) FILTER (WHERE hs.naam = 'in gebruik'::text AND mc.prio_prod = 4) AS prio_4_in_gebruik,
            count(hs.naam) FILTER (WHERE hs.naam = 'concept'::text AND mc.prio_prod = 1) AS prio_1_concept,
            count(hs.naam) FILTER (WHERE hs.naam = 'concept'::text AND mc.prio_prod = 2) AS prio_2_concept,
            count(hs.naam) FILTER (WHERE hs.naam = 'concept'::text AND mc.prio_prod = 3) AS prio_3_concept,
            count(hs.naam) FILTER (WHERE hs.naam = 'concept'::text AND mc.prio_prod = 4) AS prio_4_concept
           FROM ( SELECT object.formelenaam,
                    object.pand_id,
                    object.id AS object_id,
                    historie.datum_aangemaakt,
                    historie.historie_aanpassing_id,
                    historie.historie_status_id,
                    historie.matrix_code_id,
                    team.naam AS team
                   FROM object
                     LEFT JOIN objecten.historie ON historie.id = (( SELECT historie_1.id
                           FROM objecten.historie historie_1
                          WHERE historie_1.object_id = object.id
                          ORDER BY historie_1.datum_aangemaakt DESC
                         LIMIT 1))
                     LEFT JOIN object_gebruiktype og ON object.object_gebruiktype_id = og.id
                     LEFT JOIN object_bouwconstructie ob ON object.object_bouwconstructie_id = ob.id
                     LEFT JOIN algemeen.team ON object.team_id = team.id
                  ORDER BY historie.historie_status_id) o
             LEFT JOIN historie_aanpassing ha ON o.historie_aanpassing_id = ha.id
             LEFT JOIN historie_status hs ON o.historie_status_id = hs.id
             LEFT JOIN matrix_code mc ON o.matrix_code_id = mc.id
          GROUP BY o.team) obj
     LEFT JOIN algemeen.team_geo tg ON obj.team::text = tg.team::text;
	 
REVOKE ALL ON stavaza_objecten FROM oiv_write;

-- NOT NULL restricties toevoegen aan tabel historie
INSERT INTO historie_status (id, naam) VALUES (9, 'geen status ingevuld');
UPDATE historie SET historie_status_id = 4 WHERE historie_status_id IS NULL;
ALTER TABLE historie ALTER COLUMN historie_status_id SET NOT NULL;

INSERT INTO historie_aanpassing (id, naam) VALUES (9, 'geen aanpassing ingevuld');
UPDATE historie SET historie_aanpassing_id = 4 WHERE historie_aanpassing_id IS NULL;
ALTER TABLE historie ALTER COLUMN historie_aanpassing_id SET NOT NULL;

UPDATE historie SET matrix_code_id = '999' WHERE matrix_code_id IS NULL;
ALTER TABLE historie ALTER COLUMN matrix_code_id SET NOT NULL;

-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 2;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 10;
=======
-- CREATE bag extent t.b.v. BAG panden in qgis project
-- Upload de nieuwste versie van de BAG eerst, probleem voorloop 0 opgelost vanaf bag versie 02-2018
CREATE TABLE algemeen.bag_extent AS
SELECT b.identificatie, b.pandstatus, b.geovlak FROM algemeen.veiligheidsregio_huidig v
LEFT JOIN bagactueel.pandactueel b ON ST_INTERSECTS(v.geom, b.geovlak)

CREATE INDEX sidx_bag_extent_geom
  ON algemeen.bag_extent
  USING gist
  (geovlak);
  
-- Opruimen oude bag views database


-- Update versie van de applicatie
UPDATE algemeen.applicatie SET sub = 4;
UPDATE algemeen.applicatie SET revisie = 0;
UPDATE algemeen.applicatie SET db_versie = 17;
>>>>>>> Plugin
UPDATE algemeen.applicatie SET datum = now();
