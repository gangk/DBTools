REM GET_SEGMENT_STATS

col stat for a20
col value for 99999999

select statistics_name stat, value val from v$segment_statistics where value > 0 and owner=upper('&owner) and object_name=upper('&object');

