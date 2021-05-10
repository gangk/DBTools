undef last_x_mins
@plusenv
col obj#	format 9999999
col obj_name 	format a65 trunc
col cpu		format 999,999
col wait	format 999,999
col io		format 999,999
col tot		format 9,999,999	head '*TOT*'
col pctwait	format 999.9	head 'WAIT%'
col pctio	format 999.9	head 'IO%'
col pcttot	format 999.9	head 'TOT%'

select 	 obj#
	,obj_name
	,wait
	,100*ratio_to_report (wait) over () pctwait
	,io
	,100*ratio_to_report (io) over () pctio
	,tot
	,100*ratio_to_report (tot) over () pcttot
from
(
select 	 ash.current_obj# obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ',' - '||subobject_name) obj_name
     	,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    wait
     	,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    io
     	,sum(decode(ash.session_state,'ON CPU',1,1))     tot
from 	 v$active_session_history ash
        ,v$event_name en
	,dba_objects o
where 	 current_obj# is not NULL  
and	 current_obj# > 0
and 	 ash.event#=en.event# 
and	 ash.current_obj# = o.object_id
and 	 sample_time >= sysdate - &&last_x_mins/1440
group by current_obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ',' - '||subobject_name)
order by sum(decode(ash.session_state,'ON CPU',1,1)) desc
)
where rownum <=10
;
