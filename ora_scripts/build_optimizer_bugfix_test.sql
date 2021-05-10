/*
################################################################
### SQL= Build Optimizer bugfix test 
### PURPOSE = This script accepts optimizer_feature_version 
### and generates another script called "optimizer_bugfix_test.sql"
### to test bugfixes for given sql. 
### 
### Generated script will first set optimizer to the given 
### optimizer_feature version then DISABLE/ENABLE 1 bugfix from given
### optimizer_feature_version at a time and run the test.sql 
### and capture the plan_hash_value &optimizer_feature
### and ENABLE/DISABLE it again.  this enable-run-disable operation 
### will be done  for all bugfixes for given optimizer_feature_version
### 
### 
### 
### Author: Coskan Gundogar
### Date : 19/01/11
### Update Log:
###
###
###
###
*/
--select distinct optimizer_feature_enable from v$system_fix_control order by to_number(replace(optimizer_feature_enable,'.',''));

undefine optimizer_feature_version
set heading off
set feedback off
define optimizer_feature="&optimizer_feature_version"
set term off
spool optimizer_bugfix_test.sql
select 'set feedback off' from dual;
select 'set heading off' from dual;
select 'set term off' from dual;
select 'set echo off' from dual;
select 'spool optimizer_bugfix_test_results.log' from dual;
select 'drop table  bugfix_gtt purge;' from dual;
select 'create  table bugfix_gtt (bugfix number,plan_hash_value varchar2(20));' from dual;
select 'alter session set optimizer_features_enable=''&optimizer_feature'';' from dual;
select   'alter session set "_fix_control"='''||bugno||decode(value,1,':OFF''',':ON''')||'; '
||chr(10)||'@test.sql'||chr(10)||
--'insert into bugfix_gtt values ('||bugno||',(select substr(plan_table_output,18,12) from (select * from table(dbms_xplan.display)) where plan_table_output  like ''Plan hash value:%''));'||chr(10)||
'insert into bugfix_gtt values ('||bugno||',(select substr(plan_table_output,18,12) from (select * from table(dbms_xplan.display_cursor)) where plan_table_output  like ''Plan hash value:%''));'||chr(10)||
'alter session set "_fix_control"='''||bugno||decode(value,1,':ON''',':OFF''')||'; '
from v$system_fix_control 
where optimizer_feature_enable='&optimizer_feature' and value in (1,0) order by bugno; 
select 'set term on' from dual;
select 'set feedback on' from dual;
select 'set heading on' from dual;
select 'break on plan_hash_value' from dual;
select 'select plan_hash_value,bugfix from bugfix_gtt order by 1;' from dual;
select 'spool off' from dual;
spool off
set feedback on
set heading on
set term on


