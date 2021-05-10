set lines 500
accept module prompt 'enter module :- '
col sql_id for a14
col module for a40
set long 99999
col sql_text for a60 word_wrap
set feedback on
Prompt Currently running sql
select distinct sql_id,plan_hash_value,module,sql_text from v$sql where sql_id in (select sql_id from v$session where module='&&module'
	 );

col sql_id for a13
col reads_per_exec for 9999999999
col disk_reads for 999999999999
col executions for 9999999
col sql_text for a50 trunc
col buffer_gets_per_exec format 999,999,999 heading "Gets/exec"
col reads_per_exec format 999,999,999 heading "Reads/exec"
prompt High I/O
select * from (select sql_id,cast(disk_reads/(executions+1) as integer) as reads_per_exec,disk_reads,executions,module,substr(sql_text,1,90) sql_text from V$SQLAREA where disk_reads/(executions+1) > 1 and executions > 1  and module='&&module' order by disk_reads/(executions+1) desc ) where module='&&module' and rownum <21;

prompt High Logical I/O
select * from (select sql_id,cast(buffer_gets/(executions+1) as integer) as buffer_gets_per_exec,buffer_gets,executions,module,substr(sql_text,1,90) sql_text from V$SQLAREA where buffer_gets/(executions+1) > 1 and executions > 1 and module='&&module' order by buffer_gets/(executions+1) desc ) where module='&&module' and rownum <21;

Prompt Sql having more than 1 plan as per v$sql_plan
select sql_id,plan_hash_value,max(timestamp) from v$sql_plan where (sql_id) in (select sql_id from v$sql where module='&&module' group by sql_id having count(distinct plan_hash_value) >= 2)group by sql_id,plan_hash_value order by 3 desc, 2 desc;


Prompt plan flip in last 5 days
select  b.sql_id,
        b.plan_hash_value,
        max(a.begin_interval_time) begin_interval_time
from    dba_hist_snapshot a,
        dba_hist_sqlstat b,
        (select  sql_id ,count(1)
        from    (select distinct a.sql_id, a.plan_hash_value
                from    dba_hist_sqlstat a, dba_hist_snapshot b
                where   a.snap_id = b.snap_id
                and     b.begin_interval_time > (sysdate - 2 )
                )
        group by sql_id
        having count(1) > 1) c
where a.snap_id = b.snap_id
and b.sql_id = c.sql_id
and b.module='&module'
and a.begin_interval_time > ( sysdate - 5)
group by b.sql_id, b.plan_hash_value
order by 1,3;

prompt Baseline Info generated in last 24 Hours
col plan_name for a30
col sql_handle for a30
col enabled for a5
col accepted for a5
col fixed for a5
col created for a30
col creator for a15
col sql_text for a50 trunc
select plan_name,sql_handle,created,creator,enabled,accepted,fixed,sql_text from dba_sql_plan_baselines where module='&&module' and created >= sysdate -1;


col machine format a60
col program format a6
col event format a10
col Server Format a9
col JobID format a6
col sid format 99999
set lines 1000
set pages 10000
set trimspool on
break on report
compute sum of Used_MB on report
compute sum of Alloc_mem on report
compute sum of Freeable_MB on report
compute sum of Max_MB on report

prompt Machine Information
select status,machine,count(*) from v$session where module='&&module' group by status,machine order by 3 desc,2 desc;

prompt Connection History
col COLL_DATE format A10 heading "Date"
select substr(module,1,37) MODULE, to_char(COLLECTION_DAY,'YYYY-MM-DD') COLL_DATE ,
       max(cnt) MAX_SESSIONS, round(avg(cnt)) AVG_SESSIONS, min(cnt) MIN_SESSIONS, max(machine_cnt) MAX_MACHINES, min(machine_cnt) MIN_MACHINES from
 (select module,COLLECTION_DAY, collection_hour, sum(session_count) cnt
 , count(distinct machine) machine_cnt from db_session_log where  (module ='&module')  and
 collection_day >= sysdate-5 and collection_day <= sysdate group by module,COLLECTION_DAY, collection_hour)
  group by module,to_char(COLLECTION_DAY,'YYYY-MM-DD') order by 1,2;

Prompt Memory Consumption
select count(1) session_count ,
       	round( sum(PGA_USED_MEM/1024/1024) ) SUM_Used_MB,
	round( sum(PGA_ALLOC_MEM/1024/1024) ) SUM_Alloc_mem,
	round( sum(PGA_FREEABLE_MEM/1024/1024) ) SUM_Freeable_MB,
	round( sum(PGA_MAX_MEM/1024/1024) ) SUM_Max_MB, 
	round( avg (PGA_ALLOC_MEM/1024/1024) ) avg_Alloc_mem,
	round( avg(PGA_MAX_MEM/1024/1024) ) avg_Max_MB 
from 
	v$process p,
	v$session s 
where 
	s.paddr=p.addr  and nvl(p.background,0)<>1 and module='&&module';

undef module
