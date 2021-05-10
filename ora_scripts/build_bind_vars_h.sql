-------------------------------------------------------------------------------------------------------
--
-- File name:   build_bind_vars_h.sql
--
-- Purpose:     Build SQL*Plus test script with variable definitions created from AWR data
--
-- Author:      Based on build_bind_vars script of Jack Augustin and Kerry Osborne 
--
-- Description: This script creates an output file which can be executed in SQL*Plus. It creates bind variables, 
--              sets the bind variables to the values stored in DBA_HIST_SQL_PLAN.OTHER_XML, and then executes 
--              the statement. The sql_id is used for the file name and is also placed in the statement
--              as a comment. Note that numeric bind variable names are not permited in SQL*Plus, so if
--              the statement has numberic bind variable names, they have an 'N' prepended to them. Also
--              note that CHAR and DATA variables are converted to VARCHAR2. 
--		Important point is this script does not ask for snapid so maybe different binds could be peeked for your actual time 
--
-- Usage:       This scripts prompts for two values.
--
--              sql_id:   this is the sql_id of the statement you want to duplicate
--
--              plan_hash_value: 
--                        
--
-- original reference http://kerryosborne.oracle-guy.com/2009/07/creating-test-scripts-with-bind-variables/
-------------------------------------------------------------------------------------------------------
set sqlblanklines on
set trimspool on
set trimout on
set feedback off;
set linesize 255;
set pagesize 50000;
set timing off;
set head off
--
accept sql_id char prompt "Enter SQL ID ==> "
accept plan_hash_value number prompt "Enter Plan Hash Value ==> " default 0
var isdigits number
col sql_text for a140 word_wrap
--
--
--spool &&sql_id\.sql
--
--Check for numeric bind variable names
--
begin
select case regexp_substr(replace(name,':',''),'[[:digit:]]') when replace(name,':','') then 1 end into :isdigits
from
dba_hist_sqlbind
where
sql_id='&&sql_id'
and rownum < 2;
end;
/
--
-- Create variable statements
--
select
distinct 'variable ' ||
   case :isdigits when 1 then replace(name,':','N') else substr(name,2,30) end || ' ' ||
replace(replace(datatype_string,'CHAR(','VARCHAR2('),'DATE','VARCHAR2(32)') txt
from
dba_hist_sqlbind
where
sql_id='&&sql_id'
and snap_id=(select max(snap_id) from dba_hist_sqlbind where sql_id='&&sql_id')
;
--
-- Set variable values from V$SQL_PLAN
--
select 'begin' txt from dual;
select
   case :isdigits when 1 then replace(bind_name,':',':N') else bind_name end ||
-- case regexp_substr(replace(bind_name,':',''),'[[:digit:]]') when replace(bind_name,':','') then 'N' else ' ' end ||
' := ' ||
case when bind_type = 1 then '''' else null end ||
case when bind_type = 1 then display_raw(bind_data,'VARCHAR2')
when bind_type = 2 then display_raw(bind_data,'NUMBER')
else bind_data end ||
case when bind_type = 1 then '''' else null end ||
';' txt
from (
select
extractvalue(value(d), '/bind/@nam') as bind_name,
extractvalue(value(d), '/bind/@dty') as bind_type,
extractvalue(value(d), '/bind') as bind_data
from
xmltable('/*/*/bind'
passing (
select
xmltype(other_xml) as xmlval
from
dba_hist_sql_plan
where
sql_id='&&sql_id'
and plan_hash_value=&&plan_hash_value
and other_xml is not null
AND ROWNUM<2
)
) d
)
;
select 'end;' txt from dual;
select '/' txt from dual;
--
-- Generate statement
--
select regexp_replace(sql_text,'(select |SELECT )','select /* test &&sql_id */ /*+gather_plan_statistics*/',1,1) sql_text from (
select case :isdigits when 1 then replace(sql_text,':',':N') else sql_text end ||';' sql_text
from dba_hist_sqltext
where sql_id = '&&sql_id' AND ROWNUM<2)
--spool off;
-- ed &&sql_id\.sql
undef sql_id
undef child_no
set feedback on;
set head on
