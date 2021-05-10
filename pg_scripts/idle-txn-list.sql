SELECT pid, datname, usename, client_addr, now() - query_start as "runtime", query_start, wait_event, state, query
FROM pg_stat_activity
WHERE (state = 'idle in transaction') and 
now() - query_start > '5 minutes'::interval
ORDER BY runtime DESC;
