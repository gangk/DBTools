You need to use the dbms_spm.evolve_sql_plan_baseline function to
accept plans. If you don't want to test execute the new plan to ensure
its better than the existing accepted plan(s) you can set verify to NO
and the new plan will be accepted immediately.

exec :pbsts :=
dbms_spm.evolve_sql_plan_baseline('SYS_SQL_7de69bb90f3e54d2','SYS_SQL_PLAN_0f3e54d211df68d0',verify=> 'NO', commit=>'YES');