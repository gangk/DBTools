accept SQL_ID prompt 'Enter SQL_ID:- '
accept num_days prompt 'Enter number of days:- '
col BEGIN_INTERVAL_TIME format a30
col module format a30;
set line 999
set pagesize 999
set verify off;
col  plan_hash_value for 99999999999999
select sql_id, plan_hash_value,child_number, SQL_PLAN_BASELINE, LAST_ACTIVE_TIME, disk_reads/executions , buffer_gets/executions from v$sql where sql_id = '&SQL_ID';

prompt ========
prompt History
prompt ========

select  BEGIN_INTERVAL_TIME,
        sql_id,
        plan_hash_value,
        MODULE,
        sum(EXECUTIONS_DELTA) "Executions",
        sum(BUFFER_GETS_DELTA)/decode(nvl(sum(EXECUTIONS_DELTA),0),0,1,sum(EXECUTIONS_DELTA)) "Buffer_gets/exec",
        sum(DISK_READS_DELTA)/decode(nvl(sum(EXECUTIONS_DELTA),0),0,1,nvl(sum(EXECUTIONS_DELTA),0)) "Disk_reads/exec"
from    dba_hist_sqlstat, dba_hist_snapshot
where   sql_id = '&SQL_ID'
and     dba_hist_sqlstat.snap_id=dba_hist_snapshot.snap_id
and     BEGIN_INTERVAL_TIME > (sysdate - &num_days)
group by BEGIN_INTERVAL_TIME, sql_id, plan_hash_value, MODULE order by 1;

