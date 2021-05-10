col object_name for a30
col object_type for a20
col owner for a30
col status for a10
col created for a30
col data_object_id for 9999999999999
col object_id for 9999999999999
set lines 500
accept id Prompt 'Enter Object id:- '
select data_object_id,object_id,object_name,object_type,owner,status,created from dba_objects where object_id=&id;
undef id
