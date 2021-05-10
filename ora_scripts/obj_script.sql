set pagesize 0
set long 90000
set feedback off
set echo off 



select DBMS_METADATA.GET_DDL('DB_LINK',object_name) from user_objects where object_type ='DATABASE LINK' ;
select DBMS_METADATA.GET_DDL('FUNCTION',object_name) from user_objects where object_type ='FUNCTION' ;
select DBMS_METADATA.GET_DDL('INDEX',object_name) from user_objects where object_type ='INDEX' ;
select DBMS_METADATA.GET_DDL('PACKAGE_BODY',object_name) from user_objects where object_type ='PACKAGE BODY' ;
select DBMS_METADATA.GET_DDL('PACKAGE',object_name) from user_objects where object_type ='PACKAGE' ;
select DBMS_METADATA.GET_DDL('PROCEDURE',object_name) from user_objects where object_type ='PROCEDURE' ;
select DBMS_METADATA.GET_DDL('SEQUENCE',object_name) from user_objects where object_type ='SEQUENCE' ;
select DBMS_METADATA.GET_DDL('TABLE',object_name) from user_objects where object_type ='TABLE' ;
select DBMS_METADATA.GET_DDL('TRIGGER',object_name) from user_objects where object_type ='TRIGGER' ;
select DBMS_METADATA.GET_DDL('VIEW',object_name) from user_objects where object_type ='VIEW' ;
select dbms_metadata.GET_DDL('SYNONYM',SYNONYM_NAME) FROM DBA_SYNONYMS WHERE TABLE_OWNER='RAO';


set feedback on