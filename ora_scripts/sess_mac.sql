col username for a15
col event for a30
col sid for 99999999
col serial# for 999999999
col status for a10
col machine for a36
select s.username,s.sid,s.serial#,p.spid,sw.event,s.LAST_CALL_ET,sw.wait_time,sw.seconds_in_wait,sw.state,s.machine from v$session_wait sw,v$session s,V$process p where s.sid=sw.sid and s.paddr=p.addr and s.machine like '%&machine_name%' order by 6;
