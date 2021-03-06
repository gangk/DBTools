set serveroutput on
set echo on
set pagesize 5000
set linesize 230
column comp_name format a40
select comp_name, version, status from dba_registry;
select owner, status, count(*) from all_objects where object_type like '%JAVA%' group by owner, status;
select owner, object_type, count(*) from all_objects where object_type like '%JAVA%' and status <> 'VALID' group by owner, object_type;
select owner, status, object_type, object_name from all_objects where object_name like'%DBMS_JAVA%';
select owner, status, object_type, object_name from all_objects where object_name like'%INITJVMAUX%';
select * from v$sgastat where POOL = 'java pool' or NAME = 'free memory';
show parameter pool_size
show parameter sga
select owner, object_type, status, dbms_java.longname(object_name) from all_objects where object_type like '%JAVA%' and status <> 'VALID';
