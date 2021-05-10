prompt
prompt
prompt === total session counts (snap-total-sessions.sql) ===;

break on sessions_highwater

SELECT 	 sessions_highwater
	,status
	,count(*) 
FROM 	 v$session 
	,v$license 
GROUP BY sessions_highwater
	,status
;
