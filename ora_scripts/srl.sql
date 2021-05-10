column ID format 99 
column "SRLs" format 99 
column Active format 99 

select dest_id id,database_mode db_mode,recovery_mode, 
       protection_mode,standby_logfile_count "SRLs",
       standby_logfile_active ACTIVE, 
       archived_seq# 
from v$archive_dest_status
/


