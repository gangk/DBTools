col prefix for a23
col total for 9999
col precreate for 9999
col DDU for 999
col ADU for 999
col type for a8
set feedback on
accept table_name Prompt 'Table name:- '
accept start_days prompt 'Days Ago:- '
accept end_days  prompt  'Days till :-'



select
        d.TABLE_NAME,PARTITION_NAME_PREFIX  prefix,ROLLING_PARTITION_TYPE type,d.START_TIME drop_start,d.END_TIME drop_end,round((d.END_TIME-d.start_time)*24*60) DDU,
        a.START_TIME add_start,a.END_TIME add_end,round((a.end_time-a.start_time)*24*60) ADU,
        d.UPDATE_GLOBAL_INDEXES,b.RETAIN_NUM_PARTITIONS total,b.PRE_CREATE_NUM_PARTITIONS precreate
from
        DB_DROP_PARTITION_LOG d, db_add_partition_log a, DB_ROLLING_PARTITIONS b
where
        b.table_name like upper('%&table_name%')
and
        d.table_name(+)=b.table_name
and
        trunc(a.start_time) between (sysdate - &start_days) and (sysdate - &end_days)
and
        trunc(d.start_time) between (sysdate - &start_days) and (sysdate - &end_days)
and
        trunc(d.start_time) =trunc(a.start_time)
and
        a.table_name(+)=b.table_name
order by 4,1,2;

Prompt Currently Running

col interval for a25
col object_name for a30
col sysdate for a20

select
        a.job,a.last_date,a.next_date,a.broken,a.failures,a.interval,s.sid,s.serial#,s.sql_id,d.object_name,sysdate
from
        dba_jobs a,dba_jobs_running b, v$session s, dba_objects d
where
        a.what like '%rolling_partition%'
and
        a.job=b.job
and
        b.sid=s.sid
and
        s.row_wait_obj#=d.object_id(+)
;

