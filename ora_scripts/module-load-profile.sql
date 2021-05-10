-- Total Application vs ITS load
set line 999
set pagesize 999
set verify off
BREAK ON REPORT
COLUMN DUMMY HEADING ''
compute sum of PCT_CPU on REPORT
with total_load as
(select count(1)
from  V$ACTIVE_SESSION_HISTORY
where   SESSION_TYPE != 'BACKGROUND'
and wait_class in ('Application','Commit','Concurrency','Network','User I/O'))
select u.username,l.total_load,l.pct_load
from
(select  user_id,
count(1) "module_load",
(select * from total_load) TOTAL_LOAD,
round((count(1)/(select * from total_load))*100,2) PCT_LOAD
from  V$ACTIVE_SESSION_HISTORY
where SESSION_TYPE != 'BACKGROUND'
and   wait_class in ('Application','Commit','Concurrency','Network','User I/O')
and   user_id in (select user_id from dba_users where username in ('AFT_INVENTORY','AFT_FFRMUSER','AFT_INBOUNDDOCK_USER','AFT_P2USER'))
group by user_id order by PCT_LOAD desc) l, dba_users u where l.user_id=u.user_id;

-- Total System Load vs  ITS Load
set line 999
set pagesize 999
set verify off
BREAK ON REPORT
COLUMN DUMMY HEADING ''
compute sum of PCT_CPU on REPORT
with total_load as
(select count(1)
from  V$ACTIVE_SESSION_HISTORY
where   SESSION_TYPE != 'BACKGROUND')
select u.username,l.total_load,l.pct_load
from
(select  user_id,
count(1) "module_load",
(select * from total_load) TOTAL_LOAD,
round((count(1)/(select * from total_load))*100,2) PCT_LOAD
from  V$ACTIVE_SESSION_HISTORY
where SESSION_TYPE != 'BACKGROUND'
and   user_id in (select user_id from dba_users where username in ('AFT_INVENTORY','AFT_FFRMUSER','AFT_INBOUNDDOCK_USER','AFT_P2USER'))
group by user_id order by PCT_LOAD desc) l, dba_users u where l.user_id=u.user_id;


-- Module wise Load comparison
set line 999
set pagesize 999
set verify off
BREAK ON REPORT
COLUMN DUMMY HEADING ''
compute sum of PCT_CPU on REPORT
with total_cpu as
(select count(1)
from  V$ACTIVE_SESSION_HISTORY
where   SESSION_TYPE != 'BACKGROUND'
and wait_class in ('Application','Commit','Concurrency','Network','User I/O'))
select  module,
count(1) "module_load",
(select * from total_cpu) "total_load",
round((count(1)/(select * from total_cpu))*100,2) PCT_LOAD
from  V$ACTIVE_SESSION_HISTORY
where SESSION_TYPE != 'BACKGROUND'
and   wait_class in ('Application','Commit','Concurrency','Network','User I/O')
group by module order by PCT_LOAD desc;


-- IOPS

set line 999
set pagesize 999
set verify off
BREAK ON REPORT
COLUMN DUMMY HEADING ''
compute sum of PCT_CPU on REPORT
with total_load as
(select count(1)
from  V$ACTIVE_SESSION_HISTORY
where   SESSION_TYPE != 'BACKGROUND'
and wait_class in ('Commit','User I/O'))
select u.username,l.total_load,l.pct_load
from
(select  user_id,
count(1) "module_load",
(select * from total_load) TOTAL_LOAD,
round((count(1)/(select * from total_load))*100,2) PCT_LOAD
from  V$ACTIVE_SESSION_HISTORY
where SESSION_TYPE != 'BACKGROUND'
and   wait_class in ('Commit','User I/O')
and   user_id in (select user_id from dba_users where username in ('AFT_INVENTORY','AFT_FFRMUSER','AFT_INBOUNDDOCK_USER','AFT_P2USER'))
group by user_id order by PCT_LOAD desc) l, dba_users u where l.user_id=u.user_id;


-- CPU

set line 999
set pagesize 999
set verify off
BREAK ON REPORT
COLUMN DUMMY HEADING ''
compute sum of PCT_CPU on REPORT
with total_load as
(select count(1)
from  V$ACTIVE_SESSION_HISTORY
where   SESSION_TYPE != 'BACKGROUND'
and session_state = 'ON CPU')
select u.username,l.total_load,l.pct_load
from
(select  user_id,
count(1) "module_load",
(select * from total_load) TOTAL_LOAD,
round((count(1)/(select * from total_load))*100,2) PCT_LOAD
from  V$ACTIVE_SESSION_HISTORY
where SESSION_TYPE != 'BACKGROUND'
and   session_state = 'ON CPU'
and   user_id in (select user_id from dba_users where username in ('AFT_INVENTORY','AFT_FFRMUSER','AFT_INBOUNDDOCK_USER','AFT_P2USER'))
group by user_id order by PCT_LOAD desc) l, dba_users u where l.user_id=u.user_id;

--IOPS

select METRIC_NAME,MAXVAL,MINVAL,STANDARD_DEVIATION,METRIC_UNIT from v$sysmetric_summary where METRIC_NAME in ('Physical Read Total IO Requests Per Sec','Physical Write Total IO Requests Per Sec');

select BEGIN_TIME,END_TIME,METRIC_NAME,MAXVAL,MINVAL,STANDARD_DEVIATION,METRIC_UNIT from dba_hist_sysmetric_summary where METRIC_NAME in ('Physical Read Total IO Requests Per Sec','Physical Write Total IO Requests Per Sec') and BEGIN_TIME > sysdate - 8/24;
