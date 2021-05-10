REM get_obj_id
col owner for a12
col data_object_id for 999999
col object_name for a30

select owner,data_object_id,object_name,object_type,status from dba_objects where owner=upper('&owner) and object_name=upper(&object)
