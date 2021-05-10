set lines 500
accept table prompt 'enter table name :- '
col index_name for a30
col column_name for a40
col PARTITIONED for a20
col index_name for a30
col column_name for a30
col position for 99
col search_condition for a50
col constraint_name for a30
col con.r_constraint_name for a15
select TABLESPACE_NAME,LAST_ANALYZED,SAMPLE_SIZE,PARTITIONED from dba_tables where table_name=upper('&table');
select index_name,column_name,column_position from dba_ind_columns where table_name=upper('&table') order by 1,3 ;
select sum(bytes)/1024/1024 "Mb",sum(bytes)/1024/1024/1024 "Gb" from dba_segments where segment_name=upper('&table');
select  con.constraint_name,col.column_name,col.position,con.constraint_type,con.search_condition,con.r_constraint_name,con.index_name from dba_constraints con ,dba_cons_columns col where con.constraint_name=col.constraint_name and con.table_name=upper('&table')  order by 1,3;
prompt Rolling Partition
select PARTITION_NAME_PREFIX,ROLLING_PARTITION_TYPE,RETAIN_NUM_PARTITIONS,PRE_CREATE_NUM_PARTITIONS from db_rolling_partitions where table_name=upper('&table');
undef table

