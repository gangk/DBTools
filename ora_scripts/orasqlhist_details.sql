column SNAP_ID format 9999999
column sql_id format a14
column plan_hash_value heading 'Plan|Hash|Value'
column BEGIN_TIME format a15 trunc heading 'Begin Time'
column END_TIME format a15 trunc
column cpu_tot_sec format 999,999
column cpu_secs format 999,999
column MilliSec_per_exec format 99,999.999
column CPU_per_exec format 99,999.999 heading 'CPU|Per|Exec'
column Elap_per_exec format 99,999.999 heading 'Secs|Per|Exec'
column CWait_per_exec format 9,999,999  heading 'Concur|Wait|per|Exec'
column CLWait_per_exec format 9,999,999 heading 'Clust|Wait|per|Exec'
column Rows_per_exec format 99,999,999 heading 'Rows|Per|Exec'
column Gets_per_exec format 9,999,999 heading 'Gets|Per|Exec'
column execs_total format 999,999
column execs format 999,999
column inst# format 99
column LOADS_TOTAL format 9999
column LOADS_DELTA format 9999
select
--      s.dbid
        s.instance_number as inst#
--        ,s.snap_id
        ,to_char(s.begin_interval_time,'YY-MM-DD:HH24:MI') as BEGIN_TIME
        --,to_char(s.end_interval_time,'YY-MM-DD:HH24') as END_TIME
        ,sql.sql_id
        ,sql.plan_hash_value
--      ,sql.EXECUTIONS_TOTAL as execs_total
        ,sql.EXECUTIONS_DELTA as execs
--      ,sql.CPU_TIME_TOTAL / 1000000 as cpu_tot_sec
--        ,sql.CPU_TIME_DELTA / 1000000 as cpu_secs
        ,(sql.CPU_TIME_DELTA / sql.EXECUTIONS_DELTA) / 1000000 as CPU_per_exec
        ,(sql.ELAPSED_TIME_DELTA / sql.EXECUTIONS_DELTA) / 1000000 as Elap_per_exec
        ,(sql.CCWAIT_DELTA / sql.EXECUTIONS_DELTA) / 1000000 as CWait_per_exec
        ,(sql.CLWAIT_DELTA / sql.EXECUTIONS_DELTA) / 1000000 as CLWait_per_exec
        ,(sql.ROWS_PROCESSED_DELTA / sql.EXECUTIONS_DELTA) as Rows_per_exec
        ,(sql.BUFFER_GETS_DELTA / sql.EXECUTIONS_DELTA) as Gets_per_exec
--      ,sql.LOADS_TOTAL
--      ,sql.LOADS_DELTA
from
        dba_hist_snapshot s
        ,dba_hist_sqlstat sql
where
        s.snap_id=sql.snap_id
        and s.dbid=sql.dbid
        and s.instance_number=sql.instance_number
        and sql.sql_id = '&sql_id'
        and s.begin_interval_time > sysdate - &days
        and sql.executions_delta <> 0
order by
        s.snap_id
        ,s.instance_number
;
