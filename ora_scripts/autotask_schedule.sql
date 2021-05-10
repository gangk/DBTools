set lines 170
col window_name	format a25
col start_time	format a35
col duration	format a15
SELECT * FROM dba_autotask_schedule
order by start_time
;
