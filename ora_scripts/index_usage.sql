col table_name for a25
col index_name for a25
set verify off


SELECT table_name,
       index_name,
       used,
       start_monitoring,
       end_monitoring
FROM   v$object_usage
WHERE  table_name = UPPER('&1')
AND    index_name = DECODE(UPPER('&2'), 'ALL', index_name, UPPER('&2'));
