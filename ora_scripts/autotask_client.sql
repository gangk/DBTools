col client_name format a35
col mean_job_duration format a30

SELECT client_name, status, mean_job_duration
FROM dba_autotask_client;

-- disable stats collection --
--BEGIN
--  dbms_auto_task_admin.disable('auto optimizer stats collection', NULL, NULL);
--END;
--/
