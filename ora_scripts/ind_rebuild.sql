select 'ALTER INDEX '||table_owner||'.'||index_name||' rebuild parallel 3;' from dba_indexes WHERE  owner = UPPER('&owner') 
AND table_name = UPPER('&table_name');


