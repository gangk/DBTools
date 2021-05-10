set line 999
set pagesize 999
accept sql_id prompt 'Enter SQL_ID:- '
accept days prompt 'Enter days:- '
select to_char(b.BEGIN_INTERVAL_TIME,'DD-Mon-YYYY HH24:MI'), a.sql_id, a.plan_hash_value, a.executions_delta, a.BUFFER_GETS_DELTA/a.executions_delta "buff_gets/exec", a.DISK_READS_DELTA/a.execution
s_delta "disk_reads/exec", a.CPU_TIME_DELTA/a.executions_delta "cpu_time/exec"
from dba_hist_sqlstat a, dba_hist_snapshot b
where a.sql_id = '&SQL_ID'
and a.snap_id = b.snap_id
and b.BEGIN_INTERVAL_TIME > (sysdate - &days)
and a.executions_delta > 0
order by a.snap_id;
