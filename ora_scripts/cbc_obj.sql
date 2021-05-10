column object_name format a30
select HLADDR, DBARFIL, dbablk, tch, object_name
from X$BH b, all_objects o
where HLADDR in
(
select ADDR from v$latch_children
where sleeps > 100000 and
name like '%cache buffers%'
) and
b.obj = o.object_id
order by HLADDR
;
