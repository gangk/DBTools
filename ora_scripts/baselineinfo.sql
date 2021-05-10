accept text prompt 'enter text like :- '
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
select plan_name,sql_handle,enabled,accepted,fixed,created,creator,module from dba_sql_plan_baselines where sql_text like '%&text%';
select sql_text from dba_sql_plan_baselines where  sql_text like '%&text%' and rownum <2;
undef text
