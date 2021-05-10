set lines 170
select 	 substr(sql_text,1,150)
	,sum(sharable_mem)
	,sum(version_count)
from 	 v$sqlarea
group by substr(sql_text,1,150)
having 	 sum(sharable_mem)> 3000000 
order by 2,3;

