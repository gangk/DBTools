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

select sql_id,child_number,plan_hash_value,sql_fulltext into mysql,mychild,myplan,cl_sql_text from v$sql where sql_id='&sql_id' and child_number='&child_number' and rownum=1;

SELECT listagg(regexp_replace(extractvalue(value(d), '/hint'),'''','''''')) within group(order by 1) into myhints
        from
        xmltable('/*/outline_data/hint'
                passing (
                        select
                                xmltype(other_xml) as xmlval
                        from
                                v$sql_plan
                        where
                                other_xml is not null
                        and
                                sql_id=mysql
                        and
                                plan_hash_value=&plan_hash
                        and
                                rownum=1
                        )
                )
d;

dbms_output.put_line(myhints);


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

