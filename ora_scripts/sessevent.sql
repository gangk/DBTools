col sid format 999
col event format a35
col username for a10 
select  b.sid,
        decode(b.username,null,substr(b.program,18),b.username)username,
        a.event,
	a.total_waits,
	a.total_timeouts,
	a.time_waited,
	a.average_wait,
	a.max_wait,
	a.time_waited_micro
from v$session_event a,v$session b
where b.sid= &sid
and b.sid=a.sid
order by 6 desc;        