select source_table_owner 
       ,source_table
       ,suspend_pull
       ,suspend_synch
       ,SOURCE_TABLE_LOCATION
from   data_pull_schedules
where  target_table_owner = 'BOOKER'
and    target_table = '&tab_name'
/
