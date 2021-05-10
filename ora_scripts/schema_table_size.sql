col segment_name for a40

select owner,segment_name,segment_type,(bytes/1024/1024)MB from dba_segments where owner=UPPER('&owner_name') and segment_type in ('TABLE','TABLE PARTITION') order by MB desc;