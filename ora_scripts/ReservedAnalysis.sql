REM 
REM   Investigate memory chunk stress in the Shared Pool
REM   It is safe to run these queries as often as you like.    
REM   Large memory misses in the Shared Pool
REM   will be attemped in the Reserved Area.    Another 
REM   failure in the Reserved Area causes an 4031 error
REM
REM   What should you look for?
REM   Reserved Pool Misses = 0 can mean the Reserved 
REM   Area is too big.  Reserved Pool Misses always increasing
REM   but "Shared Pool Misses" not increasing can mean the Reserved Area 
REM   is too small.  In this case flushes in the Shared Pool
REM   satisfied the memory needs and a 4031 was not actually
REM   reported to the user.  Reserved Area Misses and 
REM   "Shared Pool Misses" always increasing can mean 
REM   the Reserved Area is too small and flushes in the 
REM   Shared Pool are not helping (likely got an ORA-04031).
REM   

clear col

col free_space format 999,999,999,999 head "Reserved|Free Space"
col max_free_size format 999,999,999,999 head "Reserved|Max"
col avg_free_size format 999,999,999,999 head "Reserved|Avg"
col used_space format 999,999,999,999 head "Reserved|Used"
col requests format 999,999,999,999 head "Total|Requests"
col request_misses format 999,999,999,999 head "Reserved|Area|Misses"
col last_miss_size format 999,999,999,999 head "Size of|Last Miss" 
col request_failures format 9,999 head "Shared|Pool|Miss"
col last_failure_size format 999,999,999,999 head "Failed|Size"

select request_failures, last_failure_size, free_space, max_free_size, avg_free_size
from v$shared_pool_reserved
/


select used_space, requests, request_misses, last_miss_size
from v$shared_pool_reserved
/

REM Look at the breakdown of chunks for more detail on fragmentation.
REM This review data from a V$ view so is not the hit to performance
REM getting this data from X$ data dictionary views

col average format 999,999.99
col maximum format 999,999

select alloc_class, avg(chunk_size) average, max(chunk_size) maximum
from v$sql_shared_memory group by alloc_class
/


col requests for 999,999,999
col last_failure_size for 999,999,999 head "LAST FAILURE| SIZE "
col last_miss_size for 999,999,999 head "LAST MISS|SIZE "
col pct for 999 head "HIT|% "
col request_failures for 999,999,999,999 head "FAILURES"
select requests,
decode(requests,0,0,trunc(100-(100*(request_misses/requests)),0)) PCT, request_failures, last_miss_size, last_failure_size
from v$shared_pool_reserved;

/

select p.inst_id, p.free_space, p.avg_free_size, p.free_count,
  p.max_free_size, p.used_space, p.avg_used_size, p.used_count, p.max_used_size,
  s.requests, s.request_misses, s.last_miss_size, s.max_miss_size,
  s.request_failures, s.last_failure_size, s.aborted_request_threshold,
  s.aborted_requests, s.last_aborted_size
  from (select avg(x$ksmspr.inst_id) inst_id, 
  sum(decode(ksmchcls,'R-free',ksmchsiz,0)) free_space,
  avg(decode(ksmchcls,'R-free',ksmchsiz,0)) avg_free_size,
  sum(decode(ksmchcls,'R-free',1,0)) free_count,
  max(decode(ksmchcls,'R-free',ksmchsiz,0)) max_free_size,
  sum(decode(ksmchcls,'R-free',0,ksmchsiz)) used_space,
  avg(decode(ksmchcls,'R-free',0,ksmchsiz)) avg_used_size,  
  sum(decode(ksmchcls,'R-free',0,1)) used_count,
  max(decode(ksmchcls,'R-free',0,ksmchsiz)) max_used_size from x$ksmspr
  where ksmchcom not like '%reserved sto%') p,
    (select sum(kghlurcn) requests, sum(kghlurmi) request_misses, 
    max(kghlurmz) last_miss_size, max(kghlurmx) max_miss_size, 
    sum(kghlunfu) request_failures, max(kghlunfs) last_failure_size,
    max(kghlumxa) aborted_request_threshold, sum(kghlumer) aborted_requests,
    max(kghlumes) last_aborted_size from x$kghlu) s
    /
    


