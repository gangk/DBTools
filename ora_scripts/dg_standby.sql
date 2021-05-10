spool dg_standby_output.log
set feedback off
set trimspool on
set line 500
set pagesize 50
set linesize 200
column name for a30
column display_value for a30
col value for a10
col PROTECTION_MODE for a15
col DATABASE_Role for a15
SELECT name, display_value FROM v$parameter WHERE name IN ('db_name','db_unique_name','log_archive_config','log_archive_dest_2','log_archive_dest_state_2','fal_client','fal_server','standby_file_management','standby_archive_dest','db_file_name_convert','log_file_name_convert','remote_login_passwordfile','local_listener','dg_broker_start','dg_broker_config_file1','dg_broker_config_file2','log_archive_max_processes') order by name;
col name for a10
col DATABASE_ROLE for a10
SELECT name,db_unique_name,protection_mode,DATABASE_ROLE,OPEN_MODE from v$database;
select thread#,max(sequence#) from v$archived_log where applied='YES' group by thread#;
select process, status,thread#,sequence# from v$managed_standby;
col name for a30
select * from v$dataguard_stats;
select * from v$archive_gap;
col name format a60
select    name
,    floor(space_limit / 1024 / 1024) "Size MB"
,    ceil(space_used  / 1024 / 1024) "Used MB"
from    v$recovery_file_dest
order by name;
spool off