REM SEG_DETAILS

col owner for a12
col segment_name for a25
select owner,segment_name,file_id,block_id,blocks from dba_extents where owner=upper('&owner') and segment_name=upper('&segment');
