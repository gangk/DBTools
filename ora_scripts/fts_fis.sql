with fts as
(select distinct p.sql_id, p.plan_hash_value
from
dba_hist_sql_plan p,dba_hist_sqlstat t, dba_hist_snapshot hs
where p.sql_id=t.sql_id
and t.snap_id=hs.snap_id
and p.operation='TABLE ACCESS'
and p.options='FULL'
and p.object_owner!='SYS'
and hs.begin_interval_time>sysdate-1
union
select distinct p.sql_id, p.plan_hash_value
from dba_hist_sqlstat t, dba_hist_sql_plan p, dba_hist_snapshot hs
where p.sql_id=t.sql_id
and t.snap_id=hs.snap_id
and p.operation='INDEX'
and p.options='FULL SCAN'
and p.object_owner!='SYS'
and hs.begin_interval_time>sysdate-1
)
select t.* from (SELECT distinct s.sql_id,
  s.plan_hash_value
FROM v$sql s, dba_sql_plan_baselines b
WHERE s.exact_matching_signature = b.signature(+)
  AND s.sql_plan_baseline = b.plan_name(+)
  AND s.sql_id in (select sql_id from fts)
and enabled='YES' and accepted='YES' ) pb,table(dbms_xplan.display_awr(pb.sql_id,pb.plan_hash_value)) t;
