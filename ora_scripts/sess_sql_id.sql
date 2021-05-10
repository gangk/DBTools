select username,sid,serial#,sql_id,event,module,program,last_call_et from v$session where sid=&sid;
