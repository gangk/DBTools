select * from table(dbms_xplan.display_sql_plan_baseline(plan_name => '&plan_name'));
