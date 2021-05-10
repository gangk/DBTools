column destination format a35 wrap 
column process format a7 
column archiver format a8 
column ID format 99 
column mid format 99
 
select dest_id "ID",destination,status,target,
       schedule,process,mountid  mid
from v$archive_dest order by dest_id
/

select dest_id "ID",archiver,transmit_mode,affirm,async_blocks async,
       net_timeout net_time,delay_mins delay,reopen_secs reopen,
       register,binding 
from v$archive_dest order by dest_id
/



