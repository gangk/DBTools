Select owner, segment_name, segment_type, bytes
from (
   Select owner, segment_name, segment_type, bytes,
   rank () over 
     (order by bytes desc) as rank
   from dba_segments)
where rank <= 10