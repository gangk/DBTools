undef sql_id
@plusenv

col sqlidc	format a16	head 'SqlId:Child'
col ue		format 99	head 'UE'
col ov		format 999	head 'OV'
col latime	format a10	head 'Last Active'
col lapdt	format a10	head 'Last Active|       PDT'
col lltime	format a10	head 'Last Load'
col llpdt	format a10	head 'Last Load|      PDT'
col min_ago	format 99999	head 'Mins|Ago'		trunc
col pcalls	format 99999999	head 'Parse|Calls'
col execs	format 999999999	head 'Execs'
col loads	format 9999999	head 'Loads'
col inv		format 9999999	head 'Invalidations'
col parse_usr	format a09		head 'ParsUsr' 		trunc

select 	 sql_id||':'||child_number 	sqlidc
	,parsing_schema_name		parse_usr
	,users_executing		ue
	,open_versions			ov
	,executions			execs
	,parse_calls			pcalls
	,loads				loads
	,to_char(to_date(last_load_time,'YYYY-MM-DD/HH24:MI:SS'),'MMDD HH24:MI')	lltime
	,to_char(to_date(new_time(last_load_time,'GMT','PDT'),'YYYY-MM-DD/HH24:MI:SS'),'MMDD HH24:MI')	llpdt
	,to_char(last_active_time,'MMDD HH24:MI')    			latime
	,to_char(new_time(last_active_time,'GMT','PDT'),'MMDD HH24:MI')    			lapdt
	,(sysdate-last_active_time)*1440				min_ago
	,invalidations 			inv
from 	 v$sql 
where	 sql_id			= '&&sql_id'
order by invalidations
;
