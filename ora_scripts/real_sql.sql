SET lines 9999
SET pages 1000
SET LONG 999999
SET longchunksize 200
set serveroutput on;
set verify off;
alter session set nls_date_format='DD-MON-YYYY:HH24:MI:SS';
accept SQL_ID prompt 'Enter SQL_ID: '
declare
v_exec_id number;
v_exec_start varchar2(50);
v_report clob;
begin
select SQL_EXEC_ID, SQL_EXEC_START into v_exec_id, v_exec_start from v$sql_monitor where sql_id = '&SQL_ID' and SQL_EXEC_ID = (select SQL_EXEC_ID from (select SQL_EXEC_ID, SQL_EXEC_START from v$sql_monitor where sql_id = '&SQL_ID' order by SQL_EXEC_START desc) where rownum = 1);
dbms_output.put_line(v_exec_id||' - '||v_exec_start);
SELECT dbms_sqltune.report_sql_monitor(sql_id=>'&SQL_ID',sql_exec_id=>v_exec_id,sql_exec_start=> to_date(v_exec_start,'DD-MON-YYYY:HH24:MI:SS'),report_level=>'ALL') into v_report FROM dual;
dbms_output.put_line(v_report);
end;
/
