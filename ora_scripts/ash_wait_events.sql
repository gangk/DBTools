@plusenv
col wclass	format a6	head 'Wait|Class'
col event	format a50	head 'Event Name'	trunc

break on wclass skip 1
select 	 decode(wait_class,'User I/O','I/O','WAIT')	wclass
     	,name						event
from 	 v$event_name
order by 1,2
;
