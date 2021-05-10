set lines 500
col module for a50
select module,coll_day,prev_coll,max_sessions,prev_session,spike from
(
select module,coll_day,prev_coll,max_sessions,prev_session,spike,rank() over (partition by module order by spike desc nulls last) rank
from
(
select 
	module,coll_day,lag(coll_day,1) over (partition by module order by coll_day) prev_coll,max_sessions,lag(max_sessions,1) over (partition by module order by coll_day) prev_session,max_sessions-lag(max_sessions,1) over (partition by module order by coll_day) spike
from
	(
		select substr(module,1,37) module, to_char(COLLECTION_DAY,'YYYY-MM-DD') coll_day, max(cnt) max_sessions
		from
		 	 (
		 		select 
		 			module,COLLECTION_DAY, collection_hour, sum(session_count) cnt, count(distinct machine) machine_cnt 
		 		from 
		 			db_session_log 
		 		where  
		 			collection_day >= sysdate-&days
		 		and 
		 			collection_day <= sysdate 
		 		group by module,COLLECTION_DAY, collection_hour
		 	)
		 group by module,to_char(COLLECTION_DAY,'YYYY-MM-DD') order by 1,2
	)
) where spike is not null order by spike desc
) where rank=1 and rownum<21;
undef days
