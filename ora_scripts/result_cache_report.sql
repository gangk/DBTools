set serveroutput on size 1000000

col object_name		format a60
col creation_date	format a14
col id			format 99
col name		format a30
col value		format 999999

execute dbms_result_cache.memory_report;

select 	 id
	,name
	,value
from 	 v$RESULT_CACHE_STATISTICS;

select 	 substr(NAME,1,60) 	object_name
	,status
	,to_char(CREATION_TIMESTAMP,'YYYYMMDD HH24:MI')	creation_date
	,build_time
	,row_count
	,BLOCK_COUNT
	,SCAN_COUNT
	,INVALIDATIONS
from 	 v$RESULT_CACHE_OBJECTS;
