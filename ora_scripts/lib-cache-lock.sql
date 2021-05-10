REM -----------------------------------------------------
REM $Id: lib-cache-lock.sql,v 1.3 2005/04/25 15:54:09 milomilo Exp $
REM Author      : Murray Ed
REM #DESC       : Show holder of a library cache lock
REM Usage       : No parameters
REM Description : Show holder of a library cache lock
REM -----------------------------------------------------
set lines 140
col sid    	format 99999
col serial 	format 99999
col orausr	format a08		trunc
col osusr	format a08		trunc
col s		format a1		trunc
col username 	format a8
col module 	format a30
col machine 	format a25
col hash	format 9999999999
col prevh	format 9999999999
col clpid  	format 999999
SELECT	 sid			sid
	,serial#		serial
	,username		orausr
	,status			s
	,server
	,module
	,sql_hash_value		hash
	,prev_hash_value	prevh
	,osuser			osusr
	,machine
	,process		clpid
FROM	 v$session
WHERE	 saddr in
(SELECT	 b.kgllkses
 FROM	 x$kgllk	b
 WHERE	 kgllkreq	= 0
 AND	 EXISTS
	(SELECT	 w.kgllkhdl
	 FROM	 x$kgllk	w
	 WHERE	 w.kgllkses	= (select s.saddr from v$session s, v$session_wait w where s.sid=w.sid 
	 			   and w.event = 'library cache lock' and rownum =1)
	 AND	 w.kgllkhdl	= b.kgllkhdl
	 AND	 w.kgllkreq	> 0
	)
)
;
