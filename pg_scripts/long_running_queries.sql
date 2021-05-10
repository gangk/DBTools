-- all running queries

SELECT pid, datname, usename, client_addr, now() - query_start as "runtime", query_start, wait_event, state, query
FROM pg_stat_activity
ORDER BY runtime DESC;

-- queries running longer than 30 min

SELECT pid, datname, usename, client_addr, now() - query_start as "runtime", query_start, wait_event, state, query
FROM pg_stat_activity
WHERE now() - query_start > '30 minutes'::interval
ORDER BY runtime DESC;

-- queries running longer than 2 hours

SELECT pid, datname, usename, client_addr, now() - query_start as "runtime", query_start, wait_event, state, query
FROM pg_stat_activity
WHERE now() - query_start > '2 hours'::interval
ORDER BY runtime DESC;

-- queries running longer than 5 days

SELECT pid, datname, usename, client_addr, now() - query_start as "runtime", query_start, wait_event, state, query
FROM pg_stat_activity
WHERE now() - query_start > '5 days'::interval
ORDER BY runtime DESC;

-- queries running longer than 2 weeks

SELECT pid, datname, usename, client_addr, now() - query_start as "runtime", query_start, wait_event, state, query
FROM pg_stat_activity
WHERE now() - query_start > '2 weeks'::interval
ORDER BY runtime DESC;

-- queries running longer than 2 months

SELECT pid, datname, usename, client_addr, now() - query_start as "runtime", query_start, wait_event, state, query
FROM pg_stat_activity
WHERE now() - query_start > '2 months'::interval
ORDER BY runtime DESC;
