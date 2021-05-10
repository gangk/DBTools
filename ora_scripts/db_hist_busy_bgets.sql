with busy as
(select begin_snap, end_snap from (
select begin_snap, end_snap, timestamp begin_timestamp, inst, a/1000000/60 DBtime from
(
select
e.snap_id end_snap,
lag(e.snap_id) over (order by e.snap_id) begin_snap,
lag(s.end_interval_time) over (order by e.snap_id) timestamp,
s.instance_number inst,
e.value,
nvl(value-lag(value) over (order by e.snap_id),0) a
from dba_hist_sys_time_model e, DBA_HIST_SNAPSHOT s
where s.snap_id = e.snap_id
and e.instance_number = s.instance_number
  and stat_name             = 'DB time'
)
where  begin_snap between (select min(snap_id) as min_snap_id FROM dba_hist_snapshot where begin_interval_time>sysdate-5 )
and (select max(snap_id) as max_snap_id FROM dba_hist_snapshot where begin_interval_time>sysdate-1 )
and begin_snap=end_snap-1
order by dbtime desc
)
where rownum < 2
)
select * from
(
select sql_id, module, sum(BUFFER_GETS_DELTA)/sum(EXECUTIONS_DELTA) Buffer_gets_per_execution,
sum(ROWS_PROCESSED_DELTA)/sum(EXECUTIONS_DELTA) Rows_processed_per_execution
from dba_hist_sqlstat a, dba_hist_snapshot b
where a.snap_id = b.snap_id
and b.snap_id between (select begin_snap from busy) and (select end_snap from busy)
group by sql_id, module
order by 3 desc ) 
where rownum<20;


