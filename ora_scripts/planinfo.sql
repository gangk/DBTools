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
select plan_name,sql_handle,enabled,accepted,fixed,creator,created,module from dba_sql_plan_baselines where plan_name='&sql_plan';
select sql_text from dba_sql_plan_baselines where plan_name='&sql_plan' and rownum<2;
SELECT * FROM   TABLE(DBMS_XPLAN.display_sql_plan_baseline(plan_name=>'&sql_plan'));
undef sql_plan

