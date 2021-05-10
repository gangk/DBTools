accept day prompt 'Enter dd-mon-yyyy :- '
set lines 500
col module for a50
select module,coll_day,collection_hour,prev_coll,max_sessions,prev_session,spike from
(
select module,coll_day,collection_hour,prev_coll,max_sessions,prev_session,spike,rank() over (partition by module order by spike desc nulls last) rank
from
(
select 
	module,coll_day,collection_hour,lag(collection_hour,1) over (partition by module order by collection_hour) prev_coll,max_sessions,lag(max_sessions,1) over (partition by module order by collection_hour) prev_session,max_sessions-lag(max_sessions,1) over (partition by module order by collection_hour) spike
from
	(
		select substr(module,1,37) module, to_char(COLLECTION_DAY,'YYYY-MM-DD') coll_day,collection_hour, max(cnt) max_sessions
		from
		 	 (
		 		select 
		 			module,COLLECTION_DAY, collection_hour, sum(session_count) cnt
		 		from 
		 			db_session_log 
		 		where  
		 			collection_day between to_date('&day','dd-mon-yyyy hh24:mi:ss') and to_date(to_date('&day','dd-mon-yyyy hh24:mi:ss') + interval '23' HOUR,'dd-mon-yyyy hh24:mi:ss')
		 		and 
		 			collection_hour between 0 and 23
		 		group by module,COLLECTION_DAY, collection_hour
		 	)
		 group by module,to_char(COLLECTION_DAY,'YYYY-MM-DD') ,collection_hour order by 1,2
	)
) where spike is not null order by spike desc
) where rank=1 and rownum<21;
undef day
