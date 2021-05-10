set line 999
set pagesize 9999
select * from table(dbms_xplan.display(FORMAT=>'advanced'));
