REM ------------------------------------------------------------------------------------------------
REM $Id: sid-stat.sql,v 1.1 2002/03/14 00:27:57 hien Exp $
REM Author     : hien
REM #DESC      : Statistics and wait events for a given sid
REM Usage      : Input parameter: session_id
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv
undef session_id

accept session_id prompt 'Enter Session Id: '

prompt
prompt -- Session Statistics --;
col name	format a30 	head 'Stat Name'
break on sid

SELECT	 /*+ ORDERED */
	 ss.sid
	,sn.name
	,ss.value
FROM	 v$statname	sn
	,v$sesstat	ss
WHERE	 sn.name in 
		 ('sorts (memory)'
		 ,'sorts (disk)'
	         ,'recursive cpu usage'
		 ,'session logical reads'
		 ,'CPU used by this session'
		 ,'table scans (short tables)'
		 ,'table scans (long tables)'
		 ,'parse time cpu'
		 ,'transaction rollbacks'
		 ,'redo size'
		 ,'physical reads direct'
		 ,'CR blocks created'
		 ,'physical reads'
		 ,'db block gets'
		 ,'consistent gets'
		 ,'db block changes'
		 ,'session uga memory'
		 ,'session uga memory max'
		 )
AND	 sn.statistic#	= ss.statistic#
AND	 ss.sid		= &&session_id
ORDER BY sn.name
;

prompt
prompt -- Session Events --;

col event	format a30	head 'Event Name'
break on sid

SELECT	 sid
	,event
	,total_waits
	,total_timeouts
	,time_waited
	,average_wait
	,max_wait
FROM	 v$session_event
WHERE	 sid		= &&session_id
ORDER BY event
;
undef session_id
