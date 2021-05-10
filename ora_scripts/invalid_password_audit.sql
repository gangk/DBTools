  set linesize 140 pagesize 1400
 col os_username for a30
 col userhost for a30
 col terminal for a30

 select os_username, userhost, terminal, username, count (*)
   from dba_audit_trail
  where returncode = 1017
  group by os_username, userhost, username, terminal
  having count (*)> 10
  / 
  
 -- Note that for high database LOGON PER SECOND, if the application configuration file in the database user password is not correct, while the application was launched in the near future if a large number of session log database may lead to frequent dc_users dictionary cache locks, the user can not log in successfully, and the whole instance hang live, the problem of specific visible <row Cache lock Problem> .