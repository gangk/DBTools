undef sqlstring
set linesize 150
set pagesize 2000
accept sqlstring prompt 'Enter sql string: '
select 	 t.*
from 	 dba_hist_sqltext ht
     	,table(dbms_xplan.display_awr(ht.sql_id, null, null, '-PREDICATE +ALIAS')) t
where 	 lower(ht.sql_text) like lower('%&&sqlstring%');
