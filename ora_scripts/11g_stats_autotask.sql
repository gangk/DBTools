select client_name,status,ATTRIBUTES,WINDOW_GROUP,SERVICE_NAME,MEAN_JOB_DURATION from DBA_AUTOTASK_CLIENT;

select WINDOW_NAME,last_start_date,ACTIVE,ENABLED from DBA_SCHEDULER_WINDOWS;

select CLIENT_NAME,WINDOW_NAME,WINDOW_START_TIME,WINDOW_DURATION,JOBS_STARTED,JOBS_COMPLETED,WINDOW_END_TIME from DBA_AUTOTASK_CLIENT_HISTORY where CLIENT_NAME='auto optimizer stats collection';