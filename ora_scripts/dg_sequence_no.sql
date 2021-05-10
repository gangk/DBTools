-- The following query will determine the current sequence number
-- and the last sequence archived.  If you are remotely archiving
-- using the LGWR process then the archived sequence should be one
-- higher than the current sequence.  If remotely archiving using the
-- ARCH process then the archived sequence should be equal to the
-- current sequence.  The applied sequence information is updated at
-- log switch time.

select ads.dest_id,max(sequence#) "Current Sequence",
       max(log_sequence) "Last Archived"
from v$archived_log al, v$archive_dest ad, v$archive_dest_status ads 
where ad.dest_id=al.dest_id 
and al.dest_id=ads.dest_id 
group by ads.dest_id
/

