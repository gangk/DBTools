undef module
set linesize 150
set pagesize 2000
select t.*
from 	 v$session s
     	,table(dbms_xplan.display_cursor(s.prev_sql_id, s.prev_child_number)) t
where 	 s.module='&&module';
