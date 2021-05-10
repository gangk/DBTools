col sample_time for a25
col sid for 99999
col serial# for 999999
col session_type for a5
col sql_id for a13
col plan for 9999999999
col event for a30
col ss for a5
col blksid for 99999
col blkserial for 999999
col blkstate for a2
col module for a25
col machine for a27
accept begin_minutes Prompt 'Enter Minutes Ago:- '
accept end_minutes   Prompt 'Enter Till Minutes (0 to see recent):- '
accept sid           prompt 'Enter Sid:- '
accept serial        prompt 'Enter Serial#:- '
accept sql_id        prompt 'Enter Sql_id:- '
accept is_null       prompt 'Is Null (Y/N):- '
accept event         prompt 'Enter Event:- '
accept module        prompt 'Enter module:- '
accept machine       prompt 'Enter machine:- '


select
sample_time,session_id sid,session_serial# serial#,sql_id,sql_plan_hash_value plan,substr(module,1,25) module,substr(event,1,30) event,substr(session_state,1,5) ss,blocking_session blksid,blocking_session_serial# blkserial,decode(blocking_session_status,'NO HOLDER','NO','UNKNOWN','UN','VALID','VA',blocking_session_status) blkstate,substr(machine,1,27) machine
from
        v$active_session_history
where
        sample_time >= (sysdate - &begin_minutes/14400) and sample_time <= (sysdate - &end_minutes/14400)
and
        event is not null
and
        event not like '%SQL*Net%'
and
        session_id like '%&sid%'
and
        session_serial# like '%&serial%'
and
        (
		sql_id like '%&sql_id%' 
		or
		(
			sql_id is null
			and
			'Y'=upper('&is_null')
		)
	) 
and
        event like '%&event%'
and
        module like '%&module%'
and
        machine like '%&machine%'
and 
	event not in ('db file sequential read','direct path read','db file scattered read')
order by 1;


undef begin_snap_id
undef end_snap_id
undef sid
undef serial
undef sql_id
undef event
undef module
undef machine

