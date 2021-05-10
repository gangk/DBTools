select decode(event,'db file scattered read','FTS',
      'latch free','LF','buffer busy waits','BBW','XYZ') event,
sql_text, hash_value, executions, buffer_gets/(decode (executions,0,1,executions)) "Bu/Ex",
s.module||'.'||program||'.'||username module_program_username
from v$session_wait w, v$sqlarea a, v$session s
where s.sid=w.sid
and   s.sql_hash_value=a.hash_value
and   s.sql_address=a.address
and   (w.event in ('db file scattered read','buffer busy waits')
       or (w.event='latch free' and p2 in (
select latch# from v$latch where name in ('cache buffers chains','cache buffers lru chain'))))
and   (w.wait_time=0 or w.state='WAITING')
and   s.sid not in
(select distinct sid from v$mystat)
/
