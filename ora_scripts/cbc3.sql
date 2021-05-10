with subq as (
select t2.child#, t2.addr,
  t2.gets-t1.gets gets,
  t2.misses-t1.misses misses,
  t2.sleeps-t1.sleeps sleeps
from hien_dba.cbc_latch_stats t1, hien_dba.cbc_latch_stats t2
where t1.child#=t2.child#
  and t1.snap=1 and t2.snap=2
order by sleeps desc
)
select * from subq
where rownum < 40;
