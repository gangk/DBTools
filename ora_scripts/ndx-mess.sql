set pages 500
set lines 1000
select 'alter system kill session '''||sid||','''||serial#||''' immediate;' from v$session where sid in (select session_id from v$locked_object where object_id = (select object_id from dba_objects where object_type='TABLE' AND OBJECT_NAME='&TABLE_NAME'));
undef TABLE_NAME
