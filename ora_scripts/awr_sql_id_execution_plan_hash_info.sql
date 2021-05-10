select a.snap_id,to_char(b.begin_interval_time,'dd/mm/yy hh24:mi') snap_tm,
a.instance_number,a.plan_hash_value,a.sorts_delta,a.executions_delta,a.disk_reads_delta,
a.buffer_gets_delta,a.rows_processed_delta,a.cpu_time_delta/1000000 cpu_time_delta,
a.elapsed_time_delta/1000000 elapsed_time_delta,
a.iowait_delta/1000000 iowait_delta,
a.clwait_delta/1000000 clwait_delta
from dba_hist_sqlstat a , dba_hist_snapshot b
where a.sql_id='&sql_id'
and a.snap_id=b.snap_id
and a.instance_number=b.instance_number
and a.dbid=b.dbid
order by a.instance_number,a.snap_id desc,a.plan_hash_value
/
