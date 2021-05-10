prompt
prompt
prompt === transactions by blockers and waiters (snap-lock-tx.sql) ===;

col svr   	format a1 	head 'S'		trunc
col shadow   	format a5    
col idlm   	format 99999		head 'Min|Idle'

SELECT 	 /*+ RULE */
	 decode(l.block,1,'>  '||lpad(l.sid,4,' ')||'-'||lpad(s.serial#,5,' '),' < '||lpad(l.sid,4,' ')||'-'||lpad(s.serial#,5,' ')) sidser
	,p.spid     				shadow
	,decode(s.server,'DEDICATED',' ','S')   svr
	,s.sql_hash_value			sqlhash
	,s.username				orauser
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
	       ,    to_char(s.command)
	       )               			cmnd
	,s.last_call_et/60     			idlm
	,t.xidusn				rb
	,t.xidslot				sl
	,t.xidsqn				sqn
	,t.status				sta
	,to_char(to_date(t.start_time,'MM/DD/YY HH24:MI:SS'),'MMDD HH24MI')	starttm
	,t.used_ublk				ublk
	,t.used_urec				urec
	,t.log_io				lio
	,t.phy_io				pio
	,t.cr_get				cget
	,t.cr_change				cchg
FROM	 
	 v$transaction	t
	,v$process	p
	,v$session	s
        ,v$lock		l
WHERE 	(l.block 	> 0
     OR  l.request 	> 0
	)
AND	 l.sid			= s.sid 
AND	 s.paddr		= p.addr 
AND	 s.taddr		= t.addr (+)
ORDER BY l.type
	,l.id1
	,l.id2
	,l.block desc
	,l.ctime desc
;
