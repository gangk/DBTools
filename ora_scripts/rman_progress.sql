
select SID,SERIAL#,START_TIME,TOTALWORK, sofar, (sofar/totalwork) * 100 pct_done,
sysdate + TIME_REMAINING/3600/24 end_at
from v$session_longops
where totalwork > sofar
AND opname NOT LIKE '%aggregate%'
AND opname like 'RMAN%'
/

