-- Rolling Partition Job Run

select admin.manage_rolling_partitions();
select admin.manage_rolling_partitions_aft();
select admin.manage_rolling_partitions_aft(true, NULL, 'booker', 'lh_asin_unit_aggs');

-- Disable/Enable Triggers
select admin.disable_triggers();
select admin.enable_triggers();

--kill long running queries

SELECT
  pid,
  now() - pg_stat_activity.query_start AS duration,
  query,
  state
FROM pg_stat_activity
WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes';

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'Database_Name'
	AND pid <> pg_backend_pid()
	AND state in ('idle', 'idle in transaction', 'idle in transaction (aborted)', 'disabled') 
	AND state_change < current_timestamp - INTERVAL '15' MINUTE;

select locktype,database,relation,pid,mode,granted from pg_locks where pid != pg_backend_pid();
select pg_blocking_pids();

SELECT pg_cancel_backend(__pid__);
SELECT pg_terminate_backend(__pid__);

