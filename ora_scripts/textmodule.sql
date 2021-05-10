set lines 500
set heading on feedback on
accept text prompt 'enter text like :- '
col sql_text for a200
col sql_id for a13
col module for a48
select sql_id,module,sum(executions) exec ,sql_text  from v$sql where upper(sql_text) like upper('%&text%') and ( sql_text not like '%v$sql%' and lower(sql_text) not like '%explain plan%') and module=nvl('&mymodule','SQL*Plus') group by sql_id,module,sql_text;
undef text
