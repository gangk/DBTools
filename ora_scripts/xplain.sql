COL id          FORMAT 999
COL parent_id   FORMAT 999 HEADING "PARENT"
COL operation   FORMAT a35 TRUNCATE
COL object_name FORMAT a30
set line 9999
set pagesize 100
SELECT     id, parent_id, LPAD (' ', LEVEL - 1) || operation || ' ' || options operation, object_name, COST, CARDINALITY, BYTES, TEMP_SPACE, TIME
FROM       plan_table
START WITH id = 0
CONNECT BY PRIOR id = parent_id;
