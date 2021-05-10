undef tabname
col obj 	format a38	head 'Object Name'
col itl_waits	format 99,999,999
select * from
(
select 	 s.OWNER||'.'||s.OBJECT_NAME obj
	,sum(s.VALUE)		itl_waits
	,i.INI_TRANS
	,pi.DEF_INI_TRANS
from 	 v$segment_statistics 	s
	,dba_indexes 		i
	,dba_part_indexes 	pi
where 	 s.owner 		= pi.owner (+)
and 	 s.object_name 		= pi.index_name (+)
and	 s.owner		= i.owner (+)
and	 s.object_name		= i.index_name (+)
and 	 s.object_type 		like 'INDEX%'
and 	 s.statistic_name	='ITL waits'
and	 i.table_name		='&&tabname'
group by s.OWNER||'.'||s.OBJECT_NAME
	,i.INI_TRANS
	,pi.DEF_INI_TRANS
order by sum(s.VALUE) desc
)
where	 rownum <101
;
