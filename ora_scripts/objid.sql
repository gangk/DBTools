col object_id for 9999999999999
col object_name for a30
col object_type for a20
col owner for a20
col created for a30
col status for a10
set lines 500
accept name Prompt 'Enter name:- '
select data_object_id,object_id,object_name,object_type,owner,created,status from dba_objects where object_name=upper('&name');
undef name
