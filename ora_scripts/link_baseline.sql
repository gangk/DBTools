SET SERVEROUTPUT ON
DECLARE
  l_plans_loaded  PLS_INTEGER;
BEGIN
  l_plans_loaded := DBMS_SPM.load_plans_from_cursor_cache(
    sql_id => '&1',
    sql_handle => '&handle');
  DBMS_OUTPUT.put_line('Plans Loaded: ' || l_plans_loaded);
END;
/
