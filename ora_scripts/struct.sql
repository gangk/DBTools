begin DBMS_METADATA.SET_TRANSFORM_PARAM (
DBMS_METADATA.SESSION_TRANSFORM, 
'SQLTERMINATOR', 
TRUE);
end;
/

set pagesize 0
set long 90000
set feedback off
set echo off 

DEFINE OWNER=&SCHEMA_NAME

Prompt******************************************USER*******************************************************

select dbms_metadata.get_ddl('USER','&OWNER')  from dual;
select dbms_metadata.get_granted_ddl('ROLE_GRANT','&&OWNER')  from dual;
select dbms_metadata.get_granted_ddl('SYSTEM_GRANT','&&OWNER') from dual;
select dbms_metadata.get_granted_ddl('OBJECT_GRANT','&&OWNER') from dual;

Prompt******************************************  TABLE ************************************************

select DBMS_METADATA.GET_DDL('TABLE',object_name,'&&owner') from dba_objects where owner=upper('&&owner') and object_type ='TABLE' ;

Prompt******************************************  INDEX ************************************************

select DBMS_METADATA.GET_DDL('INDEX',object_name,'&&owner') from dba_objects where owner=upper('&&owner') and object_type ='INDEX' ;

Prompt******************************************  VIEW ************************************************

select DBMS_METADATA.GET_DDL('VIEW',object_name,'&&owner') from dba_objects where owner=upper('&&owner') and object_type ='VIEW' ;

Prompt******************************************  FUNCTION ************************************************

select DBMS_METADATA.GET_DDL('FUNCTION',object_name,'&&owner') from dba_objects where owner=upper('&&owner') and object_type ='FUNCTION' ;

Prompt******************************************  PROCEDURE ************************************************

select DBMS_METADATA.GET_DDL('PROCEDURE',object_name,'&&owner') from dba_objects where owner=upper('&&owner') and object_type ='PROCEDURE' ;

Prompt******************************************  PACKAGE ************************************************

select DBMS_METADATA.GET_DDL('PACKAGE',object_name,'&&owner') from dba_objects where owner=upper('&&owner') and object_type ='PACKAGE' ;

Prompt******************************************  PACKAGE BODY ************************************************

select DBMS_METADATA.GET_DDL('PACKAGE_BODY',object_name,'&&owner') from dba_objects where owner=upper('&&owner') and object_type ='PACKAGE BODY' ;

Prompt******************************************  TRIGGER ************************************************

select DBMS_METADATA.GET_DDL('TRIGGER',object_name,'&&owner') from dba_objects where owner=upper('&&owner') and object_type ='TRIGGER' ;

Prompt******************************************  SEQUENCE ************************************************

select DBMS_METADATA.GET_DDL('SEQUENCE',object_name,'&&owner') from dba_objects where owner=upper('&&owner') and object_type ='SEQUENCE' ;

Prompt******************************************  DATABASE LINK ************************************************

select DBMS_METADATA.GET_DDL('DB_LINK',object_name,'&&owner') from dba_objects where owner=upper('&&owner') and object_type ='DATABASE LINK' ;

Prompt******************************************  SYNONYM ************************************************

select DBMS_METADATA.GET_DDL('SYNONYM',synonym_name) from dba_synonyms where table_owner=upper('&&owner');

set echo on
set feedback on