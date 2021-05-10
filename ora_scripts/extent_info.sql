select owner,segment_name,tablespace_name,extent_id,file_id,block_id,(bytes/1024/1024)MB from dba_extents where segment_name like 'UPPER(%&segment_name%)';

