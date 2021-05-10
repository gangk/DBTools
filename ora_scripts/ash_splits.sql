undef last_x_mins
@plusenv
col event 	format a32 trunc
col sql_id	format a13
col cnt		format 99999
select 	 ash.event	event
	,ash.sql_id	sql_id
	,count(*)	cnt
from 	 v$active_session_history 	ash
        ,v$event_name 			en
where 	 event 	 	is not NULL  
and	 sql_id 	is not NULL
and	 ash.session_state = 'WAITING'
and 	 ash.event#	= en.event# (+)
and	 ash.event 	= 'enq: TX - index contention'
and 	 sample_time 	>= sysdate - &&last_x_mins/1440
group by event
	,sql_id
order by count(*)
;
