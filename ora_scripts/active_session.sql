COLUMN username FORMAT A15
col osuser for a15
col module for a15
COLUMN machine FORMAT A30
col program for a20
COLUMN logon_time FORMAT A20

SELECT NVL(s.username, '(oracle)') AS username,
       s.osuser,
       s.sid,
       s.serial#,
       p.spid,
       s.status,
       s.module,
       s.machine,
       s.program,
       TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM   v$session s,
       v$process p
WHERE  s.paddr  = p.addr
AND    s.status = 'ACTIVE'
AND    s.username not in 'oracle'
ORDER BY s.username, s.osuser;


