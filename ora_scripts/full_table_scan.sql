select sp.object_owner,sp.object_name,
(select sql_text from v$sqlarea sa
where sa.address = sp.address
and sa.hash_value =sp.hash_value) sqltext,
(select executions from v$sqlarea sa
where sa.address = sp.address
and sa.hash_value =sp.hash_value) no_of_full_scans,
(select lpad(nvl(trim(to_char(num_rows)),' '),15,' ')||' | '||lpad(nvl(trim(to_char(blocks)),' '),15,' ')||' | '||buffer_pool
from dba_tables where table_name = sp.object_name
and owner = sp.object_owner) "rows|blocks|pool"
from v$sql_plan sp
where operation='TABLE ACCESS'
and options = 'FULL'
and object_owner IN ('&owner')
order by 1,2;
