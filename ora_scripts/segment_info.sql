col owner for a10
col segment_name for a25



select OWNER,SEGMENT_NAME,SEGMENT_TYPE,TABLESPACE_NAME,(BYTES/1024/1024)MB from dba_segments where SEGMENT_NAME=UPPER('&segment_name');