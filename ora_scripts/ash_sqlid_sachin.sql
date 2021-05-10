@ash_sqlid_event

-- @ash_sqlid_plan
-- given a sql_id, count events (including 'ON CPU')  associated with each plan step during the last_x_mins
--

col twait	format 99999	head 'Event|Cnt'
col event 	format a32 	head 'Event'		trunc
col pctwait	format 999.9	head 'Pct%'
col sql_id	format a17	head 'SqlId:Child'
col phash	format 9999999999 head 'Plan Hash'
col pline	format 999	head 'Id'
col poper	format a35	head 'Operation'	trunc
col pobj	format a40	head 'Object'		trunc

break on sql_id on phash on pline on poper skip 1 on pobj 
select 	 sql_id
	,phash
	,pline
	,poper
	,pobj
	,twait
	,100*ratio_to_report (twait) over (partition by sql_id,phash) pctwait
	,event
from
(
select	 ash.sql_id||':'||sql_child_number			sql_id
	,ash.sql_plan_hash_value				phash
	,p.id							pline
	,p.operation||' '||p.options				poper
	,nvl(p.object_owner,o.owner)||'.'||nvl(p.object_name,o.object_name)		pobj
	,decode(ash.session_state,'ON CPU','ON CPU',ash.event)	event
     	,sum(decode(ash.session_state,'ON CPU',1,1))     	twait
from 	 v$active_session_history 	ash
	,v$sql_plan			p
	,dba_objects			o
where 	 ash.sql_id 		= '&&sql_id'
and 	 ash.sample_time 	>= sysdate - &&last_x_mins/1440
and	 ash.is_sqlid_current	= 'Y'
and	 ash.sql_id		= p.sql_id 
and	 ash.sql_child_number	= p.child_number
and	 nvl(ash.sql_plan_line_id,0)	= p.id 
and	 ash.sql_plan_hash_value	= p.plan_hash_value
and	 ash.current_obj#(+)		=o.object_id
group by ash.sql_id||':'||sql_child_number
	,ash.sql_plan_hash_value				
	,p.id
	,p.operation||' '||p.options
	,nvl(p.object_owner,o.owner)||'.'||nvl(p.object_name,o.object_name)
	,decode(ash.session_state,'ON CPU','ON CPU',ash.event)
)
order by sql_id
	,phash
	,pline
	,twait desc
;
