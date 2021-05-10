SELECT 'ALTER SYSTEM KILL SESSION '||''''||sid ||','|| serial#||''''||' immediate;'
FROM v$session WHERE status ='INACTIVE' ORDER BY logon_time;