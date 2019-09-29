begin;

create table patients(
name text,
day integer,
event text);

\copy patients '/Users/jacobc/projects/database-challenges/window-function-challenges/patients.tsv' with csv delimiter E'\t';

commit;
