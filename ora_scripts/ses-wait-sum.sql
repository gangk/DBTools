REM ------------------------------------------------------------------------------------------------
REM $Id: ses-wait-sum.sql,v 1.1 2002/03/14 00:27:49 hien Exp $
REM Author     : Steve Adams (Ixora)
REM              Hien excluded more events, added 10 more "runs" and total column
REM #DESC      : Summary of session waits (20 runs)
REM Usage      : Input parameter: 
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv

column event 	format a30	head 'Event'
column tot 	format 9999	head 'Total'
column t1 	format 999
column t2 	format 999
column t3 	format 999
column t4 	format 999
column t5 	format 999
column t6 	format 999
column t7 	format 999
column t8 	format 999
column t9 	format 999
column t10 	format 999
column t11 	format 999
column t12 	format 999
column t13 	format 999
column t14 	format 999
column t15 	format 999
column t16 	format 999
column t17 	format 999
column t18 	format 999
column t19 	format 999
column t20 	format 999


select /*+ ordered */
  nvl(t1, 0) + nvl(t2, 0) + nvl(t3, 0) + nvl(t4, 0) + nvl(t5, 0) +
  nvl(t6, 0) + nvl(t7, 0) + nvl(t8, 0) + nvl(t9, 0) + nvl(t10,0) +
  nvl(t11,0) + nvl(t12,0) + nvl(t13,0) + nvl(t14,0) + nvl(t15,0) +
  nvl(t16,0) + nvl(t17,0) + nvl(t18,0) + nvl(t19,0) + nvl(t20,0)   tot,
  substr(n.name, 1, 29)  event, 
  t1, t2, t3, t4, t5, t6, t7, t8, t9, t10,
  t11, t12, t13, t14, t15, t16, t17, t18, t19, t20
from
  sys.v_$event_name  n,
  (select event e1, count(*)  t1 from sys.v_$session_wait group by event),
  (select event e2, count(*)  t2 from sys.v_$session_wait group by event),
  (select event e3, count(*)  t3 from sys.v_$session_wait group by event),
  (select event e4, count(*)  t4 from sys.v_$session_wait group by event),
  (select event e5, count(*)  t5 from sys.v_$session_wait group by event),
  (select event e6, count(*)  t6 from sys.v_$session_wait group by event),
  (select event e7, count(*)  t7 from sys.v_$session_wait group by event),
  (select event e8, count(*)  t8 from sys.v_$session_wait group by event),
  (select event e9, count(*)  t9 from sys.v_$session_wait group by event),
  (select event e10, count(*)  t10 from sys.v_$session_wait group by event),
  (select event e11, count(*)  t11 from sys.v_$session_wait group by event),
  (select event e12, count(*)  t12 from sys.v_$session_wait group by event),
  (select event e13, count(*)  t13 from sys.v_$session_wait group by event),
  (select event e14, count(*)  t14 from sys.v_$session_wait group by event),
  (select event e15, count(*)  t15 from sys.v_$session_wait group by event),
  (select event e16, count(*)  t16 from sys.v_$session_wait group by event),
  (select event e17, count(*)  t17 from sys.v_$session_wait group by event),
  (select event e18, count(*)  t18 from sys.v_$session_wait group by event),
  (select event e19, count(*)  t19 from sys.v_$session_wait group by event),
  (select event e20, count(*)  t20 from sys.v_$session_wait group by event)
where
  n.name != 'Null event' and
  n.name != 'rdbms ipc message' and
  n.name != 'pipe get' and
  n.name != 'virtual circuit status' and
  n.name != 'unread message' and
  n.name != 'queue messages' and
  n.name != 'wakeup time manager' and
  n.name != 'Replication Dequeue' and
  n.name != 'PX Deque wait' and
  n.name not like '%timer%' and
  n.name not like 'SQL*Net message from %' and
  e1 (+) = n.name and
  e2 (+) = n.name and
  e3 (+) = n.name and
  e4 (+) = n.name and
  e5 (+) = n.name and
  e6 (+) = n.name and
  e7 (+) = n.name and
  e8 (+) = n.name and
  e9 (+) = n.name and
  e10 (+) = n.name and
  e11 (+) = n.name and
  e12 (+) = n.name and
  e13 (+) = n.name and
  e14 (+) = n.name and
  e15 (+) = n.name and
  e16 (+) = n.name and
  e17 (+) = n.name and
  e18 (+) = n.name and
  e19 (+) = n.name and
  e20 (+) = n.name and
  nvl(t1, 0) + nvl(t2, 0) + nvl(t3, 0) + nvl(t4, 0) + nvl(t5, 0) +
  nvl(t6, 0) + nvl(t7, 0) + nvl(t8, 0) + nvl(t9, 0) + nvl(t10,0) +
  nvl(t11,0) + nvl(t12,0) + nvl(t13,0) + nvl(t14,0) + nvl(t15,0) +
  nvl(t16,0) + nvl(t17,0) + nvl(t18,0) + nvl(t19,0) + nvl(t20,0) > 0
order by
  nvl(t1, 0) + nvl(t2, 0) + nvl(t3, 0) + nvl(t4, 0) + nvl(t5, 0) +
  nvl(t6, 0) + nvl(t7, 0) + nvl(t8, 0) + nvl(t9, 0) + nvl(t10,0) +
  nvl(t11,0) + nvl(t12,0) + nvl(t13,0) + nvl(t14,0) + nvl(t15,0) +
  nvl(t16,0) + nvl(t17,0) + nvl(t18,0) + nvl(t19,0) + nvl(t20,0) 
;
