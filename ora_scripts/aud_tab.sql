col owner for a5
col table_name for a8
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
 where fs.tablespace_name = df.tablespace_name
 and df.tablespace_name in ('ADMIN_COMPRESS','ADMINISTRATOR')
  group by df.tablespace_name, df.bytes
 order by 1
/

col file_name for a70

select file_id,file_name,(bytes/1024/1024)MB,AUTOEXTENSIBLE, MAXBYTES/1024/1024 "MAX size Mb" from dba_data_files where tablespace_name='ADMIN_COMPRESS'
/

select tablespace_name,BLOCK_SIZE,STATUS,LOGGING,FORCE_LOGGING,EXTENT_MANAGEMENT,SEGMENT_SPACE_MANAGEMENT,DEF_TAB_COMPRESSION,COMPRESS_FOR from dba_tablespaces where tablespace_name in ('ADMINISTRATOR','ADMIN_COMPRESS')
/

select owner,table_name,TABLESPACE_NAME,STATUS,INITIAL_EXTENT,MAX_EXTENTS,NUM_ROWS,BLOCKS,EMPTY_BLOCKS,DEGREE,LAST_ANALYZED,ROW_MOVEMENT,COMPRESSION,COMPRESS_FOR from dba_tables where table_name in('AUD$','FGA_LOG$')
/

select owner,segment_name,segment_type,(bytes/1024/1024/1024) "GB" , tablespace_name from dba_segments where segment_name='AUD$'
/

show parameter audit_trail

select owner,segment_name,segment_type,tablespace_name,bytes/1024/1024 "MB" from dba_segments where tablespace_name='ADMIN_COMPRESS'
/


