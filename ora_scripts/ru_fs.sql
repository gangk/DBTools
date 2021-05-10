select sql_id,sum(EXECUTIONS),sum(BUFFER_GETS),sum(DISK_READS),sum(BUFFER_GETS)/sum(EXECUTIONS) "Per Execution Buffer gets", sum(DISK_READS)/sum(EXECUTIONS) "per exec disk reads" from v$sqlarea where sql_id in 
(
(select distinct p.sql_id
from
dba_hist_sql_plan p,dba_hist_sqlstat t, dba_hist_snapshot hs
where p.sql_id=t.sql_id
and t.snap_id=hs.snap_id
and p.operation='TABLE ACCESS'
and p.options='FULL'
and p.object_owner!='SYS'
and hs.begin_interval_time>sysdate-1
union
select distinct p.sql_id
from dba_hist_sqlstat t, dba_hist_sql_plan p, dba_hist_snapshot hs
where p.sql_id=t.sql_id
and t.snap_id=hs.snap_id
and p.operation='INDEX'
and p.options='FULL SCAN'
and p.object_owner!='SYS'
and hs.begin_interval_time>sysdate-1
)
)
group by sql_id
order by 5
;
