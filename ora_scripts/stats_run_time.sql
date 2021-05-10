column job_name format a20
column status format a12
column actual_start_date format a36
column run_duration format a14

select
        job_name, status, actual_start_date, run_duration
from
        dba_scheduler_job_run_details
where
        job_name = 'GATHER_STATS_JOB'
order by
        actual_start_date
;