set pagesize 0
set long 90000
set feedback off
set echo off
set verify off
set timing off
set escape off


select dbms_metadata.get_ddl('USER','&OWNER')  from dual;
select dbms_metadata.get_granted_ddl('ROLE_GRANT','&&OWNER')  from dual;
select dbms_metadata.get_granted_ddl('SYSTEM_GRANT','&&OWNER') from dual;
select dbms_metadata.get_granted_ddl('OBJECT_GRANT','&&OWNER') from dual;


set feedback on




