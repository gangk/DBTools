@plusenv
col client_name		format a40
col task_name		format a40
col operation_name	format a40
col status		format a10
select client_name,task_name,operation_name,status
from dba_autotask_task
/
