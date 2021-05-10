SPOOL C:\monitoring_on.sql

SELECT 'ALTER TABLE "' || owner || '"."' || table_name || '" MONITORING;'
FROM   dba_tables
WHERE  owner       = UPPER('&owner')
AND    table_name  = DECODE(UPPER('&tablename_or_enter_all'), 'ALL', table_name, UPPER('&tablename_or_enter_all'))
AND    monitoring != 'YES';

SPOOL OFF

