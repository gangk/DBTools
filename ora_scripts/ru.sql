select sum(EXECUTIONS),sum(BUFFER_GETS),sum(DISK_READS) ,sum(ROWS_PROCESSED),sum(BUFFER_GETS)/sum(EXECUTIONS) "Per Execution Buffer gets", sum(DISK_READS)/sum(EXECUTIONS) "per exec disk reads" from v$sqlarea where sql_id='&sql_id';

select elapsed_time/executions,elapsed_time,executions,cpu_time,plan_hash_value from v$sql where sql_id='&sql_id';

