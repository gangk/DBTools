/*
################################################################
### SQL= Build Optimizer features  test for explain plans
### PURPOSE = This script accepts base optimizer_feature_version 
### and generates another script called "optimizer_features_test.sql"
### to test available OFE from base OFE till maximum OFE in v$system_fix_control
### 
### Generated script will run test_e.sql script which is "explained plan for select ..." of test case
### and get explain plan output for the explained plan  for all OFES from base release 
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

undefine base_optimizer_version
set heading off
set feedback off
define optimizer_feature="&base_optimizer_version"
set term off
spool optimizer_features_test_e.sql
select 'set timing on' from dual;
select 'set echo off' from dual;
select 'spool optimizer_features_test_e_results.log' from dual;
select   'set echo on'||chr(10)||'alter session set optimizer_features_enable='''||optimizer_feature_enable||''';'
||chr(10)||'set echo off'||chr(10)||'@test_e.sql'||chr(10)||
'select * from table(dbms_xplan.display);'||chr(10)
from 
(select distinct optimizer_feature_enable from v$system_fix_control 
where 
to_number(replace(optimizer_feature_enable,'.',''))>=to_number(replace('&optimizer_feature','.',''))
order by to_number(replace(optimizer_feature_enable,'.','')) desc );
select 'set echo off' from dual;
select 'spool off' from dual;
spool off
set term on 
set heading on
set feedback on

