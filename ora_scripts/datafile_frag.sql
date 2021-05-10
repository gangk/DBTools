set lines 256
set pages 999
col "File Name" for A47
column file_name format a40;
column highwater format 9999999999;
SELECT  /*+ RULE */ df.File_id, Substr(df.file_name,1,47) "File Name",
        Round(df.bytes/1024/1024,2) "Size (M)",
        Round(e.used_bytes/1024/1024) "Used (M)",
        Round(f.free_bytes/1024/1024) "Free (M)",
        round((b.maximum+c.blocks-1)*d.db_block_size/(1024*1024)) "HWM (M)"
FROM    dba_data_files df,
        (SELECT file_id, Sum(Decode(bytes,NULL,0,bytes)) used_bytes FROM dba_extents GROUP by file_id) e,
        (SELECT Max(bytes) free_bytes, file_id FROM dba_free_space GROUP BY file_id) f,
        (SELECT file_id, max(block_id) maximum from dba_extents group by file_id) b,
        dba_extents c,
        (SELECT value db_block_size from v$parameter where name='db_block_size') d
WHERE   e.file_id (+) = df.file_id
AND     df.file_id = f.file_id (+)
AND     df.file_id = b.file_id and c.file_id = b.file_id and c.block_id = b.maximum
ORDER BY
        df.tablespace_name, df.file_name
/