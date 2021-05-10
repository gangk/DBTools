insert into hien_dba.cbc_latch_stats
select 2, systimestamp
,      CHILD#
,      ADDR
,      GETS
,      MISSES
,      SLEEPS
from v$latch_children
where name = 'cache buffers chains';
