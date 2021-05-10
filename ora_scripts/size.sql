accept segment_name prompt 'enter segment name like :- '
select segment_name,sum(bytes)/1024/1024/1024 "Gb",sum(bytes)/1024/1024 "Mb"
from
dba_segments where segment_name='&segment_name' group by segment_name;
undef segment_name
