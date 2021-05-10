col username for a15
column event format a40
col machine for a20
col spid for 999999
col PLAN_HASH_VALUE for 9999999999
select nvl(s.username, '(oracle)') AS username,s.sid,s.serial#,p.spid,sw.event,s.LAST_CALL_ET,sw.wait_time,sw.seconds_in_wait,sw.state,s.sql_id,sq.PLAN_HASH_VALUE from v$session_wait sw,v$session s,V$process p,v$sql sq where s.sid=sw.sid and s.paddr=p.addr and s.status='ACTIVE'  and s.sql_id=sq.sql_id AND s.SQL_HASH_VALUE = sq.HASH_VALUE and s.SQL_CHILD_NUMBER = sq.child_number and s.username not in 'oracle' order by seconds_in_wait;
