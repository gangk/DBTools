SELECT pg_stat_activity, pg_locks.mode
  FROM pg_stat_activity
  JOIN pg_locks USING (pid)
  JOIN pg_class ON pg_locks.relation = pg_class.oid
 WHERE pg_locks.mode IN ('ShareUpdateExclusiveLock', 'ShareLock', 'ShareRowExclusiveLock', 'ExclusiveLock', 'AccessExclusiveLock');
