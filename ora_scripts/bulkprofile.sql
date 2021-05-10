declare
profile_text varchar2(30000);
format1 varchar2(30000);
format2 varchar2(30000);
format3 varchar2(30000);
format4 varchar2(30000);
format5 varchar2(30000);
format6 varchar2(30000);
format7 varchar2(30000);
format8 varchar2(30000);
format9 varchar2(30000);
format10 varchar2(30000);
begin
select '####===================OUTPUT=========================' into format1 from dual;
select chr(10) into format2 from dual;

select 'declare' into format3 from dual;
select chr(10)||'ar_profile_hints sys.sqlprof_attr;' into format4 from dual;
select chr(10)||'begin' into format5 from dual;
select chr(10)||'ar_profile_hints := sys.sqlprof_attr(' into format6 from dual;
select chr(10)||chr(9)||'''BEGIN_OUTLINE_DATA'',' into format7 from dual;

for x in
(
        select
extractvalue(value(d), '/hint') as outline_hints
from
xmltable('/*/outline_data/hint'
passing (
select
xmltype(other_xml) as xmlval
from
v$sql_plan
where
sql_id like nvl('&sql_id',sql_id)
and child_number = &child_no
and other_xml is not null
)
) d
)
loop
        format8:=format8||chr(10)||x.output;
end loop;

select chr(10)||chr(9)||chr(9)||'''END_OUTLINE_DATA'''||chr(10)||');'||chr(10)||'for sql_rec in ('||chr(10)||chr(9)||'select t.sql_id, t.sql_text'||chr(10)||chr(9)||' from dba_hist_sqltext t, dba_hist_sql_plan p' ||chr(10)||chr(9)|| 'where t.sql_id = p.sql_id and p.sql_id = ''fkyt3j9w6a1d9'' and p.plan_hash_value = 00000000 and p.parent_id is null'||chr(10)||chr(9)||chr(9)||') loop'||chr(10)||chr(9)||'      DBMS_SQLTUNE.IMPORT_SQL_PROFILE('||chr(10) into format9 from dual;
select chr(10)||chr(9)||'sql_text => sql_rec.sql_text,profile  => ar_profile_hints,name => ''PROFILE_''||sql_rec.sql_id'||CHR(10)||chr(9)||chr(9)||chr(9)||chr(9)||chr(9)||');'||chr(10)||chr(9)||'end loop;'||chr(10)||'end;'||chr(10)||'/' into format10
FROM DUAL;

profile_text:=format1||format2||format3||format4||format5||format6||format7||format8||format9||format10;
dbms_output.put_line(profile_text);
end;
/
