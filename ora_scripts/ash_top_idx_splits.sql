undef last_x_mins
@plusenv
col event 	format a32 trunc
col sql_id	format a13
col pct		format 999.9	head 'Pct'
col oname	format a40	trunc
col stime_pdt	format a11
col etime_pdt	format a11
col dur_mins	format 999	head 'Mins'

break on event 

select 	 event
	,stime_pdt
	,etime_pdt
	,dur_mins
	,oname
	,sql_id
	,cnt
	,100*ratio_to_report (cnt) over () pct
from
(
select 	 ash.event			event
	,to_char(min(new_time(sample_time,'GMT','PDT')),'MM/DD HH24:MI')	stime_pdt
	,to_char(max(new_time(sample_time,'GMT','PDT')),'MM/DD HH24:MI')	etime_pdt
	,extract(day    from(max(sample_time)-min(sample_time)))*24*60 +
	 extract(hour   from(max(sample_time)-min(sample_time)))*60 +
	 extract(minute from(max(sample_time)-min(sample_time)))		dur_mins
	,ash.sql_id			sql_id
        ,owner||'.'||object_name	oname
	,count(*)			cnt
from 	 v$active_session_history 	ash
	,dba_objects			o
where	 event		= 'enq: TX - index contention'
and	 sql_id 	is not NULL
and	 ash.session_state = 'WAITING'
and 	 sample_time 	>= sysdate - &&last_x_mins/1440
and	 current_obj#	= o.object_id
group by event
	,owner||'.'||object_name
	,sql_id
order by count(*) desc
)
where 	 rownum <=10
;
