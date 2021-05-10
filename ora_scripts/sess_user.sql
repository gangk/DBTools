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
        TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM   v$session s,
        v$process p
WHERE  s.paddr  = p.addr
and s.username like UPPER('%&username%')
/