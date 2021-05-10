SET SERVEROUTPUT ON
DECLARE
  l_plans_disable  PLS_INTEGER;
BEGIN
  l_plans_disable := DBMS_SPM.alter_sql_plan_baseline (
    sql_handle => '&sql_handle',
    plan_name  => '&sql_plan_name',
    attribute_name => '&attribute',
    attribute_value => '&YES_OR_NO');

  DBMS_OUTPUT.put_line(l_plans_disable);
END;
/
