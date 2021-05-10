/
set echo off feed off head off lines 10
select count(*) from v$lock where block > 0;
exit
