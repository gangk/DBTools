select 'spool igen_enable.log;' from dual;
select 'ALTER TABLE '||substr(c.table_name,1,35)||
' ENABLE CONSTRAINT '||constraint_name||' ;'
from user_constraints c, user_tables u
where c.table_name = UPPER('&table_name') and
c.table_name = u.table_name; 