col tspace format a30
colu tot_ts_size format 99999999.999
colu free_ts_size format 99999999.999
colu used_ts_size format 99999999.999
select df.tablespace_name tspace,
    df.bytes/(1024*1024) tot_ts_size,
  (df.bytes/(1024*1024) -sum(fs.bytes)/(1024*1024)) Used_ts_size,
  sum(fs.bytes)/(1024*1024) free_ts_size,
        round(sum(fs.bytes)*100/df.bytes) free_pct,
  round((df.bytes-sum(fs.bytes))*100/df.bytes) used_pct1
from dba_free_space fs, (select tablespace_name, sum(bytes) bytes from dba_data_files  group by tablespace_name ) df
 where fs.tablespace_name = df.tablespace_name and fs.tablespace_name IN (UPPER('&import_tbs_name'), UPPER('&UNDO_tbs_name'))  
  group by df.tablespace_name, df.bytes 
 order by 1
/