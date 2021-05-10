col owner for a12
col object_name for a25
col object_type for a18

select owner,object_name,object_id,object_type,status,created,last_ddl_time from dba_objects where object_name=upper('&object_name');
