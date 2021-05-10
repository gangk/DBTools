col segment_name for a40

select owner,segment_name,segment_type,(bytes/1024/1024)MB from dba_segments where segment_name like UPPER('%&table_name%') and segment_type='TABLE' order by MB desc;