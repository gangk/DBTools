ttitle off
prompt
prompt
prompt === transactions (snap-transactions.sql) ===;

col rbs 	format a6 	trunc
col xidslot	format 99	head 'Sl'
col sta 	format a1 	trunc
col sidser 	format a11  	head "Sess-Ser#"
col osid 	format a7 	trunc
col oraid 	format a7	trunc
col phyio   	format 9999999	head 'PhyIO'
col ublks   	format 999999	head 'Undo|Blocks'
col crget	format 9999999 	head 'CR|Gets'
col cpu		format 99999	head 'CPU|secs'
col redo	format 99999999 head 'Redo|KB'
col starttm	format a09	trunc head 'Start Time'
col command	format a06	trunc head 'Cmnd'
col sqlh	format 9999999999	head 'SQL Hash'
col module	format a22	trunc
col mach	format a14	trunc

SELECT  /*+ RULE */
	 lpad(s.sid,5,' ')||'-'||lpad(s.serial#,5,' ')	sidser
	,s.username 		oraid
	,s.osuser 		osid
	,name			rbs
	,t.xidslot		xidslot
	,to_char(to_date(t.start_time,'MM/DD/YY HH24:MI:SS'),'MMDD HH24MI') starttm
	,decode(s.status,'ACTIVE','A',' ') sta
	--,s12.ksusestv/100	cpu
	--,s97.ksusestv/1024	redo
	,t.phy_io		phyio
	,t.used_ublk		ublks
	,t.cr_get		crget
	,s.sql_hash_value 	sqlh
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
	       ,62, 'AN TB'
	       ,63, 'AN IX'
	       ,64, 'AN CL'
	       ,85, 'TRC TB'
	       ,    to_char(s.command)
	       )               	command
	,s.module		module
	,substr(s.machine,1,instr(machine,'.')-1)	mach
FROM	 
	 v$rollname 		rn
	,dba_rollback_segs 	dr
	--,sys.x$ksusesta		s12
	--,sys.x$ksusesta		s97
	,v$session		s
	,v$transaction 		t
WHERE 	 t.addr 	= s.taddr 
--AND	 s12.indx	= s.sid
--AND	 s12.ksusestn	= 12
--AND	 s97.indx	= s.sid
--AND	 s97.ksusestn	= 97
AND 	 t.xidusn 	= rn.usn
AND 	 rn.usn 	= dr.segment_id
ORDER BY starttm
;
