col file_name format a55
select file_name,bytes/1024/1024 from dba_data_files where tablespace_name=upper('&tsname');
