select sn.snap_id
,      sn.end_interval_time
,      st.module
,      st.sql_id
,      st.plan_hash_value
,      rows_processed_delta rws
,      executions_delta     execs
,      elapsed_time_delta   elp
,      cpu_time_delta       cpu
,      buffer_gets_delta    gets
,      iowait_delta         io
from   dba_hist_snapshot sn
,      dba_hist_sqlstat  st
where  st.snap_id            = sn.snap_id
and    st.sql_id             = '&SQL_ID'
order by sn.snap_id desc; 



select * from table(dbms_xplan.display_awr('<sql_id>'));
