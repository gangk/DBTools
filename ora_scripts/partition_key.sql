col owner for a10
col name for a20
col column_name for a20


select * from DBA_PART_KEY_COLUMNS where NAME=UPPER('&table_name') and owner=UPPER('&table_owner');