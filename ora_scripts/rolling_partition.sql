col owner for a10
col table_name for a35
col partition_name for a35
col ROW_MOVEMENT_NEW_KEY_VALUE for a20

select OWNER,TABLE_NAME,PARTITION_NAME_PREFIX,ROLLING_PARTITION_TYPE,RETAIN_NUM_PARTITIONS,PRE_CREATE_NUM_PARTITIONS,ROW_MOVEMENT_NEW_KEY_VALUE from DB_ROLLING_PARTITIONS order by 2;