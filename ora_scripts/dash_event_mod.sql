col sid format 99999
col bgetspx format 999,999,999.9
col bgets format 9,999,999,999
col exec format 999,999,999
col cnt format 99
col objid format 99999999
col event format a32

break on stime on pdt skip 1

accept start_time prompt 'Enter start time [ MM/DD HH24:MI ]: '
accept end_time prompt 'Enter start time [ MM/DD HH24:MI ]: '

with sqlidstat
as
(
	select   sql_id, sum(executions) execs, sum(buffer_gets) bgets, sum(buffer_gets)/sum(executions) bgetspx
	from     v$sqlstats
	where    executions   >0
	group by sql_id
)
,dash
as
(
	select 	to_char(sample_time,'MM/DD HH24:MI') stime,
			to_char(sample_time,'MM/DD HH24:MI') PDT,
			count(*) cnt,
			SESSION_ID sid,
                        MODULE module,
			SQL_ID,
			CURRENT_OBJ# objid,
			event event
	from 	DBA_HIST_ACTIVE_SESS_HISTORY
	where 	to_char(sample_time,'MM/DD HH24:MI') between '&start_time'  and '&end_time'
	and 	lower(event) like lower('%&&event_pattern%')
        and     module='&&module'
	group by to_char(sample_time,'MM/DD HH24:MI')
			,to_char(sample_time,'MM/DD HH24:MI')
			,SESSION_ID
			,MODULE
			,SQL_ID
			,CURRENT_OBJ#
			,event
	having count(*)>0
)
select 	dash.stime,
		dash.pdt,
		dash.sid,
		dash.cnt,
		dash.sql_id,
		dash.objid,
		nvl(sqlidstat.bgetspx,0) bgetspx,
		dash.event,
		sqlidstat.execs,
		sqlidstat.bgets
from 	dash ,
		sqlidstat
where 	dash.sql_id = sqlidstat.sql_id (+)
order by dash.stime
		,dash.event
		,dash.sql_id
;
