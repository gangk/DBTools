select * from
(
select sql_id, module, sum(BUFFER_GETS_DELTA)/sum(EXECUTIONS_DELTA) Buffer_gets_per_execution,
sum(ROWS_PROCESSED_DELTA)/sum(EXECUTIONS_DELTA) Rows_processed_per_execution
from dba_hist_sqlstat a, dba_hist_snapshot b
where a.snap_id = b.snap_id
 and a.PARSING_SCHEMA_NAME not in ('ADMIN','SYS','SYSTEM')
 and b.snap_id between (select min(snap_id) as min_snap_id FROM dba_hist_snapshot where begin_interval_time>sysdate-7 )
and (select max(snap_id) as max_snap_id FROM dba_hist_snapshot where begin_interval_time>sysdate-1 ) 
 and EXECUTIONS_DELTA > 0
group by sql_id, module
order by 3 desc ) 
where rownum<20;

