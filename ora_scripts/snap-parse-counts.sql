prompt
prompt
prompt === parse counts (snap-parse-counts.sql) ===;

col name	format a40	head 'Description'
col value   	format 999,999,999,999,999,999

SELECT	 name
	,value
FROM
	 v$sysstat
WHERE	 name		like '%parse%'
;
