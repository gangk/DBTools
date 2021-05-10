set lines 140 pages 0
prompt
prompt
prompt === new sql statements in last 60 secs (snap-new-sqls.sql) ===;

col ltime	format a09		head 'First|Load Time'	trunc
col mem		format 999,999
col exe		format 999
col par		format 999
col ld		format 99
col hash   	format 9999999999	head 'Hash|Value'
col module	format a24					trunc
col sqltext	format a70		word_wrapped

SELECT 	 to_char(to_date(first_load_time,'YYYY-MM-DD/HH24:MI:SS'),'MMDD HH24MI') ltime
	,sharable_mem		mem
	,executions		exe
	,loads			ld
	,module			module
	,hash_value 		hash
	,sql_text		sqltext
FROM 	 v$sql
WHERE    to_date(first_load_time,'YYYY-MM-DD/HH24:MI:SS') > (sysdate - 1/(24*60))
AND	 sql_text		not like '%first_load_time%'
ORDER BY 1,2 desc
;
