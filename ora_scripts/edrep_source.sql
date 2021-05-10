select source_table_location
from   data_pull_schedules
where  target_table_owner = 'BOOKER'
and    target_table = '&tab_name'
/
