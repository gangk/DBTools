col obj 	format a38
col itl_waits	format 99,999,999
select * from
(
select 	 s.OWNER||'.'||s.OBJECT_NAME obj
	,sum(s.VALUE)		itl_waits
	,t.INI_TRANS		t_init
	,pt.INI_TRANS		pt_init
from 	 v$segment_statistics 	s
	,dba_tables 		t
	,dba_tab_partitions 	pt
where 	 s.owner 		= pt.table_owner (+)
and 	 s.object_name 		= pt.table_name (+)
and	 s.subobject_name	= pt.partition_name (+)
and	 s.owner		= t.owner (+)
and	 s.object_name		= t.table_name (+)
and 	 s.object_type 		like 'TABLE%'
and 	 s. statistic_name	='ITL waits'
and	 s.owner		not in ('SYS','SYSTEM')
and	 s.value		> 0
group by s.OWNER||'.'||s.OBJECT_NAME
	,t.INI_TRANS
	,pt.INI_TRANS
order by sum(s.VALUE) desc
)
where	 rownum <31
;
