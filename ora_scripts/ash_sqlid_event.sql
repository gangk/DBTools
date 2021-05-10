--
-- given a sql_id, list top 10 wait events (including 'ON CPU')  during the last_x_mins
--
undef sql_id
undef last_x_mins

@plusenv
col tcnt	format 99999	head 'Event|Cnt'
col event 	format a32 	head 'Event'		trunc
col pctcnt	format 999.9	head 'Pct%'
col sqlid_c	format a17	head 'SqlId:Child'
col phash	format 9999999999 head 'Plan Hash'
col obj		format a08	head 'ObjId'
col obj_name	format a65	head 'Object : SubObject'	trunc

break on sqlid_c on phash 
-- top events --
select 	 sqlid_c
	,phash
	,tcnt
	,100*ratio_to_report (tcnt) over (partition by sqlid_c, phash) pctcnt
	,event
	--,obj
	,obj_name
from
(
select	 ash.sql_id||':'||ash.sql_child_number			sqlid_c
	,ash.sql_plan_hash_value				phash
	,decode(ash.session_state,'ON CPU','ON CPU',ash.event)	event
	,decode(ash.session_state,'ON CPU',null,decode(o.object_name,null,to_char(ash.current_obj#),o.owner||'.'||o.object_name||decode(o.subobject_name,null,' ',' : '||subobject_name))) obj_name
     	,sum(decode(ash.session_state,'ON CPU',1,1))     	tcnt
from 	 v$active_session_history 	ash
	,dba_objects			o
where 	 sql_id 		= '&&sql_id'
and 	 sample_time 		>= sysdate - &&last_x_mins/1440
and	 ash.is_sqlid_current	= 'Y'
and	 ash.current_obj#	= o.object_id (+)
--and	 ash.sql_plan_hash_value <> 0
group by ash.sql_id||':'||ash.sql_child_number
	,ash.sql_plan_hash_value				
	,decode(ash.session_state,'ON CPU','ON CPU',ash.event)
	,decode(ash.session_state,'ON CPU',null,decode(o.object_name,null,to_char(ash.current_obj#),o.owner||'.'||o.object_name||decode(o.subobject_name,null,' ',' : '||subobject_name)))
)
order by sqlid_c
	,phash
	,tcnt desc
;

