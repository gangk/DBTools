@parm undo

col mb		format 999,999.99
break on report
compute sum of mb on report
select 	 status
	,sum(bytes)/(1024*1024) mb 
from 	 dba_undo_extents 
group by status
order by mb
;

@undo_stat
