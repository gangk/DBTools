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
and (select max(snap_id) as max_snap_id FROM dba_hist_snapshot where begin_interval_time>sysdate-5 )
and begin_snap=end_snap-1
order by dbtime desc
)
where rownum < 2
)
select * from (select module,ash_secs,100*ratio_to_report (ash_secs) over () pctio from (SELECT
                                               h.module
                                        ,      SUM(10) ash_secs
                                        ,ROW_NUMBER() OVER ( ORDER BY SUM(10) desc
                                                              ) AS rn
                                        FROM   dba_hist_snapshot x
                                        ,      dba_hist_active_sess_history h
                                        WHERE  x.snap_id between (select begin_snap from busy) and (select end_snap from busy) 
                                        AND    h.SNAP_id = X.SNAP_id
                                        AND    h.dbid = x.dbid
                                        AND    h.instance_number = x.instance_number
                                        AND    h.module not like 'DBMS%'
                                        and sql_id is not null
                                        GROUP BY h.module
                                        ORDER BY ash_secs desc) )where rownum<=20;
