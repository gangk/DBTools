column SNAP_ID format 9999999
column sql_id format a17
column BEGIN_TIME format a15 trunc
column END_TIME format a15 trunc
column Elap_tot_sec format 999,999
column cpu_tot_sec format 999,999
column cpu_secs format 999,999
column Elaps_secs format 999,999
column MilliSec_per_exec format 99,999.999
column Sec_per_exec format 99,999.99
column Elap_Sec_per_exec format 99,999.99 heading 'ELAP|SEC|PER|EXEC'
column execs_total format 999,999
column execs format 999,999
column inst# format 99
column LOADS_TOTAL format 9999
column LOADS_DELTA format 9999
column sql_profile format a30
select
--      s.dbid
        s.instance_number as inst#
        ,s.snap_id
        ,to_char(s.begin_interval_time,'YY-MM-DD:HH24:mi') as BEGIN_TIME
--      ,to_char(s.end_interval_time,'YY-MM-DD:HH24:mi') as END_TIME
        ,sql.sql_id
        ,sql.plan_hash_value
--      ,sql.EXECUTIONS_TOTAL as execs_total
        ,sql.EXECUTIONS_DELTA as execs
--      ,sql.CPU_TIME_TOTAL / 1000000 as cpu_tot_sec
--      ,sql.CPU_TIME_DELTA / 1000000 as cpu_secs
        ,sql.ELAPSED_TIME_DELTA / 1000000 as Elap_tot_sec
--      ,(sql.CPU_TIME_DELTA / sql.EXECUTIONS_DELTA) / 1000000 as Sec_per_exec
--      ,(sql.ELAPSED_TIME_DELTA / sql.EXECUTIONS_DELTA) / 1000000 as Elap_Sec_per_exec
        ,((sql.ELAPSED_TIME_DELTA / 1000000) / sql.EXECUTIONS_DELTA) as Elap_Sec_per_exec
--      ,sql.LOADS_TOTAL
--      ,sql.LOADS_DELTA
        ,sql.SQL_PROFILE
from
        dba_hist_snapshot s
        ,dba_hist_sqlstat sql
where
        s.snap_id=sql.snap_id
        and s.dbid=sql.dbid
        and s.instance_number=sql.instance_number
        and sql.sql_id = '&sql_id'
        and s.begin_interval_time > sysdate - &no_of_days
        and sql.executions_delta <> 0
order by
        s.snap_id
        ,s.instance_number
;
