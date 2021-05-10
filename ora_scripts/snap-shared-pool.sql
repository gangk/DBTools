prompt
prompt
prompt === shared pool (snap-shared-pool.sql) ===;

col name 	format a30
col bytes 	format 9,999,999,999

SELECT	 *
FROM 	 v$sgastat
WHERE 	 name 	in 	('free memory'
			,'session heap'
			,'sql area'
			,'library cache'
			,'dictionary cache'
			)
;

