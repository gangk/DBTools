select username,to_char(timestamp,'DD-MM-YY HH24:MI:SS')Time,obj_name,returncode,action_name,sql_text from dba_audit_trail
where action_name in ('LOGON','LOGOFF')
  order by time desc;