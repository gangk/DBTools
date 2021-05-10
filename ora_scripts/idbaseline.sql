SELECT b.sql_handle, b.plan_name, s.child_number,
  s.plan_hash_value, s.executions
FROM v$sql s, dba_sql_plan_baselines b
WHERE s.exact_matching_signature = b.signature(+)
  AND s.sql_plan_baseline = b.plan_name(+)
  AND s.sql_id='&SQL_ID'
/
undef SQL_ID
