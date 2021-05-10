SET LINESIZE 200

COLUMN username FORMAT A20
COLUMN module FORMAT A20

SELECT NVL(a.username,'(oracle)') AS username,
       a.module,
       a.program,
       Trunc(b.value/1024) AS memory_kb
FROM   v$session a,
       v$sesstat b,
       v$statname c
WHERE  a.sid = b.sid
AND    b.statistic# = c.statistic#
AND    c.name = 'session pga memory'
ORDER BY b.value DESC