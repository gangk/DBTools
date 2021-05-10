SELECT file_name,round(f.bytes / 1024 / 1024) "Total Size MB",round(s.bytes / 1024 / 1024) "Can be shrunk by MB",round(((f.bytes-s.bytes) / 1024 / 1024)+25) "ADVISED LENGHT MB"
FROM dba_data_files f, dba_free_space s WHERE f.file_id = s.file_id AND s.block_id IN
(SELECT MAX(block_id) FROM dba_free_space WHERE file_id = s.file_id)
-- AND file_name LIKE '%data%';
 
