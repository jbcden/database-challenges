with annotated_discharge as (
  select
    patients.name,
    patients.day,
    patients.event,
    discharge.day as discharge_day
  from patients
  left join lateral (
    select events.name, events.day, events.event
    from patients as events
    where events.event = 'discharge'
    and events.name = patients.name
    and events.day >= patients.day
    order by patients.name, patients.day
    limit 1
  )
  as discharge
  on true

  order by patients.name, patients.day
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
  discharge_day,
  count(event) filter (where event = 'family visit') as family_visits,
  discharge_day - min(admit_day) as stay_length
from annotated_patients
where name = 'ahmad'
group by name, discharge_day
order by name, discharge_day
