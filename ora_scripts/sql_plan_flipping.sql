SELECT st2.SQL_ID ,
  st2.PLAN_HASH_VALUE ,
  st_long.PLAN_HASH_VALUE l_PLAN_HASH_VALUE ,
  st2.CPU_MINS ,
  st_long.CPU_MINS l_CPU_MINS ,
  st2.ELA_MINS ,
  st_long.ELA_MINS l_ELA_MINS ,
  st2.EXECUTIONS ,
  st_long.EXECUTIONS l_EXECUTIONS ,
  st2.CROWS ,
  st_long.CROWS l_CROWS ,
  st2.CPU_MINS_PER_ROW ,
  st_long.CPU_MINS_PER_ROW l_CPU_MINS_PER_ROW
FROM
  (SELECT st.SQL_ID ,
    st.PLAN_HASH_VALUE ,
    SUM(st.EXECUTIONS_DELTA) EXECUTIONS ,
    SUM(st.ROWS_PROCESSED_DELTA) CROWS ,
    TRUNC(SUM(st.CPU_TIME_DELTA)                                         /1000000/60) CPU_MINS ,
    DECODE( SUM(st.ROWS_PROCESSED_DELTA), 0 , 0 , (SUM(st.CPU_TIME_DELTA)/1000000/60)/SUM(st.ROWS_PROCESSED_DELTA) ) CPU_MINS_PER_ROW ,
    TRUNC(SUM(st.ELAPSED_TIME_DELTA)                                     /1000000/60) ELA_MINS
  FROM DBA_HIST_SQLSTAT st
  WHERE 1                     =1
  AND ( st.CPU_TIME_DELTA    !=0
  OR st.ROWS_PROCESSED_DELTA !=0)
  GROUP BY st.SQL_ID,
    st.PLAN_HASH_VALUE
  ) st2,
  (SELECT st.SQL_ID ,
    st.PLAN_HASH_VALUE ,
    SUM(st.EXECUTIONS_DELTA) EXECUTIONS ,
    SUM(st.ROWS_PROCESSED_DELTA) CROWS ,
    TRUNC(SUM(st.CPU_TIME_DELTA)                                         /1000000/60) CPU_MINS ,
    DECODE( SUM(st.ROWS_PROCESSED_DELTA), 0 , 0 , (SUM(st.CPU_TIME_DELTA)/1000000/60)/SUM(st.ROWS_PROCESSED_DELTA) ) CPU_MINS_PER_ROW ,
    TRUNC(SUM(st.ELAPSED_TIME_DELTA)                                     /1000000/60) ELA_MINS
  FROM DBA_HIST_SQLSTAT st
  WHERE 1                                         =1
  AND ( st.CPU_TIME_DELTA                        !=0
  OR st.ROWS_PROCESSED_DELTA                     !=0)
  HAVING TRUNC(SUM(st.CPU_TIME_DELTA)/1000000/60) > 10
  GROUP BY st.SQL_ID,
    st.PLAN_HASH_VALUE
  ) st_long
WHERE 1                                                                            =1
AND st2.SQL_ID                                                                     = st_long.SQL_ID
AND st_long.CPU_MINS_PER_ROW/DECODE(st2.CPU_MINS_PER_ROW,0,1,st2.CPU_MINS_PER_ROW) > 2
ORDER BY l_CPU_MINS DESC,
  st2.SQL_ID,
  st_long.CPU_MINS DESC,
  st2.PLAN_HASH_VALUE;
