col obj 	format a38	head 'Object Name'
col sobj	format a30	head 'SubObject'
col bbw_waits	format 99,999,999
select * from
(
select 	 s.OWNER||'.'||s.OBJECT_NAME 	obj
	,s.subobject_name		sobj
	,s.VALUE			bbw_waits
from 	 v$segment_statistics 	s
where 	 s. statistic_name	='buffer busy waits'
order by value desc
)
where	 rownum <21
;
