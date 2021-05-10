undefine event
column module format a20
column event format a30
set linesize 132

SELECT module, event, sql_hash_value, count(*)
  FROM   v$session s, v$session_wait sw
  WHERE  s.sid = sw.sid
  and   event not like ('SQL*Net%')
  group by module, event, sql_hash_value;

