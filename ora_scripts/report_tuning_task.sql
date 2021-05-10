undef tuning_task
SET LONG 10000;
SET PAGESIZE 1000
SET LINESIZE 200
SELECT DBMS_SQLTUNE.report_tuning_task('&&tuning_task') AS recommendations FROM dual;
