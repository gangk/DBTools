prompt
prompt
prompt === latchholder (snap-latchholder.sql) ===;

col sidser 	format a10  	head 'Sess-Ser#'
col orauser    	format a09				trunc
col osuser   	format a08				trunc
col shadow   	format a5    
col parent   	format a5				trunc
col svr   	format a1 	head 'S'		trunc
col sta   	format a3 				trunc
col hash	format 9999999999	head 'SQL Hash'
col phash	format 9999999999	head 'Prev Hash'
col module	format a26		head 'Module'	trunc
col mach	format a16 		head 'Machine'	trunc
col pid		format 9999
col lname	format a23		head 'Latch Name'	trunc
SELECT	 
	 lpad(s.sid,4,' ')||'-'||lpad(s.serial#,5,' ')		sidser
	,lh.name						lname
	,lh.pid							pid
	,s.username 						orauser
	,substr(s.machine,1,instr(s.machine,'.')-1)     	mach
	,s.module						module
	,s.osuser   						osuser
	,p.spid     						shadow
	,decode(s.server,'DEDICATED',' ','S')   		svr
	,s.sql_hash_value 					hash
	,lh.laddr						laddr
FROM	 v$latchholder		lh
      	,v$session		s
	,v$process		p
WHERE	 lh.sid			= s.sid
AND	 s.paddr		= p.addr 
;
