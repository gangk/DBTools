col name for a40
col username for a10
col value for a40
select a.sid,c.username,a.name,a.value 
from v$ses_optimizer_env a 
join v$sys_optimizer_env b on a.id=b.id 
join v$session c on a.sid=c.sid 
where a.value<>b.value
and c.username is not null
and c.username not in ('SYS','SYSTEM','DBSNMP') 
order by a.sid,a.name;