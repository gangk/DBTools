declare
x number;
begin
x := DBMS_SPM.UNPACK_STGTAB_BASELINE('PATCHONE12', 'ADMIN', plan_name => '&PLAN' );
dbms_output.put_line('Plan unpacked :- '||x);
end;
/
undef PLAN
