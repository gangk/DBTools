col TABLE_NAME format A45
col ROLLING_PARTITION_TYPE format A10 heading "Type"
col RETAIN_NUM_PARTITIONS format 999,999 heading "Retain"
col PRE_CREATE_NUM_PARTITIONS format 999,999 heading "Pre-create"
col KEEP_PART_VALIDATION_CLAUSE format A15 heading "Keep|Clause"
col ROW_MOVEMENT_NEW_KEY_VALUE format A15 heading "New|Key|Value"
select 
	OWNER || '.' || TABLE_NAME TABLE_NAME,
	PARTITION_NAME_PREFIX, ROLLING_PARTITION_TYPE, RETAIN_NUM_PARTITIONS,
	PRE_CREATE_NUM_PARTITIONS
from
	db_rolling_partitions
order by
	1 ;
