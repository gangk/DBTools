select username,sid,serial#,sql_id,event,status,logon_time,last_call_et,p1,p2 from v$session where module='&module_name';

