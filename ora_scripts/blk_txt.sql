set pagesize 66 linesize 132
set echo on


column sql_text        heading "SQL Text"   format a60 wrap
column object          heading "Object"   format a25 wrap
column username        heading "User"   format a10 wrap

select s.username username,  
       a.sid sid,  
       a.owner||'.'||a.object object,  
       s.lockwait,  
       t.sql_text sql_text 
from   v$sqltext t,  
       v$session s,  
       v$access a 
where  t.address=s.sql_address  
and    t.hash_value=s.sql_hash_value  
and    s.sid = a.sid  
and    a.owner != 'SYS' 
and    upper(substr(a.object,1,2)) != 'V$' 
order by t.piece
/

