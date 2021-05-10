SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SPOOL D:\kalkulus_index_monitoring.sql

SELECT 'ALTER INDEX "' || i.owner || '"."' || i.index_name || '" MONITORING USAGE;'
FROM   dba_indexes i
WHERE  owner      = UPPER('&1')
AND    table_name = DECODE(UPPER('&2'), 'ALL', table_name, UPPER('&2'));

SPOOL OFF

SET PAGESIZE 18
SET FEEDBACK ON

@D:\kalkulus_index_monitoring.sql
