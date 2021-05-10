select * from table(dbms_xplan.DISPLAY_SQL_PLAN_BASELINE('&SQL_HANDLE','&PLAN_NAME'));
