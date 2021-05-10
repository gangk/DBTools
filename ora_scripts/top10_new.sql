column "Gets/Exec" format 999999.9999
column "Reads/Exec" format 999999.9999
column "Rows/Exec" format 999999.9999
column "version_count" format 99999999

Prompt Top 10 by Buffer Gets:

SELECT * FROM
(SELECT substr(sql_text,1,80) sql,
        buffer_gets, executions, buffer_gets/executions "Gets/Exec",
        hash_value,address
   FROM V$SQLAREA
  WHERE buffer_gets > 10000
    AND executions != 0
 ORDER BY buffer_gets DESC)
WHERE rownum <= 10;

Prompt Top 10 by Physical Reads:

SELECT * FROM
(SELECT substr(sql_text,1,80) sql,
        disk_reads, executions, disk_reads/executions "Reads/Exec",
        hash_value,address
   FROM V$SQLAREA
  WHERE disk_reads > 1000
    AND executions != 0
 ORDER BY disk_reads DESC)
WHERE rownum <= 10;

Prompt Top 10 by Executions:

SELECT * FROM
(SELECT substr(sql_text,1,80) sql,
        executions, rows_processed, rows_processed/executions "Rows/Exec",
        hash_value,address
   FROM V$SQLAREA
  WHERE executions > 100
 ORDER BY executions DESC)
WHERE rownum <= 10;

Prompt Top 10 by Parse Calls:

SELECT * FROM
(SELECT substr(sql_text,1,80) sql,
        parse_calls, executions, hash_value,address
   FROM V$SQLAREA
  WHERE parse_calls > 1000
 ORDER BY parse_calls DESC)
WHERE rownum <= 10;

Prompt Top 10 by Sharable Memory:

SELECT * FROM
(SELECT substr(sql_text,1,80) sql,
        sharable_mem, executions, hash_value,address
   FROM V$SQLAREA
  WHERE sharable_mem > 1048576
 ORDER BY sharable_mem DESC)
WHERE rownum <= 10;

Prompt Top 10 by Version Count:

SELECT * FROM
(SELECT substr(sql_text,1,80) sql,
        version_count, executions, hash_value,address
   FROM V$SQLAREA
  WHERE version_count > 20
 ORDER BY version_count DESC)
WHERE rownum <= 10;