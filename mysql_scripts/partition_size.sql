SELECT PARTITION_ORDINAL_POSITION, TABLE_ROWS, PARTITION_METHOD
       FROM information_schema.PARTITIONS 
       WHERE TABLE_SCHEMA = 'db_name' AND TABLE_NAME = 'tbl_name';
