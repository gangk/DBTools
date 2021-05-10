SET LONG 2000000
SET LONGCHUNKSIZE 120

select dbms_metadata.get_ddl('TABLESPACE','&TABLESPACE_NAME') from dual;