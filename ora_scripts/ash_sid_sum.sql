undef sid
undef last_x_mins
@plusenv
col ash_time format a11
break on sid
select 	 ash.session_id sid
	,to_char(sample_time,'MM/DD HH24:MI') ash_time
     	,sum(decode(ash.session_state,'ON CPU',1,0))     "CPU"
     	,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    "WAIT" 
     	,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    "IO" 
     	,sum(decode(ash.session_state,'ON CPU',1,1))     "TOTAL"
from 	 v$active_session_history ash
	,v$event_name en
where 	 ash.session_id = &&sid 
and	 ash.event#=en.event# (+)
and 	 sample_time >= sysdate - &&last_x_mins/1440
group by ash.session_id
	,to_char(sample_time,'MM/DD HH24:MI') 
order by to_char(sample_time,'MM/DD HH24:MI')
;
