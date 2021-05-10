prompt
prompt
prompt === active sessions (snap-active-sessions.sql) ===;

col sidser 	format a10  	head "Sess-Ser#"
col orauser    	format a09	trunc
col osuser   	format a09	trunc
col shadow   	format a5    
col parent   	format a5	trunc
col svr   	format a1 	head 'S'		trunc
col sta   	format a3 	trunc
col hash	format 9999999999	head 'SQL Hash'
col phash	format 9999999999	head 'Prev Hash'
col command	format a06	trunc
col mach	format a10 		head 'Machine'	truncated
col module	format a25	trunc
col idlm   	format 99999		head 'Min|Idle'
col rb		format 99
col phyio	format 99999	head 'Phy|IO'
col logontm   	format a09	trunc	head 'Logon|Time'

SELECT	/*+ RULE */
	 lpad(s.sid,4,' ')||'-'||lpad(s.serial#,5,' ')	sidser
	,s.username 				orauser
	,substr(s.machine,1,instr(s.machine,'.')-1)     mach
	,s.module				module
	,s.osuser   				osuser
	,p.spid     				shadow
	,s.process  				parent
        ,to_char(s.logon_time,'MMDD HH24MI')	logontm
	,s.last_call_et/60     			idlm
	,decode(s.server,'DEDICATED',' ','S')   svr
	,s.prev_hash_value 			phash
	,s.sql_hash_value 			hash
       	,decode (s.command
	       , 0, '      '
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
	       ,21, 'CR VW'
	       ,22, 'DR VW'
	       ,26, 'LK TB'
	       ,27, 'NO OP'
	       ,28, 'RENAME'
	       ,29, 'CMMENT'
	       ,30, 'AUDIT'
	       ,31, 'NOAUDT'
	       ,32, 'CR DBL'
	       ,33, 'DR DBL'
	       ,34, 'CR DB'
	       ,35, 'AL DB'
	       ,36, 'CR RBS'
	       ,37, 'AL RBS'
	       ,38, 'DR RBS'
	       ,39, 'CR TS'
	       ,40, 'AL TS'
	       ,41, 'DR TS'
	       ,42, 'AL SES'
	       ,43, 'AL USR'
	       ,44, 'COMMIT'
	       ,45, 'ROLLBK'
	       ,46, 'SAVEPT'
	       ,47, 'PL/SQL'
	       ,62, 'AN TB'
	       ,63, 'AN IX'
	       ,64, 'AN CL'
	       ,85, 'TRC TB'
	       ,    to_char(command)
	       )               				command
	,t.xidusn					rb
	,t.phy_io					phyio
FROM
	 v$transaction 	t
     	,v$process 	p 
	,v$session 	s 
WHERE 	 p.addr 	= s.paddr (+)
AND   	 t.addr(+) 	= s.taddr 
AND	 t.ses_addr(+) 	= s.saddr
AND	 s.status 	= 'ACTIVE'
AND   	 s.username 	> ' ' 
AND      audsid		!= userenv('SESSIONID')
ORDER BY s.last_call_et	desc
;
