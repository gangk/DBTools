SELECT * FROM (
    SELECT
          blocking_activity.pid AS blocking_pid
        , blocking_activity.application_name AS application_name  
        , blocking_activity.state AS state
        , blocking_activity.wait_event AS wait_event
        , substring(blocking_activity.query, 1, 35)   AS blocking_statement
        , extract(epoch from now()) - extract(epoch from max(blocking_activity.xact_start)) AS max_xact_duration
        , extract(epoch from now()) - extract(epoch from max(blocking_activity.query_start)) AS max_query_duration
        , count(distinct blocking_activity.pid) sessions
        , count(distinct blocked_activity.pid) blocked_sessions
        , max(blocked_locks.pid) as blocked_pid
    FROM pg_catalog.pg_stat_activity blocking_activity
    LEFT JOIN pg_catalog.pg_locks         blocking_locks
        ON blocking_activity.pid = blocking_locks.pid
    LEFT JOIN pg_catalog.pg_locks         blocked_locks
        ON blocking_locks.locktype = blocked_locks.locktype
        AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
        AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
        AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
        AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
        AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
        AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
        AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
        AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
        AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
        AND blocking_locks.pid != blocked_locks.pid
        AND NOT blocked_locks.GRANTED
    LEFT JOIN pg_catalog.pg_stat_activity blocked_activity
        ON blocked_activity.pid = blocked_locks.pid
    GROUP BY
        blocking_activity.pid,
        blocking_activity.application_name,
        blocking_activity.state,
        blocking_activity.wait_event,
        substring(blocking_activity.query, 1, 35)
) t
WHERE ((state <> 'idle' and max_query_duration > 0.01 AND blocked_pid IS not NULL) OR blocked_sessions > 0)
ORDER BY
      blocked_sessions desc
    , max_query_duration desc
    , application_name;


-- to confirm

SELECT pg_blocking_pids(<root>); 
