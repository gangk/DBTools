undef last_x_mins
@plusenv
col samptime	format a14

break on samptime on sql_id on current_obj#
select 	to_char(sample_time,'MM/DD HH24:MI') samptime
	,sql_id
	,current_obj#
	,count(*)	cnt
	,p1
	,p2 
from 	 v$active_session_history 
where 	 sample_time 	>= sysdate - &&last_x_mins/1440 
and 	 event 		like 'buffer busy %' 
group by to_char(sample_time,'MM/DD HH24:MI')
	,sql_id
	,current_obj#
	,p1
	,p2
order by samptime
	,sql_id
	,current_obj#
	,count(*) desc
/
