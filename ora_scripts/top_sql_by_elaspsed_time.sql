select * from (
 select * from (
   select sql_id,plan_hash_value,elapsed_time/1000000 etime,executions execs,(elapsed_time/1000000)/decode(executions,0,1,executions) avg_etime,
     buffer_gets/decode(executions,null,1,0,1,executions) avg_lios,
     disk_reads/decode(executions,null,1,0,1,executions) avg_pios,
     substr(sql_text,1,150) sql_text
   from v$sqlarea
   where elapsed_time > 100) -- Number of seconds
   order by avg_etime DESC)
where rownum <=10;   -- Number in list (Top - N)
   