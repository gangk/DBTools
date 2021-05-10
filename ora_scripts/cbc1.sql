create table hien_dba.cbc_latch_stats tablespace administrator as
select 1 snap, systimestamp timestamp
,      CHILD#
,      ADDR
,      GETS
,      MISSES
,      SLEEPS
from v$latch_children
where name = 'cache buffers chains';
