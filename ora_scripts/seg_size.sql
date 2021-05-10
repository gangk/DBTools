col owner for a10
col segment_name for a35

select owner,segment_name,segment_type,(bytes/1024/1024/1024)GB, tablespace_name from dba_segments where segment_name = upper('&segment_name');
