 select execution_name, execution_start, execution_end, status from dba_advisor_executions where task_name = 'SYS_AUTO_SQL_TUNING_TASK' order by
 execution_start;


select execution_name, count(*) from dba_advisor_objects where task_name= 'SYS_AUTO_SQL_TUNING_TASK' and type = 'SQL' group by execution_name order
by execution_name;