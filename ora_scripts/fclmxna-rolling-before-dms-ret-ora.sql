create table admin.db_rolling_partitions_moo as select * from db_rolling_partitions where OWNER='BOOKER';

select TABLE_NAME,ROLLING_PARTITION_TYPE,RETAIN_NUM_PARTITIONS from db_rolling_partitions where owner='BOOKER';

update admin.db_rolling_partitions set RETAIN_NUM_PARTITIONS=1000 where owner='BOOKER';

select TABLE_NAME,ROLLING_PARTITION_TYPE,RETAIN_NUM_PARTITIONS from db_rolling_partitions where owner='BOOKER';
commit;

