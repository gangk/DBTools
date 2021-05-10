SET SERVEROUTPUT ON
DECLARE
  l_plans_loaded  PLS_INTEGER;
BEGIN
  l_plans_loaded := DBMS_SPM.load_plans_from_cursor_cache
    (
    ATTRIBUTE_NAME => '&1',
    ATTRIBUTE_VALUE => '&2'
    );

  DBMS_OUTPUT.put_line('Plans Loaded: ' || l_plans_loaded);
END;
/
