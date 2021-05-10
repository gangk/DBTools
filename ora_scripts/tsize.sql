select tablespace_name,sum(bytes)/1024/1024/1024,max(bytes)/1024/1024/1024 from dba_data_files 
where tablespace_name='&tbl' group by tablespace_name;
