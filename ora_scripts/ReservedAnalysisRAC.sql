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
set lines 100
set pages 999
set termout off
set trimout on
set trimspool on
col inst_id format 999 head "Instance #"
col request_failures format 999,999,999,999 head "Misses in |General|Shared Pool"
col request_misses format 999,999,999,999 head "Reserved Area|Misses"
col FS format 999,999,999,999 head "Reserved|Free Space"
col MFS format 999,999,999,999 head "Reserved|Max"
col US format 999,999,999,999 head "Reserved|Used"
col RQ format 999,999,999,999 head "Total|Requests"
col RM format 999,999,999,999 head "Reserved|Area|Misses"
col LMS format 999,999,999,999 head "Size of|Last Miss" 
col RF format 9,999 head "Shared|Pool|Misses"
col LFS format 999,999,999,999 head "Failed|Size"
spool reserved.out

select inst_id, request_failures, request_misses
from gv$shared_pool_reserved
/

select sum(request_failures) RF, sum(last_failure_size) LFS, 
  sum(free_space) FS, sum(max_free_size) MFS
from gv$shared_pool_reserved
/


select sum(used_space) US, sum(requests) RQ, 
    sum(request_misses) RM, sum(last_miss_size) LMS
from gv$shared_pool_reserved
/

REM Look at the breakdown of chunks for more detail on fragmentation.
REM This review data from a GV$ view so is not the hit to performance
REM getting this data from X$ data dictionary views

col average format 999,999.99
col maximum format 999,999

select inst_id, alloc_class, avg(chunk_size) average, max(chunk_size) maximum
from v$sql_shared_memory group by alloc_class
order by inst_id
/

spool off
set termout on
set trimout off
set trimspool off
clear col

/* ---------------------------------------------

Sample Output:

                        Failed      Reserved     Reserved     Reserved
4031s?              Size  Free Space              Max               Avg
----------- ---------------- ------------------ ---------------- ----------------
           1               540     5,307,832       212,888       196,586


                                                          Reserved
        Reserved                 Total                Pool             Size of
               Used          Requests           Misses        Last Miss
-------------------- -------------------- ------------------- -------------------
          14,368                          2                       0                       0


INST_ID  ALLOC_CL     AVERAGE  MAXIMUM
-------- -------- ----------- --------
       1 freeabl        64.73    4,184
       1 recr        4,131.71    4,152
       1 free        1,916.80    4,056
*/
