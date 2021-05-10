set echo off 
set feedback off 
column timecol new_value timestamp 
column spool_extension new_value suffix 
select to_char(sysdate,'Mondd_hhmi') timecol, 
'.out' spool_extension from sys.dual; 
column output new_value dbname 
select value || '_' output 
from v$parameter where name = 'selecsys'; 
spool C:\dgdiag_phystby_&&dbname
set lines 200 
set pagesize 35 
set trim on 
set trims on 
alter session set nls_date_format = 'MON-DD-YYYY HH24:MI:SS'; 
set feedback on 
select to_char(sysdate) time from dual; 
 
set echo on 
 
column host_name format a20 tru 
column version format a9 tru 
select instance_name,host_name,version,archiver,log_switch_wait from v$instance; 
 
column ROLE format a7 tru 
select name,database_role,log_mode,controlfile_type,protection_mode,protection_level  
from v$database; 
 
column force_logging format a13 tru 
column remote_archive format a14 tru 
column dataguard_broker format a16 tru 
select force_logging,remote_archive,supplemental_log_data_pk,supplemental_log_data_ui, 
switchover_status,dataguard_broker from v$database;  
 
COLUMN destination FORMAT A35 WRAP 
column process format a7 
column archiver format a8 
column ID format 99 
 
select dest_id "ID",destination,status,target, 
archiver,schedule,process,mountid  
from v$archive_dest; 
 
select dest_id,process,transmit_mode,async_blocks, 
net_timeout,delay_mins,reopen_secs,register,binding 
from v$archive_dest; 
 
column error format a55 tru 
select dest_id,status,error from v$archive_dest; 
 
column message format a80 
select message, timestamp 
from v$dataguard_status 
where severity in ('Error','Fatal') 
order by timestamp; 
 

select group#,sequence#,bytes,used,archived,status from v$standby_log;

select group#,thread#,sequence#,bytes,archived,status from v$log; 

select process,status,client_process,sequence#,block#,active_agents,known_agents
from v$managed_standby;

select max(al.sequence#) "Last Seq Recieved", max(lh.sequence#) "Last Seq Applied"
from v$archived_log al, v$log_history lh;

select * from v$archive_gap; 

set numwidth 5 
column name format a30 tru 
column value format a50 wra 
select name, value 
from v$parameter 
where isdefault = 'FALSE';
 
spool off
