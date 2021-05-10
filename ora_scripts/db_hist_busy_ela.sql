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
select sql_id, avg_pio, avg_lio, avg_etime, execs, rows_proc
from (
select dbms_lob.substr(sql_text,3999,1) sql_text, b.*
from dba_hist_sqltext a, (
select sql_id, sum(execs) execs, sum(etime) etime, sum(etime)/sum(execs) avg_etime, sum(pio)/sum(execs) avg_pio,
sum(lio)/sum(execs) avg_lio, sum(rows_proc) rows_proc
from (
select ss.snap_id, ss.instance_number node, begin_interval_time, sql_id,
nvl(executions_delta,0) execs,
elapsed_time_delta/1000000 etime,
(elapsed_time_delta/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_etime,
buffer_gets_delta lio,
disk_reads_delta pio,
rows_processed_delta rows_proc,
(buffer_gets_delta/decode(nvl(buffer_gets_delta,0),0,1,executions_delta)) avg_lio,
(rows_processed_delta/decode(nvl(rows_processed_delta,0),0,1,executions_delta)) avg_rows,
(disk_reads_delta/decode(nvl(disk_reads_delta,0),0,1,executions_delta)) avg_pio
from DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS
where
ss.snap_id = S.snap_id
and ss.instance_number = S.instance_number
and ss.snap_id between (select begin_snap from busy) and (select end_snap from  busy)
and executions_delta > 0
)
group by sql_id
order by 4 desc
) b
where a.sql_id = b.sql_id
and execs > 1
)
where rownum < 20;

