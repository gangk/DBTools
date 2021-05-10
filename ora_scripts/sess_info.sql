set trimspool on
set pagesize 1000
set linesize 190
column since    format a20
column logon    format a20
column event    format a25 truncate
column machine  format a10 truncate
column status   format a10 truncate
column username format a10 truncate
column n format 9999.99
break on machine on report  skip 1
compute sum of sess_count on machine
compute sum of sess_count on report
set time on
spool client.txt append
select 'CFROM' tag,
        to_char(sysdate,'hh24:mi:ss') when,
        machine,
        event,
        seconds_in_wait,
        sql_id,
        prev_sql_id,
        count(*) sess_count,
        to_char(sysdate - (SECONDS_IN_WAIT / (60 * 60 * 24)),'dd-mon-yy hh24:mi:ss') since,
--      next two lines useful if trying to predict a concurrent spike.   1200 being 20 minutes
--      Left over from site specific issue but could be useful.
--      next is last active time + 20 minutes
--      n is a count down to next predicted spike
--        to_char(sysdate - ( (seconds_in_wait ) / (60 * 60 * 24))     + (1200 / (60 * 60 * 24)),'dd-mon-yy hh24:mi:ss')  NEXT ,
--       ((sysdate - (sysdate - ( (seconds_in_wait ) / (60 * 60 * 24)) + (1200 / (60 * 60 * 24)) ) )    * (60 * 60 * 24) ) / 60 n,
        username,
        status,
        state
from v$session
group by machine,
         event,
         seconds_in_wait,
         sql_id,
         prev_sql_id,
         username,
         status,
         state
order by machine,
         username,
         event,
         seconds_in_wait,
         sql_id,
         prev_sql_id,
         status,
         state
/
spool off
