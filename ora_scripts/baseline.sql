set line 999
set verify off;
col creator format a15;
col LAST_MODIFIED format a30;
col sql_text format a200;
col created for a30
set long 99999
accept SQL_ID prompt 'Enter sql ID:- '
select sql_text from dba_sql_plan_baselines where SIGNATURE IN (SELECT exact_matching_signature FROM v$sql WHERE sql_id='&SQL_ID') and rownum < 2;
select sql_handle, plan_name, creator,created, origin, LAST_MODIFIED, ENABLED, ACCEPTED, FIXED from dba_sql_plan_baselines
where SIGNATURE IN (SELECT exact_matching_signature FROM v$sql WHERE sql_id='&SQL_ID');
set serveroutput on;
declare
v_sql_handle varchar2(50);
v_plan_name varchar2(50);
v_plan_hash_value varchar2(50);
v_creator varchar2(50);
v_origin varchar2(50);
v_last_modified varchar2(50);
v_enabled varchar2(50);
v_accepted varchar2(50);
v_fixed varchar2(50);
begin
    dbms_output.put_line('SQL_HANDLE                  PLAN_NAME                         PLAN_HASH_VALUE    ENABLED    ACCEPTED     FIXED');
    dbms_output.put_line('-------------------------   ----------------------------      --------------     -------    -------      -------');
for plan in (select plan_name from dba_sql_plan_baselines where signature in (select exact_matching_signature from v$sql where sql_id = '&SQL_ID'))
loop
    select sql_handle, plan_name,  plan_hash_value, ENABLED, ACCEPTED, FIXED
    into v_sql_handle, v_plan_name, v_plan_hash_value , v_enabled, v_accepted, v_fixed
    from dba_sql_plan_baselines, (select substr(plan_table_output,18) plan_hash_value from table(DBMS_XPLAN.display_sql_plan_baseline(plan_name=>plan.plan_name)) where plan_table_output like ('Plan hash value:%'))
    where plan_name = plan.plan_name;
    dbms_output.put_line(v_sql_handle||'    '|| v_plan_name||'     '||v_plan_hash_value||'          '||v_enabled||'        '||v_accepted||'           '||v_fixed);
end loop;
end;
/
undef SQL_ID
