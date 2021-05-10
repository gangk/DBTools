col table_name for a30
col column_name for a30


select table_name,index_name,column_name,column_position from dba_ind_columns where table_name=UPPER('&table_name') and table_owner=UPPER('&owner')
/
