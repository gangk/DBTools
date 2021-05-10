column sum_pga_used_mem format 999,999,999,999,999
column sum_pga_alloc_mem format 999,999,999,999,999
column sum_pga_freeable_mem format 999,999,999,999,999
column sum_pga_max_mem format 999,999,999,999,999
column avg_pga_used_mem format 999,999,999,999,999
column avg_pga_alloc_mem format 999,999,999,999,999
column avg_pga_freeable_mem format 999,999,999,999,999
column avg_pga_max_mem format 999,999,999,999,999
column program_type format a10
select
        inst_id,
        sum(pga_used_mem) sum_pga_used_mem,
        sum(pga_alloc_mem) sum_pga_alloc_mem,
        sum(PGA_FREEABLE_MEM) sum_pga_freeable_mem,
        sum(PGA_MAX_MEM) sum_pga_max_mem
from
        gv$process p
group by
        inst_id
;
select
        inst_id,
        avg(pga_used_mem) avg_pga_used_mem,
        avg(pga_alloc_mem) avg_pga_alloc_mem,
        avg(PGA_FREEABLE_MEM) avg_pga_freeable_mem,
        avg(PGA_MAX_MEM) avg_pga_max_mem
from
        gv$process p
group by
        inst_id
;
select
        p.inst_id,
        substr(s.program,1,6) as program_type,
        count(*),
        avg(pga_used_mem) avg_pga_used_mem,
        avg(pga_alloc_mem) avg_pga_alloc_mem,
        avg(PGA_FREEABLE_MEM) avg_pga_freeable_mem,
        avg(PGA_MAX_MEM) avg_pga_max_mem
from
        gv$process p
        ,gv$session s
where
        p.inst_id = s.inst_id
        and p.addr=s.paddr
group by
        p.inst_id,
        substr(s.program,1,6)
--order by
--      p.inst_id,
--      substr(s.program,1,6)
;
