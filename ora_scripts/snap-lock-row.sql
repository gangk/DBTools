prompt
prompt
prompt === lock waits (snap-lock-row.sql) ===;

SELECT 	 /*+ RULE */
	 decode(block,1,'>  '||lpad(l.sid,4,' ')||'-'||lpad(s.serial#,5,' '),' < '||lpad(l.sid,4,' ')||'-'||lpad(s.serial#,5,' ')) sidser
	,s.status								sta
	,s.sql_hash_value							sqlhash
	,s.osuser								osuser
	,substr(s.machine,1,instr(s.machine,'.')-1)       			mach
	,s.process								cpid
	,l.type||':'||l.id1||'-'||l.id2						res
	,l.lmode||'-'||l.request						hldreq
	,l.ctime								ctime
	,s.row_wait_obj#||' '||s.row_wait_file#||'-'||s.row_wait_block#||'-'||s.row_wait_row# ofbr
	,substr(o.owner,1,6)||'.'||substr(o.object_name,1,30)			object
FROM	 
	 dba_objects	o
	,v$session	s
        ,v$lock		l
WHERE 	(l.block 	> 0
     OR  l.request 	> 0
	)
AND	 l.sid			= s.sid 
AND	 s.row_wait_obj#	= o.object_id (+)
ORDER BY l.type
	,l.id1
	,l.id2
	,l.block desc
	,l.ctime desc
;
ttitle off
