SELECT sql_id,PLAN_HASH_VALUE, executions
 , round(elapsed_time /1000000/60/60,1) as elapsed_hours
 , rows_processed
 , round(cpu_time /elapsed_time * 100) as cpu_time_pct
 , round(iowait_time /elapsed_time * 100) as iowait_pct
 , LIO, PIO, direct_writes
 , round(iowait_time /PIO/1000,1) as mili_sec_PIO
 FROM(SELECT sql_id,PLAN_HASH_VALUE
 , sum(EXECUTIONS_DELTA) as executions
 , sum(ROWS_PROCESSED_DELTA) as rows_processed
 , sum(ELAPSED_TIME_DELTA) as elapsed_time
 , sum(CPU_TIME_DELTA) as cpu_time, sum(IOWAIT_DELTA) as iowait_time
 , sum(DIRECT_WRITES_DELTA) as direct_writes
 , sum(BUFFER_GETS_DELTA) as LIO, sum(DISK_READS_DELTA) as PIO
 FROM dba_hist_sqlstat
 WHERE snap_id between &begin_snap_id and &end_snap_id
 AND sql_id = '&sql_id'
 GROUP BY sql_id, PLAN_HASH_VALUE);