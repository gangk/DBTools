undef sql_handle
set linesize 150
set pagesize 2000
select 	 t.*
from 	 table(dbms_xplan.display_sql_plan_baseline(sql_handle => '&&sql_handle')) t
;
