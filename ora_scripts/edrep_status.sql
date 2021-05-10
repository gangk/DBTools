select j.job as "DBMS Job"
       ,dps.target_table as "Target Table"
       ,dps.pulling_job_sid as "Pulling SID"
       ,dps.synching_job_sid as "Synching SID"
       ,substr(s.sid||','||s.serial#,1,15) as "Session"
from   dba_jobs_running j
join   data_pull_schedules dps on dps.pulling_job_sid = j.sid or dps.synching_job_sid = j.sid
join   v$session s on s.sid = j.sid
/
