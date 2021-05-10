set pagesize 29
set linesize 500
column spid format a5
column sid format 9999
column serial# format 999999
column username format A9
column schemaname format A8
column osuser format a14
column machine format a32
column terminal format a10
column logondate format a15
column idletime format 999.99
select a.sid, a.serial#, b.spid, a.process, a.username, a.osuser, a.machine, a.status,to_char(a.logon_time,'DD-MM HH24:MI:SS') LogonDate,(sysdate-a.logon_time)*30 idletime
from v$session a, v$process b 
where 
a.paddr = b.addr and
a.status = 'INACTIVE' and
a.type <> 'BACKGROUND' and
a.username not in 'SYS'
order by idletime
/