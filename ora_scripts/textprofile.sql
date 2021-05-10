DECLARE
cl_sql_text CLOB;
myhints sys.sqlprof_attr;
mysql v$sql.sql_id%type;
myplan v$sql.plan_hash_value%type;
mychild v$sql.child_number%type;
mycount number(2);
myname dba_sql_profiles.name%type;
mycategory dba_sql_profiles.category%type;
BEGIN
select sql_id,child_number,plan_hash_value,sql_fulltext into mysql,mychild,myplan,cl_sql_text from v$sql where sql_id='&sql_id' and child_number='&child_number' and rownum=1;

select count(*) into mycount from v$sql where sql_id=mysql and child_number=mychild and rownum=1;

select 'PROFILE_'||mysql,'DEFAULT' into myname,mycategory from dual;

if mycount=0
then
        dbms_output.put_line('Sql not found');
else
        select count(*) into mycount from dba_sql_profiles where name=myname and category=mycategory;
        if mycount > 0
        then
                dbms_output.put_line('Profile Already exists');
        else
                SELECT
                extractvalue(VALUE(d), '/hint') AS outline_hints
                BULK COLLECT
                INTO
                myhints
                FROM
                xmltable('/*/outline_data/hint'
                passing (
                SELECT
                xmltype(other_xml) AS xmlval
                FROM
                v$sql_plan
                WHERE
                sql_id = mysql
                AND plan_hash_value = myplan
                AND other_xml IS NOT NULL
                )
                ) d;

                DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
                sql_text => cl_sql_text,
                profile =>  myhints,
                category    => mycategory,
                name => myname,
                force_match => false
                );

                select count(*) into mycount from dba_sql_profiles where name=myname and category=mycategory;

                if mycount > 0
                then
                        dbms_output.put_line('Profile generated '||myname);
                else
                        dbms_output.put_line('Profile not created');
                end if;
        end if;
end if;
end;
/
