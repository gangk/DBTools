accept HINTED_SQL_ID prompt 'Enter good SQL ID:- '
accept CHILD_NO prompt 'Enter child number of good SQL:- '
accept BAD_SQL_ID prompt 'Enter bad SQL ID to be fixed:- '
accept PLAN_HASH_VALUE prompt 'Enter bad SQL plan_hash_value:- '
set pagesize 0
set line 9999
set verify off;
set heading off;
set feedback off;
set echo off;
set pagesize 0
prompt '======================= OUTPUT ======================='
select CHR(10) from dual;
select  'declare'
        ||CHR(10)||CHR(9)
        ||'ar_profile_hints sys.sqlprof_attr;'
        ||CHR(10)
        ||'begin'||CHR(10)||CHR(9)
        ||'ar_profile_hints := sys.sqlprof_attr('||CHR(10)||CHR(9)
        ||'''BEGIN_OUTLINE_DATA'','
from    dual;
select  CHR(9)||''''
        ||regexp_replace(extractvalue(value(d),'/hint'),'''','''''')
        || ''','
from    xmltable('/*/outline_data/hint'
                passing (select     xmltype(other_xml) as xmlval
                        from        v$sql_plan
                        where       sql_id = '33fndgzsas09k'
                        and         CHILD_NUMBER = 0
                        and         other_xml is not null)) d;
select  CHR(9)
        ||'''END_OUTLINE_DATA'');'||CHR(10)||CHR(9)
        ||'for sql_rec in ('||CHR(10)||CHR(9)
        ||'select t.sql_id, t.sql_text'||CHR(10)||CHR(9)
        ||'from dba_hist_sqltext t, dba_hist_sql_plan p'||CHR(10)||CHR(9)
        ||'where t.sql_id = p.sql_id'||CHR(10)||CHR(9)
        ||'and p.sql_id = '''||'&BAD_SQL_ID'||'''' ||CHR(10)||CHR(9)
        ||'and p.plan_hash_value = '||&PLAN_HASH_VALUE ||CHR(10)||CHR(9)
        ||'and p.parent_id is null'||CHR(10)||') loop' ||CHR(10)
        ||'DBMS_SQLTUNE.IMPORT_SQL_PROFILE(' ||CHR(10)||CHR(9)
        ||'sql_text    => sql_rec.sql_text,'||CHR(10)||CHR(9)
        ||'profile     => ar_profile_hints,' ||CHR(10)||CHR(9)
        ||'name        => ''PROFILE_'||'&BAD_SQL_ID'||'''); '||CHR(10)||CHR(9)
        || 'end loop;'||CHR(10)|| 'end;'|| CHR(10)||'/'
from    dual;
select CHR(10) from dual;
prompt '======================= OUTPUT ======================='