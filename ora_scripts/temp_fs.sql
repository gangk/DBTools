SELECT tablespace_name, SUM(bytes_used)/(1024*1024) used_mb, SUM(bytes_free)/(1024*1024) free_mb
FROM   V$temp_space_header
GROUP  BY tablespace_name;
