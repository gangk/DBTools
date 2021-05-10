set linesize 32000
set pagesize 1000
set long 2000000000
set longchunksize 1000
set head off;
set verify off;
set termout off;
 
column u new_value us noprint;
column n new_value ns noprint;
 
select name n from v$database;
select user u from dual;
set sqlprompt &ns:&us>

set head on
set echo on
set termout on
set trimspool on

spool &ns.ashsessionlist.log

column PROGRAM format a45
column username format a20
column FIRST_SAMPLE format a26
column LAST_SAMPLE format a26

select * from 
(select 
min(SAMPLE_TIME) first_sample,
max(SAMPLE_TIME) last_sample,
count(*) active_samples,
trunc((to_date(to_char(max(SAMPLE_TIME),'YYYY-MM-DD HH24:MI:SS'),
'YYYY-MM-DD HH24:MI:SS')-
to_date(to_char(min(SAMPLE_TIME),'YYYY-MM-DD HH24:MI:SS'),
'YYYY-MM-DD HH24:MI:SS'))*24*360) possible_samples,
a.INSTANCE_NUMBER,a.SESSION_ID,a.SESSION_SERIAL#,
u.username,
a.PROGRAM
from DBA_HIST_ACTIVE_SESS_HISTORY a, dba_users u
where 
a.user_id=u.user_id and
session_type='FOREGROUND' and
sample_time 
between 
to_date('30-APR-2012 11:35:00','DD-MON-YYYY HH24:MI:SS')
and 
to_date('30-APR-2012 11:45:00','DD-MON-YYYY HH24:MI:SS')
group by 
a.INSTANCE_NUMBER,a.SESSION_ID,a.SESSION_SERIAL#,
u.username,
a.PROGRAM
) sq
where 
sq.first_sample <> sq.last_sample 
order by
sq.active_samples desc,
sq.possible_samples desc;


spool off
