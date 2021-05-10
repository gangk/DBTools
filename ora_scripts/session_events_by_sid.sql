undefine session_id
start rpt140    'Session Events'
col sid    format 9999                          heading "Ses|Id"
col event       format a30
col time_waited format 99999999999999
col total_waits format 999999999999
col avg_wait    format 999999.99
break on sid
SELECT
         sid
        ,event
        ,time_waited
        ,round(average_wait,2) avg_wait
        ,total_waits
        ,total_timeouts
FROM     v$session_event
WHERE    sid    = &&session_id
ORDER BY time_waited desc;
