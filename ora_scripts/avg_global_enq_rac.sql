PRINT ######Synchronous gets are usually locking events, whereas asynchronous gets are usually caused by nonblocking inter-instance process activity##########
 SELECT
 global_enqueue_get_time AS "Get Time",
 global_enqueue_gets_sync AS "Synchronous Gets",
 global_enqueue_gets_async AS "Asynchronous Gets",
 (global_enqueue_get_time * 10) /
 (global_enqueue_gets_sync + global_enqueue_gets_async)
 AS "Average (MS)"
 FROM
 (
 SELECT value AS global_enqueue_get_time
 FROM v$sysstat
 WHERE name = 'global enqueue get time'
 ),
 (
 SELECT value AS global_enqueue_gets_sync
 FROM v$sysstat
 WHERE name = 'global enqueue gets sync'
 ),
 (
 SELECT value AS global_enqueue_gets_async
 FROM v$sysstat
 WHERE name = 'global enqueue gets async'
 )
/