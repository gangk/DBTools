prompt
prompt
prompt === rollback-segments (snap-rollback-segments.sql) ===;

col name 	format a6 	trunc
col st 		format a1 	trunc
col sst 	format a1 	trunc
col no 		format 99 	trunc
col xacts 	format 0 	heading X
col sid 	format 9999	heading SID
col osid 	format a7 	trunc
col oraid 	format a7	trunc
col lioh  	format 9999	heading 'Log|IOh'
col phyio   	format 99999	heading 'PhyIO'
col ublks   	format 99999	heading 'Undo'
col rsmb 	format 9999 	heading CUR
col optmb 	format 999 	heading OPT
col hwm 	format 9999 	heading HWM
col ext 	format 99 	heading EX
col max 	format 999 	heading MAX
col getsK 	format 9999
col wrtsK 	format 9999999
col wai 	format 99999
col wrp 	format 9999
col xt 		format 999
col sh 		format 99
col avgactK 	format 999999
col starttm	format a09	trunc heading 'Start|Time'

break on name on st on no on xacts on rsMB on optMB on hwm on ext on max on getsK on wrtsK on avgactK on wai on wrp on xt on sh

SELECT  /*+ RULE */
	 name
	,decode(rs.status,'ONLINE','O','OFFLINE','X','FULL','F','?') 		st
	,rs.usn 		no
	,xacts			xacts
	,rssize/(1024*1024) 	rsMB
	,optsize/(1024*1024) 	optMB
	,hwmsize/(1024*1024) 	hwm
	,extents		ext
	,decode(sign(999 - dr.max_extents),-1,999,dr.max_extents) max
	,gets/1024 		getsK
	,writes/1024 		wrtsK
	,aveactive/1024 	avgactK
	,waits 			wai
	,wraps 			wrp
	,extends 		xt
	,shrinks 		sh
	,s.sid 			sid
	,s.osuser 		osid
	,s.username 		oraid
	,to_char(to_date(t.start_time,'MM/DD/YY HH24:MI:SS'),'MMDD HH24MI') starttm
	,decode(s.status,'ACTIVE','x',' ') sst
	,round(t.log_io/(100))	lioh
	,t.phy_io		phyio
	,t.used_ublk		ublks
FROM	 v$session 		s 
     	,v$rollstat 		rs
	,v$rollname 		rn
	,dba_rollback_segs 	dr
	,v$transaction 		t
WHERE	 rs.usn (+) 	= rn.usn
AND 	 rs.usn 	= dr.segment_id
AND 	 t.addr 	= s.taddr (+)
AND 	 t.xidusn (+) 	= rn.usn
ORDER BY name
;
