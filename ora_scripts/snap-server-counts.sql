prompt
prompt
prompt === count of sessions by server type (snap-server-counts.sql) ===;
break on report
compute sum of sess on report

SELECT 	 decode(server,'DEDICATED','DEDICATED','PSEUDO','PSEUDO','MTS')	servertyp
	,count(*)  sess
FROM 	 v$session
GROUP BY decode(server,'DEDICATED','DEDICATED','PSEUDO','PSEUDO','MTS')
;

