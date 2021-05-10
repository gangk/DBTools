COLUMN username FORMAT A15

SELECT NVL(s.username, '(oracle)') AS username,
       s.osuser,
       s.sid,
       s.serial#,
       si.block_gets,
       si.consistent_gets,
       si.physical_reads,
       si.block_changes,
       si.consistent_changes
FROM   v$session s,
       v$sess_io si
WHERE  s.sid = si.sid
ORDER BY s.username, s.osuser;
