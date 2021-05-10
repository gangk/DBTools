select 'My Session : ' || s.sid, s.serial#, p.pid, p.spid
from v$session s,  v$process p
where s.paddr=p.addr
and s.sid = (select distinct sid from v$mystat);


select sys_context('USERENV','SID') from dual;