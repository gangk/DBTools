set lines 500
col snap_id for 999999
col sample_time for a25
col sid for 99999
col serial# for 999999
col session_type for a5
col sql_id for a13
col plan for 9999999999
col event for a20
col ss for a4
col blksid for 99999
col blkserial for 999999
col blkstate for a2
col module for a25
accept begin_snap_id Prompt 'Enter Begin Snap Id:- '
accept end_snap_id   Prompt 'Enter End Snap Id:- '
accept sid           prompt 'Enter Sid:- '
accept serial        prompt 'Enter Serial#:- '
accept sql_id        prompt 'Enter Sql_id:- '
accept include_null  prompt 'Enter Include Null(Y/N):- '
accept event         prompt 'Enter Event:- '
accept module        prompt 'Enter module:- '
accept machine       prompt 'Enter machine:- '


select 
snap_id,sample_time,session_id sid,session_serial# serial#,sql_id,sql_plan_hash_value plan,substr(module,1,25) module,substr(event,1,20) event,substr(session_state,1,4) ss,blocking_session blksid,blocking_session_serial# blkserial,decode(blocking_session_status,'NO HOLDER','NO','UNKNOWN','UN','VALID','VA',blocking_session_status) blkstate
from
	dba_hist_active_sess_history
where
	snap_id between &begin_snap_id and &end_snap_id
and
--	event is not null
--and
--	event not like '%SQL*Net%'
--and
	session_id like '%&sid%'
and
	session_serial# like '%&serial%'
and
	(
		sql_id like '%&sql_id%' 
		or 
		(
			sql_id is null and 'Y'=upper('&include_null')
		)
	)
and
	event like '%&event%'
and
	module like '%&module%'
and
	machine like '%&machine%'
order by 2;


undef begin_snap_id
undef end_snap_id
undef sid
undef serial
undef sql_id
undef event
undef module
undef machine


