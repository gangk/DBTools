select warehouse_id,scannable_id from containers where container_type = 'WORK_AREA' 
and scannable_id not like '%A'
and scannable_id not like '%B'
and scannable_id not like '%a'
and scannable_id not like '%b';
