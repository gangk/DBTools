set pagesize 1000
set long 200000
set line 999
set heading off;
accept SQL_ID prompt 'Enter SQL_ID:- '
select sql_text
from v$sqltext
where sql_id  = '&SQL_ID' 
order by piece;
set heading on;
