-- The following select will show any errors that occured the last time
-- an attempt to archive to the destination was attempted.  If ERROR is
-- blank and status is VALID then the archive completed correctly.

column error format a70 wrap

select dest_id,status,error from v$archive_dest
/
 
-- The query below will determine if any error conditions have been
-- reached by querying the v$dataguard_status view (view only available in
-- 9.2.0 and above):

column message format a80 

select message, timestamp 
from v$dataguard_status 
where severity in ('Error','Fatal') 
order by timestamp
/


 
