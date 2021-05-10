set lines 230
col index_owner for a14
col column_name for a30
break on table_name skip 1 on index_owner skip 1 on index_name skip 1
select table_name,index_owner,index_name,column_name,column_position from dba_ind_columns where table_name=upper('&table_name')  and owner=upper ('&owner') order by index_name,column_position;
clear col
clear breaks