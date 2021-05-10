set verify off
col PLAN_TABLE_OUTPUT format a140
select * from table(dbms_xplan.display_awr('&SQL_ID', '&PLAN_HASH_VALUE', null, 'TYPICAL'));
