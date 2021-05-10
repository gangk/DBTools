---
--- show high frequency sqls (with more than 10000 executions) which were loaded in the last_x_hours
---
undef last_x_hours
@plusenv

col sqlidc	format a16	head 'SqlId:Child'
col ue		format 99	head 'UE'
col ov		format 999	head 'OV'
col latime	format a10	head 'Last Active'
col lapdt	format a10	head 'Last Active|       PDT'
col lltime	format a10	head 'Last Load'
col llpdt	format a10	head 'Last Load|      PDT'
col min_ago	format 99999	head 'Mins|Ago'		trunc
col min_ago_l	format 99999	head 'Mins|Ago'		trunc
col pcalls	format 999999999	head 'Parse|Calls'
col execs	format 999999999	head 'Execs'
col loads	format 9999999	head 'Loads'
col inv		format 9999999	head 'Invs'
col parse_usr	format a09	head 'ParsUsr' 		trunc
col st		format a01	head 'S'		trunc
col lf		format a01		head 'x'

select 	 sql_id||':'||child_number 	sqlidc
	,object_status			st
	,is_obsolete			o
	,is_shareable			s
	,parsing_schema_name		parse_usr
	,users_executing		ue
	,open_versions			ov
	,executions			execs
	,parse_calls			pcalls
	,loads				loads
	,invalidations 			inv
	,to_char(to_date(last_load_time,'YYYY-MM-DD/HH24:MI:SS'),'MMDD HH24:MI')			lltime
	,to_char(to_date(new_time(last_load_time,'GMT','PDT'),'YYYY-MM-DD/HH24:MI:SS'),'MMDD HH24:MI')	llpdt
	,(sysdate-to_date(last_load_time,'YYYY-MM-DD/HH24:MI:SS'))*1440					min_ago_l
	,decode(sign(sysdate-(to_date(last_load_time,'YYYY-MM-DD/HH24:MI:SS')+2/24)),-1,'x',' ')	lf
	,'|'								sep
	,to_char(last_active_time,'MMDD HH24:MI')    			latime
	,to_char(new_time(last_active_time,'GMT','PDT'),'MMDD HH24:MI')	lapdt
	,(sysdate-last_active_time)*1440				min_ago
from 	 v$sql 
where	 parsing_schema_name	not in ('SYS')
and	 last_load_time		>= sysdate - &&last_x_hours/24
and	 executions		>10000
order by executions
;
