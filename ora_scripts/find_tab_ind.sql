col owner for a10
col index_name for a25
col table_name for a25
col table_owner for a10
col tablespace_name for a15
select owner,index_name,table_owner,table_name,TABLESPACE_NAME,BLEVEL,DISTINCT_KEYS,CLUSTERING_FACTOR,NUM_ROWS,LAST_ANALYZED,PARTITIONED from dba_indexes where index_name=upper('&index_name');
