REM ------------------------------------------------------------------------------------------------
REM $Id: ses-count.sql,v 1.2 2002/04/01 22:52:50 hien Exp $
REM Author     : hien
REM #DESC      : Session counts by machine, by module, by status, and by server type
REM Usage      : Input parameter: none
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv

prompt -- Session Count by Machine --;
col machine format a40 trunc
break on report
compute sum of sess on report
SELECT 	 machine
	,count(*)  sess
FROM 	 v$session
GROUP BY machine
ORDER BY sess
;

prompt -- Session Count by Module --;
col module format a50 trunc
break on report
compute sum of sess on report
SELECT 	 module
	,count(*)  sess
FROM 	 v$session
GROUP BY module
ORDER BY sess
;

prompt
prompt -- Session Count by Status --;
break on report
compute sum of sess on report
SELECT 	 status
	,count(*)  sess
FROM 	 v$session
GROUP BY status
;

prompt
prompt -- Session Count by Server Type --;
break on report
compute sum of sess on report
SELECT 	 decode(server,'DEDICATED','DEDICATED','PSEUDO','PSEUDO','SHARED') server
	,count(*)  sess
FROM 	 v$session
GROUP BY decode(server,'DEDICATED','DEDICATED','PSEUDO','PSEUDO','SHARED')
;

