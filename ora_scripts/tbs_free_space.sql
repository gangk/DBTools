
set pages 1000
set lines 132
set trims on
col tablespace_name format a15            heading "Tabsp Name"
col file_name       format a50            heading "File Name"
col total_size      format 999,999.00     heading "Size MB"
col free_space      format 999,999.00     heading "Free MB"
col max_size        format 999,999.00     heading "Max MB"
col pct_used        format 999.00         heading "%|Used"

clear breaks

select df.tablespace_name
,      df.file_name
,      df.bytes/1024/1024                        total_size
,      nvl(fr.bytes/1024/1024,0)                 free_space
,      ((df.bytes-nvl(fr.bytes,0))/df.bytes)*100 pct_used
,      df.maxbytes/1024/1024                     max_size
from   (select sum(bytes) bytes
        ,      file_id
        from   dba_free_space
        group by file_id)     fr
,       dba_data_files        df
where df.file_id = fr.file_id(+)
order by 1, df.file_id
/

select sum(total_size) totalsize, sum(free_space) total_free
from
(
select df.tablespace_name
,      df.file_name
,      df.bytes/1024/1024                        total_size
,      nvl(fr.bytes/1024/1024,0)                 free_space
,      ((df.bytes-nvl(fr.bytes,0))/df.bytes)*100 pct_used
,      df.maxbytes/1024/1024                     max_size
from   (select sum(bytes) bytes
        ,      file_id
        from   dba_free_space
        group by file_id)     fr
,       dba_data_files        df
where df.file_id = fr.file_id(+)
)
/
