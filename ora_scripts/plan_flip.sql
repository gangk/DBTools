set verify off;
set pagesize 999
set line 999
accept SQL_ID prompt 'Enter SQL_ID:- '
accept num_days prompt 'Enter number of days:- '
col buffer/exec format 999,999,999,999
col Disk_reads/exec format 999,999,999,999
col BEGIN_INTERVAL_TIME format a40;

select  b.sql_id,
        b.plan_hash_value,
        max(a.begin_interval_time) begin_interval_time
from    dba_hist_snapshot a,
        dba_hist_sqlstat b,
        (select  sql_id ,count(1)
        from    (select distinct a.sql_id, a.plan_hash_value
                from    dba_hist_sqlstat a, dba_hist_snapshot b
                where   a.snap_id = b.snap_id
                and     b.begin_interval_time > (sysdate - &num_days )
                )
        group by sql_id
        having count(1) > 1) c
where a.snap_id = b.snap_id
and b.sql_id = c.sql_id
and b.sql_id like '%&SQL_ID%'
and a.begin_interval_time > ( sysdate - &num_days)
group by b.sql_id, b.plan_hash_value
order by 1,3;

