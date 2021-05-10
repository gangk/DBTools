 SELECT s.sid, s.serial#, s.username, s.program,t.used_ublk, t.used_urec
FROM v$session s, v$transaction t
WHERE s.taddr = t.addr
ORDER BY 5 desc, 6 desc, 1, 2, 3, 4;