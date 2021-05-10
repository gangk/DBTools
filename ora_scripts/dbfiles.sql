colu file_name format A68
colu ts_name format A20
colu auto format A5
colu bytes format 9999999999
colu maxbytes format 99999999999
colu inc_by format 999999
select file_name, tablespace_name ts_name, autoextensible auto,(bytes/1024/1024)MB,(maxbytes/1024/1024)MAX_MB, 
increment_by inc_by from dba_data_files
order by 2,1
/
