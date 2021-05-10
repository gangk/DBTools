set lines 170
col sid		format 99999
col bgetspx	format 999,999,999.9
col bgets	format 9,999,999,999
col exec	format 999,999,999
col cnt		format 99
col event	format a30

break on stime on pdt skip 1

with	 sqlidstat 	as
(
select   sql_id, sum(executions) execs, sum(buffer_gets) bgets, sum(buffer_gets)/sum(executions) bgetspx
from     v$sqlstats
where    executions     >0
group by sql_id
)
	,dash		as
(
select 	 to_char(sample_time,'MM/DD HH24:MI')	stime
	,to_char(new_time(sample_time,'GMT','PDT'),'MM/DD HH24:MI') pdt
	,count(*)				cnt
	,SESSION_ID				sid
	,SQL_ID					
	,event					event
from 	 DBA_HIST_ACTIVE_SESS_HISTORY
where 	 to_char(new_time(sample_time,'GMT','PDT'),'MM/DD HH24:MI') between '10/21 07:27' 
									and '10/21 07:48'
and 	 SESSION_STATE = 'WAITING'
and	 SQL_ID is not null
group by to_char(sample_time,'MM/DD HH24:MI')
	,to_char(new_time(sample_time,'GMT','PDT'),'MM/DD HH24:MI')
	,SESSION_ID
	,SQL_ID
	,event
having	 count(*)>0
)
select 	 dash.stime
	,dash.pdt
	,dash.sid
	,dash.cnt
	,dash.sql_id
	,nvl(sqlidstat.bgetspx,0) bgetspx
	,dash.event
	,sqlidstat.execs
	,sqlidstat.bgets
from 	 dash
	,sqlidstat
where 	 dash.sql_id	= sqlidstat.sql_id 
order by dash.stime
	,sqlidstat.bgetspx desc
/
