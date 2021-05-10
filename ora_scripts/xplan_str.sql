undef str
set linesize 150
set pagesize 2000
select 	 xplan.*
from 	 
( select sql_id
	,child_number
  from 	 v$sql
   where	 upper(sql_text) like upper('%&&str%')
   and	 upper(sql_text) not like '%FROM V$SQL WHERE UPPER(SQL_TEXT) LIKE %'
   and	 object_status = 'VALID'
   and	 last_active_time >= sysdate -1/24
   and   last_active_time = 
	(select max(last_active_time) from v$sql 
  	 where	 upper(sql_text) like upper('%&&str%')
  	 and	 upper(sql_text) not like '%FROM V$SQL WHERE UPPER(SQL_TEXT) LIKE %'
  	 and	 object_status = 'VALID'
  	 and	 last_active_time >= sysdate -1/24
	)
) sqlinfo,
  table(dbms_xplan.display_cursor(sqlinfo.sql_id, sqlinfo.child_number,'ALLSTATS LAST +PEEKED_BINDS -ROWS')
       ) xplan
;

