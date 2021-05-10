col STAT_NAME for a30
with snap_shot as
(
select begin_time,SNAP_ID,rank from (
select trunc(BEGIN_INTERVAL_TIME,'MI') begin_time,SNAP_ID,rank() over (order by snap_id desc) as rank from DBA_HIST_SNAPSHOT
) where rank<3
),
new as
(select * from snap_shot where rank = 1),
old as
(select * from snap_shot where rank = 2)
select stat1.STAT_NAME,stat2.value-stat1.value value,(new.begin_time-old.begin_time)*24 duration_in_hour,
(stat2.value-stat1.value)/((new.begin_time-old.begin_time)*24) value_per_hour
from DBA_HIST_SYSSTAT stat1, DBA_HIST_SYSSTAT stat2,new,old
where stat1.snap_id=old.snap_id
and stat2.snap_id=new.snap_id
and stat1.STAT_NAME=stat2.STAT_NAME
and stat1.STAT_NAME in ('redo size','physical reads','physical writes','session logical reads','user calls',
'read rollbacks','transaction rollbacks','user rollbacks','user commits')
order by stat1.STAT_NAME;
