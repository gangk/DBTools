select sql_id
    ,      child_number
    ,      is_bind_aware
    ,      is_bind_sensitive
    ,      is_shareable
    ,      to_char(exact_matching_signature) sig
    ,      executions
   ,      plan_hash_value,
   sql_plan_baseline
   from   v$sql
where  sql_id = '&sql_id';