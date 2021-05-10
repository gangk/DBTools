 col username for  a20
 col program  for  a20
 col osuser for a15



select username,sid,serial#,status,terminal,osuser,program,to_char(logon_time , 'DD-MON-YYYY HH24:MI:SS')  TIME  from v$session;

