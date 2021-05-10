col TABLE_NAME format A30
col ROLLING_PARTITION_TYPE format A10 heading "Type"
col RETAIN_NUM_PARTITIONS format 999,999 heading "Retain"
col PRE_CREATE_NUM_PARTITIONS format 999,999 heading "Pre-create"
col KEEP_PART_VALIDATION_CLAUSE format A15 heading "Keep|Clause"
col ROW_MOVEMENT_NEW_KEY_VALUE format A15 heading "New|Key|Value"
col ELAPSED_TIME format A20
column OBJECT_NAME format a40 print
col object_type format A20
col AVG_ROW_LEN format 999 heading "Avg|Row|Len"
col BLOCKS format 999,999,999
col SEGMENT_NAME format A30
col NUM_ROWS format 999,999,999,999
col PARTITIONED format A12
col SIZE_IN_MB format 999,999
col subobject_name format A30
col UPDATE_GLOBAL_INDEXES format A10 heading "Update|G Indexes"
col ran_for format A20
col filler format A1 heading ''
col START_TIME format A25
col END_TIME format A8

prompt
prompt === Rolling partitions job history for last few days ===
prompt
accept go_back prompt 'go back ( no. of days, default 5 ) :- ' default 5
accept table prompt 'Table :- '

break on TABLE_NAME skip 1 duplicate
select 
   TABLE_NAME, PARTITION_NAME, UPDATE_GLOBAL_INDEXES ,
   START_TIME, to_char(END_TIME,'hh24:mi') END_TIME , '' filler,
   trunc( ( ( END_TIME - START_TIME ) - trunc( END_TIME - START_TIME ) ) * 24 ) || 'h, ' ||
   trunc( (( END_TIME - START_TIME )* 24 -  trunc(( END_TIME - START_TIME )* 24) ) * 60) || 'm, '  ||
   trunc(MOD((END_TIME - START_TIME)*24*60*60, 60)) || 's' ran_for
from 
   DB_DROP_PARTITION_LOG 
where  
   START_TIME > sysdate - &go_back  and
   table_name like upper(nvl('%&table%', table_name))
order by
   TABLE_NAME, START_TIME ;
clear break

set feedback off heading off
select 'Date : ' || sysdate from dual ;
set feedback 1 heading on
prompt



