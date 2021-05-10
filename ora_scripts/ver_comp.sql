set serveroutput on

DECLARE
 ver    VARCHAR2(100);
 compat VARCHAR2(100);
BEGIN
  dbms_utility.db_version(ver, compat);
  dbms_output.put_line('Version: ' || ver ||' Compatible: ' || compat);
END;
/
