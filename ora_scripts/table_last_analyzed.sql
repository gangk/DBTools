col owner for a10
col table_name for a25
col tablespace_name for a14
col degree for a10
col time for a22

select OWNER,TABLE_NAME,TABLESPACE_NAME,NUM_ROWS,DEGREE,SAMPLE_SIZE,to_char(LAST_ANALYZED,'DD-MM-YY Hh24:MI:SS')TIME,PARTITIONED from dba_tables
where owner=upper('&owner') and table_name=upper('&table_name');