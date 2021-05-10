set linesize 150
col os_username format a30
col obj_name format a30
col action_name format a30
col segment_name format a30
col  os_username for a20
col terminal for a20
col username for a15
col obj_name for a20
col action_name for a15



select segment_name,segment_type,sum(bytes)/1024/1024 "SIZE MB" from dba_segments where segment_name like 'AUD$' group by segment_name,segment_type;

select count(*) "AUD$ COUNT" from dba_audit_trail;

select os_username,terminal,username,timestamp,obj_name,action,action_name,ses_actions from dba_audit_trail;