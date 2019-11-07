select
  type,
  day,
  lag(day)
      over (partition by type order by type, day asc),
  day - lag(day)
    over (partition by type order by type, day asc)
    as difference
from weather
