undefine event
start rpt140 	'All Sessions'

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

SELECT	/*+ RULE */
	 s.sid		sid
	,s.username 	orauser
	,s.serial#  	ser
	,s.osuser   	osuser
	,p.spid     	shadow
	,s.process  	parent
	,s.server   	svr
	,s.status   	sta
	,s.sql_hash_value sqlh
       	,decode (s.command
	       , 0, 'NO CMD'
	       , 1, 'CR TB'
               , 2, 'INSERT'
	       , 3, 'SELECT'
	       , 4, 'CR CL'
	       , 5, 'AL CL'
	       , 6, 'UPDATE'
	       , 7, 'DELETE'
	       , 8, 'DR'
	       , 9, 'CR IX'
	       ,10, 'DR IX'
	       ,11, 'AL IX'
	       ,12, 'DR TB'
	       ,15, 'AL TB'
	       ,17, 'GRANT'
	       ,18, 'REVOKE'
	       ,19, 'CR SYN'
	       ,20, 'DR SYN'
	       ,21, 'CR VIEW'
	       ,22, 'DR VIEW'
	       ,26, 'LOCK TB'
	       ,27, 'NO OP'
	       ,28, 'RENAME'
	       ,29, 'COMMENT'
	       ,30, 'AUDIT'
	       ,31, 'NOAUDIT'
	       ,32, 'CR DB LK'
	       ,33, 'DR DB LK'
	       ,34, 'CR DB'
	       ,35, 'AL DB'
	       ,36, 'CR RBS'
	       ,37, 'AL RBS'
	       ,38, 'DR RBS'
	       ,39, 'CR TS'
	       ,40, 'AL TS'
	       ,41, 'DR TS'
	       ,42, 'AL SESSION'
	       ,43, 'AL USER'
	       ,44, 'COMMIT'
	       ,45, 'ROLLBACK'
	       ,46, 'SAVEPOINT'
	       ,62, 'ANAL TB'
	       ,63, 'ANAL IX'
	       ,64, 'ANAL CL'
	       ,85, 'TRUNC TB'
	       ,    '?'
	       )               	command
	,s.machine
	,s.module		module
	,s.program		program
	,trunc(s.last_call_et/60)	idlemin
	,t.xidusn		rb
FROM
	 v$transaction 	t
     	,v$process 	p 
	,v$session 	s 
WHERE 	 p.addr 	= s.paddr (+)
AND   	 t.addr(+) 	= s.taddr 
AND	 t.ses_addr(+) 	= s.saddr
AND   	 s.username 	> ' ' 
AND	 s.sid in (select sid from v$session_wait where event like '&&event')
ORDER BY s.osuser
	,s.sid
;
@reset
