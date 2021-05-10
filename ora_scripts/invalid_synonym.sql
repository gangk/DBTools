select 'drop '||decode (s.owner,'PUBLIC','PUBLIC SYNONYM ',
'SYNONYM'||s.owner||'.')||s.synonym_name||';'
from dba_synonyms  s
where table_owner not in('SYSTEM','SYS')
and db_link is null
and not exists
     (select  1
      from dba_objects o
      where s.table_owner=o.owner
      and s.table_name=o.object_name)
/
