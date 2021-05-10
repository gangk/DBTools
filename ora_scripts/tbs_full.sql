SET SERVEROUTPUT ON
SET PAGESIZE 1000
SET LINESIZE 255
SET FEEDBACK OFF

PROMPT
PROMPT Tablespaces nearing 0% free
PROMPT ***************************
SELECT a.tablespace_name,
       b.size_mb,
       a.free_mb,
       Trunc((a.free_mb/b.size_mb) * 100) "FREE_%"
FROM   (SELECT tablespace_name,
               Trunc(Sum(bytes)/1024/1024) free_mb
        FROM   dba_free_space
        GROUP BY tablespace_name) a,
       (SELECT tablespace_name,
               Trunc(Sum(bytes)/1024/1024) size_mb
        FROM   dba_data_files
        GROUP BY tablespace_name) b
WHERE  a.tablespace_name = b.tablespace_name
AND    Round((a.free_mb/b.size_mb) * 100,2) < 10
/

PROMPT
SET FEEDBACK ON
SET PAGESIZE 18
