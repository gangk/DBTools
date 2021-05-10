select event, sql_id, count(*),
avg(time_waited) avg_time_waited
from v$active_session_history
where event like nvl('&event','%more data from%')
group by event, sql_id
order by event, 3
/