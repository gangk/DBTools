col username for a8
col status for a10
col module for a55

select username,sid,serial#,event,status,sql_id,module,last_call_et,logon_time  from v$session where program like 'rman%' and status='ACTIVE';

