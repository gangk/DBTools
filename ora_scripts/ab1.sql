declare
x number;
begin
x := DBMS_SPM.ALTER_SQL_PLAN_BASELINE('&handle_name','&plan_name','enabled','no');
end;
/
