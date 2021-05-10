col client_name for a45
col job_name for a25
select client_name,JOB_NAME,JOB_SCHEDULER_STATUS,TASK_NAME,TASK_PRIORITY from DBA_AUTOTASK_CLIENT_JOB;
