set feedback on
accept sql_id Prompt 'Enter Sql_id:- '
with plan as
(
	select rownum rnum,PLAN_TABLE_OUTPUT FROM TABLE(dbms_xplan.DISPLAY_AWR('&sql_id'))
)
select 
	plan_table_output  
from 
	plan
where 
	rnum>=3
and    
	rnum < (select min(rnum) from plan where plan_table_output like '%Plan hash value%')

undef sql_id
