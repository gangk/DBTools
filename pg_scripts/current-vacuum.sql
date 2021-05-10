SELECT datname, usename, pid, current_timestamp - xact_start AS xact_runtime, state, query
FROM pg_stat_activity 
WHERE query LIKE '%autovacuum%' AND query NOT LIKE '%pg_stat_activity%'
ORDER BY xact_start;
