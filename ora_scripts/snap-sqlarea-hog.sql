prompt
prompt
prompt === shared pool memory hogs (snap-sqlarea-hog.sql) ===;

col sqltext	format a70
col hash	format 99999999999
col aexec	format 999,999,999
col sexec	format 999,999,999
col count	format 999,999
col shmem	format 999,999,999
col shmemb	format 9,999

SELECT	 /*  possible literal SQLs */
       	 substr(sql_text,1,70)	sqltext
	,avg(executions) 	aexec
	,sum(executions) 	sexec
	,count(*) 		count
	,sum(sharable_mem)	shmem
	,sum(sharable_mem)/(1024*1024)	shmemb
FROM 	 v$sql
GROUP BY 
	 substr(sql_text,1,70) 
HAVING   sum(sharable_mem)	> 1000000
ORDER BY sum(sharable_mem)
;

SELECT	 /* multiple versions */
       	 substr(sql_text,1,70)	sqltext
       	,hash_value		hash
	,avg(executions) 	aexec
	,sum(executions) 	sexec
	,count(*) 		count
	,sum(sharable_mem)	shmem
	,sum(sharable_mem)/(1024*1024)	shmemb
FROM 	 v$sql
GROUP BY 
	 substr(sql_text,1,70) 
	,hash_value
HAVING   sum(sharable_mem)	> 1000000
ORDER BY sum(sharable_mem)
;
