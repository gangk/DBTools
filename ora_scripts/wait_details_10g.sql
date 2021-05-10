REM --------------------------------------------------------------------------------------------------
REM Author: Riyaj Shamsudeen @OraInternals, LLC
REM         www.orainternals.com
REM
REM Thanks to Mark Bobak for making script output more readable  
REM Functionality: This script is to show session waits quickly.
REM **************
REM 
REM
REM Note : 1. Keep window 160 columns for better visibility.
REM
REM Exectution type: Execute from sqlplus or any other tool. 
REM
REM 
REM No implied or explicit warranty
REM
REM Please send me an email to rshamsud@orainternals.com, if you enhance this script :-)
REM --------------------------------------------------------------------------------------------------


set lines 120 pages 40
column event format A40
column PID format A10
column P1_P2_P3_TEXT format A40
column username format  A10
column osuser format A10
column event format A30
column sid format 99999
column wait_time format 999
column wait_time format 99
column wis format 9999
set lines 160
select s.sid, to_char(p.spid,'99999') PID,
substr(s.event, 1, 28) event,
substr(s.username,1,15) username,
substr(s.osuser, 1,10) osuser,
s.state,
s.wait_time, s.seconds_in_wait wis,
substr(s.p1text||' '||to_char(s.P1)||'-'||
s.p2text||' '||to_char(s.P2)||'-'||
s.p3text||' '||to_char(s.P3), 1, 45)
P1_P2_P3_TEXT
from v$session s, v$process p
where s.sid=s.sid
and p.addr = s.paddr
and s.username is not null
and event not like '%pipe%'
and event not like 'SQL*Net message from client%'
and event not like 'wait for unread message on%'
and event not like 'queue messages%'
/
