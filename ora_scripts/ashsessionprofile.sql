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

spool &&1..&&2..&&3..&ns.ashsessionprofile.log

column TIME_CATEGORY format a40

-- arguments - instance number, session id(SID), session sequence number

select * from
(select 
case SESSION_STATE
when 'WAITING' then event
else SESSION_STATE
end TIME_CATEGORY,
(count(*)*10) seconds
from DBA_HIST_ACTIVE_SESS_HISTORY a
where 
a.INSTANCE_NUMBER=&&1 and
a.SESSION_ID=&&2 and
a.SESSION_SERIAL#=&&3 and
sample_time 
between 
to_date('30-APR-2012 11:35:00','DD-MON-YYYY HH24:MI:SS')
and 
to_date('30-APR-2012 11:45:00','DD-MON-YYYY HH24:MI:SS')
group by 
case SESSION_STATE
when 'WAITING' then event
else SESSION_STATE
end
union
select 'INACTIVE' TIME_CATEGORY,
(trunc((to_date(to_char(max(SAMPLE_TIME),'YYYY-MM-DD HH24:MI:SS'),
'YYYY-MM-DD HH24:MI:SS')-
to_date(to_char(min(SAMPLE_TIME),'YYYY-MM-DD HH24:MI:SS'),
'YYYY-MM-DD HH24:MI:SS'))*24*360) - count(*))*10 seconds
from DBA_HIST_ACTIVE_SESS_HISTORY a
where 
a.INSTANCE_NUMBER=&&1 and
a.SESSION_ID=&&2 and
a.SESSION_SERIAL#=&&3 and
sample_time 
between 
to_date('30-APR-2012 11:35:00','DD-MON-YYYY HH24:MI:SS')
and 
to_date('30-APR-2012 11:45:00','DD-MON-YYYY HH24:MI:SS')
) q
order by seconds desc;

spool off
exit

                 
        