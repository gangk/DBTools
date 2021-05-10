SELECT trx.trx_id,
       trx.trx_started,
       trx.trx_mysql_thread_id
FROM INFORMATION_SCHEMA.INNODB_TRX trx
JOIN INFORMATION_SCHEMA.PROCESSLIST ps ON trx.trx_mysql_thread_id = ps.id 
WHERE trx.trx_started < CURRENT_TIMESTAMP - INTERVAL 1 SECOND
  AND ps.user != 'system_user';
From the above query once you have the trx_mysql_thread_id you can get the thread ID using the following command (since you have performance schema enabled)
SELECT *
FROM performance_schema.threads
WHERE processlist_id = threadID; 
