accept handle prompt 'enter sql handle :- '
set lines 500
set feedback on heading on
col sql_text for a250
col plan_name for a30
col sql_handle for a24
col module for a48
col enabled for a3
col accepted for a3
col fixed for a3
col creator for a10
col created for a28
col last_executed for a28
col plan_hash_value for 999999999999
select sql_text from dba_sql_plan_baselines where sql_handle='&handle' and rownum<2;
select sql_handle,plan_name,enabled,accepted,fixed,autopurge,creator,created,last_executed,module from dba_sql_plan_baselines where sql_handle='&handle';
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
v_reproduced varchar2(50);
v_autopurge varchar2(50);
begin
    dbms_output.put_line('SQL_HANDLE                  PLAN_NAME                         PLAN_HASH_VALUE    ENABLED    ACCEPTED     FIXED     REPRODUCED AUTOPURGED   CREATOR');
    dbms_output.put_line('-------------------------   ----------------------------      --------------     -------    -------      -------   ---------- ----------  --------');
for plan in (select plan_name from dba_sql_plan_baselines where  sql_handle='&handle')
loop
    select sql_handle, plan_name,  plan_hash_value, ENABLED, ACCEPTED, FIXED,REPRODUCED,AUTOPURGE,CREATOR
    into v_sql_handle, v_plan_name, v_plan_hash_value , v_enabled, v_accepted, v_fixed,v_reproduced,v_autopurge,v_creator
    from dba_sql_plan_baselines, (select substr(plan_table_output,18) plan_hash_value from table(DBMS_XPLAN.display_sql_plan_baseline(plan_name=>plan.plan_name)) where plan_table_output like ('Plan hash value:%'))
    where plan_name = plan.plan_name;
    dbms_output.put_line(v_sql_handle||'    '|| v_plan_name||'     '||v_plan_hash_value||'          '||v_enabled||'        '||v_accepted||'           '||v_fixed||'           '||v_reproduced||'        '||v_autopurge||'       '||v_creator);
end loop;
end;
/

undef handle
