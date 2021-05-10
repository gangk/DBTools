-- Oracle Database 11gR2: Administration Workshop II
-- Server Technologies Curriculum
SELECT 'Detail Progress Information (per file)'"Detail Data" from dual;
SELECT SID, START_TIME, ELAPSED_SECONDS, TIME_REMAINING
FROM   V$SESSION_LONGOPS
WHERE  OPNAME LIKE 'RMAN%'
AND    OPNAME NOT LIKE '%aggregate%'
AND    TOTALWORK != 0
AND    SOFAR <> TOTALWORK;
SELECT 'Aggregate Progress Information' "Aggregate Data" from dual;
SELECT INST_ID,SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM   GV$SESSION_LONGOPS
WHERE  OPNAME LIKE 'RMAN%'
AND    OPNAME LIKE '%aggregate%'
AND    TOTALWORK != 0
AND    SOFAR <> TOTALWORK;
