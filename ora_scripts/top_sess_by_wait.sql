col program for a25
col CPU for 9999
col IO for 9999
col TOTAL for 99999
col WAIT for 9999
col userid for 99999
col sid for 9999
select * from (
select
     ash.session_id sid,
     ash.session_serial# serial#,
     ash.user_id userid,
     ash.program,
     sum(decode(ash.session_state,'ON CPU',1,0))     "CPU",
     sum(decode(ash.session_state,'WAITING',1,0))    -
     sum(decode(ash.session_state,'WAITING',
        decode(wait_class,'User I/O',1, 0 ), 0))    "WAIT" ,
     sum(decode(ash.session_state,'WAITING',
        decode(wait_class,'User I/O',1, 0 ), 0))    "IO" ,
     sum(decode(session_state,'ON CPU',1,1))     "TOTAL"
from v$active_session_history ash
group by session_id,user_id,session_serial#,program
order by sum(decode(session_state,'ON CPU',1,1)) desc
) where rownum < 10
/

