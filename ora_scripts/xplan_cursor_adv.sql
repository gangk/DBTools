undef sql_id
undef child_num
set linesize 170
set pagesize 2000
select *
from 	 table(dbms_xplan.display_cursor('&&sql_id', &&child_num,'ADVANCED')) 
;
