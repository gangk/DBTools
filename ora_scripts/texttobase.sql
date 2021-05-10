set lines 500
set heading on feedback on
accept text prompt 'enter text like :- '
col sql_text for a200
select plan_name,sql_handle,enabled,accepted,fixed,created,creator,origin sql_text from dba_sql_plan_baselines where sql_text like '%text%' and sql_text not like '%dba_sql_plan_baselines%';
select sql_text from  dba_sql_plan_baselines where sql_text like '%&text%' and sql_text not like '%dba_sql_plan_baselines%' group by sql_text;
undef text
