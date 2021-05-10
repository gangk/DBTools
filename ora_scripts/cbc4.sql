undef latch_addr
set lines 170 pages 100

col object format a75
col state format a5
select /*+rule*/ *
from (
select o.owner||'.'||o.object_name||decode(o.subobject_name,NULL,'','.')||
  o.subobject_name||' ['||o.object_type||']' object, sq.*
from (
select
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
  x.hladdr  = '&&latch_addr'
) sq, dba_objects o
where
  o.data_object_id=sq.obj
  order by sq.tch desc, file#, dbablk, scn_bas
) where rownum<40;
