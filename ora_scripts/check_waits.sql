@plusenv
col coltime 	format a13
col pst 	format a13
col cnt		format 99999
col event	format a40
select 	 to_char(collection_day,'MM/DD HH24:MI')	coltime
	,sum(wait_count) 	cnt
	,to_char(new_time(collection_day,'GMT','PST'),'MM/DD HH24:MI') pst
	,event
from 	 DB_HEALTH_HEARTBEAT_LOG 
where 	 collection_day > sysdate -1
and 	 event not like '%log file sync' 
and 	 event not like 'Space Manager%'
and 	 event not like 'DIAG idle wait%'
and	 event not like 'Backup: MML write%'
group by to_char(collection_day,'MM/DD HH24:MI')
	,event
	,to_char(new_time(collection_day,'GMT','PST'),'MM/DD HH24:MI')
having	 sum(wait_count) >2
order by to_char(collection_day,'MM/DD HH24:MI')
;
