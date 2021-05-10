REM --------------------------------------------------------------------------------------------------
REM Author: Riyaj Shamsudeen @OraInternals, LLC
REM         www.orainternals.com
REM
REM Functionality: This script is to print session_state of a named process. It is useful to see what that
REM                process was doing at a specific point in time.
REM **************
REM Source  : gv$active_session_history
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
undef minutes
col sample_time format A25
col st format A40
col P1_P2_P3_TEXT format A40
select sample_time, session_id, event ||' '||session_state st, wait_time, time_Waited, 
substr(s.p1text||' '||to_char(s.P1)||'-'||
s.p2text||' '||to_char(s.P2)||'-'||
s.p3text||' '||to_char(s.P3), 1, 45)
P1_P2_P3_TEXT
 from v$active_session_history s where session_id= (select sid from v$session where program like '%LGWR%')
and sample_time > sysdate - &&minutes /( 60*24)
order by sample_time
/

select
   decode (event , null, 'ON CPU',event) event,
      sum(decode(ash.session_state,'ON CPU',1,0))  cnt_on_cpu,
      sum(decode(ash.session_state,'WAITING',1,0)) cnt_waiting
from  v$active_session_history ash where session_id= (select sid from v$session where program like '%LGWR%')
and sample_time > sysdate - &&minutes /( 60*24)
group by decode (event , null, 'ON CPU',event)
order by  3,2
/
