select SQL_ID,ADDRESS,CHILD_NUMBER,HASH_VALUE,CHILD_ADDRESS,SQL_PLAN_BASELINE,SQL_PROFILE,PLAN_HASH_VALUE from v$sql where sql_id='&id';

exec sys.dbms_shared_pool.purge('&address, &hash_value','c');
