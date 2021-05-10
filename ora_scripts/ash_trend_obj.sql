@plusenv
col wait	format 9999
col io_t0	format 99999	head '-15m|*IO*'
col io_t3	format 99999	head '-60m|IO'
col io_t2	format 99999	head '-45m|IO'
col io_t1	format 99999	head '-30m|IO'
col tot		format 99999
col rnk		format 99	head 'Rnk'
col delim	format a01	head '|'
col obj#	format 9999999
col obj_name 	format a62 trunc
col pctio	format 999	head 'IO%'
col pctwait	format 999	head 'WAI%'
col pcttot	format 999	head 'TOT%'


with      t3 as
(
select 	 obj#
	,obj_name
	,wait
	,100*ratio_to_report (wait) over () pctwait
	,io
	,100*ratio_to_report (io) over () pctio
	,tot
	,100*ratio_to_report (tot) over () pcttot
	,rownum	rnk
from
(
select 	 ash.current_obj# obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ','-'||subobject_name) obj_name
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
and 	 sample_time 	between sysdate-60/1440 and sysdate-46/1440
group by ash.current_obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ','-'||subobject_name) 
order by sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0)) desc
)
where rownum <=100
)
	,t2 as
(
select 	 obj#
	,obj_name
	,wait
	,100*ratio_to_report (wait) over () pctwait
	,io
	,100*ratio_to_report (io) over () pctio
	,tot
	,100*ratio_to_report (tot) over () pcttot
	,rownum	rnk
from
(
select 	 ash.current_obj# obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ','-'||subobject_name) obj_name
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
and 	 sample_time 	between sysdate-45/1440 and sysdate-31/1440
group by ash.current_obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ','-'||subobject_name) 
order by sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0)) desc
)
where rownum <=100
)
	,t1 as
(
select 	 obj#
	,obj_name
	,wait
	,100*ratio_to_report (wait) over () pctwait
	,io
	,100*ratio_to_report (io) over () pctio
	,tot
	,100*ratio_to_report (tot) over () pcttot
	,rownum	rnk
from
(
select 	 ash.current_obj# obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ','-'||subobject_name) obj_name
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
and 	 sample_time 	between sysdate-30/1440 and sysdate-16/1440
group by ash.current_obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ','-'||subobject_name) 
order by sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0)) desc
)
where rownum <=100
)
	,t0 as
(
select 	 obj#
	,obj_name
	,wait
	,100*ratio_to_report (wait) over () pctwait
	,io
	,100*ratio_to_report (io) over () pctio
	,tot
	,100*ratio_to_report (tot) over () pcttot
	,rownum	rnk
from
(
select 	 ash.current_obj# obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ','-'||subobject_name)  obj_name
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
and 	 sample_time 	between sysdate-15/1440 and sysdate
group by ash.current_obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ','-'||subobject_name) 
order by sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0)) desc
)
where rownum <=20
)
select	 t3.wait	wait
	,t3.pctwait	pctwait
	,t3.io		io_t3
	,t3.pctio	pctio
	,'|'		delim
	,t2.wait	wait
	,t2.pctwait	pctwait
	,t2.io		io_t2
	,t2.pctio	pctio
	,'|'		delim
	,t1.wait	wait
	,t1.pctwait	pctwait
	,t1.io		io_t1
	,t1.pctio	pctio
	,'|'		delim
	--,t0.rnk	rnk
	,t0.obj#	obj#
	,t0.obj_name	obj_name
	,'|'		delim
	,t0.wait	wait
	,t0.pctwait	pctwait
	,t0.io		io_t0
	,t0.pctio	pctio
	,t0.tot		tot
from	 t0
	,t3
	,t2
	,t1
where	 t0.obj#		= t3.obj# (+)
and	 t0.obj#		= t2.obj# (+)
and	 t0.obj#		= t1.obj# (+)
order by t0.rnk
;
