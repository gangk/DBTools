SELECT pid, now() - query_start as "runtime", usename, datname, wait_event, state, query
FROM  pg_stat_activity WHERE now() - query_start > '0.001 seconds'::interval and  state = 'active' ORDER BY runtime DESC;
