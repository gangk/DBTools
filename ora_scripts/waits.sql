col sid    format 9999                          heading "Ses|Id"
col cnt    format 99999                 heading "Cnt"
col event  format a28                   heading "Wait Event" trunc
col state  format a12                   heading "Wait State" trunc
col siw    format 999999                heading "Secs|Waited"
col wt     format 999                   heading "Wt|ms"
col p1txt  format a14                   trunc
col p1     format 9999999999999                 heading "P1"
col p2txt  format a12                   trunc
col p2     format 9999999999999                 heading "P2"
col p3txt  format a11                   trunc
col p3     format 999999                heading "P3"
SELECT   sid
        ,seq#   cnt
        ,event
        ,p1text p1txt
        ,p1
        --,p1raw
        ,state
        ,seconds_in_wait siw
        ,p2text p2txt
        ,p2
        ,p3text p3txt
        ,p3
FROM     v$session_wait
WHERE    event not in ('SQL*Net message from client'
                      ,'Null event'
                      ,'rdbms ipc message'
                      ,'rdbms ipc reply'
                      ,'pmon timer'
                      )
ORDER BY seconds_in_wait desc
;
