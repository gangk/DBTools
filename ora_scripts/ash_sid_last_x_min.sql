-- Showing all events for a sid in chronological order since x minutes ago --
-- Run on 11R2 only --
undef sid
undef for_the_last_x_min
@plusenv
col	stime		format a08
col	usrid		format 9999	head 'Usr|Id'
col 	cn		format 999
col 	sqlstart	format a09
col	event		format a28	trunc
col 	bsid		format 9999	head 'BSid'
col	module		format a22	trunc
col	pgam		format 999
col	tempm		format 9999
col	objid		format 999999999
col	p1p2p3		format a22	head '         P1/P2/P3'
col	state		format a03	head 'Sta'
col	dtime		format 999999999
col	dcpu		format 9999999
col	dread		format 9999
col	sid		format 9999
col	opname		format a06	trunc
col 	secs		format 999
col	sqlxid		format 999999999
col	phash		format 9999999999
col	pline		format 999

select	 session_id	sid
      	,to_char(SAMPLE_TIME,'HH24:MI:SS') 	stime
	--,USER_ID					usrid
	,SQL_ID
	,SQL_CHILD_NUMBER				cn
	,SQL_EXEC_ID					sqlxid
	,SQL_PLAN_HASH_VALUE				phash
	,SQL_PLAN_LINE_ID				pline
	,to_char(SQL_EXEC_START,'HH24:MI:SS')		sqlstart
	,(sysdate-SQL_EXEC_START)*(24*60*60)		secs
	,SQL_OPNAME					opname
	,EVENT
	,lpad(P1||'/'||P2||'/'||P3,20,' ')		p1p2p3
	,decode(SESSION_STATE,'ON CPU','CPU','WAITING','-w-','???')	state
	,BLOCKING_SESSION				bsid
	,CURRENT_OBJ#					objid
	--,IN_CONNECTION_MGMT
	--,IN_PARSE
	--,IN_HARD_PARSE
	,IN_SQL_EXECUTION
	--,IN_PLSQL_RPC
	--,IN_BIND
	--,MODULE
	--,TM_DELTA_TIME				dtime
	,TM_DELTA_CPU_TIME				dcpu
	,DELTA_READ_IO_REQUESTS				dread
	,PGA_ALLOCATED/1024/1024			pgam
	,TEMP_SPACE_ALLOCATED/1024/1024			tempm
from	 v$active_session_history
where	 session_id	= &&sid
and	 sample_time >= sysdate-&&for_the_last_x_min/1440
order by sample_time
;
