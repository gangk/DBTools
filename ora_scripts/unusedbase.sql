accept sql_plan prompt 'enter sql plan :- '
set lines 500
col sql_text for a250
col plan_name for a30
col sql_handle for a30
col module for a48
col enabled for a10
col accepted for a10
col fixed for a10
col creator for a20
col created for a30
select plan_table_output from (SELECT * FROM   TABLE(DBMS_XPLAN.display_sql_plan_baseline(plan_name=>'&sql_plan',format=>'advanced'))) where rownum < 5;
undef sql_plan
