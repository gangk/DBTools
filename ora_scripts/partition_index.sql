SELECT a.index_name,
       a.partition_name,
       a.status,
       a.tablespace_name,
       a.initial_extent,
       a.next_extent,
       a.pct_increase,
       a.num_rows
FROM   dba_ind_partitions a
WHERE  a.index_name  = Upper('&index_name')
AND    a.index_owner = Upper('&owner')
ORDER BY a.PARTITION_POSITION;
