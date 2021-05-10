col object_name for a20

select object_name,statistic_name,value from v$segment_statistics where object_name= '&object_name';