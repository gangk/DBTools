set lines 155
col execs for 999,999,999
col avg_etime for 999,999.999
col avg_lio for 999,999,999.9
col begin_interval_time for a30
col node for 99999
break on plan_hash_value on startup_time skip 1
select ss.snap_id,begin_interval_time, sql_id, plan_hash_value,
nvl(executions_delta,0) execs,
(elapsed_time_delta/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_etime,
(buffer_gets_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta)) avg_lio,
(disk_reads_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta)) avg_phy,
(cpu_time_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta))/1000000 avg_cpu,
(rows_processed_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta)) avg_rows
from DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS
where sql_id = '&sql_id'
and ss.snap_id = s.snap_id
and executions_delta > 0
order by 1, 2, 3
/
undef sql_id
