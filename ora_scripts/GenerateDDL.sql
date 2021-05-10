set heading off;
set feedback off;
set verify off;
set pagesize 0;
set linesize 1000;
set newpage none;
set long 5000000;

spool file_name.sql ;


EXECUTE DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',false);
EXEC DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE);
EXEC DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', FALSE);
EXEC DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'CONSTRAINTS', FALSE);
EXEC DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'REF_CONSTRAINTS', FALSE);
exec DBMS_METADATA.SET_TRANSFORM_PARAM (DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', true);
exec DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',true);




SELECT DBMS_METADATA.GET_DDL('TABLE',TN.TABLE_NAME)  FROM USER_TABLES TN  ;


     
SELECT DBMS_METADATA.GET_DDL('PACKAGE',PACK.OBJECT_NAME)  FROM USER_OBJECTS PACK WHERE OBJECT_TYPE='PACKAGE';



SELECT DBMS_METADATA.GET_DDL('PACKAGE BODY',PACK_BOD.OBJECT_NAME)  FROM USER_OBJECTS PACK_BOD WHERE OBJECT_TYPE='PACKAGE BODY';
 


SELECT DBMS_METADATA.GET_DDL('VIEW',UO.OBJECT_NAME)  FROM USER_OBJECTS UO WHERE OBJECT_TYPE='VIEW';
     
col output for a2000;



SELECT TRIM(DBMS_METADATA.GET_DDL('INDEX',IND.INDEX_NAME)) as output   FROM USER_INDEXES IND;  



spool off;


