select inst_id,function_name,
sum(small_read_megabytes+large_read_megabytes) as read_mb,
sum(small_write_megabytes+large_write_megabytes) as write_mb
from gv$iostat_function
group by cube (inst_id,function_name) 
order by inst_id,function_name;