undef sqlid
set linesize 170
set pagesize 2000
select t.*
from 	 (select distinct sql_id, plan_hash_value from v$sql where sql_id='&&sqlid') p
     	,table(dbms_xplan.display_awr(p.sql_id)) t
;
