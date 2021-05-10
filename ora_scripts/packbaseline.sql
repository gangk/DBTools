accept handle prompt 'enter sql_handle :- '
accept plan_name prompt 'enter plan_name :- '
SET serveroutput on
exec DBMS_SPM.CREATE_STGTAB_BASELINE('STGTAB', 'SUBHATIA_DBA');
declare
x number;
begin
x := DBMS_SPM.PACK_STGTAB_BASELINE('STGTAB', user, sql_handle => '&handle', plan_name => '&plan_name' );
dbms_output.put_line('Plan Packed :- ' || x);
end;
/
undef handle
undef plan_name
