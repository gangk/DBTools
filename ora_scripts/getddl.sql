#set long 99999
set line 9999
set heading off
col Code format a9999
SELECT dbms_metadata.get_ddl(upper('&type'),upper('&obj_name'),upper('&owner')) "Code" from dual;
