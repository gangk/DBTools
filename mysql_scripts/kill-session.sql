CALL mysql.rds_kill(thread-ID) ;

CALL mysql.rds_kill_query(thread-ID); 

SELECT GROUP_CONCAT(CONCAT('KILL ',id,';') SEPARATOR ' ') 'Paste the following query to kill all processes' FROM information_schema.processlist WHERE user<>'system user';

SELECT GROUP_CONCAT(CONCAT('call mysql.rds_kill(',id,');') SEPARATOR ' ') 'Paste the following query to kill all processes' FROM information_schema.processlist WHERE user='scrs_rw_user_001';

