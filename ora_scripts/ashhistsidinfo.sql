col wait for 999
col module for a20
col sample_time for a18
col sid for 99999
col serial# for 999999
col session_type for a4
col sql_id for a13
col plan for 9999999999
col event for a30
col blksid for 99999
col blkserial for 99999
col blkstate for a2

accept begin_snap_id prompt 'Enter Begin Snap:- '
accept end_snap_id   prompt 'Enter End Snap:- '
accept sid           prompt 'Enter Sid:- '

select
	snap_id,substr(sample_time,1,18),session_id sid,session_serial# serial#,sql_id,sql_plan_hash_value plan,substr(module,1,20) module,(wait_time+time_waited)/1000000 Wait,
	substr(event,1,30) event,substr(session_state,1,4) ss,blocking_session blksid,blocking_session_serial# blkserial,decode(blocking_session_status,'NO HOLDER','NO','UNKNOWN','UN','VALID','VA','NOT IN WAIT','NW',blocking_session_status) blkstate,object_name
from
        dba_hist_active_sess_history ,dba_objects
where
        snap_id between &begin_snap_id and &end_snap_id
and
        session_id = &sid
and
	CURRENT_OBJ#=object_id(+)
order by 2;

prompt '*********ROWS ACCESSED**************'
select
        snap_id,substr(sample_time,1,18) sample_time ,session_id sid,session_serial# serial#,sql_id,substr(event,1,30) event,CURRENT_OBJ#,object_name,dbms_rowid.rowid_create ( 1, CURRENT_OBJ#, CURRENT_FILE#, CURRENT_BLOCK#, CURRENT_ROW# ) myrow
from
	 dba_hist_active_sess_history ,dba_objects
where
        snap_id between &begin_snap_id and &end_snap_id
and
        session_id = &sid
and
        CURRENT_OBJ#=object_id
and 
	CURRENT_FILE# is not null
and
	CURRENT_BLOCK# is not null
and 
	CURRENT_ROW# is not null
order by 2;

undef begin_snap_id
undef end_snap_id
undef sid
