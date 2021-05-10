column tablespace format a12
column username   format a12

select   se.username
       ,se.sid
       ,su.extents
       ,su.blocks * to_number(rtrim(p.value)) as Space
       ,tablespace
       ,segtype
from     v$sort_usage su
       ,v$parameter  p
       ,v$session    se
where    p.name          = 'db_block_size'
and      su.session_addr = se.saddr
order by se.username, se.sid;

