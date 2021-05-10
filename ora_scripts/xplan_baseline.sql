undef sql_handle
undef plan_name
set linesize 170
set pagesize 2000
select *
from 	 table(dbms_xplan.display_sql_plan_baseline('&&sql_handle','&&plan_name','typical +predicate +peeked_binds')) 
;
