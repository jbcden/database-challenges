begin;

create table patients(
name text,
day integer,
event text);

\copy '/Users/jacobc/projects/database-challenges/window-function-challenges/patients.tsv' delimiter '\t';

commit;
