SET TIME ON VERIFY OFF

COLUMN    event                  FORMAT A30         HEADING 'Event'    TRUNCATE
COLUMN    wait_state             FORMAT A7          HEADING 'State'
COLUMN    seconds_in_wait        FORMAT 999999      HEADING 'Time|Waiting'
COLUMN    wait_time              FORMAT 999999      HEADING 'Time|Waited'
COLUMN    p1                     FORMAT A20         HEADING 'P1'       TRUNCATE
COLUMN    p2                     FORMAT A20         HEADING 'P2'       TRUNCATE
COLUMN    p3                     FORMAT A20         HEADING 'P3'       TRUNCATE



SELECT     vsw.event, 
           CASE WHEN vsw.state = 'WAITING' THEN vsw.state
                ELSE 'WAITED'
           END  wait_state, 
           vsw.seconds_in_wait seconds_in_wait,
           vsw.wait_time wait_time, 
           DECODE(vsw.p1text, NULL, NULL, vsw.p1text||'='||vsw.p1) p1, 
           DECODE(vsw.p2text, NULL, NULL, vsw.p2text||'='||vsw.p2) p2, 
           DECODE(vsw.p3text, NULL, NULL, vsw.p3text||'='||vsw.p3) p3 
FROM       v$session_wait vsw
WHERE      vsw.sid = &&user_sid 
/
