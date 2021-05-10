undef sql_id
set lines 170
col pui 		format 999		head 'UId'
col uname		format a11
col cn 			format 99		trunc
col ue			format 99
col parse_usr		format a10		trunc
col lltime		format a16	trunc	head 'Last|LoadTime'
col exec		format 999999999	head 'Executions'
col paprun 		format 9.9 		head 'Parse|PerEx'
col cprun 		format 9999 		head 'CPU|PerEx'
col bgprun 		format 99999 		head 'BGets|PerEx'
col rwprun 		format 9999.9 		head 'RwsP|PerEx'
col awprun 		format 999.9 		head 'AppW|PerEx'
col cwprun 		format 999.9 		head 'ConW|PerEx'
col iowprun 		format 999.9 		head 'IOW|PerEx'
col phash		format 9999999999	head 'Plan Hash'
col module		format a20	trunc	head 'Module'
col o			format a01
col s			format a01	trunc
col sqltext		format a50		head 'SQL Text'
select 	 parsing_schema_name	parse_usr
	,object_status		s
	,child_number		cn
	,plan_hash_value	phash
	,last_load_time		lltime
	,users_executing	ue
	,EXECUTIONS		exec
	,least((parse_calls/executions),9.99)			paprun
       	,least((cpu_time/executions),9999.9) 			cprun
       	,least((buffer_gets/executions),99999.9) 		bgprun
       	,least((rows_processed/executions),9999.9)		rwprun
	,module 		module
	,substr(sql_text,1,50)	sqltext
from 	 v$sql
where 	 (sql_id,child_number,plan_hash_value) in (select distinct sql_id,child_number,plan_hash_value from v$sql_plan where sql_id = '&&sql_id')
and	 executions	>1
order by last_load_time
;
select t.*
from 	 (select distinct sql_id, plan_hash_value from v$sql_plan where sql_id='&&sqlid') p
     	,table(dbms_xplan.display_cursor(p.sql_id)) t
where 	 p.sql_id='&&sqlid'
union
select t.*
from 	 (select distinct sql_id, plan_hash_value from dba_hist_sql_plan where sql_id='&&sqlid') p
     	,table(dbms_xplan.display_awr(p.sql_id)) t
where 	 p.sql_id='&&sqlid'
;
