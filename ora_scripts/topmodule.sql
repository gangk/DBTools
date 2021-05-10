set lines 500
col module for a50
select module,count(1) session_count ,sum(PGA_USED_MEM/1024/1024)SUM_Used_MB,sum(PGA_ALLOC_MEM/1024/1024) SUM_Alloc_mem,sum(PGA_FREEABLE_MEM/1024/1024)SUM_Freeable_MB,sum(PGA_MAX_MEM/1024/1024) SUM_Max_MB, avg (PGA_ALLOC_MEM/1024/1024) avg_Alloc_mem,avg(PGA_MAX_MEM/1024/1024) avg_Max_MB from v$process p,v$session s where s.paddr=p.addr  and nvl(p.background,0)<>1 
group by module order by  4 desc;
