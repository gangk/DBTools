prompt
prompt
prompt === lock waits (snap-lock-waits.sql) ===;

col cchg	format 99999		head 'CRChg'
col cget	format 99999		head 'CRGet'
col cmnd	format a06		head 'Cmnd'		trunc 
col cnt	   	format 99999		head 'Seq|Cnt'
col cpid	format a05		head 'ClPID'
col ctime	format 9999		head 'Conv|Secs'
col event  	format a28  		head 'Wait Event' 	trunc
col hldreq	format a3		head 'H-R'
col lkids    	format a15		head 'Id1-Id2'
col lio		format 99999		head 'LogIO'
col lmode	format 9		head 'L'
col ltyp    	format a2		head 'Lk|Tp'
col mach	format a13 		head 'Machine'		trunc
col module	format a18 		head 'Module'		trunc
col object	format a35		head 'Locked Object'
col ofbr	format a19		head 'Obj-File-Blk-Row'
col orauser    	format a06		head 'Oracle|User'	trunc
col osuser   	format a07					trunc
col p1     	format 999999999999  	head 'P1'
col p1txt  	format a13					trunc
col p2     	format 999999999999  	head 'P2'
col p2txt  	format a09					trunc
col p3     	format 9999999  	head 'P3'
col p3txt  	format a09					trunc
col pio		format 9999		head 'PhyIO'
col prevhash	format 9999999999 	head 'Prev|Hash Value'
col rb		format 99 					trunc
col res		format a18		head 'Resource'
col request	format 9		head 'R'
col secs   	format 999		head 'Wait|secs'
col ser    	format 99999		head 'Ser'
col sid    	format a7		head 'Sid'
col sidser    	format a13		head '   Sid-Ser'
col sl		format 999		head 'Slt'
col sqlhash	format 9999999999 	head 'SQL|Hash Value'
col sqlt64	format a64		word_wrapped
col sqltext	format a79		word_wrapped
col sqn		format 999999		head 'SQN'
col sta   	format a1		head 'S'		trunc
col starttm	format a09		head 'Start|Time'
col state  	format a12  		head 'Wait State' 	trunc
col styp   	format a1		head 'T'		trunc
col ublk    	format 99999		head 'Undo|Blks'
col urec	format 99999		head 'Undo|Recs'
col ux		format 9		head 'X'
col wblk	format 999999		head 'Wait|Blk'
col wfile	format 999		head 'Wait|File'
col wobj	format 999999		head 'Wait|Obj'
col wrow	format 999		head 'Wt|Row'
col wtim    	format 999999  		head 'Wait|Time'

SELECT 	 /*+ RULE */
	 decode(block,1,'>  '||lpad(l.sid,4,' ')||'-'||lpad(s.serial#,5,' '),' < '||lpad(l.sid,4,' ')||'-'||lpad(s.serial#,5,' ')) sidser
	,s.status								sta
	,s.sql_hash_value							sqlhash
	,s.osuser								osuser
	,substr(s.machine,1,instr(s.machine,'.')-1)       			mach
	,s.process								cpid
	,l.type||':'||l.id1||'-'||l.id2						res
	,l.lmode||'-'||l.request						hldreq
	,l.ctime								ctime
	,s.row_wait_obj#||')'||s.row_wait_file#||'-'||s.row_wait_block#||'-'||s.row_wait_row# ofbr
	,substr(o.owner,1,6)||'.'||substr(o.object_name,1,30)			object
FROM	 
	 dba_objects	o
	,v$session	s
        ,v$lock		l
WHERE 	(l.block 	> 0
     OR  l.request 	> 0
	)
AND	 l.sid			= s.sid 
AND	 s.row_wait_obj#	= o.object_id (+)
ORDER BY l.type
	,l.id1
	,l.id2
	,l.block desc
	,l.ctime desc
;
ttitle off
