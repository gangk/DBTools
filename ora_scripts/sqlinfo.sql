col "io wait" for 999999999999999
col sql_text for a500
col Operation for a30
col options for a40
col Optimal/onepass/Multipass for a15
accept sql_id prompt 'enter sql_id :- '

select
        sum(disk_reads)"phy_io",
        sum(buffer_gets) "logical_io",
        sum(executions) "executions",
        round( sum(disk_reads)/sum(executions), 1) "phy/exe",
        round( sum(buffer_gets)/sum(executions), 1) "log/exec",
        round( sum(fetches)/sum(executions), 1 )"fetches/exec",
        round( sum(rows_processed)/sum(executions), 1) "rows/exec",
        round( sum(buffer_gets)/decode(sum(fetches),0,1,sum(fetches)),1) "log/fetch",
        round( sum(buffer_gets)/decode(sum(rows_processed),0,1,sum(rows_processed)),1) "log/rows",
        round( sum(fetches)/decode(sum(rows_processed),0,1,sum(rows_processed)), 1) "fetches/rows",
        round( sum(sorts)/decode(sum(rows_processed),0,1,sum(rows_processed)), 1 ) "sorts/exec",
        round( sum(CPU_TIME)/decode(sum(rows_processed),0,1,sum(rows_processed))/1000000,1) "cpu/row",
        round( sum(ELAPSED_TIME)/decode(sum(rows_processed),0,1,sum(rows_processed))/1000000,1) "elap/row"
from
        v$sql
where
        sql_id='&sql_id';


set heading off feedback off
select 'NOTE : All the below times are in SECONDS' from dual ;
set heading on feedback on

select
        round( sum(APPLICATION_WAIT_TIME)/1000000, 1) "App_wait_time",
        round( sum(CONCURRENCY_WAIT_TIME)/1000000, 1) "Concurr_wait_time",
        round( sum(USER_IO_WAIT_TIME)/1000000, 1) "iowait time",
        round( sum(CPU_TIME)/1000000, 1 ) "cpu_time",
        round( sum(ELAPSED_TIME)/1000000, 1) "elap_time",
        round( sum(executions), 1) "execs" ,
        round( sum(APPLICATION_WAIT_TIME)/sum(executions)/1000000, 1) "appwait/exec",
        round( sum(CONCURRENCY_WAIT_TIME)/sum(executions)/1000000, 1) "concurr_wait/exec",
        round( sum(USER_IO_WAIT_TIME)/sum(executions)/1000000, 1) "iowait/exec Secs",
        round( sum(CPU_TIME)/sum(executions)/1000000, 1) "cpu/exec",
        round( sum(ELAPSED_TIME)/sum(executions)/1000000, 1) "elap/exec"
from
        v$sql
where
        sql_id='&sql_id';

select  plan_hash_value,max(timestamp) from v$sql_plan where sql_id='&sql_id' group by plan_hash_value order by 2 desc;

prompt ****Versions information ****
select version_count ,LOADED_VERSIONs,OPEN_VERSIONS,USERS_OPENING,LOADS,FIRST_LOAD_TIME,sysdate,INVALIDATIONS from v$sqlarea where sql_id='$sql_id';

prompt **** Plan flips ****
select sql_id
       ,plan_hash_value
       ,prev_hash_value
       ,timestamp
from (
select sql_id
       ,plan_hash_value
       ,timestamp
       ,lag(plan_hash_value,1) over (order by timestamp) prev_hash_value
from   dba_hist_sql_plan
where  sql_id = '&sql_id'
)
where  plan_hash_value != prev_hash_value
/

prompt ***** executions spiked *****
col "Prev Time" for a30
col btime for a30
select * from
(
        select sql_id,ph,lag(btime,1) over (order by baggtime) "Prev Time",btime,lag(execs,1) over (order by baggtime) "Prev exec",execs,execs-lag(execs,1) over (order by baggtime) "Diff"
        from
        (SELECT  distinct sql_id,TO_CHAR(snap.END_INTERVAL_TIME - (sysdate - current_date), 'YYYY-MM-DD HH24')  baggtime
                           ,       stat.PLAN_HASH_VALUE ph
                           ,       MIN(snap.END_INTERVAL_TIME)
                                    OVER(PARTITION BY TO_CHAR(snap.END_INTERVAL_TIME - (sysdate - current_date), 'YYYY-MM-DD HH24')) btime
                           ,       SUM(stat.EXECUTIONS_DELTA)
                                    OVER(PARTITION BY TO_CHAR(snap.END_INTERVAL_TIME - (sysdate - current_date), 'YYYY-MM-DD HH24')) execs
                           FROM DBA_HIST_SQLSTAT stat
                           ,    DBA_HIST_SNAPSHOT snap
                           WHERE stat.SNAP_ID = snap.SNAP_ID
                           AND   stat.SQL_ID = '&sql_id'
                           AND   snap.END_INTERVAL_TIME - (sysdate - current_date)  >= sysdate-2
                           AND   snap.END_INTERVAL_TIME - (sysdate - current_date) <= sysdate
                           order by 4 desc
)
order by 7 desc
) where rownum <7 ;


