col JOB_NAME format A20
col log_date format A30
col req_start_date format A20
col actual_start_date format A20
col run_duration format A20
select log_date
,      job_name
,      status
,      error#
,      req_start_date
,      actual_start_date
,      run_duration
from   dba_scheduler_job_run_details where job_name like UPPER('%&job_name%');
