set line 999
set pagesize 999
set verify off;
col sql_id format a15;
col host_type format a10;
col BASELINE format a35;
col profile format a25;
col fts_ifs format a7;
col "buffer_gets/exec" format 999,999,999,999
col "cpu_time/exec" format 999,999,999,999
col "elapsed_time/exec" format 999,999,999,999
col "disk_reads/exec" format 999,999,999,999
accept SQL_ID prompt 'Enter SQL_ID to check:- '
accept HOST_TYPE prompt 'Enter Host Type to compare:- '
select a.db_name, e.prim_owner, c.host_type, sql_id, plan_hash_value, fts_ifs, exec, baseline, profile, round(buffer_gets/exec) "buffer_gets/exec", round(cpu_time/exec) "cpu_time/exec", round(elapsed_time/exec) "elapsed_time/exec", round(disk_reads/exec) "disk_reads/exec", max(last_active_time) last_active_time
from sql_perf a, db_details b, host_details c, (WITH pivot_data AS (
		select amzn_id, database, role from m2_database_relationships c
		where start_date = (select max(start_date) from m2_database_relationships d where c.database = d.database and c.role = d.role))
		SELECT * from pivot_data
		pivot(max(amzn_id) for role in ('PRIMARY' as prim_owner,'SECONDARY' as sec_owner))) e
where a.sql_id = '&SQL_ID'
and a.db_name = b.db_name
and b.host_name = c.host_name
and a.db_name = lower(e.database(+))
and b.db_role = 'primary'
and a.db_name not like 't%'
and c.host_type like '%'||'&HOST_TYPE'||'%'
group by a.db_name, e.prim_owner, c.host_type, sql_id, plan_hash_value, fts_ifs, exec, baseline, profile , round(buffer_gets/exec), round(cpu_time/exec), round(elapsed_time/exec), round(disk_reads/exec)
order by 3,(round(buffer_gets/exec) + round(cpu_time/exec) + round(elapsed_time/exec) + round(disk_reads/exec));


prompt Best Plan:
prompt ==========
select db_name,owner,host_type,sql_id, plan_hash_value, fts_ifs, exec, baseline, profile, "buffer_gets/exec","cpu_time/exec", "elapsed_time/exec", "disk_reads/exec" from (
select a.db_name db_name, e.prim_owner owner, c.host_type host_type, sql_id sql_id, plan_hash_value plan_hash_value , fts_ifs fts_ifs , exec exec , baseline, profile, round(buffer_gets/exec) "buffer_gets/exec", round(cpu_time/exec) "cpu_time/exec", round(elapsed_time/exec) "elapsed_time/exec", round(disk_reads/exec) "disk_reads/exec",
rank() over (partition by c.host_type order by (round(buffer_gets/exec) + round(cpu_time/exec) + round(elapsed_time/exec) + round(disk_reads/exec))) ranking
from sql_perf a, db_details b, host_details c, (WITH pivot_data AS (
		select amzn_id, database, role from m2_database_relationships c
		where start_date = (select max(start_date) from m2_database_relationships d where c.database = d.database and c.role = d.role))
		SELECT * from pivot_data
		pivot(max(amzn_id) for role in ('PRIMARY' as prim_owner,'SECONDARY' as sec_owner))) e
where a.sql_id = '&SQL_ID'
and a.db_name = b.db_name
and b.host_name = c.host_name
and a.db_name = lower(e.database(+))
and b.db_role = 'primary'
and a.db_name not like 't%'
and a.db_name not in (select lower(database) from fc_database_schemas where CREATED_DATE_UTC > to_date('01-01-2012','DD-MM-YYYY') and database like 'DC%')
order by 3,(round(buffer_gets/exec) + round(cpu_time/exec) + round(elapsed_time/exec) + round(disk_reads/exec))
 ) where ranking=1
 order by host_type;
