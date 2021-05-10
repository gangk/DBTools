var v_num number;
accept sql_id prompt 'sql_id :- '
exec :v_num:=dbms_spm.load_plans_from_cursor_cache(sql_id => '&sql_id',plan_hash_value => '&plan_hash_value' );   
prompt 'Number of baselines Created:- '
print :v_num
col LAST_MODIFIED for a35
set lines 500
col creator for a20
select sql_handle, plan_name, creator, origin, LAST_MODIFIED, ENABLED, ACCEPTED, FIXED from dba_sql_plan_baselines where SIGNATURE IN (SELECT exact_matching_signature FROM v$sql WHERE sql_id='&&sql_id');
undef sql_id
undef plan_hash_value
