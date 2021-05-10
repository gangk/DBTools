select count(1) from v$session where status='SNIPED';

select
'alter system kill session '||''''||s.sid||','||to_char(s.serial#)||''''||';'||chr(10)||
'!kill -9 '||p.spid
from v$session s,v$process p
where s.serial# <> 1
and s.status = 'SNIPED'
and s.paddr=p.addr
/