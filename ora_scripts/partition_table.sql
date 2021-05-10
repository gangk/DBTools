col table_name for a15
col partition_name for a25
col high_value for a80

SELECT a.table_name,
       a.partition_name,
       a.HIGH_VALUE,
       a.last_analyzed,
       a.tablespace_name,
       a.initial_extent,
       a.next_extent,
       a.pct_increase,
       a.num_rows,
       a.avg_row_len
FROM   dba_tab_partitions a
WHERE  a.table_name  = UPPER('&table_name')
AND    a.table_owner = Upper('&owner')
ORDER BY a.PARTITION_POSITION;


