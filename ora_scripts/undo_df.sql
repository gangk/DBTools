@plusenv
col file_name format a70
col maxbytes format 99,999,999
select tablespace_name, file_name, autoextensible, maxbytes/(1024*1024) from dba_data_files
where tablespace_name = 'UNDO_T1';
