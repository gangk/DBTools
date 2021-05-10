 select inst_id,sid,serial#,event,p1, p2raw, count(*)
  from gv$session
 where event = 'cursor: pin S wait on X'
   and wait_time = 0
 group by inst_id,sid,serial#,event,p1, p2raw;
 
 
 