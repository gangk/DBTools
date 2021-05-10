col owner for a10
col data_type for a15
col table_name for a25
set lines 230
break on owner skip 1 on table_name skip 1
select owner,table_name,COLUMN_NAME,NULLABLE,DATA_TYPE,NUM_DISTINCT,NUM_NULLS,LAST_ANALYZED,HISTOGRAM from dba_tab_columns where table_name=upper('&TABLE_NAME') order by owner,column_name
/
