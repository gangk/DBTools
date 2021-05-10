select * from table(dbms_xplan.display_cursor('&sqlid',NULL));
