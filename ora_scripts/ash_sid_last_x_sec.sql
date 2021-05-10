-- Showing all events for a sid in chronological order since x seconds ago --
-- Run on 11R2 only --
undef sid
undef for_the_last_x_sec
@plusenv
col	stime		format a13
col	usrid		format 9999	head 'Usr|Id'
col 	cn		format 999
col 	sqlstart	format a09
col	event		format a30	trunc
col 	bsid		format 9999	head 'BSid'
col	module		format a25	trunc
col	pgam		format 999
col	tempm		format 9999
col	objid		format 99999999
col	p1p2p3		format a20	head '         P1/P2/P3' trunc
col	state		format a03	head 'Sta'
col	dtime		format 999999999
col	dcpu		format 9999999
col	dread		format 9999
col	sid		format 9999
col	opname		format a03	trunc
col	phv		format 9999999999
col 	plid		format 999
col sqlid   	format a17		head 'SqlId:Child'
col	event		format a25	trunc

break on sid on usrid

select	 SESSION_ID					sid
	,to_char(SAMPLE_TIME,'MMDD HH24:MI:SS') 	stime
	,sql_id||decode(sql_id,null,' ',':')||sql_child_number		sqlid
	,SQL_PLAN_HASH_VALUE				phv
	,SQL_PLAN_LINE_ID				plid
	,to_char(SQL_EXEC_START,'HH24:MI:SS')		sqlstart
	,SQL_OPNAME					opname
	,decode(SESSION_STATE,'ON CPU','CPU','WAITING','-w-','???')	state
	,event
	,lpad(P1||'/'||P2||'/'||P3,20,' ')		p1p2p3
	,BLOCKING_SESSION				bsid
	,CURRENT_OBJ#					objid
	--,IN_CONNECTION_MGMT
	--,IN_PARSE
	--,IN_HARD_PARSE
	,IN_SQL_EXECUTION
	--,IN_PLSQL_RPC
	--,IN_BIND
	--,MODULE
	,TM_DELTA_TIME					dtime
	,TM_DELTA_CPU_TIME				dcpu
	,DELTA_READ_IO_REQUESTS				dread
	,PGA_ALLOCATED/1024/1024			pgam
	,TEMP_SPACE_ALLOCATED/1024/1024			tempm
from	 v$active_session_history
where	 session_id	= &&sid
and	 sample_time > sysdate-&&for_the_last_x_sec/86400
order by sample_time
;
