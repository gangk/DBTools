@plusenv
col module 	format a60 trunc
col cpu		format 999,999	head '*CPU*'
col wait	format 999,999
col io		format 999,999
col tot		format 9,999,999	head 'TOT'
col pctcpu	format 999.9	head 'CPU%'
col pctio	format 999.9	head 'IO%'
col pctwait	format 999.9	head 'WAIT%'
select 	 module
	,cpu
	,100*ratio_to_report (cpu) over () pctcpu
	,wait
	,100*ratio_to_report (wait) over () pctwait
	,io
	,100*ratio_to_report (io) over () pctio
	,tot
from
(
select 	 nvl(module,'['||program||']') 			module
     	,sum(decode(ash.session_state,'ON CPU',1,0))    cpu
     	,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    	wait
     	,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    							io
     	,sum(decode(ash.session_state,'ON CPU',1,1))    tot
from 	 v$active_session_history 	ash
        ,v$event_name 			en
where 	 ash.event#	= en.event# (+)
and 	 sample_time 	>= sysdate - &&last_x_mins/1440
group by nvl(module,'['||program||']')
order by sum(decode(session_state,'ON CPU',1,0))   desc
)
where rownum <=10
;
