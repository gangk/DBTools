REM ------------------------------------------------------------------------------------------------
REM $Id: ses-wait.sql,v 1.3 2005/05/17 20:25:54 hagan Exp $
REM Author     : hien
REM #DESC      : Show session wait information
REM Usage      : Input parameter: none
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv

col command	format a04		head 'Cmnd'		trunc
col event  	format a15  		head 'Wait Event' 	trunc
col hash   	format 9999999999	head 'Hash|Value'
col mach	format a10		head 'Machine'		trunc
col module 	format a23  		head 'Module' 		trunc
col orauser    	format a08		head 'Oracle|User'	trunc
col osuser	format a08		head 'OS User'		trunc
col p1     	format 9999999999	head 'P1'
col p2     	format 9999999999	head 'P2'
col p1txt  	format a07					trunc
col p2txt  	format a07					trunc
col p3     	format 999  		head 'P3'
col p3txt  	format a06					trunc
col sidser	format a10  		head 'Sid,Serial'
col sqlh	format 9999999999	head 'SQL Hash|Value'
col state_seq  	format a09  		head 'State-Seq'
col swseq   	format 99999  		head 'Seq#'
col siw   	format 999  		head 'Sec|Wt'
col sp		format a10 		head 'Svr-Pgm'

SELECT 	 
	/*+ RULE */
	 lpad(sw.sid,4,' ')||','||lpad(se.serial#,5,' ')	sidser
	,se.username 						orauser
	,se.osuser						osuser
	,pr.spid||'-'||substr(nvl(pr.program,'null'),instr(pr.program,'(')+1,4)	sp
	,decode(sw.event
		,'control file sequential read'	, 'cfile seq read'
		,'control file single write'	, 'cfile sgl write'
		,'control file parallel write'	, 'cfile par write'
		,'refresh controlfile command'	, 'rfrsh cfile cmd'
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
		,sw.event)							event
       	,lpad(decode(sw.state,'WAITED','Wted','WAITED KNOWN TIME','Wknt','WAITING','Wtng','WAITED SHORT TIME','Shrt',sw.state),4,' ')||
       	 '-'||lpad(decode(sign(9999-sw.seq#),-1,9999,sw.seq#),4,' ')		state_seq
       	,decode(sign(999-sw.seconds_in_wait),-1,999,sw.seconds_in_wait) 	siw
	,decode(se.module,null,'n/a',se.module)					module
       	,decode (se.command
	       , 0, ' -  '
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
	,se.sql_hash_value	hash
       	,decode(sign(999999999-sw.p1),-1,999999999,sw.p1)   	p1 
       	,decode(sign(999999999-sw.p2),-1,999999999,sw.p2)   	p2 
       	,decode(sign(999-sw.p3),-1,999,sw.p3)             	p3 
FROM   	 v$process		pr
        ,v$session		se
        ,v$session_wait		sw
WHERE  	 sw.event not in ('SQL*Net message from client'
		      ,'queue messages'
		      ,'rdbms ipc message'
		      ,'rdbms ipc reply'
		      ,'pmon timer'
		      ,'smon timer'
		      ,'PL/SQL lock timer'
		      ,'jobq slave wait'
		      )
AND	 sw.sid		= se.sid (+)
AND	 se.paddr	= pr.addr (+)
ORDER BY sw.event desc, p1, p2
;
ttitle off
