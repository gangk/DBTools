accept SQL_ID prompt 'Enter SQL_ID:- '
accept num_days prompt 'Enter number of days:- '
col BEGIN_INTERVAL_TIME format a30
col module format a30;
set line 999
set pagesize 999
set verify off;

select begin_interval_time, sql_id, plan_hash_value, module, Executions, Buffer_gets, Disk_reads
from (
select  BEGIN_INTERVAL_TIME,
        sql_id,
        plan_hash_value,
        MODULE,
        sum(EXECUTIONS_DELTA) Executions,
        sum(BUFFER_GETS_DELTA)/decode(nvl(sum(EXECUTIONS_DELTA),0),0,1,sum(EXECUTIONS_DELTA)) Buffer_gets,
        sum(DISK_READS_DELTA)/decode(nvl(sum(EXECUTIONS_DELTA),0),0,1,nvl(sum(EXECUTIONS_DELTA),0)) Disk_reads
from    dba_hist_sqlstat, dba_hist_snapshot
where   sql_id = 'agxf7ca9pvx48'
and     dba_hist_sqlstat.snap_id=dba_hist_snapshot.snap_id
and     BEGIN_INTERVAL_TIME > (sysdate - 1)
group by BEGIN_INTERVAL_TIME, sql_id, plan_hash_value, MODULE order by 1
)
order by 5;
