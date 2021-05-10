col file_name for a70

select file_id,file_name,(bytes/1024/1024)MB,AUTOEXTENSIBLE, MAXBYTES/1024/1024 "MAX size Mb" from dba_data_files where tablespace_name=UPPER('&tbs_name');
