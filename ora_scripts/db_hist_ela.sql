select sql_id,  avg_pio, avg_lio, avg_etime, execs, rows_proc
from (
select  b.*
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
and ss.BEGIN_INTERVAL_TIME > SYSDATE -3
and executions_delta > 0
)
group by sql_id
order by 4 desc
) b
where a.sql_id = b.sql_id
and execs > 1
)
where rownum <20;


