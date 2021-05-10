col orauser    	format a09	trunc
col sid      	format 9999
col ser      	format 99999
col osuser   	format a09	trunc
col shadow   	format a5    
col parent   	format a5	trunc
col svr   	format a3 	trunc
col sta   	format a3 	trunc
col sqlh	format 99999999999	heading 'SQL HASH|VALUE'
col command	format a08	trunc
col machine	format a15	trunc
col module	format a25	trunc
col program	format a12	trunc
col idlemin	format 99999	heading 'Idle|Min'
col rb		format 99

SELECT
	 s.machine
	,s.osuser
	,s.process
	,s.sid
	,s.serial#
	,s.username
	,decode(s.status,'INACTIVE',NULL,s.status) status
	,s.lockwait
	,p.spid
FROM
	 v$session	s
	,v$process	p
WHERE
	 s.paddr = p.addr
AND	 p.spid	= &spid
ORDER BY s.machine
	,s.osuser
	,s.process
;
