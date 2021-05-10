col owner for a10
col table_name for a30
col partition_name for a35
col PARTITION_VALUE for a35

select OWNER,TABLE_NAME,PARTITION_NAME,PARTITION_VALUE,START_TIME,END_TIME from DB_ADD_PARTITION_LOG where START_TIME  > sysdate -1 order by 5;

