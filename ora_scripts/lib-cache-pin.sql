REM -----------------------------------------------------
REM $Id: lib-cache-pin.sql,v 1.3 2005/04/25 15:53:46 milomilo Exp $
REM Author      : Murray Ed
REM #DESC       : Show holder of a library cache pin
REM Usage       : No parameters
REM Description : Show holder of a library cache pin
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
(SELECT	 b.kglpnses
 FROM	 x$kglpn		b
 WHERE	 kglpnreq		= 0
 AND	 EXISTS
	(SELECT	 w.kglpnhdl
	 FROM	 x$kglpn	w
	 WHERE	 w.kglpnses	= (select s.saddr from v$session s, v$session_wait w where s.sid=w.sid 
	 			   and w.event = 'library cache pin' and rownum =1)
	 AND	 w.kglpnhdl	= b.kglpnhdl
	 AND	 w.kglpnreq	> 0
	)
)
;
