prompt
prompt
prompt === sqls by blockers and waiters (snap-lock-sql.sql) ===;

SELECT 	 /*+ RULE */
	 decode(l.block,1,'>  '||lpad(l.sid,4,' ')||'-'||lpad(s.serial#,5,' '),' < '||lpad(l.sid,4,' ')||'-'||lpad(s.serial#,5,' ')) sidser
	,s.prev_hash_value			prevhash
	,s.sql_hash_value			sqlhash
	,q.users_executing			ux
	,q.sql_text				sqltext
FROM	 
	 v$sqlarea	q
	,v$session	s
        ,v$lock		l
WHERE 	(l.block 	> 0
     OR  l.request 	> 0
	)
AND	 l.sid			= s.sid 
AND	 s.sql_address		= q.address
ORDER BY l.type
	,l.id1
	,l.id2
	,l.block desc
	,l.ctime desc
;
