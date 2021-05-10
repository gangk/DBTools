undef tuning_task
SELECT * FROM dba_sqltune_binds;

exec dbms_sqltune.execute_tuning_task('&&tuning_task');

col execution_name format a15
col operation format a20
col options format a20

SELECT task_id, execution_name, operation, options, cpu_cost, io_cost
FROM dba_sqltune_plans;

set long 100000

SELECT dbms_sqltune.report_tuning_task('&&tuning_task')
FROM dual;
