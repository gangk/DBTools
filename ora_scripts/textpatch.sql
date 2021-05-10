undef sql_id
undef child_number
DECLARE
cl_sql_text CLOB;
myhints varchar2(32767);
mysql v$sql.sql_id%type;
myplan v$sql.plan_hash_value%type;
mychild v$sql.child_number%type;
mycount number(2);
myname dba_sql_profiles.name%type;
mycategory dba_sql_profiles.category%type;
BEGIN
myhints:=trim('&hint1')||trim('&hint2')||trim('&hint3')||trim('&hint4')||trim('&hint5')||trim('&hint6')||trim('&hint7')||trim('&hint8')||trim('&hint9')||trim('&hint10');
select sql_id,child_number,plan_hash_value,sql_fulltext into mysql,mychild,myplan,cl_sql_text from v$sql where sql_id='&sql_id' and child_number='&child_number' and rownum=1;

select count(*) into mycount from v$sql where sql_id=mysql and child_number=mychild and rownum=1;
select 'PATCH_'||mysql,'DEFAULT' into myname,mycategory from dual;
if mycount=0
then
        dbms_output.put_line('Sql not found');
else
        select count(*) into mycount from dba_sql_patches where name=myname and category=mycategory;
        if mycount > 0
        then
                dbms_output.put_line('Patch Already exists');
        else
                sys.dbms_sqldiag_internal.i_create_patch(
                sql_text  => cl_sql_text,
                hint_text =>  myhints,
                category  => mycategory,
                name => myname
                );

                select count(*) into mycount from dba_sql_patches where name=myname and category=mycategory;

                if mycount > 0
                then
                        dbms_output.put_line('Patch generated '||myname);
                else
                        dbms_output.put_line('Patch not created');
                end if;
        end if;
end if;
end;
/

