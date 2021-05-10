set pagesize 0 
set echo off 
set timing off
set linesize 1000
set trimspool on 
set trim on 
set long 2000000 
set longchunksize 2000000 
set feedback off
accept sid  prompt "Enter value for sql_id: "
spool sql_monitor_report_&&sql_id.html
select dbms_sqltune.report_sql_monitor(type=>'EM', sql_id=>'ftbqr550hyvnz') monitor_report from dual;
spool off