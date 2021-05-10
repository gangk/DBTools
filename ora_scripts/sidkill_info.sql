set verify off
set serveroutput on size 1000000
set linesize 100
column kill_cmd format a40
column username format a10
ACCEPT sid prompt 'Session ID: '
select t.used_ublk,
used_urec,
log_io,
phy_io,
cr_get,
cr_change,
'ALTER SYSTEM KILL SESSION ''' || sid || ',' || serial# || ''';' kill_cmd,
s.username,s.osuser
from v$transaction t, v$session s
where t.addr = s.taddr
and sid = &sid.;