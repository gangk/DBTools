col plan_hash_value for 99999999999
accept SQL_ID prompt 'Enter SQL_ID:- '
select  sql_id,
        plan_hash_value,
        child_number,
        IS_OBSOLETE,
        IS_BIND_SENSITIVE,
        IS_BIND_AWARE,
        IS_SHAREABLE,
        round(buffer_gets/decode(nvl(executions,1),0,1,executions)) "buff_gets/exec",
        round(disk_reads/decode(nvl(executions,1),0,1,executions)) "disk_reads/exec",
        round(elapsed_time/(1000000*decode(nvl(executions,1),0,1,executions))) "elapsed_time/exec",
        round(rows_processed/(decode(nvl(executions,1),0,1,executions))) "rows_processed/exec",
        executions,
        SQL_PLAN_BASELINE
from    v$sql
where   sql_id = '&SQL_ID';
undefine SQL_ID

