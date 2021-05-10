@plusenv
col sql_id	format a17	head 'SqlId:Child'
col cpu_t0	format 9999	head '-15m|*CPU*'
col cpu_t1	format 9999	head '-30m|CPU'
col cpu_t2	format 9999	head '-45m|CPU'
col cpu_t3	format 9999	head '-60m|CPU'
col wait	format 9999
col io		format 99999
col tot		format 99999
col pctcpu	format 999	head 'CPU%'
col pctio	format 999	head 'IO%'
col rnk		format 99	head 'Rnk'
col delim	format a01	head '|'

with      t3 as
(
select 	 sql_id
	,cpu
	,100*ratio_to_report (cpu) over () pctcpu
	,wait
	,io
	,100*ratio_to_report (io) over () pctio
	,tot
	,rownum	rnk
from
(
select	 ash.sql_id||':'||ash.sql_child_number			sql_id
     	,sum(decode(ash.session_state,'ON CPU',1,0))     cpu
     	,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    wait
     	,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    io
     	,sum(decode(ash.session_state,'ON CPU',1,1))     tot
from 	 v$active_session_history ash
        ,v$event_name en
where 	 ash.sql_id 	is not NULL  
and 	 ash.event#	= en.event# (+)
and 	 sample_time 	between sysdate-60/1440 and sysdate-46/1440
group by ash.sql_id||':'||ash.sql_child_number
order by sum(decode(session_state,'ON CPU',1,0))   desc
)
where rownum <=100
)
	,t2 as
(
select 	 sql_id
	,cpu
	,100*ratio_to_report (cpu) over () pctcpu
	,wait
	,io
	,100*ratio_to_report (io) over () pctio
	,tot
	,rownum	rnk
from
(
select	 ash.sql_id||':'||ash.sql_child_number			sql_id
     	,sum(decode(ash.session_state,'ON CPU',1,0))     cpu
     	,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    wait
     	,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    io
     	,sum(decode(ash.session_state,'ON CPU',1,1))     tot
from 	 v$active_session_history ash
        ,v$event_name en
where 	 ash.sql_id 	is not NULL  
and 	 ash.event#	= en.event# (+)
and 	 sample_time 	between sysdate-45/1440 and sysdate-31/1440
group by ash.sql_id||':'||ash.sql_child_number
order by sum(decode(session_state,'ON CPU',1,0))   desc
)
where rownum <=100
)
	,t1 as
(
select 	 sql_id
	,cpu
	,100*ratio_to_report (cpu) over () pctcpu
	,wait
	,io
	,100*ratio_to_report (io) over () pctio
	,tot
	,rownum	rnk
from
(
select	 ash.sql_id||':'||ash.sql_child_number			sql_id
     	,sum(decode(ash.session_state,'ON CPU',1,0))     cpu
     	,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    wait
     	,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    io
     	,sum(decode(ash.session_state,'ON CPU',1,1))     tot
from 	 v$active_session_history ash
        ,v$event_name en
where 	 ash.sql_id 	is not NULL  
and 	 ash.event#	= en.event# (+)
and 	 sample_time 	between sysdate-30/1440 and sysdate-16/1440
group by ash.sql_id||':'||ash.sql_child_number
order by sum(decode(session_state,'ON CPU',1,0))   desc
)
where rownum <=100
)
	,t0 as
(
select 	 sql_id
	,cpu
	,100*ratio_to_report (cpu) over () pctcpu
	,wait
	,io
	,100*ratio_to_report (io) over () pctio
	,tot
	,rownum	rnk
from
(
select	 ash.sql_id||':'||ash.sql_child_number			sql_id
     	,sum(decode(ash.session_state,'ON CPU',1,0))     cpu
     	,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    wait
     	,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    io
     	,sum(decode(ash.session_state,'ON CPU',1,1))     tot
from 	 v$active_session_history ash
        ,v$event_name en
where 	 ash.sql_id 	is not NULL  
and 	 ash.event#	= en.event# (+)
and 	 sample_time 	between sysdate-15/1440 and sysdate
group by ash.sql_id||':'||ash.sql_child_number
order by sum(decode(session_state,'ON CPU',1,0))   desc
)
where rownum <=20
)
select	 t3.cpu		cpu_t3
	,t3.pctcpu	pctcpu
	,t3.wait	wait
	,t3.io		io
	,t3.pctio	pctio
	,t3.tot		tot
	,'|'		delim
	,t2.cpu		cpu_t2
	,t2.pctcpu	pctcpu
	,t2.wait	wait
	,t2.io		io
	,t2.pctio	pctio
	,t2.tot		tot
	,'|'		delim
	,t1.cpu		cpu_t1
	,t1.pctcpu	pctcpu
	,t1.wait	wait
	,t1.io		io
	,t1.pctio	pctio
	,t1.tot		tot
	,'|'		delim
	,t0.rnk		rnk
	,t0.sql_id	sql_id
	,'|'		delim
	,t0.cpu		cpu_t0
	,t0.pctcpu	pctcpu
	,t0.wait	wait
	,t0.io		io
	,t0.pctio	pctio
	,t0.tot		tot
from	 t0
	,t1
	,t2
	,t3
where	 t0.sql_id	= t3.sql_id (+)
and	 t0.sql_id	= t2.sql_id (+)
and	 t0.sql_id	= t1.sql_id (+)
order by t0.rnk
;
