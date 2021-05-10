col file_name for a50
col status for a15
col tablespace_name for a15
col PROPERTY_VALUE for a20


select file_name,tablespace_name,bytes/1024/1024 as "SIZE_IN_MB",status,autoextensible from dba_temp_files;
SELECT  PROPERTY_NAME,PROPERTY_VALUE  FROM DATABASE_PROPERTIES where PROPERTY_NAME='DEFAULT_TEMP_TABLESPACE';


