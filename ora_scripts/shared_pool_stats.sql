
-- Names of and sessions for shared pool allocations causing contention.

select ksmlrhon, ksmlrsiz, ksmlrses
from x$ksmlru
where ksmlrsiz > 1000
order by ksmlrsiz;

-- Shared pool memory allocated.

select sum(ksmchsiz)||' bytes' "TotSharPoolMem"
from x$ksmsp;


-- Fragmentation

set verify off
column PctTotSPMem for a45
select ksmchcls "ChnkClass",
    sum(ksmchsiz) "SumChunkTypeMem",
    Max(ksmchsiz) "LargstChkofThisTyp",
    count(1) "NumOfChksThisType",
    round((sum(KSMCHSIZ)/tot_sp_mem.totspmem),2)*100||'%' "PctTotSPMem"
from x$ksmsp,
    (select sum(KSMCHSIZ) TotSPMem from x$ksmsp) tot_sp_mem
group by ksmchcls, tot_sp_mem.TotSPMem
order by sum(KSMCHSIZ);

-- Information regarding shared_pool_reserved_size.
select free_space, free_count, max_free_size, max_used_size, request_misses, max_miss_size
from v$shared_pool_reserved;

--

