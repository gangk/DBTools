set termout off
set serverout off
set linesize 200
set pagesize 9999
alter session set statistics_level = all;
@slow_query.sql;
spool slow_query_plan.lst
select * from table(dbms_xplan.display_cursor(null, null, 'allstats last'));
spool off