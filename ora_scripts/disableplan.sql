set serveroutput on
declare
myplan pls_integer;
begin
myplan:=DBMS_SPM.ALTER_SQL_PLAN_BASELINE (plan_name  => '&plan_name',attribute_name => 'ENABLED',   attribute_value => 'NO');
dbms_output.put_line('PLAN ALTERED '||myplan);
end;
/
undef plan_name
