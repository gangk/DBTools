col owner for a10
col table_name for a30
col partition_name for a35

select OWNER,TABLE_NAME,PARTITION_NAME,UPDATE_GLOBAL_INDEXES,START_TIME,END_TIME from DB_DROP_PARTITION_LOG where START_TIME > sysdate -1 order by 5;
