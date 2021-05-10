col owner for a10
col object_name for a40
col object_type for a25
col status for a15

select owner,object_name,object_type,status,created,last_ddl_time from dba_objects where status !='VALID';