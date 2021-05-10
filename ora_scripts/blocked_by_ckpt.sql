--
-- Show all sessions (and sql_ids) that were blocked by CKPT in the last 2 hours
-- mainly due to "direct path read"
--
@big_job
@plusenv
col sid		format 99999
col cnt		format 99
col objid	format 99999999
col event	format a32
col module	format a40 	trunc
col machine	format a35	trunc

break on stime on pdt skip 1

select 	 to_char(sample_time,'MM/DD HH24:MI:SS')	stime
	,to_char(new_time(sample_time,'GMT','PDT'),'MM/DD HH24:MI:SS') PDT
	,SESSION_ID				sid
	,BLOCKING_SESSION			bsid
	,SQL_ID					
	,CURRENT_OBJ#				objid
	,event					event
	,module
	,machine
from 	 v$active_session_history
--from 	 DBA_HIST_ACTIVE_SESS_HISTORY
where	 sample_time	> sysdate - 120/1440
--where 	 to_char(new_time(sample_time,'GMT','PDT'),'MM/DD HH24:MI:SS') 	between '08/01 00:00:00' 
--  										    and '08/03 10:00:00'
and	 BLOCKING_SESSION in (select sid from v$session where program like '%CKPT%')
order by sample_time
	,session_id
;
@big_job_off
