REM ------------------------------------------------------------------------------------------------
REM $Id: redo-by-module.sql,v 1.1 2002/03/14 00:41:32 hien Exp $
REM Author     : hien
REM #DESC      : Show redo size by module
REM Usage      : 
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv

col module	format a40	trunc
col rsize	format 999,999,999,999	head 'Redo Size'

SELECT	/*+ RULE */
	 decode(se.module,null,'N/A',se.module)	module
	,sum(ss.value)		rsize
FROM	 v$session	se
        ,v$sesstat	ss
	,v$statname	sn
WHERE	 ss.statistic#	= sn.statistic#
AND	 sn.name	= 'redo size'
AND	 ss.sid		= se.sid
AND	 ss.value	> 0
GROUP BY se.module
ORDER BY sum(ss.value)
;
