SET VERIFY OFF

SELECT *
FROM   (SELECT Substr(a.sql_text,1,50) sql_text,sql_id,
               Trunc(a.disk_reads/Decode(a.executions,0,1,a.executions)) reads_per_execution, 
               a.buffer_gets, 
               a.disk_reads, 
               a.executions, 
               a.sorts,
               a.address
        FROM   v$sqlarea a
        ORDER BY 2 DESC)
WHERE  sql_text like 'BEGIN%' and rownum <= &1

SET VERIFY ON
