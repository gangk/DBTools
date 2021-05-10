select 
  st.SQL_ID 
, st.PLAN_HASH_VALUE 
, sum(st.EXECUTIONS_DELTA) EXECUTIONS
, sum(st.ROWS_PROCESSED_DELTA) CROWS
, trunc(sum(st.CPU_TIME_DELTA)/1000000/60) CPU_MINS
, trunc(sum(st.ELAPSED_TIME_DELTA)/1000000/60)  ELA_MINS
from DBA_HIST_SQLSTAT st
where st.SQL_ID = '&sql_id'
group by st.SQL_ID , st.PLAN_HASH_VALUE
order by st.SQL_ID, CPU_MINS;
