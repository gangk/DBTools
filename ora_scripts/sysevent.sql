

select
event                         ,
total_waits                   ,
time_waited / 100          ,
total_timeouts               ,
average_wait /100       
from
v$system_event
where
event not in (
 'dispatcher timer',
'lock element cleanup',
'Null event',
'parallel query dequeue wait',
'parallel query idle wait - Slaves',
 'pipe get',
'PL/SQL lock timer',
 'pmon timer',
 'rdbms ipc message',
 'slave wait',
  'smon timer',
'SQL*Net break/reset to client',
 'SQL*Net message from client',
 'SQL*Net message to client',
'SQL*Net more data to client',
'virtual circuit status',
'WMON goes to sleep'
 )AND
 event not like 'DFS%'
and
event not like '%done%'
and
event not like '%Idle%'
AND
event not like 'KXFX%'
;

