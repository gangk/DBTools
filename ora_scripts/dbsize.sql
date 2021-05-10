select sum(bytes/1024/1024/1024) Physical_size_gb from dba_data_files;

select sum(bytes/1024/1024/1024) Actual_size_gb from dba_segments;


