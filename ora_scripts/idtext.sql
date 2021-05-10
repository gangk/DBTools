set long 9999999
col sql_text for a250
col sql_fulltext for a250
set lines 500
accept mysql prompt 'Enter sql id:- '
select sql_fulltext from v$sql where sql_id='&mysql' and rownum <2;

select sql_text  from dba_hist_sqltext where sql_id='&mysql';

undef mysql
