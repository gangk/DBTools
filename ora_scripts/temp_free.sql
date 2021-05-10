col DEFAULT_TEMP for  a15
col tablespace_name for a10


select PROPERTY_VALUE as "DEFAULT_TEMP" from database_properties where PROPERTY_NAME='DEFAULT_TEMP_TABLESPACE';
select tablespace_name,sum(bytes_used/1024/1024)  USEB_IN_MB,sum(bytes_free/1024/1024) FREE_IN_MB  from v$temp_space_header group by tablespace_name;