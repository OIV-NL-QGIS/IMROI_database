ALTER TABLE objecten.object
  ADD COLUMN fotografie_id integer;
alter table objecten.object add CONSTRAINT object_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE objecten.pictogram
  ADD COLUMN fotografie_id integer;
alter table objecten.pictogram add CONSTRAINT pictogram_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE objecten.scheiding
  ADD COLUMN fotografie_id integer;
alter table objecten.scheiding add CONSTRAINT scheiding_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE objecten.gevaarlijkestof_opslag
  ADD COLUMN fotografie_id integer;
alter table objecten.gevaarlijkestof_opslag add CONSTRAINT gevaarlijkestof_opslag_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE objecten.vlakken
  ADD COLUMN fotografie_id integer;
alter table objecten.vlakken add CONSTRAINT vlakken_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE objecten.bouwlagen
  ADD COLUMN fotografie_id integer;
alter table objecten.bouwlagen add CONSTRAINT bouwlagen_fotografie_id_fk FOREIGN KEY (fotografie_id)
      REFERENCES algemeen.fotografie (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;