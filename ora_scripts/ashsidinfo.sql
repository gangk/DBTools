col wait for 999
col module for a20
col sample_time for a25
col sid for 99999
col serial# for 999999
col session_type for a5
col sql_id for a13
col plan for 9999999999
col event for a30
col blksid for 99999
col blkserial for 999999
col blkstate for a2

accept begin_minutes Prompt 'Enter Minutes Ago:- '
accept end_minutes   Prompt 'Enter Till Minutes (0 to see recent):- '
accept sid           prompt 'Enter Sid:- '

select
        sample_time,session_id sid,session_serial# serial#,sql_id,sql_plan_hash_value plan,substr(module,1,20) module,(wait_time+time_waited)/1000000 Wait,
        substr(event,1,30) event,substr(session_state,1,5) ss,blocking_session blksid,blocking_session_serial# blkserial,decode(blocking_session_status,'NO HOLDER','NO','UNKNOWN','UN','VALID','VA','NOT IN WAIT','NW',blocking_session_status) blkstate
from
       v$active_session_history
where
        sample_time >= (sysdate - &begin_minutes/14400) and sample_time <= (sysdate - &end_minutes/14400)
and
        session_id = &sid
order by 2;

undef begin_minutes
undef end_minutes
undef sid

