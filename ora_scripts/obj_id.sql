col owner for a15
col object_name for a30
select owner,object_name,object_type,status from dba_objects where object_id=&object_id;