col event	format a30
col cnt		format 999,999
col time_waited	format 999,999,999
SELECT   DECODE (session_state, 'WAITING', event, NULL) event,
           session_state, COUNT(*) cnt, SUM (time_waited) time_waited
FROM     v$active_session_history
WHERE    module = '&module'
AND      sample_time > SYSDATE - (3/24)
GROUP BY DECODE (session_state, 'WAITING', event, NULL),
         session_state
ORDER BY time_waited;
