COLUMN username FORMAT A15
COLUMN osuser FORMAT A15
COLUMN sid FORMAT 99999
COLUMN serial# FORMAT 9999999
COLUMN wait_class FORMAT A15
COLUMN state FORMAT A19
COLUMN logon_time FORMAT A20

SELECT NVL(a.username, '(oracle)') AS username,
       a.osuser,
       a.sid,
       a.serial#,
       d.spid AS process_id,
       a.wait_class,
       a.seconds_in_wait,
       a.state,
       a.blocking_session,
       a.blocking_session_status,
       a.module,
       TO_CHAR(a.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM   v$session a,
       v$process d
WHERE  a.paddr  = d.addr
AND    a.status = 'ACTIVE'
AND    a.username not in 'oracle'
ORDER BY 1,2;
