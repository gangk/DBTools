accept handle prompt 'enter sql_handle :- '
accept plan_name prompt 'enter plan_name :- '
set serveroutput on
declare
x number;
begin
x := DBMS_SPM.UNPACK_STGTAB_BASELINE('&STGTAB', '&usr', sql_handle => '&handle', plan_name => '&plan_name' );
dbms_output.put_line('Plan unpacked :- '||x);
end;
/
undef handle
undef plan_name
