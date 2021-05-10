SELECT pid, datname, usename, client_addr, now() - query_start as "runtime", query_start, wait_event, state, query
FROM pg_stat_activity
WHERE now() - query_start > '2 hours'::interval
ORDER BY runtime DESC;
