select sum(bytes/1024/1024) from dba_segments where segment_name=upper('BINEDIT_ENTRIES');
