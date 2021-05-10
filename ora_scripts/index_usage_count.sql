col c1 heading 'Object|Name' format a30
col c2 heading 'Operation' format a15
col c3 heading 'Option' format a15
col c4 heading 'Index|Usage|Count' format 999,999
break on c1 skip 2
break on c2 skip 2

select
p.object_name ,
p.operation ,
p.options ,
count(1)
from
dba_hist_sql_plan p,
dba_hist_sqlstat s
where
p.object_owner = 'schemaname'
and
p.operation like '%INDEX%'
and
p.sql_id = s.sql_id
group by
p.object_name,
p.operation,
p.options
order by
1,2,3;


========================================


