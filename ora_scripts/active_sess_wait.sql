col username for a15
column event format a40
col machine for a20

select nvl(s.username, '(oracle)') AS username,s.sid,s.serial#,p.spid,s.machine,sw.event,s.sql_id,s.logon_time,s.LAST_CALL_ET,sw.wait_time,sw.seconds_in_wait,sw.state from v$session_wait sw,v$session s,V$process p
where s.sid=sw.sid and s.paddr=p.addr and s.status='ACTIVE' AND s.username not in 'oracle' order by seconds_in_wait;
