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
from awr_2015.dba_hist_sys_time_model e, awr_2015.DBA_HIST_SNAPSHOT s
where s.snap_id = e.snap_id
and e.instance_number = s.instance_number
  and stat_name             = 'DB time'
)
where  begin_snap between (select min(snap_id) as min_snap_id FROM awr_2015.dba_hist_snapshot where begin_interval_time>sysdate-340 )
and (select max(snap_id) as max_snap_id FROM awr_2015.dba_hist_snapshot where begin_interval_time>sysdate-320 )
and begin_snap=end_snap-1
order by dbtime desc
)
where rownum < 2
)
select * from busy;


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
where  begin_snap between (select min(snap_id) as min_snap_id FROM dba_hist_snapshot where begin_interval_time>sysdate-10 )
and (select max(snap_id) as max_snap_id FROM dba_hist_snapshot where begin_interval_time>sysdate-1 )
and begin_snap=end_snap-1
order by dbtime desc
)
where rownum < 2
)
select * from busy;
