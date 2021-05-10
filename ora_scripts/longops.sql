COLUMN pct_done         HEADING "%Done"           FORMAT 999,99 ON
COLUMN time_remaining   HEADING "Remain|(sec)"    FORMAT 99,999 ON
COLUMN elapsed_seconds  HEADING "Elapsed|(sec)"   FORMAT 99,999 ON
COLUMN sid              HEADING "SID"             FORMAT 9999 ON
COLUMN username         HEADING "USER"            FORMAT a15 ON
COLUMN OSUSER           HEADING "OSUSER"          FORMAT a20 ON
COLUMN program          HEADING "Program"          FORMAT a20 ON
COLUMN start_time       HEADING "Start Time"      FORMAT a18 ON
COLUMN last_update_time HEADING "Last Update"     FORMAT a18 ON
COLUMN opname           HEADING "Operation"       FORMAT a20 ON
COLUMN target_desc      HEADING "Target|Desc"     FORMAT a20 ON 

SELECT ROUND(l.sofar / l.totalwork *100,   2) pct_done
     , l.time_remaining
     , l.elapsed_seconds
     , s.sid
     , s.username
     , s.osuser
     , s.program
     , TO_CHAR(l.start_time,'DD-MON-YY hh24:mi:ss') start_time
     , TO_CHAR(l.last_update_time,'DD-MON-YY hh24:mi:ss') last_update_Time
     , l.opname
     , l.target_desc
FROM v$session_longops l, v$session s
WHERE time_remaining > 0
and s.sid = l.sid;