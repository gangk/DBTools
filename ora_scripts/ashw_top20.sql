REM --------------------------------------------------------------------------------------------------
REM Author: Riyaj Shamsudeen @OraInternals, LLC
REM         www.orainternals.com
REM
REM --------------------------------------------------------------------------------------------------
REM Author: Riyaj Shamsudeen @OraInternals, LLC
REM         www.orainternals.com
REM
REM Functionality: This script is to print top events
REM **************
REM Source  :  DBA_HIST_ACTIVE_SESS_HISTORy warehouse for gv$active_session_history
REM
REM Note : 1. Keep window 160 columns for better visibility.
REM
REM Exectution type: Execute from sqlplus or any other tool.
REM
REM No implied or explicit warranty
REM
REM Please send me an email to rshamsud@orainternals.com, if you enhance this script :-)
REM  This is a open Source code and it is free to use and modify.
REM --------------------------------------------------------------------------------------------------
REM
prompt  ========================================
prompt  Top 30 wait events in the past &&hours hours
prompt  ========================================
REM
set lines 160 pages 100
set verify off
undef hours
select * from (
select  event, instance_number, sample_hr, dense_rank () over (partition by instance_number, sample_hr order by cnt_waiting desc) wait_rnk
from
(
select event,  instance_number,  to_char(sample_time, 'DD-MON-YYYY HH24') sample_hr, 
       sum(decode(ash.session_state,'WAITING',1,0)) cnt_waiting
from  DBA_HIST_ACTIVE_SESS_HISTORY ash
where sample_time > sysdate - &&hours /(24)
group by event ,instance_number , to_char(sample_time, 'DD-MON-YYYY HH24')
order by 3 desc
 )
)
 where wait_rnk <20
order by sample_hr, wait_rnk desc
/
pause 'Press any key to Continue...'
REM
prompt  ===================================================
prompt  Top 30 sql_ids consuming CPUs in the past N hours
prompt  ===================================================
REM
select * from (
select sql_id, instance_number,   sample_hr,
   module, action, cnt_on_cpu, cnt_waiting,
   dense_rank () over (partition by instance_number, sample_hr order by  cnt_on_cpu desc) cpu_rnk,
   dense_rank () over (partition by instance_number, sample_hr order by  cnt_waiting desc) wait_rnk
from (
   select sql_id,  instance_number,   to_char(sample_time, 'DD-MON-YYYY HH24') sample_hr,
      sum(decode(ash.session_state,'ON CPU',1,0))  cnt_on_cpu,
      sum(decode(ash.session_state,'WAITING',1,0)) cnt_waiting ,
      module, action
   from  DBA_HIST_ACTIVE_SESS_HISTORY ash
   where sample_time > sysdate - &&hours /( 24)
   group by sql_id, instance_number, module, action,  to_char(sample_time, 'DD-MON-YYYY HH24')
   order by 3 desc
 )
)
where  wait_rnk <=20 or cpu_rnk <=20
order by sample_hr, cpu_rnk asc
/
