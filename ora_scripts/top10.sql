PROMPT --Top 10 by Buffer Gets:
 
set linesize 100
set pagesize 100
SELECT * FROM
(SELECT substr(sql_text,1,40) sql,
        buffer_gets, executions, buffer_gets/executions "Gets/Exec",
        hash_value,address
   FROM V$SQLAREA
  WHERE buffer_gets > 10000
 ORDER BY buffer_gets DESC)
WHERE rownum <= 10
;
 
PROMPT  --Top 10 by Physical Reads:
 
set linesize 100
set pagesize 100
SELECT * FROM
(SELECT substr(sql_text,1,40) sql,
        disk_reads, executions, disk_reads/executions "Reads/Exec",
        hash_value,address
   FROM V$SQLAREA
  WHERE disk_reads > 1000
 ORDER BY disk_reads DESC)
WHERE rownum <= 10
;
 
PROMPT  --Top 10 by Executions:
 
set linesize 100
set pagesize 100
SELECT * FROM
(SELECT substr(sql_text,1,40) sql,
        executions, rows_processed, rows_processed/executions "Rows/Exec",
        hash_value,address
   FROM V$SQLAREA
  WHERE executions > 100
 ORDER BY executions DESC)
WHERE rownum <= 10
;
 
PROMPT  --Top 10 by Parse Calls:
 
set linesize 100
set pagesize 100
SELECT * FROM
(SELECT substr(sql_text,1,40) sql,
        parse_calls, executions, hash_value,address
   FROM V$SQLAREA
  WHERE parse_calls > 1000
 ORDER BY parse_calls DESC)
WHERE rownum <= 10
;
 
PROMPT  --Top 10 by Sharable Memory:
 
set linesize 100
set pagesize 100
SELECT * FROM
(SELECT substr(sql_text,1,40) sql,
        sharable_mem, executions, hash_value,address
   FROM V$SQLAREA
  WHERE sharable_mem > 1048576
 ORDER BY sharable_mem DESC)
WHERE rownum <= 10
;
 
 PROMPT  --Top 10 by Version Count:
 
set linesize 100
set pagesize 100
SELECT * FROM
(SELECT substr(sql_text,1,40) sql,
        version_count, executions, hash_value,address
   FROM V$SQLAREA
  WHERE version_count > 20
 ORDER BY version_count DESC)
WHERE rownum <= 10
;
