PROMPT --Top 20 by CPU/Buffer Gets
 
set linesize 100
set pagesize 100
SELECT * FROM
(SELECT sql_id sql,
        buffer_gets, executions, buffer_gets/executions "Gets/Exec",
        hash_value,address
   FROM V$SQLAREA
  WHERE buffer_gets > 10000 and executions > 0
 ORDER BY buffer_gets DESC)
WHERE rownum <= 20
;
 
PROMPT  --Top 20 by IO/Physical Reads:
 
set linesize 100
set pagesize 100
SELECT * FROM
(SELECT sql_id sql,
        disk_reads, executions, disk_reads/executions "Reads/Exec",
        hash_value,address
   FROM V$SQLAREA
  WHERE disk_reads > 1000 and executions > 0
 ORDER BY disk_reads DESC)
WHERE rownum <= 20
;
 
PROMPT  --Top 20 by Executions:
 
set linesize 100
set pagesize 100
SELECT * FROM
(SELECT sql_id sql,
        executions, rows_processed, rows_processed/executions "Rows/Exec",
        hash_value,address
   FROM V$SQLAREA
  WHERE executions > 100 and executions > 0
 ORDER BY executions DESC)
WHERE rownum <= 20
;
 
