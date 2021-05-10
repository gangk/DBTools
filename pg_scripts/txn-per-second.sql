SELECT datname, xact_commit, xact_rollback, stats_reset, ((xact_commit + xact_rollback ) / EXTRACT(EPOCH FROM ( now() - stats_reset))) as transactions_per_sec
FROM pg_stat_database
order by 5 desc;
