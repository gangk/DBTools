accept TABLE_NAME prompt 'Enter table name:- ' 
accept DAYS prompt 'Number of days:- '
set pagesize 999
set verify off;
set feedback off;
select to_char(BATCH_START_TIME,'DD-MON-YYYY HH24'), sum(ROW_COUNT) from THROTTLE_SNAP_STATS where TARGET_TABLE='&TABLE_NAME' and BATCH_START_TIME > sysdate - &DAYS group by to_char(BATCH_START_TIME,'DD-MON-YYYY HH24') order by 1;

