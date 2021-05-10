undef sqlid
------ from awr snapids
--DECLARE
-- ttask VARCHAR2(100);
--BEGIN
--  ttask := dbms_sqltune.create_tuning_task(
--    begin_snap => &&bsnapid,
--    end_snap => &&esnapid,
--    sql_id => '&&sqlid',
--    scope => dbms_sqltune.scope_comprehensive,
--    time_limit => 60,
--    task_name => '&&sqlid||_AWR_tuning_task',
--    description => 'Tuning task for statement &&sqlid in AWR.');
--
--  dbms_output.put_line('Tuning Task: ' || ttask);
--END;
--/

---- from the cursor cache
DECLARE
 ttask VARCHAR2(100);
BEGIN
  ttask := dbms_sqltune.create_tuning_task(
    sql_id => '&&sqlid',
    scope => DBMS_SQLTUNE.scope_comprehensive,
    time_limit => 300,
    task_name => '&&sqlid'||'_tuning_task',
    description => 'Tuning task for statement &&sqlid');

  dbms_output.put_line('l_sql_tune_task_id: ' || ttask);
END;
/

------ from an SQL tuning set
--DECLARE
-- l_sql_tune_task_id VARCHAR2(100);
--BEGIN
--  l_sql_tune_task_id := dbms_sqltune.create_tuning_task(
--    sqlset_name => 'test_sql_tuning_set',
--    scope => DBMS_SQLTUNE.scope_comprehensive,
--    time_limit => 60,
--    task_name => 'sqlset_tuning_task',
--    description => 'Tuning task for an SQL tuning set.');
--
-- dbms_output.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
--END;
--/
--
------ for a manually specified statement
--DECLARE
-- l_sql VARCHAR2(500);
-- l_sql_tune_task_id VARCHAR2(100);
--BEGIN
--  l_sql := 'SELECT e.*, d.* ' ||
--  'FROM emp e JOIN dept d ON e.deptno = d.deptno ' ||
--  'WHERE NVL(empno, ''0'') = :empno';
--
--  l_sql_tune_task_id := dbms_sqltune.create_tuning_task (
--    sql_text => l_sql,
--    bind_list => sql_binds(anydata.ConvertNumber(100)),
--    user_name => 'scott',
--    scope => dbms_sqltune.scope_comprehensive,
--    time_limit => 60,
--    task_name => 'emp_dept_tuning_task',
--    description => 'Tuning task for an EMP to DEPT join query.');
--
--  dbms_output.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
--END;
--/
--
@@list_tuning_task
