accept SQL_ID prompt 'Enter SQL ID: -'
accept SQL_HINTS prompt 'Enter hints to be used:- '
set serveroutput on;
declare
v_sql_id varchar2(20);
v_sql_text CLOB;
v_patch_name varchar2(20);
begin
select sql_id, sql_fulltest into v_sql_id, v_sql_text from v$sql where sql_id  = &SQL_ID;
v_patch_name := 'PATCH_'||v_sql_id;
select count(1) into v_patch_count from dba_sql_patches where NAME = v_patch_name;
if v_patch_count > 0
then
    dbms_output.put_line('Patch already exists '||v_patch_name);
else
    dbms_output.put_line('Creating Patch '||v_patch_name);

    sys.dbms_sqldiag_internal.i_create_patch(
        sql_text  => v_sql_text,
        hint_text =>  &SQL_HINTS,
        name => v_patch_name
        );
    dbms_output.put_line('Patch Created '||v_patch_name);
end if;
end;
/
