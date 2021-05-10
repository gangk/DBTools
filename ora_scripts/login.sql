col upper(instance_name) new_v dbname noprint
select upper(instance_name) from v$instance;
set SQLP &dbname>
clear col
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD:HH24:MI';
select sysdate, startup_time from v$instance;
--set echo on
set lin 200 pages 200
