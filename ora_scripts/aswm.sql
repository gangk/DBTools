col username for a15
col spid for a10
column event format a35
col module for a35
col machine for a20
col spid for 99999

select nvl(s.username, '(oracle)') AS username,s.sid,s.serial#,p.spid,sw.event,s.LAST_CALL_ET,sw.wait_time,sw.seconds_in_wait,s.module,s.sql_id from v$session_wait sw,v$session s,V$process p
where s.sid=sw.sid and s.paddr=p.addr and s.status='ACTIVE' AND s.username not in 'oracle' order by seconds_in_wait;
