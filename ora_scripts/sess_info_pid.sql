SELECT NVL(s.username, '(oracle)') AS username,
        s.osuser,
        s.sid,
        s.serial#,
        p.spid,
        s.status,
        s.module,
        s.terminal,
        s.machine,
        s.program,
        sw.event,sw.wait_time,sw.seconds_in_wait,sw.state,
        TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM   v$session s,
        v$process p,
        v$session_wait sw
WHERE  s.paddr  = p.addr and 
s.sid=sw.sid
and p.spid =&spid
ORDER BY s.username, s.osuser