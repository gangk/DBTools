set lin 500 pages 10000
set long 999999999
SELECT dbms_metadata.get_ddl(upper('&type'),upper('&obj_name'),upper('&owner')) from dual;
