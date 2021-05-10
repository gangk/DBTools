col name for a10
col state for a12
col "% FREE/TOTAL(GB)" for a15

select group_number g#, name, sector_size secs, block_size blks, ALLOCATION_UNIT_SIZE "AUS",
 STATE, TYPE, ' ' || round(free_mb/total_mb*100)  || ' ' || round(FREE_MB/1024) || '/' || round(TOTAL_MB/1024) "% FREE/TOTAL(GB)",
  REQUIRED_MIRROR_FREE_MB RQ_M_FREE_MB, USABLE_FILE_MB, OFFLINE_DISKS
  from v$asm_diskgroup_stat
   where total_mb > 0;