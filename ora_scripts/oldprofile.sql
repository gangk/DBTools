/*
Name          :- Oldprofile.sql
Db Version    :- 11.1.0.7
Author        :- Sumit Bhatia
Version       :- 1.1
Purpose       :- Create a profile to force the old plan
Input         :- sql_id, old plan hash value, bad plan hash value
*/
set feedback off
set echo off
set timing off
set pagesize 0
set heading off verify off
accept sql_id prompt 'enter sql_id:- '
accept old_plan_hash_value prompt'enter old plan hash value:- '
accept plan_hash prompt'enter bad plan hash value to be tuned :- '
prompt '===================OUTPUT========================='
select chr(10) from dual;

select 'declare' from dual;
select 'ar_profile_hints sys.sqlprof_attr;' from dual;
select 'begin' from dual;
select chr(9)||'ar_profile_hints := sys.sqlprof_attr(' from dual;
select chr(9)||chr(9)||'''BEGIN_OUTLINE_DATA'',' from dual;

SELECT chr(9)||chr(9)||''''||regexp_replace(extractvalue(value(d), '/hint'),'''','''''')||''','
        from
        xmltable('/*/outline_data/hint'
                passing (
                        select
                                xmltype(other_xml) as xmlval
                        from
                                dba_hist_sql_plan
                        where
                                sql_id like nvl('&sql_id',sql_id)
                                and plan_hash_value=&old_plan_hash_value
                                and other_xml is not null
                                and rownum < 2
                        )
                )
d;

select chr(9)||chr(9)||'''END_OUTLINE_DATA'''||chr(10)||');'||chr(10)||'for sql_rec in ('||chr(10)||chr(9)||'select t.sql_id, t.sql_text'||chr(10)||chr(9)||' from dba_hist_sqltext t, dba_hist_sql_plan p' ||chr(10)||chr(9)|| 'where t.sql_id = p.sql_id and p.sql_id = ''&sql_id'' and p.plan_hash_value = &plan_hash and p.parent_id is null'||chr(10)||chr(9)||chr(9)||') loop'||chr(10)||chr(9)||'      DBMS_SQLTUNE.IMPORT_SQL_PROFILE('||chr(10)||chr(9)||chr(9)||'sql_text    => sql_rec.sql_text,profile     => ar_profile_hints,name => ''PROFILE_''||sql_rec.sql_id'||CHR(10)||chr(9)||chr(9)||chr(9)||chr(9)||chr(9)||');'||chr(10)||chr(9)||'end loop;'||chr(10)||'end;'||chr(10)||'/' FROM DUAL;
prompt  '===================OUTPUT========================='
set heading on
set pages 500
undef sql_id
undef old_plan_hash_value
undef plan_hash
