col object_name for a30
col object_type for a20


PROMPT **********Objects that take more than 5% of the buffer cache***************************

select o.owner, o.object_type, o.object_name, count(b.objd)
  from v$bh b, dba_objects o
  where b.objd = o.object_id
  group by o.owner, o.object_type, o.object_name
  having count (b.objd) > (select to_number(value*.05)
    from v$parameter
    where name = 'db_block_buffers');
