SET SERVEROUTPUT ON
DECLARE
  pbsts varchar2(1000) ;
BEGIN
   pbsts := dbms_spm.evolve_sql_plan_baseline(
    plan_name       => '&PLAN_NAME',
    VERIFY          => 'NO',
    COMMIT          => 'YES');
  DBMS_OUTPUT.put_line(' Got Output : ' || pbsts );
END;
/

undef PLAN_NAME
