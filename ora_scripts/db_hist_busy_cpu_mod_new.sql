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
select module,cpu,pctcpu from (select   
        module
        ,cpu
        ,100*ratio_to_report (cpu) over () pctcpu
        ,wait
        ,io
        ,tot
from
(
select   
        ash.module     module
        ,sum(decode(ash.session_state,'ON CPU',1,0))     cpu
        ,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0)) wait
        ,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    io
        ,sum(decode(ash.session_state,'ON CPU',1,1))     tot
from     DBA_HIST_ACTIVE_SESS_HISTORY ash
        ,v$event_name en
where    ash.sql_id is not NULL
and      ash.event_id=en.event# (+)
and snap_id between (select begin_snap from busy) and (select end_snap from busy)
group by module
order by sum(decode(session_state,'ON CPU',1,0))   desc
)
where rownum <=20)
;

