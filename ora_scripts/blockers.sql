@plusenv
col acpu	format 999.9		head 'Avg|Cpu%'
col command	format a04		head 'Cmnd'		trunc
col cpu		format 9999.9		head '*Cpu*'
col elaps	format 999		head 'LCl|Ela'
col event  	format a18  		head 'Wait Event' 	trunc
col hcpu	format 99.9		head 'High|Cpu%'
col lcpu	format 99.9		head 'Low|Cpu%'
col lrds	format 99999		head 'Logi|Reads'
col module 	format a23  		head 'Module' 		trunc
col orauser    	format a08		head 'Oracle|User'	trunc
col osuser	format a08		head 'OS User'		trunc
col p1     	format 9999		head 'P1'
col p2     	format 999999		head 'P2'
col p3     	format 99  		head 'P3'
col pct		format 99.9		head 'Sid|Cpu%'
col physr	format 999999		head 'Phys|Reads'
col sidser	format a15  		head 'Sid,Serial<Blk'
col sp		format a10 		head ' Svr - Pgm'
col sqlid   	format a17		head 'SqlId:Child'
col state_siw  	format a07  		head 'Sta:SIW'		
col wobj	format 9999999		head 'Object#'


break on acpu
with 	 totcpu as
(
select sum(cpu) tcpu from v$sessmetric
)
SELECT 	 ccpu.acpu acpu
	,least((sm.cpu/tcpu)*100,99.9)	pct
	,least(sm.logical_reads,99999)	lrds
	,lpad(se.sid,4,' ')||','||lpad(se.serial#,5,' ')||decode(substr(se.blocking_session_status,1,1),'V','<',' ')||lpad(se.blocking_session,4,' ')	sidser
	,se.username 						orauser
	,se.osuser						osuser
	,lpad(pr.spid,5)||'-'||lpad(substr(nvl(pr.program,'null'),instr(pr.program,'(')+1,4),4)	sp
	,decode(se.event
		,'control file sequential read'	, 'cfile seq read'
		,'control file single write'	, 'cfile sgl write'
		,'control file parallel write'	, 'cfile par write'
		,'refresh controlfile command'	, 'rfrsh cfile cmd'
		,'library cache load lock'	, 'lib cach ld lk'
		,'library cache lock'		, 'lib cach lock'
		,'library cache pin'		, 'lib cach pin'
		,'log file sequential read'	, 'logf seq read'
		,'log file single write'	, 'logf sgl write'
		,'log file parallel write'	, 'logf par write'
		,'switch logfile command'	, 'swtch logf cmd'
		,'log file switch completion'	, 'logf swtch cmp'
		,'db file sequential read'	, 'dbf seq read'
		,'db file scattered read'	, 'dbf scat read'
		,'db file single write'		, 'dbf sgl write'
		,'db file parallel write'	, 'dbf par write'
		,'db file parallel read'	, 'dbf par read'
		,'PX Deq: Par Recov Reply'	, 'PXDq par rcvrpl'
		,'PX Deq: Par Recov Execute'	, 'PXDq par rcvexe'
		,'virtual circuit status'	, 'virt circ sta'
		,'SQL*Net message to client'	, 'N msg to clnt'
		,'SQL*Net message to dblink'	, 'N msg to dbln'
		,'SQL*Net more data to client'	, 'N more to clnt'
		,'SQL*Net more data to dblink'	, 'N more to dbln'
		,'SQL*Net message from client'	, 'N msg fr clnt'
		,'SQL*Net more data from client', 'N more fr clnt'
		,'SQL*Net message from dblink'	, 'N msg fr dbln'
		,'SQL*Net more data from dblink', 'N more fr dbln'
		,'SQL*Net break/reset to client', 'N brkrs to clnt'
		,'SQL*Net break/reset to dblink', 'N brkrs to dbln'
		,se.event)						event
	,decode(se.state,'WAITING'	,'Wtg'
		,'WAITED KNOWN TIME'	,'Kno'
		,'WAITED SHORT TIME'	,'Sho'
		,'?') 		
		||':'||lpad(least(se.seconds_in_wait,999),3)		state_siw
       	,least(se.p1,9999)   	p1 
       	,least(se.p2,999999)   	p2 
       	,least(se.p3,99)   	p3 
	,se.row_wait_obj#						wobj
	,nvl(se.module,'<'||substr(se.machine,1,instr(se.machine,'.')-1)||'>')	module
	,least(se.last_call_et,999)	elaps
       	,decode (se.command
	       , 0, ' 0  '
	       , 1, 'CRTB'
               , 2, 'ISRT'
	       , 3, 'SEL'
	       , 4, 'CRCL'
	       , 5, 'ALCL'
	       , 6, 'UPDT'
	       , 7, 'DEL'
	       , 8, 'DR'
	       , 9, 'CRIX'
	       ,10, 'DRIX'
	       ,11, 'ALIX'
	       ,12, 'DRTB'
	       ,15, 'ALTB'
	       ,17, 'GRNT'
	       ,18, 'REVK'
	       ,19, 'CSYN'
	       ,20, 'DSYN'
	       ,21, 'CRVW'
	       ,22, 'DRVW'
	       ,26, 'LKTB'
	       ,27, 'NOOP'
	       ,28, 'RENM'
	       ,29, 'CMNT'
	       ,30, 'AUDT'
	       ,31, 'NAUD'
	       ,32, 'CRLN'
	       ,33, 'DRLN'
	       ,34, 'CRDB'
	       ,35, 'ALDB'
	       ,36, 'CRRB'
	       ,37, 'ALRB'
	       ,38, 'DRRB'
	       ,39, 'CRTS'
	       ,40, 'ALTS'
	       ,41, 'DRTS'
	       ,42, 'ALSE'
	       ,43, 'ALUS'
	       ,44, 'COMT'
	       ,45, 'RLBK'
	       ,46, 'SVPT'
	       ,47, 'PLSQ'
	       ,62, 'ANTB'
	       ,63, 'ANIX'
	       ,64, 'ANCL'
	       ,85, 'TRTB'
	       ,    to_char(se.command)
	       )               	command
	,nvl(se.sql_id,se.prev_sql_id)||':'||decode(se.sql_id,null,'p',se.sql_child_number)		sqlid
FROM   	 v$session		se
	,v$process		pr
	,v$sessmetric		sm
	,totcpu
	,(select avg(value) acpu from v$sysmetric where METRIC_NAME='Host CPU Utilization (%)') ccpu
WHERE  	se.sid in (select sid from v$lock where block=1)
and	 se.paddr	= pr.addr
and	 se.sid		= sm.session_id
and	 se.serial#	= sm.session_serial_num
ORDER BY se.last_call_et
;
