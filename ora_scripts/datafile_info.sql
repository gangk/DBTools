col flname for a55
col status for a15
col  tsname for a18


PROMPT
PROMPT ***********************
PROMPT *** DATAFILE STATUS ***
PROMPT ***********************

select file_name                                          flname
,       status
,      autoextensible
,      tablespace_name                                    tsname
,      bytes/1024/1024                                    siz
,      decode(maxbytes,0,0,maxbytes/1024/1024)            maxsiz
,      decode(maxbytes,0,0,bytes/maxbytes*100)            pctmax
from   dba_data_files
/