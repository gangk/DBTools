column inst format 9999 heading 'inst' justify left
column et format 99,999,999 heading 'Elapsd|Secs' justify left
column username format a15 heading 'User' justify left truncate
column program format a29 heading 'Program' justify left truncate
column machine format a7 heading 'Machine' justify left truncate
column stat format a8 heading 'Session|Status' justify left
column sql_id format a13 heading 'Current|SQL_ID' justify left
column ssid format 999999 heading 'Oracle|Sess|ID' justify right truncate
column sser format 999999 heading 'Oracle|Serial|No' justify left truncate
column service format a9 heading 'Service' justify left truncate
column spid format a7 heading 'UNIX|Proc|ID' justify right truncate
column pu format a8 heading 'O/S|Login|ID' justify left
column su format a8 heading 'Oracle|User ID' justify left

set verify off

select
       s.last_call_et et,
       s.username username,
       s.program,
       s.machine machine,
       s.sql_id sql_id,
       s.sid ssid,
       s.serial# sser,
       s.service_name service,
       lpad(p.spid,7) spid
from v$process p,
     v$session s
where
        p.addr=s.paddr
        and s.username is not null
        and s.status = 'ACTIVE'
order by
        s.last_call_et desc,
        s.username
;
