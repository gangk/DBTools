-- Total Application vs ITS load
REPHEADER PAGE CENTER '***Total Application Load vs Top Modules/Users***'
set line 999
set pagesize 999
set verify off
BREAK ON REPORT
COLUMN DUMMY HEADING ''
with total_app_load as
(select count(1)
from  V$ACTIVE_SESSION_HISTORY
where   SESSION_TYPE != 'BACKGROUND'
and wait_class in ('Application','Commit','Concurrency','Network','User I/O'))
select u.username,l.total_app_load,l.pct_load
from
(select  user_id,
count(1) "module_load",
(select * from total_app_load) total_app_load,
round((count(1)/(select * from total_app_load))*100,2) PCT_LOAD
from  V$ACTIVE_SESSION_HISTORY
where SESSION_TYPE != 'BACKGROUND'
and   wait_class in ('Application','Commit','Concurrency','Network','User I/O')
and   user_id in (select user_id from dba_users where username in ('AFT_INVENTORY','AFT_FFRMUSER','AFT_INBOUNDDOCK_USER','AFT_P2USER'))
group by user_id order by PCT_LOAD desc) l, dba_users u where l.user_id=u.user_id;
REPHEADER OFF

-- Total System Load vs  ITS Load
REPHEADER PAGE CENTER '***Total System Load vs Top Modules/Users***'
set line 999
set pagesize 999
set verify off
BREAK ON REPORT
COLUMN DUMMY HEADING ''
with total_sys_load as
(select count(1)
from  V$ACTIVE_SESSION_HISTORY
where   SESSION_TYPE != 'BACKGROUND')
select u.username,l.total_sys_load,l.pct_load
from
(select  user_id,
count(1) "module_load",
(select * from total_sys_load) total_sys_load,
round((count(1)/(select * from total_sys_load))*100,2) PCT_LOAD
from  V$ACTIVE_SESSION_HISTORY
where 
user_id in (select user_id from dba_users where username in ('AFT_INVENTORY','AFT_FFRMUSER','AFT_INBOUNDDOCK_USER','AFT_P2USER'))
group by user_id order by PCT_LOAD desc) l, dba_users u where l.user_id=u.user_id;
REPHEADER OFF


-- IOPS
REPHEADER PAGE CENTER '***Total IOPS Consumption vs Top Modules/Users***'
set line 999
set pagesize 999
set verify off
BREAK ON REPORT
COLUMN DUMMY HEADING ''
with total_iops_util as
(select count(1)
from  V$ACTIVE_SESSION_HISTORY
where   SESSION_TYPE != 'BACKGROUND'
and wait_class in ('Commit','User I/O'))
select u.username,l.total_iops_util,l.pct_iops_util
from
(select  user_id,
count(1) "module_load",
(select * from total_iops_util) total_iops_util,
round((count(1)/(select * from total_iops_util))*100,2) pct_iops_util
from  V$ACTIVE_SESSION_HISTORY
where SESSION_TYPE != 'BACKGROUND'
and   wait_class in ('Commit','User I/O')
and   user_id in (select user_id from dba_users where username in ('AFT_INVENTORY','AFT_FFRMUSER','AFT_INBOUNDDOCK_USER','AFT_P2USER'))
group by user_id order by pct_iops_util desc) l, dba_users u where l.user_id=u.user_id;
REPHEADER OFF

-- CPU
REPHEADER PAGE CENTER '***Total CPU Consumption vs Top Modules/Users***'
set line 999
set pagesize 999
set verify off
BREAK ON REPORT
COLUMN DUMMY HEADING ''
with total_cpu_util as
(select count(1)
from  V$ACTIVE_SESSION_HISTORY
where   SESSION_TYPE != 'BACKGROUND'
and session_state = 'ON CPU')
select u.username,l.total_cpu_util,l.pct_cpu_util
from
(select  user_id,
count(1) "module_load",
(select * from total_cpu_util) total_cpu_util,
round((count(1)/(select * from total_cpu_util))*100,2) pct_cpu_util
from  V$ACTIVE_SESSION_HISTORY
where SESSION_TYPE != 'BACKGROUND'
and   session_state = 'ON CPU'
and   user_id in (select user_id from dba_users where username in ('AFT_INVENTORY','AFT_FFRMUSER','AFT_INBOUNDDOCK_USER','AFT_P2USER'))
group by user_id order by pct_cpu_util desc) l, dba_users u where l.user_id=u.user_id;
REPHEADER OFF
