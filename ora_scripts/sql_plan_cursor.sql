set verify off
col PLAN_TABLE_OUTPUT format a140
select * from table(dbms_xplan.DISPLAY_CURSOR('&SQL_ID', '&CHILD_NO', 'TYPICAL'));
