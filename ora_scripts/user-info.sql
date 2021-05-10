set lin 200 pages 200
set long 9999

accept username         prompt 'Enter DB User Name : '

SELECT dbms_metadata.get_ddl('USER',upper('&&username')) FROM dual;

select GRANTED_ROLE from dba_role_privs where grantee=upper('&&username');
select PRIVILEGE from dba_sys_privs where GRANTEE=upper('&&username');
select PRIVILEGE,TABLE_NAME,OWNER from dba_tab_privs where GRANTEE=upper('&&username');

