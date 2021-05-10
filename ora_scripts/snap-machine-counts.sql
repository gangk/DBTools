prompt
prompt
prompt === session count by machine (snap-machine-counts.sql) ===;

col machine 	format a30 				trunc
col scount	format 9999 	head 'Num|Sessions'

SELECT 	 machine
	,count(*) 	scount
from v$session 
group by machine
;
