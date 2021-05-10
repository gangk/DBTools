set lines 170
col client_name		format a35	trunc
col job_status		format a10	trunc
col start_time		format a11	trunc
col start_time_PDT	format a11	trunc
col job_duration	format a20	trunc
SELECT 	 client_name
	,job_status
	,to_char(job_start_time,'MM/DD HH24:MI')	start_time
	,to_char(new_time(job_start_time,'GMT','PDT'),'MM/DD HH24:MI') start_time_PDT
	,job_duration
FROM dba_autotask_job_history
WHERE 	(client_name like '%stats%'
      or client_name like '%advisor%')
and	 job_start_time > sysdate-30
ORDER BY job_start_time;
