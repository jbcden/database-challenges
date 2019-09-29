with annotated_discharge as (
  select
    name,
    day,
    event,
    (select day
     from patients as events
     where name = patients.name
       and event = 'discharge'
       and patients.day <= day
     order by name, day limit 1) as discharge_day
  from patients
  order by name, day
), annotated_patients as (
  select
    name,
    annotated_discharge.day,
    event,
    first_value(day) over (partition by name, discharge_day order by day) as admit_day,
    discharge_day
  from annotated_discharge
  order by name, annotated_discharge.day
)
select
  name,
  min(admit_day),
  COALESCE(
    (select count(*)
     from annotated_patients ap
     where annotated_patients.name = name
       and annotated_patients.discharge_day = discharge_day
       and event = 'family visit' group by name, discharge_day),
    0
  ) as family_visits,
  discharge_day - min(admit_day) as stay_length
from annotated_patients
where name = 'ahmad'
group by name, discharge_day
order by name, discharge_day
