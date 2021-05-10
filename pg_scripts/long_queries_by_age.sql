\echo "==========================Report of Long Running Requests(>2 min)=========================="

SELECT datname, pid, state, query, age(clock_timestamp(), query_start) AS req_age, age(clock_timestamp(), xact_start) as txn_age
FROM pg_stat_activity
WHERE state <> 'idle'
and  age(clock_timestamp(), query_start) > '2 minutes'::interval and age(clock_timestamp(), xact_start) > '2 minutes'::interval;
