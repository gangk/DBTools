SET LONG 10000
SELECT DBMS_SPM.evolve_sql_plan_baseline(sql_handle => '&SQL_HANDLE',PLAN_NAME =>'&SQL_PLAN_NAME',VERIFY=>'YES',COMMIT=>'NO') from dual;
