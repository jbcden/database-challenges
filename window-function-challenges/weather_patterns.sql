with weather_with_last_occurance_difference as (
select
  type,
  day,
  day - lag(day)
    over (partition by type order by type, day asc)
    as difference
from weather
)
select
  type,
  day,
  difference
from weather_with_last_occurance
group by type
having min(difference)
order by day asc
