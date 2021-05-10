col owner for a15
col object_name for a40
col object_type for a20
select owner,object_name,object_type,to_char(last_ddl_time,'DD-MON-YY HH24:MI:SS')LAST_REBUILD_DATE from dba_objects where object_type='INDEX' and owner=UPPER('&owner_name');