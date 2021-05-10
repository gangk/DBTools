REM ------------------------------------------------------------------------------------------------
REM $Id: ts-sum-graph.sql,v 1.1 2002/03/14 20:00:14 hien Exp $
REM Author     : Bally Bassi
REM #DESC       : Show Space usage at tablespace level.
REM Usage      : Input parameter: None
REM Description: Show Space usage at tablespace level.
REM ------------------------------------------------------------------------------------------------

@plusenv

column tbs_nm format a20 truncate  heading 'Tablespace'
column file_nm format a40 truncate  heading 'File Name'
column df.bytes/1024/1024 format 999,999,999 heading 'Total|(Mbytes)'
column used format 999,999,999 heading 'Used|(Mbytes)'
column f.free_bytes/1024/1024 format 999,999,999 heading  'Avail|(Mbytes)'
column pct_used format 999.99  heading '% Used|(Mbytes)'
column pct_free format 999.99  heading '% Free|(Mbytes)'
column extent_mgmt format a10 heading 'Extent|Mangmt'
column alloc_type format a10 heading 'Alloc|Type'
COLUMN prcnt_used format a11 heading 'Graph|Used'
COLUMN prcnt_free format a11 heading 'Graph|Free'
 

Prompt Database Used/Free Space by Tablespace 

SELECT  
  df.tablespace_name TBS_NM,
  df.bytes/1024/1024,
  f.free_bytes/1024/1024,
  ((df.bytes/1024/1024) - (f.free_bytes/1024/1024)) used, 
  (((df.bytes/1024/1024) - (f.free_bytes/1024/1024))/(df.bytes/1024/1024) * 100) as PCT_USED,
  RPAD(' '|| RPAD ('X',ROUND(((df.bytes) - (f.free_bytes))*10/df.bytes,0), 'X'),11,'-') PRCNT_USED,
  ((f.free_bytes/1024/1024)/(df.bytes/1024/1024) * 100) as PCT_Free,
  RPAD(' '|| RPAD ('X',ROUND(f.free_bytes*10/df.bytes,0), 'X'),11,'-') PRCNT_FREE,
  d.extent_management EXTENT_MGMT,
  d.allocation_type ALLOC_TYPE
FROM dba_tablespaces d,
     (SELECT
      sum(bytes) bytes,
      tablespace_name
    FROM dba_data_files 
    GROUP BY tablespace_name) df,
    (SELECT
      sum(bytes) free_bytes,
      tablespace_name
    FROM dba_free_space
    GROUP BY tablespace_name) f
WHERE
 df.tablespace_name  = f.tablespace_name (+)
and d.tablespace_name=df.tablespace_name
ORDER BY
df.tablespace_name;

