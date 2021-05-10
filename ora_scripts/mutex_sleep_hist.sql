@plusenv
col MUTEX_ID	format 99999999999
col stime	format a14
col mtype	format a10	trunc
col gets	format 999,999,999
col sleeps	format 99,999,999
col rsid	format 99999
col bsid	format 99999
col location	format a20
col mvalue	format a16
col p1		format 999999
col p2		format 999999
col p3		format 999999
col p4		format 999999
col p5		format a10	trunc
select 	 MUTEX_IDENTIFIER	mutex_id
	,to_char(SLEEP_TIMESTAMP,'MM/DD HH24:MI:SS')	stime
	,mutex_type		mtype
	,gets
	,sleeps
	,requesting_session	rsid
	,blocking_session	bsid
	,location		
	,mutex_value		mvalue
	,p1
	,p1raw
	,p2
	,p3
	,p4
	,p5
from 	 v$mutex_sleep_history
where	 sleeps > 100
order by sleeps
;
