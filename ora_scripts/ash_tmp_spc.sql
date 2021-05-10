-- who's using temp space and how much currently
@plusenv
col sid		format 99999
col module 	format a60
col mb 		format 999,999
col qc 		format a5
col hhmmss 	format a10
col sql_id 	format a13

break on hhmmss on qc skip 1 on sid

select 	 to_char(sample_time,'HH24:MI:SS') 	hhmmss
	,decode(qc_session_id,null,'n/a',qc_session_id) 	qc
	,SESSION_ID 				sid
	,TEMP_SPACE_ALLOCATED/(1024*1024) 	mb
	,sql_id					sql_id
	,module
from 	 v$active_session_history 
where 	 TEMP_SPACE_ALLOCATED>0 
and 	 sample_time > sysdate-3/60/1440 
order by sample_time, qc_session_id, SESSION_ID
/
