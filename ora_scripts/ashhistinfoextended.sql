set lines 500
col snap_id for 999999
col sample_time for a18
col sid for 99999
col serial# for 999999
col session_type for a5
col sql_id for a13
col plan for 9999999999
col event for a20
col ss for a4
col blksid for 99999
col blkserial for 99999
col sblksid for 99999
col sblkser for 99999
col blkstate for a2
col module for a25
col blksql for a13
col sblkst for a2
accept begin_snap_id Prompt 'Enter Begin Snap Id:- '
accept end_snap_id   Prompt 'Enter End Snap Id:- '
accept sid           prompt 'Enter Sid:- '
accept serial        prompt 'Enter Serial#:- '
accept sql_id        prompt 'Enter Sql_id:- '
accept event         prompt 'Enter Event:- '
accept module        prompt 'Enter module:- '
accept machine       prompt 'Enter machine:- '


select 
a.snap_id,substr(a.sample_time,1,18) sample_time,a.session_id sid,a.session_serial# serial#,a.sql_id,a.sql_plan_hash_value plan,substr(a.module,1,25) module,substr(a.event,1,20) event,substr(a.session_state,1,4) ss,a.blocking_session blksid,a.blocking_session_serial# blkserial,decode(a.blocking_session_status,'NO HOLDER','NO','UNKNOWN','UN','VALID','VA','NOT IN WAIT','NW',a.blocking_session_status) blkstate,b.sql_id blksql,b.blocking_session sblksid,b.blocking_session_serial# sblkser,decode(b.blocking_session_status,'NO HOLDER','NO','UNKNOWN','UN','VALID','VA','NOT IN WAIT','NW',b.blocking_session_status) sblkst
from
	dba_hist_active_sess_history a,dba_hist_active_sess_history b
where
	a.snap_id between &begin_snap_id and &end_snap_id
and
	a.event is not null
and
	a.event not like '%SQL*Net%'
and
	a.session_id like '%&sid%'
and
	a.session_serial# like '%&serial%'
and
	a.sql_id like '%&sql_id%'
and
	a.event like '%&event%'
and
	a.module like '%&module%'
and
	a.machine like '%&machine%'
and
	a.blocking_session=b.session_id(+)
and
	a.blocking_session_serial#=b.session_serial#(+)
and
	a.snap_id=b.snap_id
and
	a.sample_time=b.sample_time	
order by 2;


undef begin_snap_id
undef end_snap_id
undef sid
undef serial
undef sql_id
undef event
undef module
undef machine


