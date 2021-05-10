set linesize 170 pagesize 9000

accept sql_id 	prompt 'Enter sql_id : '
prompt
prompt	========== from awr ==========
select 	 t.*
from
	(select distinct sql_id, plan_hash_value from dba_hist_sql_plan where sql_id = '&&sql_id') s
	,table(dbms_xplan.display_awr(s.sql_id,s.plan_hash_value)) t
;

