set lines 410
col path for a30

select inst_id, group_number, disk_number, mount_status, header_status, mode_status, state, total_mb, free_mb, name, failgroup, path, library
from gv$asm_disk order by 1, 2, 3;