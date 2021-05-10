col OBJECT_NAME for a30
col OBJECT_TYPE for a15
select object_name,object_type,status from dba_objects where owner=upper('&schema_name') order by 2;