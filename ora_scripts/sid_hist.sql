undef sid
undef ser
undef min_ago
set lines 150 echo off feed off
col sidser      format a10              head 'Sid,Serial'
col sqlid	format a13		head 'SqlId'
col p123	format a16		head 'p1/p2/p3'
col event	format a28		head 'Wait Event'	trunc
col bsid	format 9999		head 'Blk|Sid'
col module	format a28		head 'Module Name'	trunc
col stime	format a14		head 'Sample Time'
col pr		format a06		head 'Prgm'
col pobid	format 999999		head 'PLSQL|ObjId'
col opcd	format 9999		head 'SQL|OpCd'
col snapid	format 999999		head 'SnapId'
select	 lpad(ash.session_id,4,' ')||','
	||lpad(ash.session_serial#,5,' ')		sidser
	,to_char(SAMPLE_TIME,'YYMMDD HH24:MI')		stime
	,snap_id					snapid
	,lpad(substr(nvl(ash.program,'null'),instr(ash.program,'(')+1,4),4)	pr
	,sql_id						sqlid
	,plsql_object_id				pobid
	,sql_opcode					opcd
	,event						event
	,p1||'/'||p2||'/'||p3				p123
	,BLOCKING_SESSION				bsid
	,decode(ash.module,null,'n/a',ash.module)	module
from 	 DBA_HIST_ACTIVE_SESS_HISTORY 			ash
where 	 session_id					= &&sid
and	 session_serial#				= &&ser
and 	 SAMPLE_TIME 					> sysdate - (&&min_ago/(24*60))
/

