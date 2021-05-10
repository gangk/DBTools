accept sql_id prompt 'enter sql id :- '
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
SELECT PLAN_TABLE_OUTPUT FROM TABLE(dbms_xplan.DISPLAY_AWR('&sql_id'));

