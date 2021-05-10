set long 500000
set lines 3000
SET HEAD off
set trimspool on
set pages 500
col def for a10000 
exec dbms_metadata.SET_TRANSFORM_PARAM (dbms_metadata.SESSION_TRANSFORM, 'PRETTY', true); 
exec dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', true );
exec dbms_metadata.SET_TRANSFORM_PARAM (dbms_metadata.SESSION_TRANSFORM, 'STORAGE', false);
set long 500000 pages 0 lines 50 doc off 
col def for a900 word_wrapped

SELECT  replace(dbms_metadata.get_ddl('MATERIALIZED_VIEW',upper('&obj_name'),'BOOKER'),'"','') as def from dual;

