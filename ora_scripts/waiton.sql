accept EVENT_NAME prompt 'Enter Event Name:- '
set verify off;
col module format a40
col event format a40
set line 999
select sid, serial#, username, module, event, sql_id, status from v$session where event like '%&EVENT_NAME%' order by 5;
