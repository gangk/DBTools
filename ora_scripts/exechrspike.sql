set lines 500
col begin_interval_time for a28
col prev_time for a28
col module for a48

select PREV_TIME,begin_interval_time,SQL_ID,PLAN_HASH_VALUE,EXECUTIONS_DELTA,PREV_EXEC,SPIKE,module
from
(
select BEGIN_INTERVAL_TIME,PREV_TIME,SQL_ID,PLAN_HASH_VALUE,EXECUTIONS_DELTA,PREV_EXEC,SPIKE,rank() over (partition by sql_id order by spike desc) drank,module
from
(select 
	BEGIN_INTERVAL_TIME,lag(BEGIN_INTERVAL_TIME,1) over (partition by sql_id order by begin_interval_time) Prev_Time, 
	sql_id,plan_hash_value,executions_delta,lag(executions_delta,1) over (partition by sql_id order by begin_interval_time) Prev_exec,
	executions_delta-lag(executions_delta,1) over (partition by sql_id order by begin_interval_time) Spike,module
from
(
select 
	BEGIN_INTERVAL_TIME , sql_id, plan_hash_value,module, EXECUTIONS_DELTA
from 
	dba_hist_sqlstat sql, dba_hist_snapshot snap 
where 
	snap.snap_id=sql.snap_id 
and  
	begin_interval_time>=trunc(sysdate)
	and module not in ('FCMVIEWREFRESH')
order by 1 desc
) order by 7 desc
) where Prev_Time is not null and prev_exec is not null order by 7 desc
) where drank=1 and rownum < 11 order by 7 desc;
