select distinct inst_id,sid,status,sql_id,sql_plan_hash_value,sql_child_address,sql_exec_id
 from gv$sql_plan_monitor
 where sid in (&1) and status='EXECUTING';
