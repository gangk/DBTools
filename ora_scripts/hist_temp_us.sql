set lin 200
col machine for a65
accept num_days prompt 'Enter number of days:- '

SELECT * FROM (
  SELECT /*+ PARALLEL */
         count(*) AS count,
         user_id, program, module, machine, sql_id
  FROM SYS.DBA_HIST_ACTIVE_SESS_HISTORY
  WHERE sample_time > sysdate - &num_days
  AND sample_time < sysdate
  AND temp_space_allocated > 1024*1024*1024
  GROUP BY user_id, program, module, machine, sql_id
  ORDER BY count(*) DESC
)
WHERE rownum <= 20
/

column temp_space_allocated format 999,999,999,999
accept SQL_ID prompt 'Enter SQL_ID:- '

SELECT /*+ PARALLEL */
       sql_id, 
       TO_CHAR(sample_time,'DD-MON-YYYY HH24:MI:SS') AS sample_time, 
       temp_space_allocated
FROM SYS.DBA_HIST_ACTIVE_SESS_HISTORY
WHERE sample_time > sysdate - &num_days
AND sample_time < sysdate 
AND sql_id = '&SQL_ID'
ORDER BY sample_time
/
