begin;

create table weather(
type text,
day integer
);

\copy weather from '/Users/jacobc/projects/database-challenges/window-function-challenges/weather.tsv' with csv delimiter E'\t';


commit;
