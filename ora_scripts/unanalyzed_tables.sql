select owner||'.'||table_name UnanalyzedTables
from dba_tables
where owner not in ('SYS','SYSTEM','ADMIN','DBSNMP')
and LAST_ANALYZED is null
order by 1
/
