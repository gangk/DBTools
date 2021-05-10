col program for a30

SELECT s.sid, s.serial#, s.username, s.program, i.block_changes FROM v$session s, v$sess_io i
    WHERE s.sid = i.sid  and program !='ORACLE.EXE' ORDER BY 5 desc, 1, 2, 3, 4
/
