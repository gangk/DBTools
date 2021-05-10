set lines 500
accept index prompt 'index name :- '
col column_name for a30
col table_name for a30
col index_type for a20
col table_name for a30
col degree for a5
col PARTITIONED for a10
col TABLESPACE_NAME for a20
select * from (select a.TABLE_NAME,a.UNIQUENESS,a.TABLESPACE_NAME,a.BLEVEL,a.LEAF_BLOCKS,a.DISTINCT_KEYS,a.LAST_ANALYZED,a.DEGREE,a.PARTITIONED,b.locality,b.partitioning_type,b.partition_count from dba_indexes a,dba_part_indexes b where a.index_name=upper('&index') and a.index_name = b.index_name(+)  order by 1) where rownum=1;
select distinct column_name,column_position from dba_ind_columns where index_name=upper('&index') order by 2;
select sum(bytes)/1024/1024 "Mb",sum(bytes)/1024/1024/1024 "Gb" from dba_segments where segment_name=upper('&index');
undef index
