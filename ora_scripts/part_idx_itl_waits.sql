col owner format a08
select s.OWNER owner, s.OBJECT_NAME, s.SUBOBJECT_NAME, s.VALUE, i.DEF_INI_TRANS
from v$segment_statistics s, dba_part_indexes i
where i.index_name = s.object_name
and i.owner = s.owner
and s.object_type in ('INDEX PARTITION','INDEX SUBPARTITION')
and s. statistic_name='ITL waits'
and s.value > 20
order by s.VALUE
;
