set long 10000000
set longchunksize 10000000
select dbms_sqltune.report_sql_monitor (sql_id=>'&1') from dual;