select file_type,space_used*percent_space_used/100/1024/1024 used,
space_reclaimable*percent_space_reclaimable/100/1204/1024 reclaimable,
frau.number_of_files
from
v$recovery_file_dest rfd,v$flash_recovery_area_usage frau;
