set pagesize 60
set linesize 500
col sql_id for a13
col reads_per_exec for 9999999999
col disk_reads for 999999999999
col executions for 9999999
col module for a30
col sql_text for a90
select * from (select sql_id,cast(disk_reads/(executions+1) as integer) as reads_per_exec,disk_reads,executions,module,substr(sql_text,1,90)
from V$SQLAREA where disk_reads/(executions+1) > 1 and executions > 1 order by disk_reads/(executions+1) desc ) where rownum <31;

