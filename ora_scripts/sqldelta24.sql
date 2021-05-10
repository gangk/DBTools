col BEGIN_INTERVAL_TIME format a40
col END_INTERVAL_TIME format a40
select 
ss.sql_id,
sn.BEGIN_INTERVAL_TIME,
sn.END_INTERVAL_TIME,
ss.executions_delta,
ELAPSED_TIME_DELTA/(executions_delta*1000) "Elapsed Average ms",
CPU_TIME_DELTA/(executions_delta*1000) "CPU Average ms",
IOWAIT_DELTA/(executions_delta*1000) "IO Average ms",
BUFFER_GETS_DELTA/executions_delta "Average buffer gets",
DISK_READS_DELTA/executions_delta "Average disk reads"
from 
DBA_HIST_SQLSTAT ss,DBA_HIST_SNAPSHOT sn
where ss.snap_id=sn.snap_id
and 
executions_delta > 100000
and sn.BEGIN_INTERVAL_TIME > sysdate - 1
order by ss.snap_id,ss.sql_id;
