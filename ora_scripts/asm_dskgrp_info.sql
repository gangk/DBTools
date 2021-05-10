set lines 410
col path for a20
select inst_id, group_number, name, state, type, total_mb/1024 total_gb, free_mb/1024 free_gb, offline_disks from gv$asm_diskgroup order by 1, 2;  
