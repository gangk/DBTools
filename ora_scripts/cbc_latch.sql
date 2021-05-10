--
-- create table to hold cbc latch stats
-- collect cbc latch stats at t1
--
prompt Collecting cbc stats at t1 ...
set echo off feed off termout off
clear columns
drop   table admin.cbc_latch_stats;
create table admin.cbc_latch_stats tablespace administrator as
select 1 snap, systimestamp timestamp
,      CHILD#
,      ADDR
,      GETS
,      MISSES
,      SLEEPS
from v$latch_children
where name = 'cache buffers chains';

--
-- sleep for 60 secs
--
set termout on
prompt Sleeping 60 secs ...
set termout off
!sleep 60

-- 
-- collect cbc latch stats at t2
-- 
set termout on
prompt Collecting cbc stats at t2 ...
set termout off
insert into admin.cbc_latch_stats
select 2, systimestamp
,      CHILD#
,      ADDR
,      GETS
,      MISSES
,      SLEEPS
from v$latch_children
where name = 'cache buffers chains';

-- 
-- show the top 30 latch addresses
-- 
set termout on lines 170 pages 100
prompt
prompt == Top 30 latch addresses ==

with subq as (
select t2.child#, t2.addr,
  t2.gets-t1.gets gets,
  t2.misses-t1.misses misses,
  t2.sleeps-t1.sleeps sleeps
from admin.cbc_latch_stats t1, admin.cbc_latch_stats t2
where t1.child#=t2.child#
  and t1.snap=1 and t2.snap=2
order by sleeps desc
)
select * from subq
where rownum < 31;

-- 
-- get top cbc latch address
-- 
set termout off
prompt Top latch address
col top_laddr new_value tladdr

select top_laddr, sleeps from (
select t2.addr top_laddr, t2.sleeps-t1.sleeps sleeps
from admin.cbc_latch_stats t1, admin.cbc_latch_stats t2
where t1.child#=t2.child#
  and t1.snap=1 and t2.snap=2
order by sleeps desc
)
where rownum <2;

--
-- show objects associated w/ top latch address
-- tladdr being passed from prev query
--
set termout on lines 170 pages 100
prompt
prompt == Objects associated with top latch address ==
col object format a75
col state format a5

select /*+rule*/ *
from (
select o.owner||'.'||o.object_name||decode(o.subobject_name,NULL,'','.')||
  o.subobject_name||' ['||o.object_type||']' object, sq.*
from (
  select
    x.hladdr,
    x.obj,
    x.file#,x.dbablk,
    x.tch,
    decode(x.state,0,'FREE',1,'XCUR',2,'SCUR',3,'CR',4,'READ',
      5,'MREC',6,'IREC',7,'WRITE',8,'PI',9,'MEMORY',10,'MWRITE',
      11,'DONATED',x.state) state,
    decode(x.state,3,cr_scn_bas,NULL) scn_bas
  from
    v$latch_children  l,
    x$bh  x
  where
    x.hladdr = l.addr and
    x.obj < power(2,22) and
    x.hladdr  = '&&tladdr'
     ) sq, dba_objects o
where
  o.data_object_id=sq.obj
  order by sq.tch desc, file#, dbablk, scn_bas
) where rownum<11;
