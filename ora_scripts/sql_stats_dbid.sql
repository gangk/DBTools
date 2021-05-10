select
 snap_id,
 EXECUTIONS_DELTA  execs,
 DISK_READS_DELTA  disk,
 BUFFER_GETS_DELTA lio,
 ROWS_PROCESSED_DELTA rws,
 CPU_TIME_DELTA       cpu,
 ELAPSED_TIME_DELTA   elapse,
 IOWAIT_DELTA         io_time,
 APWAIT_DELTA         ap_time,
 CCWAIT_DELTA         cc_time,
 DIRECT_WRITES_DELTA  dio,
 PHYSICAL_READ_REQUESTS_DELTA reads,
 PHYSICAL_WRITE_REQUESTS_DELTA writes
from dba_hist_sqlstat
where sql_id='&sql_id'
and dbid=&dbid
order by snap_id
/