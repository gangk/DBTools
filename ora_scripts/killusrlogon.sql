set pagesize 29
set linesize 500
set echo off
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
select 'alter system kill session'||''''||a.sid||','||a.serial#||''''||';'  from v$session a, v$process b 
where 
a.paddr = b.addr AND
a.username <> 'SYS' and
a.status = 'INACTIVE' and
a.type <> 'BACKGROUND' and
to_char(a.logon_time,'DD-MM HH24:MI')<='&logon_time'
order by a.logon_time
/