prompt **** Maximum executions ****
select * from
(
        select sql_id,ph,lag(btime,1) over (order by baggtime) "Prev Time",btime,lag(execs,1) over (order by baggtime) "Prev exec",execs,execs-lag(execs,1) over (order by baggtime) "Diff"
        from
        (SELECT  distinct sql_id,TO_CHAR(snap.END_INTERVAL_TIME - (sysdate - current_date), 'YYYY-MM-DD HH24')  baggtime
                           ,       stat.PLAN_HASH_VALUE ph
                           ,       MIN(snap.END_INTERVAL_TIME)
                                    OVER(PARTITION BY TO_CHAR(snap.END_INTERVAL_TIME - (sysdate - current_date), 'YYYY-MM-DD HH24')) btime
                           ,       SUM(stat.EXECUTIONS_DELTA)
                                    OVER(PARTITION BY TO_CHAR(snap.END_INTERVAL_TIME - (sysdate - current_date), 'YYYY-MM-DD HH24')) execs
                           FROM DBA_HIST_SQLSTAT stat
                           ,    DBA_HIST_SNAPSHOT snap
                           WHERE stat.SNAP_ID = snap.SNAP_ID
                           AND   stat.SQL_ID = '&sql_id'
                           AND   snap.END_INTERVAL_TIME - (sysdate - current_date)  >= sysdate-2
                           AND   snap.END_INTERVAL_TIME - (sysdate - current_date) <= sysdate
                           order by 4 desc
)
order by 6  desc
) where rownum < 7;

Prompt **** current Executions ****
col BEGIN_INTERVAL_TIME format a30;
col prev_time format a30;

select * from
(select  lag(b.BEGIN_INTERVAL_TIME,1) over (order by b.BEGIN_INTERVAL_TIME) prev_time,
        b.BEGIN_INTERVAL_TIME,
        SQL_ID,
        plan_hash_value,
        EXECUTIONS_DELTA,
        lag(EXECUTIONS_DELTA,1) over(order by BEGIN_INTERVAL_TIME) prev_exec,
        EXECUTIONS_DELTA-lag(EXECUTIONS_DELTA,1) over(order by BEGIN_INTERVAL_TIME) diff
from    dba_hist_sqlstat a, dba_hist_snapshot b
where   a.snap_id = b.snap_id
and     b.BEGIN_INTERVAL_TIME > (sysdate - 5)
and     sql_id = '&sql_id'
order by b.BEGIN_INTERVAL_TIME desc)
where rownum < 6;


col options format A30 trunc
col operation format A20 trunc
col name for a30
col Optimal/onepass/Multipass for a25
select distinct
   operation,
   options,
   object_name name,
   trunc(bytes/1024/1024) "input(MB)",
   trunc(last_memory_used/1024) last_mem,
   trunc(estimated_optimal_size/1024) opt_mem,
   trunc(estimated_onepass_size/1024) onepass_mem,
   decode(optimal_executions, null, null,
   optimal_executions||'/'||onepass_executions||'/'||
   multipasses_executions) "Optimal/onepass/Multipass"
from
   v$sql_plan p,
   v$sql_workarea w
where
   p.address=w.address(+)
and
   p.hash_value=w.hash_value(+)
and
  p.id=w.operation_id(+)
and
  p.sql_id='&sql_id';

select count(*) as "cursors spawned" from v$sql_shared_cursor ssc where sql_id='&sql_id';

prompt **** child ****
select child_number from v$sql where sql_id='&sql_id';


select module,sql_fulltext from v$sql where sql_id='&sql_id'  and rownum<2;

var v_child_number number;

begin
select max(CHILD_NUMBER) into :v_child_number from v$sql where sql_id = '&sql_id';
end;
/

SELECT * FROM TABLE(dbms_xplan.display_cursor('&sql_id',:v_child_number));

set serveroutput on;
declare
v_sql_handle varchar2(50);
v_plan_name varchar2(50);
v_plan_hash_value varchar2(50);
v_creator varchar2(50);
v_origin varchar2(50);
v_last_modified varchar2(50);
v_enabled varchar2(50);
v_accepted varchar2(50);
v_fixed varchar2(50);
v_reproduced varchar2(50);
v_autopurge varchar2(50);
begin
    dbms_output.put_line('SQL_HANDLE                  PLAN_NAME                         PLAN_HASH_VALUE    ENABLED    ACCEPTED     FIXED     REPRODUCED AUTOPURGED   CREATOR');
    dbms_output.put_line('-------------------------   ----------------------------      --------------     -------    -------      -------   ---------- ----------  --------');
for plan in (select plan_name from dba_sql_plan_baselines where signature in (select exact_matching_signature from v$sql where sql_id = '&sql_id'))
loop
    select sql_handle, plan_name,  plan_hash_value, ENABLED, ACCEPTED, FIXED,REPRODUCED,AUTOPURGE,CREATOR
    into v_sql_handle, v_plan_name, v_plan_hash_value , v_enabled, v_accepted, v_fixed,v_reproduced,v_autopurge,v_creator
    from dba_sql_plan_baselines, (select substr(plan_table_output,18) plan_hash_value from table(DBMS_XPLAN.display_sql_plan_baseline(plan_name=>plan.plan_name)) where plan_table_output like ('Plan
 hash value:%'))
    where plan_name = plan.plan_name;
    dbms_output.put_line(v_sql_handle||'    '|| v_plan_name||'     '||v_plan_hash_value||'          '||v_enabled||'        '||v_accepted||'           '||v_fixed||'           '||v_reproduced||'
   '||v_autopurge||'       '||v_creator);
end loop;
end;
/

