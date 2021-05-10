col cnt	   	format 99999		head 'Seq|Cnt'
col cpid	format a05		head 'ClPID'
col ctime	format 9999		head 'Conv|Secs'
col event  	format a28  		head 'Wait Event' 	trunc
col hldreq	format a3		head 'H-R'
col lkids    	format a15		head 'Id1-Id2'
col ltyp    	format a2		head 'Lk|Tp'
col osuser   	format a07					trunc
col p1     	format 999999999999  	head 'P1'
col p2     	format 999999999999  	head 'P2'
col p3     	format 9999999  	head 'P3'
col res		format a18		head 'Resource'
col secs   	format 9999		head 'Wait|secs'
col sid    	format 99999		head 'Sid'
col sqlhash	format 9999999999 	head 'Curr/Last|SQL Hash'
col state  	format a12  		head 'Wait State' 	trunc
col wtim    	format 99999  		head 'Wait|Time'
prompt
prompt === session wait by blockers (snap-lock-blocker.sql) ===;

break on sid on orauser 
SELECT 	 /*+ RULE */
	 l.sid		sid
	,l.type||':'||l.id1||'-'||l.id2		res
	,l.lmode||'-'||l.request		hldreq
	,sw.seq#	cnt
	,sw.seconds_in_wait secs
	,l.ctime	ctime
	,sw.event	event
       	,sw.p1 		p1
	,sw.p2 		p2
	,sw.p3		p3
       	,sw.state	state
       	,sw.wait_time 	wtim
FROM	 
	 v$session_wait sw
        ,v$lock		l
WHERE 	(l.block 	> 0
	)
AND	 l.sid			= sw.sid (+)
ORDER BY
	 l.ctime desc
	,l.id1
	,l.id2
;
