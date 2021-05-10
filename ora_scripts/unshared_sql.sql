@plusenv
col sql_text format a60
SELECT count(*), SUBSTR(SQL_TEXT, 1, 60) sql_text
  FROM V$SQLSTATS
 WHERE EXECUTIONS < 3
 GROUP BY SUBSTR(SQL_TEXT, 1, 60)
 HAVING COUNT(*) > 50
order by 1;
