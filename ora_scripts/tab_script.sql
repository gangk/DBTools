set pagesize 0
set long 90000
set feedback off
set echo off 

select dbms_metadata.get_ddl('TABLE',u.table_name) from user_tables u;

select dbms_metadata.get_ddl('INDEX',u.index_name) from user_indexes u;

select dbms_metadata.get_ddl('VIEW',u.view_name) from user_views u;