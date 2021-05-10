
select name, value
  from v$sysstat
  where name like '%sort%';

select tablespace_name, current_users, total_extents,
  total_blocks, used_extents, used_blocks
  from v$sort_segment;
