/*

1) repetition-related (i.e. the driving operation is causing this operation to be executed more times than necessary)
2) filtering-related (i.e. because of lack of a more efficient access path, we read more rows than we actually need, and thus 
   waste I/O on accessing data that is not returned to the user).

Issues from the first group can be resolved by changing the method and/or order of join, by allowing subquery unnesting to avoid executing the
subquery per each row of the master query, and other similar methods. Very often, such issues are caused by wrong cardinality estimates, 
and providing more complete information to the optimizer can suffice for resolving the problem.

Issues from the second group typically arise when the optimizer lacks an appropriate access method to retrieve just as many rows as necessary. 
In such cases the problem can be resolved by either creating a new index or changing an existing one, modifying the query to avoid implicit conversions
that would make it possible for the query to use an existing index, adjusting partitioning strategy for tables involved in the query, etc.

*/

rem (c) Nikolay Savvinov, 2013
rem a script to identify performance bottlenecks
rem and estimate potential benefits from removing them
rem using rowsource statistics (will only return meaningful results
rem if the plan is still in the cache and if rowsource statistics were populated.
rem takes sql_id and child_number as parameters

set verify off
set linesize 400
set pagesize 9999

column id format 999
column operation format A40
column potential_savings format A30
column origin_of_inefficiency format A30
column comments format A30
column starts format 999999
column filter_predicates format A30
column repetition_ratio format 999999
spool report.txt

with myplan as
(
select p.sql_id, id, parent_id, operation, options, object_owner, object_name, object_type, cardinality, depth,
S.LAST_CR_BUFFER_GETS gets, S.last_starts STARTS, s.last_output_rows outrows, p.filter_predicates, p.access_predicates
from v$sql_plan p,
v$sql_plan_statistics s
where p.sql_id = s.sql_id
and P.CHILD_NUMBER = S.CHILD_NUMBER
and p.id = s.operation_id
--and (p.sql_id, p.child_number) = (SELECT * FROM (SELECT SQL_ID, CHILD_NUMBER FROM V$SQL WHERE SQL_TEXT like &&1 ORDER BY LAST_ACTIVE_TIME DESC) WHERE ROWNUM=1)
and p.sql_id = '&1'
and p.child_number = &2
),
extended_plan as
(
select mp.*,
(
select max(id)
from myplan
connect by prior id = parent_id
start with id = mp.id
and 'TABLE ACCESS' = mp.operation
and mp.options like 'BY%ROWID'
) rowid_provider_id,
(
select min(id)
from myplan
where parent_id = mp.id
) older_child_id,
(select min(id) from myplan where parent_id = mp.id) older_child,
(select count(*) from myplan where parent_id = mp.id) num_children
from myplan mp
),
opstats as
(
select owner, table_name, num_rows, blocks, t.stale_stats, t.user_stats
from dba_tab_statistics t
where table_name in (select object_name from myplan)
and partition_name is null
union
select owner, index_name, num_rows, leaf_blocks blocks, I.STALE_STATS, I.USER_STATS
from dba_ind_statistics i
where index_name in (select object_name from myplan)
and partition_name is null
),
segstats as
(
select owner, segment_name, sum(blocks) actual_blocks
from dba_segments s
where segment_name in (select object_name from myplan)
and rownum>0
group by owner, segment_name
),
inrows as
(
select lpad(' ', ep.depth, ' ') || operation || ' ' || options || ' ' plan_output,
(select min(id) from myplan where operation like 'PARTITION%' and id != ep.id connect by prior parent_id = id and num_children<=1 start with id = ep.id) partition_iterator_id,
case when operation in ('FILTER', 'INDEX', 'VIEW', 'TABLE ACCESS', 'COUNT') then gets
when operation = 'HASH JOIN' then gets - (select sum(gets) from extended_plan ep2 where parent_id = ep.id)
end own_gets,
case when operation = 'TABLE ACCESS' and options like 'BY%ROWID' then (select outrows from myplan where id = rowid_provider_id)
-- when operation = 'TABLE ACCESS' and options = 'FULL' then ss.num_rows*ep.starts
when operation = 'TABLE ACCESS' and options = 'FULL' then ceil(num_rows*gets/os.blocks)
when (operation = 'INDEX' and options like '%SCAN' and options != 'FULL SCAN') then ceil(num_rows*gets/os.blocks)
else (select outrows from myplan where id = older_child_id)
end inrows,
ep.*,
ceil(gets/os.blocks) rpt_ratio,
os.num_rows,
os.blocks,
ss.actual_blocks,
os.user_stats,
os.stale_stats
from extended_plan ep,
opstats os,
segstats ss
where ep.object_owner = os.owner (+)
and ep.object_name = os.table_name (+)
and ep.object_owner = ss.owner (+)
and ep.object_name = ss.segment_name (+)
),
leakage as
(
select inrows.*,
case when nvl(inrows,0) <= 0 then null
when inrows1 then 'inefficient filtering operation (probably a subquery could not be unnested)'
when operation = 'FILTER' and filter_predicates is not null and num_children=1 then 'restrictive single-source filtering operation'
when operation = 'INDEX' and starts = 1 and filter_predicates is not null then 'inefficient index filter predicates'
when operation = 'INDEX' and starts > 1 and partition_iterator_id is null and filter_predicates is null then 'inefficient driving operation (join, subquery etc.) and/or B-tree navigation overhead'
when operation = 'INDEX' and starts > 1 and partition_iterator_id is not null  and filter_predicates is null and (select operation || ' ' || options from leakage where id = l.partition_iterator_id) not like '%SINGLE%' then 'navigating multiple partitions of a local index (' || (select operation || ' ' || options from leakage where id = l.partition_iterator_id) || ')'
when operation = 'INDEX' and starts > 1 and partition_iterator_id is not null  and filter_predicates is null and (select operation || ' ' || options from leakage where id = l.partition_iterator_id)  like '%SINGLE%' then 'inefficient driving operation'
when operation = 'INDEX' and starts > 1 and partition_iterator_id is not null and filter_predicates is not null then 'inefficient index access predicates, navigating multiple partitions of a local index (' || (select operation || ' ' || options from leakage where id = l.partition_iterator_id) || ')'
when operation = 'INDEX' and starts > 1 and filter_predicates is not null then 'inefficient join order and/or access predicates'
when operation = 'TABLE ACCESS' and options = 'FULL' and starts = 1 and filter_predicates is not null then 'rows rejected by filter predicate after a full table scan'
when operation = 'TABLE ACCESS' and options = 'FULL' and starts > 1 then 'multiple executions of a full table scan'
when operation = 'TABLE ACCESS' and options like 'BY%ROWID' and starts > 1 and filter_predicates is null then 'inefficient driving operation (join, subquery etc.)'
when operation = 'TABLE ACCESS' and options like 'BY%ROWID' and starts>1 and filter_predicates is not null then 'inefficient driving operation (join, subquery etc.) and/or access predicates'
when operation = 'TABLE ACCESS' and options like 'BY%ROWID' and starts=1 and filter_predicates is not null then 'inefficient access predicates'
WHEN COST_LEAKAGE>0 THEN 'unknown'
end leakage_reason,
round(abs(100*(actual_blocks/blocks - 1))) stats_error,
nullif(rpt_ratio, 1) repetition_ratio,
max(gets) over () total_gets
from leakage l
)
select id,
operation || ' ' || options || ' ' || object_owner || decode(object_name, null, null, '.') || object_name operation, --num_rows, gets, inrows, outrows,
nvl2(cost_leakage, cost_leakage || ' (' || round(100*cost_leakage/gets) || '% operation, ' || round(100*cost_leakage/total_gets) || '% query)', 'UNKNOWN') potential_savings,
-- round(abs(100*(actual_blocks/blocks - 1))) || case when user_stats = 'YES' then ' caution: user-defined stats!' when stale_stats = 'YES' then ' caution: stale stats!' end "stats",
-- stale_stats,
-- user_stats,
case when cost_leakage is null then notes else leakage_reason end origin_of_inefficiency,
case when stats_error>10 then 'caution: actual blocks differ from estimated blocks by ' || stats_error || ' %' end || case when user_stats = 'YES' then '(user-defined stats!)' when stale_stats = 'YES' then '(stale stats!)' end comments,
starts/*,
repetition_ratio,
filter_predicates*/
from summary s
where gets>0
--where cost_leakage > 0
order by cost_leakage desc nulls first;

spool off


