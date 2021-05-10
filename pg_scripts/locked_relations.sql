SELECT relation, transaction, pid, mode, granted, relname
FROM pg_locks
INNER JOIN pg_stat_user_tables
ON pg_locks.relation = pg_stat_user_tables.relid
WHERE pg_locks.pid='pid';
